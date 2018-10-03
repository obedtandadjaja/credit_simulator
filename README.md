# credit_simulator - FAIR INTERVIEW CODE CHALLENGE
My implementation of a simple credit simulator API. 

Please take into account the short amount of time it took to build this app so please judge the architecture, code quality, and tests with a grain of salt.

Design choices:
- Database: MongoDB - to showcase that I have some experience in NoSQL (this was a mistake I hate Mongoid)
- Tracking/Logger: Mongo-history
- API: Grape, Grape Entity, Rack
- UI: Swagger.io
- Authentication: Custom token-authorization library using JWT (not trying to reinvent the wheel, but I want something simpler than OAuth2)
- Background worker: Sidekiq (see /app/workers/daily_billing_worker.rb)
- Test: RSpec - Tried to cover all edge cases but there might be some that I miss due to the time constraints
- Fat models, Skinny controllers (API) - I was not able to do this effectively due to limitations with Mongoid

Included logistics:
- Interest calculations are done everyday at 12:01 AM by a background worker every 30 days
- Interest calculations will round up to the cent (i.e. $104.211 to $104.22)
- Owed interest will be charged at the end of the monthly calculations to the credit product with the description: 'description'
- Charge should not be bigger than remaining balance amount
- Updates on charge should not make balance to go into negative figures
- Payment can be bigger than credit limit
- Deletion of payments should not make balance to go into negative figures
- Updates to credit limit will increase right away
- On update of credit limit, increase the balance by the difference
- On credit limit decreased, check so that balance should not go into negative figures
- Only admin has permission to settle disputes (i.e. update and delete transactions)
- Only admin has permission to view all users, credits, and transactions
- Polymorphic relations of transaction to charges and payments
- Only admin has permission to update credit products (i.e. change credit limit, etc)
- that's all that I can remember...

NOTE: To access the API, please firstly authenticate yourself in 'localhost:3000/auth' using these accounts:
```
username: user
password: user
role: user

username: admin
password: admin
role: admin
```

Please give me an email at obed.tandadjaja@gmail.com or call me at (559)4737555 if you have any trouble setting up the application. I am happy to demo the app to you too if you like

## Setting up the application
First, clone the repo and navigate to the app directory

install the dependencies
```
bundle install
```

Because I am using mongoDB for this application, you might need to install and run it
```
brew update
brew install mongodb
brew services start mongodb
```

If you don't want to keep mongodb in your machine, then afterwards you can do
```
brew services stop mongodb
brew uninstall mongodb
```

We can then initialize the database by doing
```
rake db:setup
```

Afterwards, we can start the server
```
rails s
```

## Testing the application
Because this application does not have any built-in UI, you can test if the application works by running my RSpec tests (usually runs about 3-4 minutes on my machine)
```
rspec
```

Or you can also visit [swagger.io](https://petstore.swagger.io) and put 'http://localhost:3000/api/swagger_doc' on the explore textbox to preview and test out the APIs.

Alternatively, you can always just use Postman or curl commands.

## Things to improve
1. Learn more about Mongoid (ORM for MongoDB)... I was too ambitious to try MongoDB on Rails for this project but ended up backfiring. It is really different from other ORM for MongoDB. I could not figure out their callbacks (on return false it does not rollback)... my models end up skinnier than my controllers
2. Test edge cases (i.e. bounds of variables types)
3. Upgrade to Rails 5
4. Write more comments and implement Rdoc
5. Have CircleCI support for continuous integration
