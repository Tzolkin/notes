class NotesController < ApplicationController
  def create
    @note = Note.create(note_params)
    @structure = Folder.structure.to_json

    respond_to do |format|
      if @note.valid?
        format.js { render json: @structure.as_json, status: :ok }
      else
        format.js { render json: @note.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  def show
    note = Note.find_by_name(params[:name])

    respond_to do |format|
      if note.present?
        format.html
      else
        return not_found
      end
    end
  end

  private

  def note_params
    params.require(:note).permit(:name, :folder_id)
  end
end