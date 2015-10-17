# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

statuses_list = [
  ["backlog",     "ToDo",             1],
  ["release",     "ToDo next",        2],
  ["sprint",      "Work planned",     3],
  ["in_progress", "Work in progress", 4],
  ["done",        "Work done",        5]
]

statuses_list.each do |tcode, description, order|
  Status.create(translation_code: tcode, description: description, progress_order: order)
end

workloads_list = [
  [0,    "0"],
  [0.5,  "½"],
  [1,    "1"],
  [2,    "2"],
  [3,    "3"],
  [5,    "5"],
  [8,    "8"],
  [13,   "13"],
  [20,   "20"],
  [40,   "40"],
  [100,  "100"],
  [1000, "∞"]
]

workloads_list.each do |value, description|
  Workload.create(value: value, description: description)
end

licenses_list = [
  ["gplv3", "GPLv3", "https://www.gnu.org/licenses/gpl-3.0.en.html"],
  ["gplv2", "GPLv2", "https://www.gnu.org/licenses/gpl-2.0.html"],
  ["agpl",  "AGPL",  "https://www.gnu.org/licenses/agpl-3.0.html"],
  ["mit",   "MIT",   "https://opensource.org/licenses/MIT"]
]

licenses_list.each do |name, description, url|
  License.create(name: name, description: description, url: url)
end

cycles_list = [
  ["one_week",   "One week",   7],
  ["two_weeks",  "Two weeks",  14],
  ["four_weeks", "Four weeks", 28],
]

cycles_list.each do |tcode, description, days|
  Cycle.create(translation_code: tcode, description: description, days: days)
end

categories_list = [
  ["web_applications",       "web_applications_description",       "cream"],
  ["libraries",              "libraries_description",              "green"],
  ["games",                  "games_description",                  "red"],
  ["sysadmin_applications",  "sysadmins_applications_description", "black"],
  ["didactics_applications", "didactics_applications_description", "yellow"],
  ["system_applications",    "system_applications_description",    "orange"],
  ["media_applications",     "media_applications_description",     "violet"],
  ["graphics_applications",  "graphics_applications_description",  "lightblue"],
  ["tools_applications",     "tools_applications_description",     "gray"]
]

categories_list.each do |tname, tdescription, color|
  Category.create(t_name: tname, t_description: tdescription, color: color)
end
