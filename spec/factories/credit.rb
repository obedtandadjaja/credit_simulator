FactoryGirl.define do
  factory :credit do
    active true
    credit_limit 1000
    apr 15
    next_billing_statement { (Date.today + 30.days).to_time.to_i }
    last_billing_statement nil

    balance { FactoryGirl.build(:balance) }

    trait :inactive do
      active false
    end
  end
end
