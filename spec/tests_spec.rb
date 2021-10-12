describe do
  
  describe do
    let!(:post) { create(:post) }
    it 'Testing root route' do
      get '/'
      body = JSON.parse(last_response.body)
      expect(body.first["title"]).to eq(post.title)
    end
  end

  describe do
    it 'Testing logout' do
      post '/logout'
      session = JSON.parse(last_response.session)
      expect(session.first["user_id"]).to be nil
    end
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
    post '/users', user_params
    expect(last_response).to be_ok
  end

# --- Testing to create post
  it 'Testing create post' do
    
  end

# --- Testing login
  describe do
    let!(:user) { create(:user) }
    it 'Testing loggin' do
      post '/login', { email: user.email, password: user.password  }
      expect(last_response).to be_ok
    end
  end
end