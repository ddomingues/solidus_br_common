module Spree
  module Api
    module ApiHelpers
      mattr_reader :city_attributes

      @@city_attributes = [:id, :name, :ibge_code, :state_id]
    end
  end
end
