FactoryGirl.define do
  factory :charge do

    currency 'usd'
    amount 100
    description 'description'
    status 'succeeded'

    trait :failed do
      status 'failed'
    end

  end
end
