class Folder < ApplicationRecord
  belongs_to :parent, class_name: 'Folder', optional: true, foreign_key: :folder_id
  has_many :children, class_name: 'Folder'
  has_many :notes

  scope :roots, -> { where(folder_id: nil) }

  def data(child)
    items = []
    unless child.children.blank?
      child.children.each do |emp|
        items << data(emp)
      end
    end
    if child.notes.present?
      child.notes.map do |note|
        items << note.data
      end
    end
    item = { text: child.name, folderid: child.id }
    item[:nodes] = items.flatten if items.present?

    item
  end
end
