module DocumentUploader
  class Service

    class FileNotFound < StandardError; end
    class FileIncompatible < StandardError; end


    def call(file_path, file_name)
      
      raise FileNotFound, file_name unless File.exist?(file_path)

      case file_name
      when Document::SUPPLIER_FILE_NAME
        SupplierStrategy.new(file_path).execute
      when Document::GOODS_FILE_NAME
        ProductStrategy.new(file_path).execute
      else
        raise FileIncompatible, file_name
      end
    end

  end
end
