module Nestable
  extend ActiveSupport::Concern

  included do
    scope :roots, -> { where(folder_id: nil) }
  end

  def url_path
    url = [name]
    parent = self.class == Note ? folder : self.parent
    while parent.present?
      url << parent.name
      parent = parent.parent
    end

    url.reverse.join('/').prepend('/') + "?id=#{id}"
  end
end
