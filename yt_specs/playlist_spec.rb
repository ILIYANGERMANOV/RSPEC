require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist do
  subject(:playlist) { Yt::Playlist.new attrs }

  describe '#exists?' do
    context 'given a playlist with an id' do
      let(:attrs) { {id: 'PLSWYkYzOr'} }
      it { expect(playlist).to exist }
    end

    context 'given a playlist without an id' do
      let(:attrs) { {} }
      it { expect(playlist).not_to exist }
    end
  end

  describe '#snippet' do
    context 'given fetching a playlist returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(playlist.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#status' do
    context 'given fetching a playlist returns a status' do
      let(:attrs) { {status: {"privacyStatus"=>"public"}} }
      it { expect(playlist.status).to be_a Yt::Status }
    end
  end

  describe '#update' do
    let(:attrs) { {id: 'PLSWYkYzOr', snippet: {'title'=>'old'}, status: {"privacyStatus"=>"public"}} }
    before { expect(playlist).to receive(:do_update).and_yield 'snippet'=>{'title'=>'new'} }

    it { expect(playlist.update title: 'new').to be true }
    it { expect{playlist.update title: 'new'}.to change{playlist.title} }
  end

  describe '#delete' do
    let(:attrs) { {id: 'PLSWYkYzOr'} }

    context 'given an existing playlist' do
      before { expect(playlist).to receive(:do_delete).and_yield }

      it { expect(playlist.delete).to be true }
      it { expect{playlist.delete}.to change{playlist.exists?} }
    end
  end

	before :each do
		@myplaylist = Yt::Playlist.new
	end

	describe '#add_video' do
		it 'should receive playlist_items.insert with ignore_errors: true'do
			mocked_items = double("playlist_item_params")
			allow(@myplaylist).to receive(:playlist_items).and_return(mocked_items)
			expect(mocked_items).to receive(:insert).with({:resource_id=>{:kind=>"youtube#video", :videoId=>12}}, 
																										ignore_errors: true)
			@myplaylist.add_video(12, {})
		end
	end

	describe '#add_video!' do
		it 'should receive playlist_items.insert without ignore_errors: true' do
			mocked_playlist_items = double("playlist_items")
			allow(@myplaylist).to receive(:playlist_items).and_return(mocked_playlist_items)
			expect(mocked_playlist_items).to receive(:insert).with({:resource_id=>{:kind=>"youtube#video", :videoId=>12}})
			@myplaylist.add_video!(12, {})
		end
	end

	describe '#delete_playlist_items' do 
		it 'should receive playlist_items.delete_all with attrs' do
			attrs = {}
			mocked_playlist_items = double("playlist_items")
			allow(@myplaylist).to receive(:playlist_items).and_return(mocked_playlist_items)
			expect(mocked_playlist_items).to receive(:delete_all).with(attrs)
			@myplaylist.delete_playlist_items(attrs)
		end
	end
end
