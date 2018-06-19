class DocumentsController < ApplicationController

  def new
    @document = Document.new
  end

  def create
    begin
      @document = Document.new(document_params)
    rescue ActionController::ParameterMissing
      flash[:error] = "Couldn't find attachment."
      redirect_to root_url
    end

    if @document.save
      UploadJob.perform_later(document_id: @document.id)
      flash[:error] = "Go to products path than wait few second and reload page to see result"
      redirect_to(new_document_url)
    else
      flash[:error] = "Couldn't save file."
      redirect_to(new_document_url)
    end
  end

  private

  def document_params
    params.require(:document)
          .permit(:attachment)
  end
end
