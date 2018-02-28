require 'grape-swagger'

class RootApi < Grape::API
  prefix 'api'

  format :json

  # on document not found
  rescue_from Mongoid::Errors::DocumentNotFound do |error|
    rack_response({ status: 404, error_msg: 'No record found'}.to_json, 404)
  end

  # on validations error
  rescue_from Grape::Exceptions::ValidationErrors do |error|
    rack_response({ status: error.status, error_msg: error.message }.to_json, 400)
  end

  mount V1::BaseApi
  mount Auth::Api

  add_swagger_documentation

end
