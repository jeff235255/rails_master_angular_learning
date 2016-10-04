class UsersController < ApplicationController
  before_filter :set_user, :except => [:new, :create, :update, :show]

  def index
  end

  def new
    @user = User.new
  end

  def create
  end

  def show
  end

  def edit
    
  end

  def update
    respond_to do |format|
      if @user.update(secure_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @root_url, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(secure_params)
        sign_in(@user, :bypass => true)
        redirect_to root_url, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end


  private 
  def set_user 
    @user = User.find(params[:id])
  end

  def secure_params
    params.require(:user).permit(:name, :current_password, :password, :password_confirmation, :email)
  end
end