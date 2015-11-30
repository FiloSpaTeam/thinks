module GoalsHelper
  def tasks_title(goal)
    pluralize(goal.tasks.count, 'task') + ", " +
      pluralize(goal.tasks.done.count, 'task') + " done, " +
      pluralize(goal.tasks.in_progress.count, 'task') + " in progress"
  end

  def release_btn_title(tasks_ready)
    "Put " + pluralize(tasks_ready.count, 'task') + " in Sprint automatically"
  end
end
