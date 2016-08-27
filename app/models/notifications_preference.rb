class NotificationsPreference < ActiveRecord::Base
  enum sending_types: [:only_web, :only_email, :web_and_email]

  # Consideration level:
  # - one: all notifications are sent
  # - two: no notifications about something where i've not contributed (example, voted tasks)
  # - three: only notifications about my personal work (tasks created...)
  # - four: only notifications about progress
  # - five: no consideration
  enum minimum_considerations_for_sending: [:one, :two, :three, :four, :five]

  belongs_to :thinker
end
