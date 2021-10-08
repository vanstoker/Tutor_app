describe do
  it do
    get '/'
    # binding.irb
    expect(last_response).to be_ok
  end

  it 'Going to \'Contact\' page' do
    get '/contact'
    expect(last_response).to be_ok
  end

  it 'Create user' do
    post '/users'
    binding.irb
    expect(last_response).to be_ok
  end
end