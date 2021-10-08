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
    user_params = {
      user: {
        name: 'Cop',
        email: 'cop@hot.com',
        password: 'badcop',
        password_confirmation: 'badcop'
      }
    }
    # binding.irb
    post '/users', user_params
    expect(last_response).to be_ok
  end
end