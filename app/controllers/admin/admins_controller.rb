class Admin::AdminsController < ApplicationController
  skip_before_action :check_profile_completion, :block_admin_user
  skip_before_action :authenticate_user!, only: [:log_in]
  before_filter :log_in_user?, only: [:log_in]
  # before_filter :admin?
  respond_to :html, :js, :json

  layout 'admin'

  def manage_admins
    authorize :admin, :manage_admins?
    @admins = User.where(user_type: User.user_types[:admin])

    if params[:email].present?
      wildcard_search = "%#{params[:email].strip! || params[:email]}%"
      @admins = @admins.where('email LIKE :search' , search: wildcard_search)
    end

    @admins = @admins.page params[:page]
  end

  def create
    authorize :admin, :manage_admins?
    @admin = User.new(admin_params) do |admin|
      admin.status = User.statuses[:active]
      admin.user_type = User.user_types[:admin]
    end

    @success = true
    @messages = ''

    if @admin.save
      # @admin.update_column(:status, User.statuses[:active])
      # @admin.update_column(:user_type, User.user_types[:admin])
      # @admin.save
      @messages << 'New admin added successfully.'
    else
      @messages = @admin.errors.full_messages
      @success = false
    end

    Rails.logger.info "----------------Admin is -----------------------#{@admin}------------------"
    respond_to do |format|
      format.js{ }
    end
  end

  def update
    authorize :admin, :manage_brandreach?
    @admin = current_user

    if @admin.update(admin_params.except(:current_password, :password, :password_confirmation))
      if admin_params[:current_password].present? && admin_params[:password].present?
        if @admin.update_with_password(admin_params)
          sign_in  @admin, :bypass => true
          flash[:success] = 'User Password update success'
        else
          flash[:error] = 'Old Password was Not correct or Retype Password does Not match with New Password'
        end
      end
      flash[:success] = 'User Information has been updated successfully' if flash[:error].nil?
      redirect_to profile_admin_admins_path
    else
      render 'profile'
    end
  end

  def destroy
    authorize :admin, :manage_admins?
    @admin = User.where(id: params[:id], user_type: User.user_types[:admin]).first
    @error_message = ''
    @success = false

    if @admin
      @success = true
      @admin.destroy
      @messages = 'Successfully admin deleted.'
    else
      @error_message = 'Requested operation fail.'
    end
  end

  def brands_request
    authorize :admin, :manage_brandreach?
    @brands = User.where(user_type: User.user_types[:brand], status: User.statuses[:waiting])

    if params[:email].present?
      wildcard_search = "%#{params[:email].strip! || params[:email]}%"
      @brands = @brands.where('email LIKE :search' , search: wildcard_search)
    end

    @brands = @brands.page params[:page]
  end

  def profile
    authorize :admin, :manage_brandreach?
    @admin = current_user
  end

  def log_in
    render :layout => false
  end

  def influencer_list
    authorize :admin, :manage_brandreach?
    @influencers = User.active_suspended_influencers

    if params[:email].present?
      wildcard_search = "%#{params[:email].strip! || params[:email]}%"
      @influencers = @influencers.where('email LIKE :search' , search: wildcard_search)
    end

    @influencers = @influencers.page params[:page]
  end

  def brand_list
    authorize :admin, :manage_brandreach?
    @brands = User.active_suspended_brands

    if params[:email].present?
      wildcard_search = "%#{params[:email].strip! || params[:email]}%"
      @brands = @brands.where('email LIKE :search' , search: wildcard_search)
    end

    @brands = @brands.page params[:page]
  end

  def deactivate_user
    authorize :admin, :manage_brandreach?
    @user = User.where(id: params[:id], status: User.statuses[:active],
                       user_type: [User.user_types[:influencer],
                       User.user_types[:brand]
                       ]).first

    @success = false
    @message = 'User suspend request fail'
    logger.info "-----------Rails session now #{session.inspect}"

    if @user
      if @user.engaged_campaigns.present?
        @message = 'Cannot be deactivate at this point. The selected user has active campaigns running.'
      else
        @user.update_column(:status, User.statuses[:suspended])
        session.delete(user_id: @user.id)
        logger.info "------------Rails session now #{       session.delete(user_id: @user.id)
                    }"
        @success = true
        @message = 'Successfully suspend user account.'
      end
    end
  end

  def activate_user
    authorize :admin, :manage_brandreach?

    @user = User.where(id: params[:id], status: [User.statuses[:suspended],User.statuses[:waiting]],
                       user_type: [User.user_types[:influencer],
                                   User.user_types[:brand]
                       ]).first

    @success = false
    @message = 'User activate request fail'

    if @user
      if @user.suspended?
        @user.status = User.statuses[:active]
        @user.save(validate: false)
        CampaignMailer.account_activate_after_deactivate_notification_to_user(@user).deliver_now


      else
        password = Devise.friendly_token.first(8)
        @user.password = password
        @user.password_confirmation = password
        @user.status = User.statuses[:active]
        @user.save(validate: false)
        CampaignMailer.account_activate_notification_to_user(@user, password).deliver_now

      end

      @success = true
      @message = 'Successfully activate user.'
    end
  end

  def make_celebrity
    authorize :admin, :manage_brandreach?

    @user = User.where(id: params[:id], user_type: [User.user_types[:influencer]]).first
    @success = false
    @message = 'Influencer still is a Community.'

    if @user
      @user.influencer_type = User.influencer_types[:celebrity]
      @user.save(validate: false)

      @success = true
      @message = 'Successfully Influencer converted to a Celebrity.'
    end
  end

  def make_community
    authorize :admin, :manage_brandreach?

    @user = User.where(id: params[:id], user_type: [User.user_types[:influencer]]).first
    @success = false
    @message = 'Influencer still is a Celebrity.'

    if @user
      @user.influencer_type = User.influencer_types[:community]
      @user.save(validate: false)

      @success = true
      @message = 'Successfully Influencer converted to a Community.'
    end
  end

  def reset_user_password
    authorize :admin, :manage_brandreach?
    @user = User.where(user_type: User.user_types[:brand], id: params[:id]).first
    @success = true
    @messages = []

    if @user
        temp = @user.send_reset_password_instructions
        Rails.logger.info "#{temp.inspect}"
    else
      @success = false
      @messages << 'User not found.'
    end
  end

  def delete_user
    authorize :admin, :manage_brandreach?
    @user = User.where(id: params[:id]).first
    @success = false
    @message = ''

    if @user
      if @user.engaged_campaigns.present?
        @message = 'Cannot be deleted at this point. The selected user has active campaigns running.'
      else
        @user.destroy
        @success = true
      end
    else
      @message = 'User is not found.'
    end
  end

  # influencer payment requests
  def payment_request
    authorize :admin, :manage_brandreach?
    @payment_requests = InfluencerPayment.includes(:user).order('id DESC')

    @payment_requests = @payment_requests.page params[:page]
  end

  def make_payment_paid
    authorize :admin, :manage_brandreach?
    @payment_request = InfluencerPayment.where(id: params[:payment_id]).first
    @success = false

    if @payment_request && @payment_request.update(status: InfluencerPayment.statuses[:paid])
      @success = true
    else
      @message = 'Requested payment is not found.'
    end
  end

  def show_contact_us_mails
    authorize :admin, :manage_brandreach?

    @contact_us_mails = ContactUs.includes(:user).where.not(user_id: nil).page(params[:page])
  end

  def show_celebrities_campaign
    authorize :admin, :manage_brandreach?
    @celebrity_campaign_list = CelebrityCampaign.all

    @celebrity_campaign_list = @celebrity_campaign_list.page params[:page]
  end

  def remove_celebrities_campaign
    authorize :admin, :manage_brandreach?
    @celebrity_campaign = CelebrityCampaign.find(params[:id])
    @success = false
    @message = ''

    if @celebrity_campaign
      @celebrity_campaign.destroy
      @success = true
    else
      @message = 'Campaign is not found.'
    end
  end

  def show_chat_history_to_admin
    authorize :admin, :manage_admins?
    @messages = Message.order('campaign_id DESC, id DESC')
    @messages = @messages.page(params[:page])
  end

  private

  def admin_params
    params.require(:user).permit(:current_password, :first_name, :last_name, :email, :password, :password_confirmation,
                     :user_type)
  end

  def log_in_user?
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end
