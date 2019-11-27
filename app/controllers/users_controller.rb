class UsersController < ApplicationController
  before_action :set_user, :only => [:show, :edit, :update, :destroy]
  # before_action :authenticate_user, only: [:show]

  # GET /users.json
  def index
    @users = User.all
    render json: @users, :only => [:id, :email, :name, :admin], :include => [{:memberships => {:only => [:id, :project_id, :user_id, :admin, :invitation, :email], :include => [{:project => {:only => [:id, :name, :description]}}]}}]
  end

  # GET /users/1.json
  def show
    @user = User.find params[:id]
    render json: @user, :only => [:id, :email, :name, :admin], :include => [{:memberships => {:only => [:id, :project_id, :user_id, :admin, :invitation, :email], :include => [{:project => {:only => [:id, :name, :description]}}]}}]
  end

  # NOTE: registration controller taking care of user creation
  # def create
  # end

  # Not implementing update of user
  def update
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :memberships => [])
  end
end
