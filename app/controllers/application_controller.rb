class ApplicationController < ActionController::Base
before_action :get_country

	  def get_country
    if Rails.env.production?

      if request.present? && request.location.present?
        @country = request.location&.country_code
        @country_name = request.location&.country
        @city_name = request.location.city
      else
        @country = 'GH'
        @country_name = 'Ghana'
        @city_name = 'Accra'
      end
    else

      @country = "USA" # you can replace Not Found with some default  country so the code will not break on development mode too
      @country_name = "United States"
      @city_name = "Washington DC"
    end
  end

end
