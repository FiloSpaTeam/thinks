# This file is part of Thinks.

# Thinks is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Thinks is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero Public License for more details.

# You should have received a copy of the GNU Affero Public License
# along with Thinks.  If not, see <http://www.gnu.org/licenses/>.

# Copyright (c) 2015, Claudio Maradonna

namespace :admin do
  # task create_password: :environment do
  #   puts ::BCrypt::Password.create("123123", :cost => 10).to_s
  # end

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

  task update_team_roles: :environment do
    puts 'Update team roles'

    projects = Project.with_deleted.eager_load(:contributions).all
    projects.each do |project|
      project.contributions.each do |contribution|
        if contribution.thinker == project.thinker
          AssignedRole.create(thinker: contribution.thinker, team_role: TeamRole.product_owner.first, project: project)
          AssignedRole.create(thinker: contribution.thinker, team_role: TeamRole.scrum_master.first, project: project)
        else
          AssignedRole.create(thinker: contribution.thinker, team_role: TeamRole.team_member.first, project: project)
        end
      end
    end

    puts 'Update team roles done'
  end

  task close_election_poll_overtime: :environment do
    puts 'Start check for election polls that need to be closed'

    election_polls = ElectionPoll
                     .where("created_at <= ?", (DateTime.now - 21).to_date)
                     .where(status: ElectionPoll.statuses[:active])
    election_polls.each do |election_poll|
      notification = Notification.new

      if election_poll.voters.size < (election_poll.project.team.size / 2) + 1
        election_poll.status = ElectionPoll.statuses[:closed]
        election_poll.save

        notification.model      = election_poll.class.name
        notification.model_id   = election_poll.id
        notification.controller = 'elections'
      else
        winner = election_poll
                 .voters
                 .group(:elect_id, :id)
                 .order('count(elect_id) DESC')
                 .first

        assigned_role = AssignedRole
                        .where(project: election_poll.project)
                        .where(team_role: election_poll.team_role)
                        .first

        assigned_role.update(thinker_id: winner.elect_id)

        election_poll.status = ElectionPoll.statuses[:done]
        election_poll.save

        unless (election_poll.project.part_of_team?(assigned_role.thinker_id_was))
          assigned_role.create(project: election_poll.project, team_role: TeamRole.team_member.first, thinker: assigned_role.thinker_id_was)
        end

        notification.model      = assigned_role.class.name
        notification.model_id   = assigned_role.id
        notification.controller = 'assigned_roles'
      end

      notification.project    = election_poll.project
      notification.thinker_id = 0
      notification.action     = 'update'
      notification.save
    end

    puts 'Finished check for election polls that need to be closed'
  end
end
