class Folder < ApplicationRecord
  belongs_to :parent, class_name: 'Folder', optional: true, foreign_key: :folder_id
  has_many :children, class_name: 'Folder'
  has_many :notes

  def all_children_sql
    Folder.find_by_sql(recursive_tree_children_sql)
  end

  def deep
    result = deep_sql
    return 0 if result.blank?

    result.first['max']
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

  def deep_sql
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
        SELECT  MAX(level)
        FROM    folder_tree
        WHERE   level > 0
        Group By level
        ORDER BY level DESC
        Limit 1;
      SQL
    sql.chomp
    ActiveRecord::Base.connection.execute(sql)
  end
end
