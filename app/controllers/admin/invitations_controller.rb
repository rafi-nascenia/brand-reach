class Admin::InvitationsController < ApplicationController
  skip_before_action :check_profile_completion, :block_admin_user
  layout 'admin'

  def index
    authorize :admin, :manage_brandreach?
    @invitations = Admin::Invitation.all.page params[:page]
  end

  def create
    authorize :admin, :manage_brandreach?
    @invitation = Admin::Invitation.create(invitation_params)
  end

  def brand_invitation
    authorize :admin, :manage_brandreach?
    @invited_brands= User.where(status: User.statuses[:invited], user_type: User.user_types[:brand]).page params[:page]
    Rails.logger.info "Loaded brand initation #{@invited_brands.inspect}"
  end

  def create_brand_invitation
    authorize :admin, :manage_brandreach?

    @user = User.new(user_params)
    password = Devise.friendly_token.first(8)
    @user.password = password
    @user.password_confirmation = password
    @user.user_type = User.user_types[:brand]
    @user.status = User.statuses[:invited]

    @success = true
    @messages = []

    unless @user.save
      @messages = @user.errors.full_messages
      @success = false
    end

    respond_to do |format|
      format.js{ }
    end
  end

  def resend
    user = User.where(id: params[:id], status: User.statuses[:invited])
    @success = false

    if user
      user.send(:send_mail)
      @success = false
    else

    end
  end

  def destroy
  end

  private

  def invitation_params
    params.require(:invitation).permit(:first_name, :last_name, :email)
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :position, :company_name, :phone, :short_bio)
  end
end
