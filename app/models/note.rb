class Note < ApplicationRecord
  include Nestable
  belongs_to :folder, optional: true

  # scope :roots, -> { where(folder_id: nil) }

  validates_uniqueness_of :name

  def data
    {
      text: name,
      icon: 'glyphicon glyphicon-file',
      folderid: folder.try(:id),
      href: url_path
    }
  end

  # def url_path
  #   url = [name]
  #   parent = folder
  #   while parent.present?
  #     url << parent.name
  #     parent = parent.parent
  #   end
  #
  #   url.reverse.join('/').prepend('/')
  # end
end
