class HealthcheckController < ApplicationController

    def local
        render status: 200
    end

    def database
        ActiveRecord::Base.connection.execute("select 1 = 1")
        render status: 200
    end

end
