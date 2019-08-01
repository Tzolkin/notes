class NotesController < ApplicationController
  def create
    @note = Note.create(note_params)
    folder = @note.folder
    @structure = folder.present? ? [folder.data(folder)].to_json : Hierarchy.structure.to_json

    respond_to do |format|
      if @note.valid?
        format.js { render json: @structure.as_json, status: :ok }
      else
        format.js { render json: @note.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  private

  def note_params
    params.require(:note).permit(:name, :folder_id)
  end
end
