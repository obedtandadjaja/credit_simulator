namespace :sidekiq do
  desc "TODO"
  task task1: :environment do

    # get all due credits today
    due_credits = Credit.where(next_billing_statement: Date.today.to_time.to_i)
    byebug

    # loop through due credits
    due_credits.each do |due_credit|
      if due_credit.balance.amount < due_credit.credit_limit
        owed_interest = 0
        last_billing_statement = due_credit.last_billing_statement.presence || (Date.today - 30.days).to_time.to_i
        current_balance = due_credit.credit_limit
        current_elapsed_day = 0

        # group transactions by day
        daily_transactions = due_credit.transactions.group_by { |t| t.created_at.to_date }
        daily_transactions.each do |transactions, i|

          # calculate elapsed day
          elapsed_day = elapsed_days(transactions.first.created_at.to_date, last_billing_statement)

          # get next elapsed day
          next_day = daily_transactions[i+1].nil? ? Date.today.to_date : daily_transactions[i+1].first.created_at.to_date
          next_elapsed_day = elapsed_days(next_day, last_billing_statement)

          # get difference to current elapsed day - will be used for APR calculations
          difference_elapsed_day = next_elapsed_day - elapsed_day

          # calculate transactions by the day
          transactions.each do |transaction|
            elapsed_day = elapsed_days(transaction.created_at, last_billing_statement)
            sign = transaction.type == 'Payment' ? 1 : -1
            current_balance += transaction.amount * sign
          end

          # calculate interest only if balance is under credit limit
          if current_balance < due_credit.credit_limit
            difference_from_credit_limit = due_credit.credit_limit - current_balance
            owed_interest += difference_from_credit_limit * (due_credit.apr/100) / 365 * difference_elapsed_day
          end
        end

        puts owed_interest
      end
    end

  end

end
