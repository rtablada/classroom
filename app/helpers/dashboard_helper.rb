module DashboardHelper

  def week_number(total, index)
    ((index + 1) - total).abs + 1
  end

  def status_for(assignment, student)
    case
    when assignment.completed_by?(student)            then as_label('Completed',  :success)
    when assignment.incomplete_by?(student)           then as_label('Incomplete', :warning)
    when assignment.submissions_for(student).present? then as_label('Pending')
    when assignment.late?                             then as_label('Late',       :danger)
    end
  end

  private

  def has_feedback?(submission)
    submission.ratings.count > 0 && submission.ratings.first.notes.length > 1
  end

  def as_label(msg, severity = :default)
    content_tag(:span, msg, class: "label label-#{severity}")
  end
end
