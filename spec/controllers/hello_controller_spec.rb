require 'rails_helper'

RSpec.describe HelloController, type: :controller do
	include Rails.application.routes.url_helpers

	let(:name) { 'cv' }

	let(:past) { '2023-02-07' }
	let(:today) { '2023-02-08' }
	let(:future) { '2023-02-09' }

	# Freeze the now date
	before {
		allow(DateTime).to receive(:now).and_return(DateTime.parse today)
	}

	let(:errors) { JSON.load(response.body)['errors'] }
	let(:message) { JSON.load(response.body)['message'] }

	context 'with no users in the database' do
		describe 'GET #greet' do
			it 'finds no user' do
				get :greet, params: {name: name}
				expect(response).to have_http_status(:not_found)
			end
		end

		describe 'PUT #save' do
			it 'creates a user for valid input' do
				put :save, params: {name: name, 'dateOfBirth': past }
				expect(response).to have_http_status(204)
			end

			it 'rejects a user with an invalid name' do
				put :save, params: {name: 'rd2d', 'dateOfBirth': past }
				expect(response).to have_http_status(400)
				expect(errors).to include ["name", "must contain only letters"]
			end

			it 'rejects a user with a date of birth today' do
				put :save, params: {name: name, 'dateOfBirth': today }
				expect(response).to have_http_status(400)
				expect(errors).to include ["birthdate", "must be a date before the today date"]
			end

			it 'rejects a user with a date of birth in the future' do
				put :save, params: {name: name, 'dateOfBirth': future }
				expect(response).to have_http_status(400)
				expect(errors).to include ["birthdate", "must be a date before the today date"]
			end
		end

	end # 'with no users in the database'



	context 'with an already existing user in the database' do
		let(:birthdate) { past }
		before {
			create(:user, name: name, birthdate: birthdate)
		}

		describe 'GET #greet' do
			it 'finds no user with a wrong name' do
				get :greet, params: {name: name+name}
				expect(response).to have_http_status(:not_found)
			end

			context 'with a correct name' do
				it 'notifies about coming birthday on a non-birthday date' do
					get :greet, params: {name: name}
					expect(response).to have_http_status(200)
					expect(message).to start_with 'Hello, cv! Your birthday is'
				end

				it 'greets on a birthday date' do
					allow(DateTime).to receive(:now).and_return(DateTime.parse(birthdate) + 1.year)
					get :greet, params: {name: name}
					expect(response).to have_http_status(200)
					expect(message).to eq 'Hello, cv! Happy birthday!'
				end
			end

		end

		describe 'PUT #save' do
			let(:user) { User.find_by_name(name) }
			it 'updates the user with a valid input dateOfBirth' do
				new_birthdate = (DateTime.parse(birthdate) - 1.year).to_date.to_s
				put :save, params: {name: name, 'dateOfBirth': new_birthdate }
				expect(response).to have_http_status(204)
				expect(user.birthdate.to_s).to eq new_birthdate
			end

			it 'fails to update the user with an invalid input dateOfBirth' do
				put :save, params: {name: name, 'dateOfBirth': future }
				expect(response).to have_http_status(400)
				expect(errors).to include ["birthdate", "must be a date before the today date"]
				expect(user.birthdate.to_s).to eq birthdate
			end

		end

	end # 'with a user "cv" in the database'

end
