require 'spec_helper'
require 'yt/models/playlist_item'

describe Yt::PlaylistItem do
  subject(:playlist_item) { Yt::PlaylistItem.new attrs }

  describe '#snippet' do
    context 'given fetching a playlist item returns a snippet' do
      let(:attrs) { {snippet: {"position"=>0}} }
      it { expect(playlist_item.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#status' do
    context 'given fetching a playlist item returns a status' do
      let(:attrs) { {status: {"privacyStatus"=>"public"}} }
      it { expect(playlist_item.status).to be_a Yt::Status }
    end
  end

  describe '#delete' do
    let(:attrs) { {id: 'playlist-item-id'} }

    context 'given an existing playlist item' do
      before { expect(playlist_item).to receive(:do_delete).and_yield }

      it { expect(playlist_item.delete).to be true }
      it { expect{playlist_item.delete}.to change{playlist_item.exists?} }
    end
  end

	before :each do
		@myplaylist_item = Yt::PlaylistItem.new
	end

	describe '#resource_id' do
		it do
			allow(@myplaylist_item).to receive(:video_id).and_return('test-id')
			expected = {
				kind: 'youtube#video',
				videoId: 'test-id'
			}
			expect(@myplaylist_item.send(:resource_id)).to eq(expected)
		end
	end

	describe '#update_parts' do
		it do
			expected = {
				snippet: {
					keys: [:position, :playlist_id, :resource_id],
					required: true
				}
			}
			expect(@myplaylist_item.send(:update_parts)).to eq(expected)
		end
	end
end
