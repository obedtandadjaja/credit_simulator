# require 'rails_helper'

# describe 'POST /api/auth' do

#   # declarations
#   let(:username) { user.username }
#   let(:password) { user.password }
#   let!(:user) { create :user }
#   let(:valid_params) { { username: username, password: password } }
#   let(:params) { valid_params }

#   context 'negative tests' do
#     context 'missing params' do
#       context 'password' do
#         let(:params) { valid_params.except(:password) }
#         it_behaves_like '400'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'password is missing'
#       end

#       context 'username' do
#         let(:params) { valid_params.except(:username) }
#         it_behaves_like '400'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'username is missing'
#       end
#     end

#     context 'invalid params' do
#       context 'incorrect password' do
#         let(:params) { valid_params.merge(password: 'invalid') }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Bad Authentication Parameters'
#       end

#       context 'username does not exist' do
#         let(:params) { valid_params.merge(username: 'invalid') }
#         it_behaves_like '401'
#         it_behaves_like 'json result'
#         it_behaves_like 'contains error msg', 'Bad Authentication Parameters'
#       end
#     end
#   end

#   context 'positive tests' do
#     context 'valid params' do
#       let(:params) { valid_params }
#       it_behaves_like '200'
#       it_behaves_like 'json result'

#       specify 'returns the token as part of the response' do
#         api_call params
#         expect(JSON.parse(response.body)['access_token']).to be_present
#         expect(JSON.parse(response.body)['user_id']).to be_present
#       end
#     end
#   end

#   def api_call *params
#     post "/api/auth", *params
#   end

# end
