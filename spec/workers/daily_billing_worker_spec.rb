require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe DailyBillingWorker, type: :worker do

  describe 'run worker' do

    '''
    Scenario 1:

    Someone creates a line of credit for $1000 and 35% APR.

    They draws $500 on day one so their remaining credit limit is $500 and their balance is $500.
    They keep the money drawn for 30 days. They should owe $500 * 0.35 / 365 * 30 = 14.38$ worth
    of interest on day 30. Total payoff amount would be $514.38
    '''

    context 'with scenario 1' do
      let!(:credit) { Credit.new(_id: BSON::ObjectId.new, credit_limit: 100000, apr: 35, active: true) }
      let!(:charge1) { Charge.new(_id: BSON::ObjectId.new, amount: 50000, currency: 'usd', description: 'withdraw') }

      it "performs scenario 1 successfully", job: true do
        credit.created_at = (DateTime.now - 30.days).to_i
        credit.next_billing_statement = Date.today.to_time.to_i
        credit.save!

        charge1.created_at = (DateTime.now - 30.days).to_i
        charge1.save!

        credit.transactions << charge1
        credit.balance.amount -= charge1.amount
        credit.save!

        worker = DailyBillingWorker.new
        worker.perform

        expect(credit.reload.transactions[1].amount.to_i).to eq 1439 # should be rounded up - instead of 1438
        expect(credit.transactions[1].description).to eq 'interest'
      end
    end

    '''
    Scenario 2:

    Someone creates a line of credit for $1000 and 35% APR.

    They draw $500 on day one so their remaining credit limit is $500 and their balance is $500.
    They pay back $200 on day 15 and then draws another 100$ on day 25. Their total owed interest
    on day 30 should be 500 * 0.35 / 365 * 15 + 300 * 0.35 / 365 * 10 + 400 * 0.35 / 365 * 5 which
    is 11.99. Total payment should be $411.99.
    '''

    context 'with scenario 2' do
      let!(:credit) { Credit.new(_id: BSON::ObjectId.new, credit_limit: 100000, apr: 35, active: true) }
      let!(:charge1) { Charge.new(_id: BSON::ObjectId.new, amount: 50000, currency: 'usd', description: 'withdraw') }
      let!(:payment1) { Payment.new(_id: BSON::ObjectId.new, amount: 20000, currency: 'usd') }
      let!(:charge2) { Charge.new(_id: BSON::ObjectId.new, amount: 10000, currency: 'usd', description: 'withdraw') }

      it "performs scenario 1 successfully", job: true do
        credit.created_at = (DateTime.now - 30.days).to_i
        credit.next_billing_statement = Date.today.to_time.to_i
        credit.save!

        charge1.created_at = (DateTime.now - 30.days).to_i
        charge1.save!

        payment1.created_at = (DateTime.now - 15.days).to_i
        payment1.save!

        charge2.created_at = (DateTime.now - 5.days).to_i
        charge2.save!

        credit.transactions += [charge1, payment1, charge2]
        credit.balance.amount -= (charge1.amount + charge2.amount - payment1.amount)
        credit.save!

        worker = DailyBillingWorker.new
        worker.perform

        expect(credit.reload.transactions[3].amount.to_i).to eq 1199
        expect(credit.transactions[3].description).to eq 'interest'
      end
    end

  end

end
