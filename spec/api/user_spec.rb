# require 'rails_helper'

# describe 'Users API' do
#   # declarations
#   let(:access_token) { AccessTokenAuth.issue(user) }
#   let!(:user) { create :user }

#   let(:admin_access_token) { AccessTokenAuth.issue(admin) }
#   let!(:admin) { create :user, :admin }

#   let(:authorization_header) { { Authorization: 'Basic ' + access_token } }
#   let(:admin_authorization_header) { { Authorization: 'Basic ' + admin_access_token } }

#   let(:params) {}
#   let(:headers) {}

#   ###################
#   # GET api/v1/user #
#   ###################

#   describe 'GET api/v1/user' do
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
#           expect(JSON.parse(response.body)['data'].count).to eq User.all.count
#         end
#       end

#       context 'with ordering' do
#         # id first_name last_name username email created_at updated_at
#         context 'ordered id' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :id } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:asc, :id_str)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :id } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:desc, :id_str)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered first_name' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :first_name } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:asc, :first_name)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :first_name } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:desc, :first_name)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered last_name' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :last_name } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:asc, :last_name)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :last_name } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:desc, :last_name)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered username' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :username } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:asc, :username)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :username } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:desc, :username)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end
#         end

#         context 'ordered email' do
#           context 'asc' do
#             let(:params) { { order: :asc, order_by: :email } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:asc, :email)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
#               end
#             end
#           end

#           context 'desc' do
#             let(:params) { { order: :desc, order_by: :email } }
#             it_behaves_like '200'
#             it_behaves_like 'json result'
#             it_behaves_like 'contains data'
#             it_behaves_like 'pagination headers'

#             specify 'is not in order correctly' do
#               api_call params
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:desc, :email)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
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
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:asc, :created_at)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
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
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:desc, :created_at)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
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
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:asc, :updated_at)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
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
#               returned_users = JSON.parse(response.body)['data']

#               users = User.all.send(:desc, :updated_at)
#               users.each do |user, i|
#                 expect(user.id_str).to eq returned_users[i]['id'] if !i.nil?
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
#             expect(response.headers['Total']).to eq User.all.count.to_s
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
#             returned_users = JSON.parse(response.body)['data']

#             returned_users.each do |returned_user|
#               expect(returned_user[:created_at]).to be >= period_params[:start_date]
#               expect(returned_user[:created_at]).to be <= period_params[:end_date]
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
#             returned_users = JSON.parse(response.body)['data']
#             expect(returned_users.count).to eq 0
#           end
#         end
#       end
#     end

#     def api_call *params
#       get '/api/v1/user', *params, headers
#     end

#   end

#   #######################
#   # GET api/v1/user/:id #
#   #######################

#   describe 'GET api/v1/user/:id' do
#     # declarations
#     let(:user_id) { admin.id_str }

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
#       let(:user_id) { user.id_str }

#       context 'on user requesting their own user info' do
#         let(:headers) { authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'not returning the correct user data' do
#           api_call params
#           expect(JSON.parse(response.body)['data']['id']).to eq user_id
#         end

#         specify 'returning multiple users' do
#           api_call params
#           expect(JSON.parse(response.body)['data']).to be_a(Object)
#         end
#       end

#       context 'on admin requesting other user\'s info' do
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '200'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'

#         specify 'not returning request data' do
#           api_call params
#           expect(JSON.parse(response.body)['data']['id']).to eq user_id
#         end
#       end
#     end

#     def api_call *params
#       get '/api/v1/user/' + user_id, *params, headers
#     end

#   end

#   ###############################
#   # GET api/v1/user/:id/credits #
#   ###############################

#   describe 'GET api/v1/user/:id/credits' do
#     # declarations
#     let(:user_id) { user.id_str }
#     let!(:credits) { 5.times do user.credits << FactoryGirl.build(:credit) end }
#     # let(:user_credits) { credits.each do |credit| user.credits << credit end }

#     context 'negative tests' do
#       context 'on querying with other user\'s id' do
#         let(:headers) { authorization_header }
#         let(:user_id) { admin.id_str }
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

#       context 'invalid ordering param' do
#         let(:params) { { order_by: 'abc' } }
#         let(:headers) { admin_authorization_header }
#         it_behaves_like '400'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'order_by does not have a valid value'
#       end
#     end

#     context 'positive tests' do
#       let(:headers) { authorization_header }

#       context 'without extra params' do
#         it_behaves_like '200'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains data'
#         it_behaves_like 'pagination headers'

#         specify 'returns an array of credits' do
#           api_call params
#           expect(JSON.parse(response.body)['data']).to be_a(Array)
#           expect(JSON.parse(response.body)['data'].count).to eq User.find(user_id).credits.count
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

#               credits = User.find(user_id).credits.send(:asc, :credit_limit)
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

#               credits = User.find(user_id).credits.send(:desc, :credit_limit)
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

#               credits = User.find(user_id).credits.send(:asc, :apr)
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

#               credits = User.find(user_id).credits.send(:desc, :apr)
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

#               credits = User.find(user_id).credits.send(:asc, :next_billing_statement)
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

#               credits = User.find(user_id).credits.send(:desc, :next_billing_statement)
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

#               credits = User.find(user_id).credits.send(:asc, :last_billing_statement)
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

#               credits = User.find(user_id).credits.send(:desc, :last_billing_statement)
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

#               credits = User.find(user_id).credits.send(:asc, :created_at)
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

#               credits = User.find(user_id).credits.send(:desc, :created_at)
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

#               credits = User.find(user_id).credits.send(:asc, :updated_at)
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

#               credits = User.find(user_id).credits.send(:desc, :updated_at)
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
#             expect(response.headers['Total']).to eq User.find(user_id).credits.count.to_s
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
#       get '/api/v1/user/' + user_id + '/credits', *params, headers
#     end
#   end
# end
