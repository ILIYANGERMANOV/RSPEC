require 'spec_helper'
require 'yt/models/advertising_options_set'

describe Yt::AdvertisingOptionsSet do
	before :each do
		@mocked_auth = double("@auth")
		attrs = {
			:auth => @mocked_auth,
			:data => {'adFormats'=>'expected'}
		}
		@myclass = Yt::AdvertisingOptionsSet.new attrs
	end

	describe '#update' do
		it do
				expect(@myclass).to receive(:underscore_keys!)
				expect(@myclass).to receive(:do_patch)
				expect(@myclass.update).to be true
		end
	end

	describe '#ad_formats' do  
		it do
			expect(@myclass.ad_formats).to eq('expected')
		end
	end

	describe '#patch_params' do
		it 'should eq expected' do
			allow(@mocked_auth).to receive(:owner_name).and_return("test")
			expected = {
				:expected_response => Net::HTTPOK,
				:path =>  "/youtube/partner/v1/videoAdvertisingOptions/#{@video_id}",
				:params => {on_behalf_of_content_owner: @mocked_auth.owner_name},
				:host => "www.googleapis.com",
				:method => :patch,
				:auth => @mocked_auth
			}
			expect(@myclass.send(:patch_params)).to eq(expected)
		end
	end
end
