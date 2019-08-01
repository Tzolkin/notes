class Hierarchy
  def self.structure
    array = []
    Folder.roots.each do |root|
      array << root.data(root)
    end
    Note.roots.each do |root|
      array << root.data
    end
    array.flatten
  end
end
