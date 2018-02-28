FactoryGirl.define do
  factory :balance do

    amount { rand(1000...100000).to_s }
    currency 'usd'

  end
end
