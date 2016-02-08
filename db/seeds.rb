# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

statuses_list = [
  ['backlog',     'ToDo',             1],
  ['release',     'ToDo next',        2],
  ['sprint',      'Work planned',     3],
  ['in_progress', 'Work in progress', 4],
  ['done',        'Work done',        5]
]

statuses_list.each do |tcode, description, order|
  Status.where(translation_code: tcode).first_or_create do |status|
    status.description    = description
    status.progress_order = order
  end
end

workloads_list = [
  [0,    '0'],
  [0.5,  '½'],
  [1,    '1'],
  [2,    '2'],
  [3,    '3'],
  [5,    '5'],
  [8,    '8'],
  [13,   '13'],
  [20,   '20'],
  [40,   '40'],
  [100,  '100'],
  [1000, '∞']
]

workloads_list.each do |value, description|
  Workload.where(value: value).first_or_create do |workload|
    workload.description = description
  end
end

licenses_list = [
  ['gplv3', 'GPLv3', 'https://www.gnu.org/licenses/gpl-3.0.en.html'],
  ['gplv2', 'GPLv2', 'https://www.gnu.org/licenses/gpl-2.0.html'],
  ['agpl',  'AGPL',  'https://www.gnu.org/licenses/agpl-3.0.html'],
  ['mit',   'MIT',   'https://opensource.org/licenses/MIT']
]

licenses_list.each do |name, description, url|
  License.where(name: name).first_or_create do |license|
    license.description = description
    license.url         = url
  end
end

cycles_list = [
  ['one_week',   'One week',   7],
  ['two_weeks',  'Two weeks',  14],
  ['four_weeks', 'Four weeks', 28]
]

cycles_list.each do |tcode, description, days|
  Cycle.where(translation_code: tcode).first_or_create do |cycle|
    cycle.description = description
    cycle.days        = days
  end
end

categories_list = [
  %w(web_applications       web_applications_description       cream),
  %w(libraries              libraries_description              green),
  %w(games                  games_description                  red),
  %w(sysadmin_applications  sysadmins_applications_description black),
  %w(didactics_applications didactics_applications_description yellow),
  %w(system_applications    system_applications_description    orange),
  %w(media_applications     media_applications_description     violet),
  %w(graphics_applications  graphics_applications_description  lightblue),
  %w(tools_applications     tools_applications_description     gray)
]

categories_list.each do |tname, tdescription, color|
  Category.where(t_name: tname).first_or_create do |category|
    category.t_description = tdescription
    category.color         = color
  end
end

sexes_list = %w(male female)

sexes_list.each do |tname|
  Sex.where(t_name: tname).first_or_create
end
CSV.foreach(File.join(Rails.root, 'db', 'iso_country_list.csv'), headers: false, col_sep: ',') do |row|
  Country.where(iso: row[0]).first_or_create do |country|
    country.name           = row[1]
    country.printable_name = row[2]
    country.iso3           = row[3]
    country.numcode        = row[4].to_i
  end
end
