# Users controller
class API::V2::UsersController < API::V2::APIController
  def me
    render json: @current_user
  end

  # GET /
  def index
    render json: @users
  end

  # POST /
  def create
    render json: User.create!(user_params), status: :created
  end

  # GET /:id
  def show
    render json: @user
  end

  # PUT /:id
  def update
    @user.update!(user_params)
    render json: @user
  end

  # DELETE /:id
  def destroy
    @user.destroy!
    head :no_content
  end

  def user_params
    params.require(:user)
        .permit(:email, :name, :role)
  end
end
