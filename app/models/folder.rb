class Folder < ApplicationRecord
  belongs_to :parent, class_name: 'Folder', optional: true, foreign_key: :folder_id
  has_many :children, class_name: 'Folder'
  has_many :notes

  scope :roots, -> { where(folder_id: nil) }

  def self.structure
    array = []
    Folder.roots.each do |root|
      array << root.data(root)
    end
    array.flatten
  end

  def data(child)
    items = []
    unless child.children.blank?
      child.children.each do |emp|
        items << data(emp)
      end
    end
    if child.notes.present?
      child.notes.map do |note|
        items << {
          text: note.name,
          icon: 'glyphicon glyphicon-file',
          folderid: note.folder.id,
          href: note.url_path
        }
      end
    end
    item = { text: child.name, folderid: child.id }
    item[:nodes] = items.flatten if items.present?

    item
  end
end
