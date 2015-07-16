module ApplicationHelper

  def display_visibility(value)
    if value == 'publiced'
      'Public'
    elsif value == 'privated'
      'Private'
    end
  end

  def display_full_date(date)
    date.to_formatted_s :long_ordinal
  end
end
