require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  test 'search 50+ notes' do
    root = parent = Folder.create(name: 'Sport')

    15.times do |i|
      parent = Folder.create(name: "Folder #{i}", parent: parent)
    end
    rand(50..70).times do |i|
      parent = root.all_children_sql.map(&:id).sample
      Note.create(name: "Note #{i}", folder_id: parent)
    end

    root.reload
    tabs = '  '
    puts '+ ' + root.name
    root.all_children_sql.each do |folder|
      puts "#{tabs}+ #{folder.name}"
      folder.notes.each do |note|
        puts "#{tabs}- #{note.name}"
      end
      tabs += '  '
    end
  end
end
