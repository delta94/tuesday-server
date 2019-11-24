class SessionController < ApplicationController
  def create
    user = User.find_by :email => params['user']['email']
    if user.present?  && user.authenticate(params['user']['password'])
      session[:user_id] = user.id
      created_jwt = JWT.encode({id: user.id}, "mys3cr3t", "HS256")
      cookies.signed[:jwt] = {
        value: created_jwt,
        httponly:true,
        expires: 1.hour.from_now
      }
      render json: {
        status: :created,
        logged_in: true,
        user: user
      }
    else
      render json: { status: 401,
      params: params}
    end
  end

  def logged_in
    if session[:user_id]
      @current_user = User.find(session[:user_id])
      render json: {
        logged_in: true,
        user: @current_user
      }
    else
      render json: { logged_in: false }
    end
  end

  def logout
    session[:user_id] = nil
    cookies.delete(:jwt)
    render json: {
      status: 200,
      session: session,
      logged_out: true
    }
  end


end
