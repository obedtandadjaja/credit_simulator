# require 'rails_helper'

# describe 'Credits API' do
#   #declarations
#   let(:access_token) { AccessTokenAuth.issue(user) }
#   let!(:user) { create :user }
#   let!(:user_credits) { 5.times do user.credits << FactoryGirl.build(:credit) end }

#   let(:admin_access_token) { AccessTokenAuth.issue(admin) }
#   let!(:admin) { create :user, :admin }
#   let!(:admin_credits) { 2.times do admin.credits << FactoryGirl.build(:credit) end }

#   let(:authorization_header) { { Authorization: 'Basic ' + access_token } }
#   let(:admin_authorization_header) { { Authorization: 'Basic ' + admin_access_token } }

#   let(:params) {}
#   let(:headers) {}

#   #####################
#   # GET api/v1/credit #
#   #####################

#   describe 'GET api/v1/credit' do
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
#           expect(JSON.parse(response.body)['data'].count).to eq Credit.all.count
#         end
#       end

#       context 'with ordering' do
#         # credit_limit apr next_billing_statement last_billing_statement created_at updated_at
#         context 'ordered id' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :credit_limit } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               credits = Credit.all.send(:asc, :credit_limit)
#               credits.each do |credit, i|
#                 expect(credit.credit_limit).to eq returned_credits[i]['credit_limit'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :credit_limit } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               credits = Credit.all.send(:desc, :credit_limit)
#               credits.each do |credit, i|
#                 expect(credit.credit_limit).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered apr' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :apr } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               credits = Credit.all.send(:asc, :apr)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :apr } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               credits = Credit.all.send(:desc, :apr)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered next_billing_statement' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :next_billing_statement } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               credits = Credit.all.send(:asc, :next_billing_statement)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :next_billing_statement } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               credits = Credit.all.send(:desc, :next_billing_statement)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered last_billing_statement' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :last_billing_statement } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               credits = Credit.all.send(:asc, :last_billing_statement)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :last_billing_statement } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_credits = JSON.parse(response.body)['data']

#               credits = Credit.all.send(:desc, :last_billing_statement)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
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

#               credits = Credit.all.send(:asc, :created_at)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
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

#               credits = Credit.all.send(:desc, :created_at)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
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

#               credits = Credit.all.send(:asc, :updated_at)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
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

#               credits = Credit.all.send(:desc, :updated_at)
#               credits.each do |credit, i|
#                 expect(credit.id_str).to eq returned_credits[i]['id'] if !i.nil?
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
#             expect(response.headers['Total']).to eq Credit.all.count.to_s
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
#             returned_credits = JSON.parse(response.body)['data']

#             returned_credits.each do |returned_credit|
#               expect(returned_credit[:created_at]).to be >= period_params[:start_date]
#               expect(returned_credit[:created_at]).to be <= period_params[:end_date]
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
#             returned_credits = JSON.parse(response.body)['data']
#             expect(returned_credits.count).to eq 0
#           end
#         end
#       end
#     end

#     def api_call *params
#       get '/api/v1/credit', *params, headers
#     end
#   end

#   #########################
#   # GET api/v1/credit/:id #
#   #########################

#   describe 'GET api/v1/credit/:id' do
#     # declarations
#     let(:credit_id) { admin.credits.first.id_str }

#     context 'negative tests' do
#       context 'on querying with other user\'s id' do
#         let(:headers) { authorization_header }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. You have no permission to access other users\' account'
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

#       context 'on user requesting their own credit info' do
#         let(:headers) { authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'not returning the correct credit data' do
#           api_call params
#           expect(user.credits).to include(Credit.find(JSON.parse(response.body)['data']['id']))
#         end

#         specify 'returning multiple credits' do
#           api_call params
#           expect(JSON.parse(response.body)['data']).to be_a(Object)
#         end
#       end

#       context 'on admin requesting other user\'s credit info' do
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'not returning request data' do
#           api_call params
#           expect(user.credits).to include(Credit.find(JSON.parse(response.body)['data']['id']))
#         end
#       end
#     end

#     def api_call *params
#       get '/api/v1/credit/' + credit_id, *params, headers
#     end
#   end

#   ######################################
#   # GET api/v1/credit/:id/transactions #
#   ######################################

#   describe 'GET api/v1/credit/:id/transactions' do
#     let(:credit_id) { user.credits.first.id_str }
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

#       context 'access other users\' account' do
#         let(:credit_id) { admin.credits.first.id_str }
#         let(:headers) { authorization_header }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Unauthorized. You have no permission to access other user\'s account'
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
#           expect(JSON.parse(response.body)['data'].count).to eq user.credits.first.transactions.count
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

#               transactions = user.credits.first.transactions.send(:asc, :amount)
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

#               transactions = user.credits.first.transactions.send(:desc, :amount)
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

#               transactions = user.credits.first.transactions.send(:asc, :currency)
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

#               transactions = user.credits.first.transactions.send(:desc, :currency)
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

#               transactions = user.credits.first.transactions.send(:asc, :type)
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

#               transactions = user.credits.first.transactions.send(:desc, :type)
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

#               transactions = user.credits.first.transactions.send(:asc, :status)
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

#               transactions = user.credits.first.transactions.send(:desc, :status)
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

#               transactions = user.credits.first.transactions.send(:asc, :created_at)
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

#               transactions = user.credits.first.transactions.send(:desc, :created_at)
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

#               transactions = user.credits.first.transactions.send(:asc, :updated_at)
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

#               transactions = user.credits.first.transactions.send(:desc, :updated_at)
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
#             expect(response.headers['Total']).to eq user.credits.first.transactions.count.to_s
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
#       get '/api/v1/credit/' + credit_id + '/transactions', *params, headers
#     end
#   end

#   ######################
#   # POST api/v1/credit #
#   ######################

#   describe 'POST api/v1/credit' do
#     # declarations
#     let(:valid_params) { { credit_limit: rand(1000..100000), apr: rand(0..100) } }
#     let(:params) { valid_params }
#     let(:headers) { authorization_header }

#     context 'negative tests' do
#       context 'missing params' do
#         context 'credit_limit' do
#           let(:params) { valid_params.except(:credit_limit) }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'credit_limit is missing'
#         end

#         context 'apr' do
#           let(:params) { valid_params.except(:apr) }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'apr is missing'
#         end
#       end

#       context 'params wrong type' do
#         context 'credit_limit' do
#           let(:params) { valid_params.merge!(credit_limit: 'abc') }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'credit_limit is invalid'
#         end

#         context 'apr' do
#           let(:params) { valid_params.merge!(apr: 'abc') }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'apr is invalid'
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
#     end

#     context 'positive tests' do
#       context 'on create credit' do
#         let(:headers) { authorization_header }
#         it_behaves_like '201'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'incorrect data created' do
#           api_call params
#           expect(JSON.parse(response.body)['data']['credit_limit'].to_i).to eq params[:credit_limit].to_i
#           expect(JSON.parse(response.body)['data']['apr'].to_i).to eq params[:apr].to_i
#         end

#         specify 'credit created not attached to user' do
#           before_count = user.credits.count
#           api_call params
#           expect(Credit.find(JSON.parse(response.body)['data']['id']).user_id.to_str).to eq user.id_str
#           expect(user.credits.count).to eq before_count+1
#         end
#       end
#     end

#     def api_call *params
#       post '/api/v1/credit/', *params, headers
#     end
#   end

#   ############################
#   # DELETE api/v1/credit/:id #
#   ############################

#   describe 'DELETE api/v1/credit/:id' do
#     let(:credit_id) { user.credits.first.id_str }

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
#       context 'on delete credit' do
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'

#         specify 'credit not deleted' do
#           before_count = user.credits.count
#           api_call params
#           expect(user.credits.first.id_str).not_to eq credit_id
#           expect(user.credits.count).to eq before_count-1
#         end
#       end
#     end

#     def api_call *params
#       delete '/api/v1/credit/' + credit_id, *params, headers
#     end
#   end

#   #########################
#   # PUT api/v1/credit/:id #
#   #########################

#   describe 'PUT api/v1/credit/:id' do
#     let(:credit_id) { user.credits.first.id_str }
#     let(:valid_params) { { credit_limit: rand(1000..100000), apr: rand(0..100), active: false } }
#     let(:params) { valid_params }
#     let(:headers) { admin_authorization_header }

#     context 'negative tests' do
#       context 'params wrong type' do
#         context 'credit_limit' do
#           let(:params) { valid_params.merge!(credit_limit: 'abc') }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'credit_limit is invalid'
#         end

#         context 'apr' do
#           let(:params) { valid_params.merge!(apr: 'abc') }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'apr is invalid'
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
#     end

#     context 'positive tests' do
#       context 'on update credit' do
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'

#         specify 'credit not updated' do
#           api_call params
#           expect(Credit.find(credit_id).credit_limit.to_i).to eq valid_params[:credit_limit].to_i
#           expect(Credit.find(credit_id).apr.to_i).to eq valid_params[:apr].to_i
#           expect(Credit.find(credit_id).active).to eq valid_params[:active]
#         end
#       end
#     end

#     def api_call *params
#       put '/api/v1/credit/' + credit_id, *params, headers
#     end
#   end

#   #################################
#   # POST api/v1/credit/:id/charge #
#   #################################

#   describe 'POST api/v1/credit/:id/charge' do
#     # declarations
#     let(:credit_id) { user.credits.first.id_str }
#     let(:valid_params) { { amount: rand(1..1000), currency: 'usd', description: 'sample' } }
#     let(:params) { valid_params }
#     let(:headers) { authorization_header }

#     context 'negative tests' do
#       context 'missing params' do
#         context 'amount' do
#           let(:params) { valid_params.except(:amount) }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'amount is missing'
#         end

#         context 'currency' do
#           let(:params) { valid_params.except(:currency) }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'currency is missing'
#         end

#         context 'description' do
#           let(:params) { valid_params.except(:description) }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'description is missing'
#         end
#       end

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

#       context 'insufficient funds' do
#         let(:params) { { amount: user.credits.first.balance.amount + 10, currency: 'usd', description: 'sample' } }
#         it_behaves_like '400'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Bad Request. Insufficient funds.'
#       end
#     end

#     context 'positive tests' do
#       context 'on create credit' do
#         let(:headers) { authorization_header }
#         it_behaves_like '201'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'incorrect data created' do
#           api_call params
#           expect(Credit.find(credit_id).transactions.last.amount).to eq params[:amount]
#           expect(Credit.find(credit_id).transactions.last.currency).to eq params[:currency]
#           expect(Credit.find(credit_id).transactions.last.description).to eq params[:description]
#         end

#         specify 'charge created not attached to credit' do
#           before_balance = user.credits.first.balance.amount
#           before_count = user.credits.first.transactions.count
#           api_call params
#           expect(Credit.find(credit_id).balance.amount).to eq before_balance-params[:amount]
#           expect(Credit.find(credit_id).transactions.count).to eq before_count+1
#         end
#       end
#     end

#     def api_call *params
#       post '/api/v1/credit/' + credit_id + '/charge', *params, headers
#     end
#   end

#   ##################################
#   # POST api/v1/credit/:id/payment #
#   ##################################

#   describe 'POST api/v1/credit/:id/payment' do
#     # declarations
#     let(:credit_id) { user.credits.first.id_str }
#     let(:valid_params) { { amount: rand(1..1000), currency: 'usd' } }
#     let(:params) { valid_params }
#     let(:headers) { authorization_header }

#     context 'negative tests' do
#       context 'missing params' do
#         context 'amount' do
#           let(:params) { valid_params.except(:amount) }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'amount is missing'
#         end

#         context 'currency' do
#           let(:params) { valid_params.except(:currency) }
#           it_behaves_like '400'
#           it_behaves_like 'json result'
#           it_behaves_like 'contains error msg', 'currency is missing'
#         end
#       end

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
#     end

#     context 'positive tests' do
#       context 'on create credit' do
#         let(:headers) { authorization_header }
#         it_behaves_like '201'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'incorrect data created' do
#           api_call params
#           expect(Credit.find(credit_id).transactions.last.amount).to eq params[:amount]
#           expect(Credit.find(credit_id).transactions.last.currency).to eq params[:currency]
#         end

#         specify 'payment created not attached to credit' do
#           before_balance = user.credits.first.balance.amount
#           before_count = user.credits.first.transactions.count
#           api_call params
#           expect(Credit.find(credit_id).balance.amount).to eq before_balance+params[:amount]
#           expect(Credit.find(credit_id).transactions.count).to eq before_count+1
#         end
#       end
#     end

#     def api_call *params
#       post '/api/v1/credit/' + credit_id + '/payment', *params, headers
#     end
#   end

# end
