class DayDecorator < Draper::Decorator
  # don't delegate_all in this one! it's too easy to forget to in_time_zone things
  delegate :absences?
  def starts_at
    object.start.in_time_zone(object.tz).strftime("%l:%M%P %Z") if object.start
  end

  def late_at
    object.late_time.in_time_zone(object.tz).strftime("%l:%M%P %Z")
  end

  def created_on
    adjusted_time = object.created_at.in_time_zone(object.tz)
    adjusted_time.strftime("%A, %B #{adjusted_time.day.ordinalize}")
  end

  def override_code
    object.override_code
  end

  def checkins_hash
    #possible timezone bug since as_hash might do it wrong?
    object.checkins.map(&:as_hash)
  end

  def month_name
    object.start.strftime("%B")
  end

  def date_in_words
    object.start.strftime("%a %e")
  end

  def unaccounted_for_students_names
    object.unaccounted_for_students.map(&:name).join ','
  end
end
