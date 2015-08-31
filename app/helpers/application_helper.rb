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

  def display_tags(tags)
    tags.present? ? tags.map(&:name).join(', ') : 'None'
  end
end
