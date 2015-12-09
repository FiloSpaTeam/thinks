namespace :admin do
  desc 'Allow admin to reset counters of database'
  task reset_counters: :environment do
    puts "Likes counter reset"
    Comment.find_each { |comment| Comment.reset_counters(comment.id, :likes) }

    puts "Counters reset done"
  end

  desc 'This task update sprint automatically'
  task update_sprint_system: :environment do
    puts "Sprint update system (Task)"

    projects = Project.all

    projects.each do |project|
      if project.started?
        if project.sprints.count.zero?
          sprint = Sprint.new

          sprint.project = project
          sprint.save
        else
          last_sprint = project.sprints.last

          if (DateTime.now.to_date - last_sprint.created_at.to_date) == project.cycle.days
            sprint = Sprint.new

            sprint.project = project
            sprint.save
          end
        end

        # day = project.actual_day_of_sprint

        # if day == 1

        #   sprint = Sprint.new

        #   sprint.project = project
        #   sprint.save

        #   if project.sprints.count > 1
        #     last_sprint       = project.sprints.where('id < ?', sprint.id).last
        #     tasks_last_sprint = project.tasks.done.where('updated_at < ?', sprint.created_at).where('updated_at > ?', last_sprint.created_at)

        #     last_sprint.obtained = tasks_last_sprint.sum(:workload)
        #     last_sprint.save
        #   end
        # end
      end
    end

    puts "Sprint update done"
  end
end
