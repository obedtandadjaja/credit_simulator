class DailyBillingWorker
  include Sidekiq::Worker

  def perform(*args)
    logger.info "Things are happening."

    # get all due credits today
    due_credits = Credit.where(next_billing_statement: Date.today.to_time.to_i)

    # loop through due credits
    due_credits.each do |due_credit|
      if due_credit.balance.amount < due_credit.credit_limit
        owed_interest = 0
        last_billing_statement = due_credit.last_billing_statement.presence || (DateTime.now - 30.days).beginning_of_day.to_time.to_i
        current_balance = due_credit.credit_limit
        current_elapsed_day = 0

        # group transactions by day
        daily_transactions = due_credit.transactions.succeeded.group_by { |t| t.created_at.beginning_of_day }
        days = daily_transactions.keys.sort

        days.each_with_index do |day, i|

          # calculate elapsed day
          elapsed_day = elapsed_days(daily_transactions[day].first.created_at.beginning_of_day.to_time.to_i, last_billing_statement)

          # get next elapsed day
          next_day = daily_transactions[days[i+1]].nil? ? Date.today : daily_transactions[days[i+1]].first.created_at.beginning_of_day
          next_elapsed_day = elapsed_days(next_day.to_time.to_i, last_billing_statement)

          # get difference to current elapsed day - will be used for APR calculations
          difference_elapsed_day = next_elapsed_day - elapsed_day

          # calculate transactions by the day
          daily_transactions[day].each do |transaction|
            sign = transaction.type == 'Payment' ? 1 : -1
            current_balance += transaction.amount * sign
          end

          # calculate interest only if balance is under credit limit
          if current_balance < due_credit.credit_limit
            difference_from_credit_limit = due_credit.credit_limit - current_balance
            owed_interest += difference_from_credit_limit * (due_credit.apr/100.0) / 365.0 * difference_elapsed_day
          end
        end

        due_credit.transactions << Charge.new({_id: BSON::ObjectId.new, amount: owed_interest.ceil, currency: 'usd', description: 'interest'})
        due_credit.balance.amount -= owed_interest
        due_credit.save!
      end
    end
  end

  def elapsed_days(day, day_from)
    (day - day_from)/(24*3600)
  end
end
