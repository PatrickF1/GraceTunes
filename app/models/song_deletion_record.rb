class SongDeletionRecord < ApplicationRecord
  validates :id, presence: true
  validates :deleted_at, presence: true
  validates :name, presence: true

  before_validation do
    self.deleted_at ||= Time.now
  end

end