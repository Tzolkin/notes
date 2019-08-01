class HomeController < ApplicationController
  def main
    @structure = Hierarchy.structure.to_json
  end
end
