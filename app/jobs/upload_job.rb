class UploadJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::InvalidForeignKey, ActiveRecord::NotNullViolation) do |error|
    #error handling logic here
    Rails.logger.error error
  end

  def perform(options = {})
    document = Document.find(options[:document_id])
    DocumentUploader::Service.new.call(document.attachment.path, document.attachment_file_name)
  end
end
