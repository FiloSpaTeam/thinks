# coding: utf-8
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

# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'csv'

statuses_list = [
  ['backlog', 'backlog_description', 1],
  ['release', 'release_description', 2],
  ['sprint', 'sprint_description', 3],
  ['in_progress', 'in_progress_description', 4],
  ['done', 'done_description', 5]
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
  ['gplv3',          'GPLv3',             'https://www.gnu.org/licenses/gpl-3.0.en.html'],
  ['gplv2',          'GPLv2',             'https://www.gnu.org/licenses/gpl-2.0.html'],
  ['lgplv2_1',       'LGPLv2_1',          'https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html'],
  ['lgplv3',         'LGPLv3',            'https://www.gnu.org/licenses/lgpl.html'],
  ['agpl',           'AGPLv3',            'https://www.gnu.org/licenses/agpl-3.0.html'],
  ['gplvap',         'GNUAllPermissive',  'https://www.gnu.org/prep/maintain/html_node/License-Notices-for-Other-Files.html'],
  ['apache2',        'Apache2',           'http://directory.fsf.org/wiki/License:Apache2.0'],
  ['artistica2',     'Artistica2',        'http://directory.fsf.org/wiki/License:ArtisticLicense2.0'],
  ['artisticc',      'ArtisticClarified', 'http://gianluca.dellavedova.org/2011/01/03/clarified-artistic-license'],
  ['berkeleydb',     'BerkeleyDB',        'http://directory.fsf.org/wiki/License:Sleepycat'],
  ['boost',          'Boost',             'http://directory.fsf.org/wiki/License:Boost1.0'],
  ['bsdm',           'BSDModified',       'http://directory.fsf.org/wiki/License:BSD_3Clause'],
  ['bsdc',           'ClearBSD',          'http://directory.fsf.org/wiki/License:ClearBSD'],
  ['cc0',            'CC0',               'http://directory.fsf.org/wiki/License:CC0'],
  ['cecill2',        'CeCILL2',           'https://directory.fsf.org/wiki/License:CeCILLv2'],
  ['cryptix',        'Cryptix',           'http://directory.fsf.org/wiki/License:CryptixGL'],
  ['ecos2',          'eCos2',             'http://directory.fsf.org/wiki/License:ECos2.0'],
  ['ecl2',           'ECL2',              'http://directory.fsf.org/wiki/License:ECL2.0'],
  ['efl2',           'EFL2',              'http://directory.fsf.org/wiki/License:EFLv2'],
  ['eudatagrid',     'EUDataGrid',        'http://directory.fsf.org/wiki/License:EUDataGrid'],
  ['expat',          'Expat',             'http://directory.fsf.org/wiki/License:Expat'],
  ['freebsd',        'FreeBSD',           'http://directory.fsf.org/wiki?title=License:FreeBSD'],
  ['freetype',       'Freetype',          'http://directory.fsf.org/wiki/License:FreeType'],
  ['mit',            'MIT',               'https://opensource.org/licenses/MIT'],
  ['imatix',         'iMatix',            'http://directory.fsf.org/wiki?title=License:SFL'],
  ['imlib2',         'imlib2',            'http://directory.fsf.org/wiki/License:Imlib2'],
  ['ijp',            'ijp',               'http://directory.fsf.org/wiki?title=License:JPEG'],
  ['intel',          'intel',             'http://directory.fsf.org/wiki/License:IntelACPI'],
  ['isc',            'ISC',               'http://directory.fsf.org/wiki/License:ISC'],
  ['mpl2',           'MPL2',              'http://directory.fsf.org/wiki/License:MPLv2.0'],
  ['ncsa',           'NCSA',              'http://directory.fsf.org/wiki/License:IllinoisNCSA'],
  ['openldap',       'OpenLDAP',          'http://directory.fsf.org/wiki/License:OpenLDAPv2.7'],
  ['publicdomain',   'PublicDomain',      'http://directory.fsf.org/wiki/License:PublicDomain'],
  ['python2',        'Python2',           'http://directory.fsf.org/wiki?title=License:Python2.0.1'],
  ['python1',        'Python1',           'http://directory.fsf.org/wiki?title=License:Python1.6a2'],
  ['ruby',           'Ruby',              'http://directory.fsf.org/wiki/License:Ruby'],
  ['sgifreeb',       'SGIFreeB',          'http://directory.fsf.org/wiki/License:SGIFreeBv2'],
  ['standardmlofnj', 'StandardMKofNJ',    'http://directory.fsf.org/wiki/License:StandardMLofNJ'],
  ['unicode',        'Unicode',           'http://directory.fsf.org/wiki/License:Unicode'],
  ['upl',            'UPL',               'http://directory.fsf.org/wiki/License:Universal_Permissive_License'],
  ['unlicense',      'Unlicense',         'http://directory.fsf.org/wiki/License:TheUnlicense'],
  ['vim',            'Vim',               'http://directory.fsf.org/wiki/License:Vim7.2'],
  ['w3c',            'W3C',               'http://directory.fsf.org/wiki/License:W3C_31Dec2002'],
  ['webm',           'WebM',              'http://directory.fsf.org/wiki/License:WebM'],
  ['wtfpl2',         'WTFPL2',            'http://sam.zoy.org/wtfpl/COPYING'],
  ['x11',            'X11',               'http://directory.fsf.org/wiki/License:X11'],
  ['xfree86',        'XFree86',           'http://directory.fsf.org/wiki/License:XFree86_1.1'],
  ['zlib',           'ZLib',              'http://directory.fsf.org/wiki/License:Zlib'],
  ['zope2',          'Zope2',             'http://directory.fsf.org/wiki?title=License:ZopePLv2.1'],
  ['fdlo',           'FDLOther',          'https://www.gnu.org/licenses/fdl.html'],
  ['ccby4',          'CCBY4',             'http://creativecommons.org/licenses/by/4.0/legalcode'],
  ['ccbysa4',        'CCBYSA4',           'http://creativecommons.org/licenses/by-sa/4.0/legalcode'],
  ['ccbync4',        'CCBYNC4',           'https://creativecommons.org/licenses/by-nc/4.0/legalcode'],
  ['ccbyncsa4',      'CCBYNCSA4',         'https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode'],
  ['dsl',            'DSL',               'https://www.gnu.org/licenses/dsl.html'],
  ['freeart',        'FreeArt',           'https://directory.fsf.org/wiki/License:Free-Art-L-v1.3'],
  ['odbl',           'ODbl',              'http://directory.fsf.org/wiki/License:ODbl'],
  ['silofl',         'SILOFL',            'http://scripts.sil.org/OFL_web'],
  ['gnuv',           'GNUVerbatim',       'https://www.gnu.org/licenses/licenses.html#VerbatimCopying'],
  ['ccbynd',         'CCBYND3',           'http://creativecommons.org/licenses/by-nd/3.0/legalcode'],
  ['ccbynd4',        'CCBYND4',           'https://creativecommons.org/licenses/by-nd/4.0/legalcode'],
  ['hpnd',           'HPND',              'http://directory.fsf.org/wiki/License:Historical_Permission_Notice_and_Disclaimer']
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
  %w[software software_description cream],
  %w[web_applications web_applications_description lightblue],
  %w[robotic robotic_description black],
  %w[domotic domotic_description yellow],
  %w[artworks artworks_description]
]

categories_list.each do |tname, tdescription, color|
  Category.where(t_name: tname).first_or_create do |category|
    category.t_description = tdescription
    category.color         = color
  end
end

sexes_list = %w[male female other]

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

surveys_list = %w(what_went_well what_could_be_done_better what_can_be_done_better)

surveys_list.each do |ttitle|
  Survey.where(t_title: ttitle).first_or_create
end

answers_list = [
  ['sprint_workload',         1],
  ['goals',                   1],
  ['tasks',                   1],
  ['communication',           1],
  ['other',                   1],
  ['idk',                     1],
  ['sprint_workload',         2],
  ['goals',                   2],
  ['tasks',                   2],
  ['communication',           2],
  ['other',                   2],
  ['idk',                     2],
  ['better_goals_definition', 3],
  ['better_tasks_separation', 3],
  ['other',                   3],
  ['idk',                     3]
]

answers_list.each do |tdescription, survey_id|
  Answer
    .where(survey_id: survey_id)
    .where(t_description: tdescription)
    .first_or_create
end

team_roles = %w(product_owner scrum_master team_member)

team_roles.each do |tname|
  TeamRole
    .where(t_name: tname)
    .first_or_create
end

skills_list = [
  ['computer_scientist',     'computer_scientist_description'],
  ['passion',                'passion_description'],
  ['fearless_refactor',      'fearless_refactor_description'],
  ['quality_code',           'quality_code_description'],
  ['dont_invent_new_wheel',  'dont_invent_new_wheel_description'],
  ['maintainability',        'maintainability_description'],
  ['multiple_languages',     'multiple_languages_description'],
  ['vision',                 'vision_description'],
  ['attention_to_details',   'attention_to_details_description'],
  ['business_vision',        'business_vision_description'],
  ['curiosity',              'curiosity_description'],
  ['experience',             'experience_description'],
  ['discipline',             'discipline_description'],
  ['patience',               'patience_description'],
  ['teamwork',               'teamwork_description'],
  ['guide_for_others',       'guide_for_others_description'],
  ['problem_solver',         'problem_solver_description'],
  ['quickly_learning',       'quickly_learning_description'],
  ['analytical_thinking',    'analytical_thinking_description'],
  ['critical_thinking',      'critical_thinking_description'],
  ['license_expert',         'license_expert_description'],
  ['user_experience_expert', 'user_experience_expert_description'],
  ['mathematician',          'mathematician_description'],
  ['query_expert',           'query_expert_description'],
  ['designer',               'designer_description'],
  ['mobile_expert',          'mobile_expert_description']
]

skills_list.each do |tname, tdescription|
  Skill
    .where(t_name: tname)
    .first_or_create do |skill|
      skill.t_description = tdescription
    end
end

offers_list = [
  [0, 'freedom', 'freedom_description'],
  [10, 'beginner', 'beginner_description'],
  [25, 'creator', 'creator_description']
]

offers_list.each do |price, module_name, description|
  Offer
    .where(module: module_name)
    .first_or_create do |offer|
      offer.price = price
      offer.description = description
    end
end
