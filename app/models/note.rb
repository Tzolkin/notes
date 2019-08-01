class Note < ApplicationRecord
  include Nestable
  belongs_to :folder, optional: true

  validates_uniqueness_of :name

  def data
    {
      text: name,
      icon: 'glyphicon glyphicon-file',
      folderid: folder.try(:id),
      href: url_path
    }
  end
end
