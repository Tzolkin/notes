class Folder < ApplicationRecord
  include Nestable

  belongs_to :parent, class_name: 'Folder', optional: true, foreign_key: :folder_id
  has_many :children, class_name: 'Folder'
  has_many :notes

  def data(child)
    items = []
    unless child.children.blank?
      child.children.each do |emp|
        items << data(emp)
      end
    end
    child.notes.map do |note|
      items << note.data
    end

    item = { text: child.name, folderid: child.id, href: child.url_path }
    item[:nodes] = items.flatten if items.present?

    item
  end
end
