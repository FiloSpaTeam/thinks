class Status < ActiveRecord::Base
  has_many :tasks

  default_scope { order(:progress_order) }
  
  scope :backlog, -> () { where translation_code: :backlog }
  scope :done, -> () { where translation_code: :done }
  scope :release, -> () { where translation_code: :release }
  scope :sprint, -> () { where translation_code: :sprint }
  scope :in_progress, -> () { where translation_code: :in_progress }

  scope :for_print, -> () { order :print_order }
end
