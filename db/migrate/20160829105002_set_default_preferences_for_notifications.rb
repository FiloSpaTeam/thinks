class SetDefaultPreferencesForNotifications < ActiveRecord::Migration
  def self.up
    thinkers = Thinker.all

    thinkers.each do |thinker|
      if thinker.notifications_preference.nil?
        notifications_preference = NotificationsPreference.new

        notifications_preference.thinker = thinker
        notifications_preference.save
      end
    end
  end

  def self.down
  end
end
