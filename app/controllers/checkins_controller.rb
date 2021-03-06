class CheckinsController < ApplicationController
  after_action :verify_authorized, :except => :index
  def create
    # Hardcoded business rules :(
    # -- In a controller of all places too. Ugh.
    #

    checkin         = Checkin.new
    authorize checkin
    day = current_user.student.cohort.current_day

    if !day || day.has_checkin_for?(current_user.student)
      render json: '', status: :bad_request
    else
      checkin.student = current_user.student
      checkin.day     = day
      provided_code   = params.fetch(:override_code, 'none')
      distance        = params.fetch(:distance, 0)
      if distance.to_i > 1.0 && provided_code != day.override_code
        render json: 'Code Invalid', status: :unauthorized
      elsif checkin.save
        render json: [
          checkin.created_at.strftime("%I:%M%p"),
          checkin,
          { tardies: current_user.student.tardies, absences: current_user.student.absences }
        ].to_json, status: 200
      else
        render json: checkin.errors, status: :unprocessable_entity
      end
    end
  end
end
