require 'rails_helper'

RSpec.describe WidgetController, :type => :controller do

  let!(:published_album)   { create(:album, is_published: true) }
  let!(:unpublished_album) { create(:album, is_published: false) }

  describe 'GET index' do
    context 'when album is published' do
      let(:params) { { album_id: published_album.id, widget_type: 'gallery' } }
      
      before(:each) do
        get :index, params
      end

      it 'returns http success' do
        expect(response).to be_success
      end

      it 'returns correct Content-Type' do
        expect(response.headers['Content-Type']).to eq 'text/javascript; charset=utf-8'
      end
    end

    context 'when album is not published' do
      let(:params)  { { album_id: unpublished_album.id, widget_type: 'gallery' } }
        
      before(:each) do
        get :index, params
      end
    
      it 'returns http success' do
        expect(response).to be_success
      end

      it 'returns correct Content-Type' do
        expect(response.headers['Content-Type']).to eq 'application/javascript'
      end

      it 'returns nothing' do
        expect(response.body).to be_blank
      end
    end
  end
end
