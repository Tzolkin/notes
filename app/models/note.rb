class Note < ApplicationRecord
  belongs_to :folder

  validates_uniqueness_of :name
end
