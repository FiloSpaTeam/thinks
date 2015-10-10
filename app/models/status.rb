class Status < ActiveRecord::Base
  has_many :tasks

  default_scope { order(:progress_order) }
  
  scope :backlog, lambda { where translation_code: :backlog }
  scope :done, lambda { where translation_code: :done }
  scope :release, lambda { where translation_code: :release }
  scope :sprint, lambda { where translation_code: :sprint }
  scope :in_progress, lambda { where translation_code: :in_progress }

  scope :for_print, lambda { order :print_order }
end
