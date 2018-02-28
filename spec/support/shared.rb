RSpec.shared_examples 'json result' do
  specify 'returns JSON' do
    api_call params
    expect(response.headers["Content-Type"]).to eq "application/json"
    expect { JSON.parse(response.body) }.not_to raise_error
  end
end

RSpec.shared_examples '400' do
  specify 'does not return 400' do
    api_call params
    expect(response.status).to eq(400)
  end
end

RSpec.shared_examples '200' do
  specify 'does not return 200' do
    api_call params
    expect(response.status).to eq(200)
  end
end

RSpec.shared_examples '201' do
  specify 'does not return 201' do
    api_call params
    expect(response.status).to eq(201)
  end
end

RSpec.shared_examples '204' do
  specify 'does not return 204' do
    api_call params
    expect(response.status).to eq(204)
  end
end

RSpec.shared_examples '401' do
  specify 'does not return 401' do
    api_call params
    expect(response.status).to eq(401)
  end
end

RSpec.shared_examples '404' do
  specify 'does not return 404' do
    api_call params
    expect(response.status).to eq(404)
  end
end

RSpec.shared_examples 'contains error msg' do |msg|
  specify 'error msg is not #{msg}' do
    api_call params
    json = JSON.parse(response.body)
    expect(json['error_msg']).to eq(msg)
  end
end

RSpec.shared_examples 'contains data' do
  specify 'does not contains data' do
    api_call params
    json = JSON.parse(response.body)
    expect(json['data']).to be_present
  end
end

RSpec.shared_examples 'pagination headers' do
  specify 'does not return with pagination headers' do
    api_call params
    expect(response.headers["Per-Page"]).to be_present
    expect(response.headers["Total"]).to be_present
  end
end
