class ItemController < ApplicationController
  def show
    item = Note.where(id: params[:id], name: params[:name]).first
    item ||= Folder.where(id: params[:id], name: params[:name]).first
    @structure = [item.data(item)].to_json if item.class == Folder
    @name = item.name

    respond_to do |format|
      format.html do
        if item.present?
          render item.class == Note ? 'notes/show' : 'folders/show'
        else
          return not_found
        end
      end
    end
  end
end
