# frozen_string_literal: true

FactoryBot.define do
	factory :user do
		name { 'cv' }
		trait :valid do
			birthdate { '2006-06-06' }
		end
	end
end
