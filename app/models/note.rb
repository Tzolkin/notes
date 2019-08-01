class Note < ApplicationRecord
  belongs_to :folder

  validates_uniqueness_of :name

  def url_path
    url = [name]
    parent = folder
    while parent.present?
      url << parent.name
      parent = parent.parent
    end

    url.reverse.join('/').prepend('/')
  end
end
