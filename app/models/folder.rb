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
      items << child.notes.map { |note| { text: note.name, icon: 'glyphicon glyphicon-file', folderid: note.folder.id } }
    end
    item = { text: child.name, folderid: child.id }
    item[:nodes] = items.flatten if items.present?

    item
  end

  # TODO: Delete me
  def all_children_sql
    Folder.find_by_sql(recursive_tree_children_sql)
  end

  private

  def recursive_tree_children_sql
    columns = self.class.column_names
    columns_joined = columns.join(',')
    sql =
      <<-SQL
        WITH RECURSIVE folder_tree (#{columns_joined}, level)
        AS (
          SELECT
            #{columns_joined},
            0
          FROM folders
          WHERE id = #{id}

          UNION ALL

          SELECT
            #{columns.map { |col| 'folders.' + col }.join(',')},
            folder_tree.level + 1
          FROM folders, folder_tree
          WHERE folders.folder_id = folder_tree.id
        )
        SELECT  *
        FROM    folder_tree
        WHERE   level > 0
        ORDER BY level, folder_id, name;
      SQL
    sql.chomp
  end
end
