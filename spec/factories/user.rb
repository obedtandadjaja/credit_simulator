FactoryGirl.define do
  factory :user do
    password 'asdf'
    password_confirmation { |u| u.password }

    role 'user'
    first_name 'Bob'
    last_name 'Marley'


    sequence(:email) { |n| "email#{n}@example.com" }
    sequence(:username) { |n| "username#{n}" }

    trait :admin do
      role 'admin'
    end

    trait :user do
      role 'user'
    end
  end
end
