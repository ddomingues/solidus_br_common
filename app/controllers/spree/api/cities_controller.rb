module Spree
  module Api
    class CitiesController < Spree::Api::BaseController
      skip_before_action :authenticate_user

      def index
        @cities = scope.ransack(params[:q]).result.
          includes(:state).order(name: :asc).
          page(params[:page]).per(params[:per_page])

        city = City.order(updated_at: :asc).last
        if stale?(city)
          respond_with(@cities)
        end
      end

      def show
        @city = scope.find(params[:id])
        respond_with(@city)
      end

      private
      def scope
        if params[:state_id]
          @state = State.accessible_by(current_ability, :read).find(params[:state_id])
          return @state.cities.accessible_by(current_ability, :read)
        else
          return City.accessible_by(current_ability, :read)
        end
      end
    end
  end
end
