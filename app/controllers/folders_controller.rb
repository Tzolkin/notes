class FoldersController < ApplicationController
  def create
    folder = Folder.create(folder_params)
    @structure = folder.parent.present? ? [folder.data(folder.parent)].to_json : Hierarchy.structure.to_json

    respond_to do |format|
      format.js { render json: @structure.as_json, status: :ok }
    end
  end

  def show; end

  private

  def folder_params
    params.require(:folder).permit(:name, :folder_id)
  end
end
