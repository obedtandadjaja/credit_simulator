FactoryGirl.define do
  factory :payment do

    currency 'usd'
    amount 100
    status 'succeeded'

    trait :failed do
      status 'failed'
    end

  end
end
