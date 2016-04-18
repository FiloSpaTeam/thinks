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

  task delete_notifications: :environment do
    puts 'Delete notifications'

    Notification.destroy_all
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE notifications_thinkers')

    puts 'Notifications clean up done'
  end

  task delete_rows_without_related_project: :environment do
    puts 'Delete rows without related project'

    Task.with_deleted.where('project_id NOT IN (SELECT DISTINCT(id) FROM projects)').delete_all
    Task.with_deleted.where('project_id NOT IN (SELECT DISTINCT(id) FROM projects)').delete_all

    Goal.with_deleted.where('project_id NOT IN (SELECT DISTINCT(id) FROM projects)').delete_all
    Goal.with_deleted.where('project_id NOT IN (SELECT DISTINCT(id) FROM projects)').delete_all

    Sprint.with_deleted.where('project_id NOT IN (SELECT DISTINCT(id) FROM projects)').delete_all
    Sprint.with_deleted.where('project_id NOT IN (SELECT DISTINCT(id) FROM projects)').delete_all

    puts 'Delete rows without related project done'
  end

  task update_task_serial: :environment do
    puts 'Update task serial'

    projects = Project.with_deleted.eager_load(:tasks).all
    projects.each do |project|
      tasks = project.tasks.with_deleted.order('created_at')

      tasks.each_with_index do |task, index|
        task.update_attribute(:serial, index + 1)
      end
    end

    puts 'Update task serial done'
  end
end
