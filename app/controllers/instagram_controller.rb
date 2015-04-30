class InstagramController < ApplicationController
  def confirm_subscription
    head :bad_request unless valid_subscription_request?
    render text: new_subscription_params["hub.challenge"], status: :ok
  end

  def process_subscription
    Instagram.process_subscription(params["_json"].to_json) do |handler|
      handler.on_tag_changed do |tag_name, payload|
        Album.find_by_main_hashtag(tag_name).each do |album|
          Inbox.new(album.id).increase_pending_pictures
        end
      end
    end
    render nothing: true, status: :ok
  end

  def subscription_callback
    head :unprocessable_entity
  end

  private
    def new_subscription_params
      params.require("hub.challenge") and params.require("hub.mode")
      params.permit("hub.challenge", "hub.mode")
    end

    def valid_subscription_request?
      new_subscription_params["hub.mode"] == "subscribe"
    end
end
