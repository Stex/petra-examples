class Stick < ActiveRecord::Base
  validates_uniqueness_of :number

  scope :taken, -> { where.not(:taken_by => nil) }
  scope :taken_by, ->(identifier) { where(:taken_by => identifier) }

end
