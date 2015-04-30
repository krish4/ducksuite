require 'rails_helper'

RSpec.describe InstagramController, type: :controller do
  it 'rejects subscriptions-related requests from instagram' do
    get('subscription_callback')
    expect(response).to have_http_status :unprocessable_entity
  end
end
