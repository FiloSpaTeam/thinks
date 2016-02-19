namespace :admin do
  desc 'Allow admin to reset counters of database'
  task reset_counters: :environment do
    puts "Likes counter reset"
    Comment.find_each { |comment| Comment.reset_counters(comment.id, :likes) }

    puts 'Counters reset done'
  end

  desc 'This task update sprint automatically'
  task update_sprint_system: :environment do
    puts 'Sprint update system (Task)'

    Sprint.update_sprint_system

    puts 'Sprint update done'
  end

  desc 'Update wrong goal progress'
  task update_goal_progress: :environment do
    puts 'Update goal progress'

    Goal.all.each { |goal| goal.update_attribute(:progress, goal.progress_percentage) }

    puts 'Update goal progress done'
  end

  desc 'Delete notifications without related model'
  task delete_unrelated_notifications: :environment do
    puts 'Delete notifications without relation'

    Notification.all.each { |notification|
      model = Object.const_get(notification.model)

      if notification.controller == 'tasks'
        model = model.try(:with_deleted)
      end

      model = model.find_by_id notification.model_id

      notification.destroy if model.nil?
    }

    puts 'Notifications clean up done'
  end
end
