class Meetup < ActiveRecord::Base
  serialize :guests, JSON

  def guests=(guests)
    puts guests.inspect
    super( guests.select(&:present?).map(&:strip) )
    puts guests.inspect
  end
end
