class Tag < ActiveRecord::Base
  
  before_save :normalize

  private
  def normalize
    self.name = self.name.titleize
    self.artist = self.name.titleize
  end

end
