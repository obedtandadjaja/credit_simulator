# require 'rails_helper'

# describe 'Credits API' do
#   #declarations
#   let(:access_token) { AccessTokenAuth.issue(user) }
#   let!(:user) { create :user }
#   let!(:user_credits) { 5.times do user.credits << FactoryGirl.build(:credit) end }
#   let!(:user_credit_charges) { 3.times do user.credits.first.transactions << FactoryGirl.build(:charge) end }
#   let!(:user_credit_payments) { 2.times do user.credits.first.transactions << FactoryGirl.build(:payment) end }

#   let(:admin_access_token) { AccessTokenAuth.issue(admin) }
#   let!(:admin) { create :user, :admin }
#   let!(:admin_credits) { 2.times do admin.credits << FactoryGirl.build(:credit) end }
#   let!(:admin_credit_charges) { 3.times do admin.credits.first.transactions << FactoryGirl.build(:charge) end }
#   let!(:admin_credit_payments) { 2.times do admin.credits.first.transactions << FactoryGirl.build(:payment) end }

#   let(:authorization_header) { { Authorization: 'Basic ' + access_token } }
#   let(:admin_authorization_header) { { Authorization: 'Basic ' + admin_access_token } }

#   let(:params) {}
#   let(:headers) {}

#   ##########################
#   # GET api/v1/transaction #
#   ##########################

#   describe 'GET api/v1/transaction' do
#     let!(:credit_charges) { 3.times do user.credits.first.transactions << FactoryGirl.build(:charge) end }
#     let!(:credit_payments) { 2.times do user.credits.first.transactions << FactoryGirl.build(:payment) end }

#     context 'negative tests' do
#       context 'on missing authorization header' do
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. '
#       end

#       context 'on invalid access token' do
#         let(:headers) { { Authorization: 'asdf' } }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. '
#       end

#       context 'not admin' do
#         let(:headers) { authorization_header }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. Not enough permission.'
#       end

#       context 'invalid ordering param' do
#         let(:params) { { order_by: 'abc' } }
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '400'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'order_by does not have a valid value'
#       end
#     end

#     context 'positive tests' do
#       let(:headers) { admin_authorization_header }

#       context 'without extra params' do
#         it_behaves_like '200'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'
#         it_behaves_like 'pagination headers'

#         specify 'returns an array of users' do
#           api_call params
#           expect(JSON.parse(response.body)['data']).to be_a(Array)
#           expect(JSON.parse(response.body)['data'].count).to eq Transaction.all.count
#         end
#       end

#       context 'with ordering' do
#         # amount type status currency created_at updated_at
#         context 'ordered id' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :amount } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:asc, :amount)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :amount } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:desc, :amount)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered currency' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :currency } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:asc, :currency)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :currency } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:desc, :currency)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered type' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :type } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:asc, :type)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :type } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:desc, :type)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered status' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :status } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:asc, :status)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :status } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:desc, :status)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered created_at' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :created_at } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:asc, :created_at)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :created_at } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:desc, :created_at)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered updated_at' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :updated_at } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:asc, :updated_at)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :updated_at } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               transactions = Transaction.all.send(:desc, :updated_at)
#               transactions.each do |transaction, i|
#                 expect(transaction.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end
#       end

#       context 'with pagination' do
#         context 'on missing per_page param' do
#           let(:params) { { page: 1 } }
#           it_behaves_like '200'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains data'
#           it_behaves_like 'pagination headers'

#           specify 'per_page not defaulted to 25' do
#             api_call params
#             expect(response.headers['Per-Page']).to eq 25.to_s
#           end
#         end

#         context 'on per_page and page params present' do
#           let(:params) { { per_page: 1, page: 1 } }
#           it_behaves_like '200'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains data'
#           it_behaves_like 'pagination headers'

#           specify 'pagination headers not updated' do
#             api_call params
#             expect(response.headers['Per-Page']).to eq 1.to_s
#             expect(response.headers['Total']).to eq Transaction.all.count.to_s
#             expect(response.headers['Link']).to be_present
#           end
#         end

#         context 'on change between pages' do
#           let(:params) { { page: 2, per_page: 1 } }
#           it_behaves_like '200'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains data'
#           it_behaves_like 'pagination headers'

#           specify 'items in page1 not equal to items in page2' do
#             first_page = { page: 1, per_page: 1 }
#             api_call first_page
#             result1 = response.body

#             second_page = { page: 2, per_page: 1 }
#             api_call second_page
#             result2 = response.body

#             expect(result1).not_to eq result2
#           end
#         end
#       end

#       context 'with period' do
#         context 'on valid start_date and end_date param' do
#           it_behaves_like '200'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains data'
#           it_behaves_like 'pagination headers'

#           specify 'incorrect filtering' do
#             period_params = { start_date: (DateTime.now - 5.minutes).to_i, end_date: DateTime.now.to_i }
#             api_call period_params
#             returned_transactions = JSON.parse(response.body)['data']

#             returned_transactions.each do |returned_transaction|
#               expect(returned_transaction[:created_at]).to be >= period_params[:start_date]
#               expect(returned_transaction[:created_at]).to be <= period_params[:end_date]
#             end
#           end
#         end

#         context 'on start_date more than end_date param' do
#           it_behaves_like '200'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains data'
#           it_behaves_like 'pagination headers'

#           specify 'not returning empty data' do
#             period_params = { start_date: (DateTime.now + 5.minutes).to_i, end_date: DateTime.now.to_i }
#             api_call period_params
#             returned_transactions = JSON.parse(response.body)['data']
#             expect(returned_transactions.count).to eq 0
#           end
#         end
#       end
#     end

#     def api_call *params
#       get '/api/v1/transaction', *params, headers
#     end
#   end

#   ##############################
#   # GET api/v1/transaction/:id #
#   ##############################

#   describe 'GET api/v1/transaction/:id' do
#     # declarations
#     let(:transaction_id) { user.credits.first.transactions.first.id_str }

#     context 'negative tests' do
#       context 'on querying other user\'s transaction' do
#         let(:headers) { authorization_header }
#         let(:transaction_id) { admin.credits.first.transactions.first.id_str }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. You have no permission to access other user\'s account'
#       end

#       context 'missing authorization header' do
#         let(:headers) {}
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. '
#       end

#       context 'invalid access token' do
#         let(:headers) { { Authorization: 'asdf' } }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. '
#       end
#     end

#     context 'positive tests' do
#       let(:credit_id) { user.credits.first.id_str }

#       context 'on user requesting their own transaction info' do
#         let(:headers) { authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'not returning the correct transaction data' do
#           api_call params
#           expect(user.credits.first.transactions).to include(Transaction.find(JSON.parse(response.body)['data']['id']))
#         end

#         specify 'returning multiple transactions' do
#           api_call params
#           expect(JSON.parse(response.body)['data']).to be_a(Object)
#         end
#       end

#       context 'on admin requesting other user\'s transaction info' do
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'not returning request data' do
#           api_call params
#           expect(user.credits.first.transactions).to include(Transaction.find(JSON.parse(response.body)['data']['id']))
#         end
#       end
#     end

#     def api_call *params
#       get '/api/v1/transaction/' + transaction_id, *params, headers
#     end
#   end

#   #################################
#   # DELETE api/v1/transaction/:id #
#   #################################

#   describe 'DELETE api/v1/transaction/:id' do
#     let(:transaction_id) { user.credits.first.transactions.first.id_str }

#     context 'negative tests' do
#       context 'missing authorization header' do
#         let(:headers) {}
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. '
#       end

#       context 'invalid access token' do
#         let(:headers) { { Authorization: 'asdf' } }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. '
#       end

#       context 'not admin' do
#         let(:headers) { authorization_header }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. Not enough permission.'
#       end
#     end

#     context 'positive tests' do
#       context 'on delete transaction' do
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'

#         specify 'transaction not deleted' do
#           before_count = user.credits.first.transactions.count
#           api_call params
#           expect(user.credits.first.transactions.first.id_str).not_to eq transaction_id
#           expect(user.credits.first.transactions.count).to eq before_count-1
#         end

#         context 'update balance on charge delete' do
#           let!(:curr_charge) { user.credits.first.transactions << FactoryGirl.build(:charge) }
#           let(:transaction_id) { user.credits.first.transactions.last.id_str }

#           specify 'rollback balance changes failed' do
#             before_balance = user.credits.first.balance
#             transaction = Transaction.find(transaction_id)
#             rollback_sign = transaction.type == 'Payment' ? 1 : -1
#             rollback_value = transaction.amount * rollback_sign
#             api_call params
#             expect(Credit.find(transaction.transactionable.id_str).balance.amount).to eq before_balance.amount - rollback_value
#           end
#         end

#         context 'update balance on payment delete' do
#           let!(:curr_payment) { user.credits.first.transactions << FactoryGirl.build(:payment) }
#           let(:transaction_id) { user.credits.first.transactions.last.id_str }

#           specify 'rollback balance changes failed' do
#             before_balance = user.credits.first.balance
#             transaction = Transaction.find(transaction_id)
#             rollback_sign = transaction.type == 'Payment' ? 1 : -1
#             rollback_value = transaction.amount * rollback_sign
#             api_call params
#             expect(Credit.find(transaction.transactionable.id_str).balance.amount).to eq before_balance.amount - rollback_value
#           end
#         end
#       end
#     end

#     def api_call *params
#       delete '/api/v1/transaction/' + transaction_id, *params, headers
#     end
#   end

#   ##############################
#   # PUT api/v1/transaction/:id #
#   ##############################

#   describe 'PUT api/v1/transaction/:id' do
#     let(:valid_params) { { amount: rand(10..1000), currency: 'usd' } }
#     let(:transaction_id) { user.credits.first.transactions.first.id_str }
#     let(:headers) { authorization_header }

#     context 'negative tests' do
#       context 'params wrong type' do
#         context 'amount' do
#           let(:params) { valid_params.merge!(amount: 'abc') }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'amount is invalid'
#         end
#       end

#       context 'missing authorization header' do
#         let(:headers) {}
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. '
#       end

#       context 'invalid access token' do
#         let(:headers) { { Authorization: 'asdf' } }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. '
#       end

#       context 'not admin' do
#         let(:headers) { authorization_header }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. Not enough permission.'
#       end

#       context 'update charge failed on insufficient funds' do
#         let!(:credit_balance) { user.credits.first.balance.amount = '10' }
#         let!(:curr_charge) { user.credits.first.transactions << FactoryGirl.build(:charge) }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. Not enough permission.'
#       end
#     end

#     context 'positive tests' do
#       context 'on update credit' do
#         let(:params) { { amount: 10, currency: 'usd' } }
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'

#         specify 'transaction not updated' do
#           api_call params
#           expect(Transaction.find(transaction_id).amount.to_i).to eq params[:amount].to_i
#           expect(Transaction.find(transaction_id).currency).to eq params[:currency]
#         end

#         context 'update balance on charge update' do
#           let!(:curr_charge) { user.credits.first.transactions << FactoryGirl.build(:charge) }
#           let(:params) { { amount: 20, currency: 'usd' } }
#           let(:transaction_id) { user.credits.first.transactions.last.id_str }
#           it_behaves_like '200'
#           it_behaves_like 'json result'

#           specify 'balance not updated' do
#             before_balance = user.credits.first.balance
#             transaction = Transaction.find(transaction_id)
#             rollback_sign = transaction.type == 'Payment' ? 1 : -1
#             rollback_value = transaction.amount * rollback_sign
#             api_call params
#             expect(Credit.find(transaction.transactionable.id_str).balance.amount).to eq before_balance.amount
#           end
#         end

#         context 'update balance on payment update' do
#           let!(:curr_payment) { user.credits.first.transactions << FactoryGirl.build(:payment) }
#           let(:params) { { amount: 20, currency: 'usd' } }
#           let(:transaction_id) { user.credits.first.transactions.last.id_str }
#           it_behaves_like '200'
#           it_behaves_like 'json result'

#           specify 'balance not updated' do
#             before_balance = user.credits.first.balance
#             transaction = Transaction.find(transaction_id)
#             rollback_sign = transaction.type == 'Payment' ? 1 : -1
#             rollback_value = transaction.amount * rollback_sign
#             api_call params
#             expect(Credit.find(transaction.transactionable.id_str).balance.amount).to eq before_balance.amount
#           end
#         end
#       end
#     end

#     def api_call *params
#       put '/api/v1/transaction/' + transaction_id, *params, headers
#     end
#   end

# end
