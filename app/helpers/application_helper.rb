module ApplicationHelper

  def display_visibility(value)
    if value == 'publiced'
      'Public'
    elsif value == 'privated'
      'Private'
    end
  end
end
