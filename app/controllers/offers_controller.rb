class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy, :accept, :deny, :undo_deny, :reply_message, :make_messages_read]

  # GET /offers
  # GET /offers.json
  def index
      @offers = Offer.get_active_offer(current_user).includes(:messages).order('messages.created_at desc')
      @stared_offers =  Offer.get_stared_offer(current_user).includes(:messages).order('messages.created_at desc')
  end

 # take array of offer ids and make those stared
  #  target_column may be 'starred_by_brand' of 'starred_by_influencer'
  def toggle_star
    target_column = current_user.brand? ? :starred_by_brand : :starred_by_influencer
    @ids = params[:ids].map(&:to_i)
    offers = Campaign.where(id: @ids)

    @reset = nil

    if offers.count == offers.where(target_column => true).count
      # all offers are stared
      reset_star(offers, target_column)
      @reset = true
    elsif offers.count == offers.where(target_column => false).count
      # all offers are non stared
      set_star(offers, target_column)
    else
      # make all stared
      set_star(offers, target_column)
    end

    # redirect_to offers_path
  end

  def accept
    @offer.update_attribute(:status, Campaign.statuses[:accepted])
    CampaignMailer.campaign_accept_notification(@offer).deliver_now if @offer.sender.email_remainder_active?
  end

  def deny
    @offer.update_attributes({status: Campaign.statuses[:denied], denied_at: Time.now })
    CampaignMailer.campaign_deny_notification(@offer).deliver_now if @offer.sender.email_remainder_active?
  end

  def undo_deny
    @offer.update_attribute(:status, Campaign.statuses[:waiting])
    CampaignMailer.campaign_deny_undo_notification(@offer).deliver_now if @offer.sender.email_remainder_active?
  end

  def reply_message
      message = @offer.messages.new(sender_id: current_user.id, receiver_id: params[:receiver_id], body: params[:body])

      if message.save
        success = true
        id = @offer.id
        # CampaignMailer.campaign_new_message_notification(message).deliver if message.receiver.email_remainder_active?
      else
        success = false
        id = @offer.id
      end

      respond_to do |format|
        format.json { render :json => {success: success, id: id }}
      end
  end

  def make_messages_read
      @offer.messages.where(receiver_id: current_user.id, read: false).update_all(:read => true)

      respond_to do |format|
        format.json { render :json => { id: @offer.id }}
      end
  end

  def delete_offers
    target_column = current_user.brand? ? :deleted_by_brand : :deleted_by_influencer
    @ids = params[:ids].map(&:to_i)
    offers = Campaign.where(id: @ids)

    offers.update_all(target_column => true)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params[:campaign]
    end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:user).permit(:body, :sender_id, :receiver_id, :campaign_id)
  end


  def set_star(offers, target_column)
    offers.update_all(target_column => true)
  end

  def reset_star(offers, target_column)
    offers.update_all(target_column => false)
  end
end
