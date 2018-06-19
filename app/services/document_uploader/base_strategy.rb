module DocumentUploader
  class BaseStrategy

    def initialize(file_path)
      @file_path = file_path
    end

    def execute
      create_tmp_table
      copy_data_to_tmp_table
      insert_or_update
    end

    private

    def copy_data_to_tmp_table
      File.open(@file_path, 'r') do |file|
        ActiveRecord::Base.connection.raw_connection.copy_data %{copy #{self.class::TMP_TABLE} from stdin with csv delimiter '|'} do
          while line = file.gets do
            line = line.gsub('¦', '|')
            violation = yield(line) if block_given?
            next if violation
            ActiveRecord::Base.connection.raw_connection.put_copy_data(line)
          end
        end
      end
    end

    def create_tmp_table
      raise 'Must be Implemented!'
    end

    def insert_or_update
      raise 'Must be Implemented!'
    end

  end
end
