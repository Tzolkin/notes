class HomeController < ApplicationController
  def main
    @structure = Folder.structure.to_json
  end
end
