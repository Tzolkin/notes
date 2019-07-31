class FoldersController < ApplicationController
  def create
    Folder.create(folder_params)
    @structure = Folder.structure.to_json

    respond_to do |format|
      format.js { render json: @structure.as_json, status: :ok }
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :folder_id)
  end
end
