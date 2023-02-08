class User < ApplicationRecord

	validates :name, presence: true
	validates :name, format: { with: /\A[a-zA-Z]+\z/, message: "must contain only letters" }

	validates :birthdate, presence: true
	validates_each :birthdate do |record, attr, value|
		record.errors.add(attr, 'must be a date before the today date') if value >= DateTime.now
	end

	def days_until_birthdate current
		is_birthdate_this_year = (birthdate.month == current.month && birthdate.day >= current.day) ||
				(birthdate.month > current.month)

		next_birthdate = Date.new current.year + (is_birthdate_this_year ? 0 : 1), birthdate.month, birthdate.day
		(next_birthdate.to_date - current.to_date).to_i
	end
	# NB days also depend on the timezone for the calendar date

end
