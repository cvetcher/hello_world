require 'rails_helper'

RSpec.describe User, type: :model do
	let!(:user) {
		create(:user, birthdate: '2006-06-06')
	}

	it { should be_a described_class }

	describe '#days_until_birthdate' do
		{
			'2022-06-05' => 1,
			'2022-06-06' => 0,
			'2022-06-07' => 364,
			'2023-06-07' => 365, # leap year
			'2022-05-07' => 30,
			'2022-07-05' => 336,
		}.each_pair do |now, days_left|
			context "for now date #{now}" do
				it {
					now_date = DateTime.parse now
					expect(
						user.days_until_birthdate now_date
					).to eq days_left
				}
			end
		end
	end

end
