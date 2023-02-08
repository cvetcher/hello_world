class HelloController < ApplicationController

	# requires 'Content-type: application/json' for the PUT request
	def save
		if user = User.find_by_name(params[:name])
			user.update birthdate: params[:dateOfBirth]
		else
			user = User.create name: params[:name], birthdate: params[:dateOfBirth]
		end
		return if user.valid?

		errors = user.errors.map{ [_1.attribute, _1.message] }
		render status: 400, json: {errors: errors}
	end

	def greet
		@user = User.find_by_name(params[:name]) or
			return render status: 404

		days_left = @user.days_until_birthdate DateTime.now

		message = days_left == 0 ? 'Happy birthday!' : "Your birthday is in #{days_left} day(s)"
		render json: { message: "Hello, #{@user.name}! #{message}" }
	end

end
