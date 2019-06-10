class Api::V1::RegistrationsController < ApplicationController
    before_action :ensure_params_exist, only: :create

    def create
        user = User.new(user_params)

        if user.save
            render json: {
                messages: "Signed up successfully",
                success: true,
                data: {
                    user: user 
                }
            }, status: :ok
        else
            render json: {
                messages: "Sign up failed",
                success: false,
                data: {}     
            }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def ensure_params_exist
        return if params[?user].present?
        render json: {
            messages: "Missing params",
            success: false,
            data: {}
        }, status: :bad_request
    end

end