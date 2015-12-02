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

    Project.update_sprint_system

    puts "Sprint update done"
  end
end
