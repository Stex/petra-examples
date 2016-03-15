class Philosopher < ActiveRecord::Base
  before_create :set_number
  after_create  :ensure_stick_creation
  after_destroy :fill_numbers

  def left_stick
    Stick.find_by(:number => (number + 1) % Philosopher.count)
  end

  def right_stick
    Stick.find_by(:number => number)
  end

  def sticks_taken?
    Stick.taken_by(identifier).size == 2
  end

  def avatar_url
    "http://www.avatarpro.biz/avatar/#{Digest::MD5.hexdigest(name)}?s=300"
  end

  def identifier
    "philosopher_#{number}"
  end

  def as_json(*)
    super.merge(:avatar_url => avatar_url, :identifier => identifier, :is_eating => sticks_taken?)
  end

  private

  #
  # If one philosopher leaves, all philosophers with higher numbers
  # will fill up the free space to ensure that there is no gap in
  # their numbers.
  #
  def fill_numbers
    Philosopher.all.each do |phil|
      if phil.number > number
        phil.update_attribute(:number, phil.number - 1)
      end
    end
  end

  def set_number
    self.number = Philosopher.count
  end

  def ensure_stick_creation
    Stick.create!(:number => Stick.count) until Stick.count >= Philosopher.count
  end

end
