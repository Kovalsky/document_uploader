module DocumentUploader
  class SupplierStrategy < BaseStrategy

    TMP_TABLE = 'supplier_temp'

    private

    def copy_data_to_tmp_table
      super do |line|
        items = line.chop.split('|')
        violation = !(items[0] && items[1])
        Rails.logger.error("Update error: violation not-null constraint on supplier with code=#{items[0]}}") if violation
        violation
      end
    end

    def create_tmp_table
      ActiveRecord::Base.connection.execute <<-SQL
        DROP TABLE IF EXISTS #{TMP_TABLE};
        CREATE TEMP TABLE #{TMP_TABLE}
        (
          code character varying,
          name character varying
        )
      SQL
    end

    def insert_or_update
      ActiveRecord::Base.connection.execute <<-SQL
        insert into suppliers(code, name, created_at, updated_at)
        select code, name, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        from #{TMP_TABLE}
        on conflict(code) do
        update set
          code = EXCLUDED.code,
          name = EXCLUDED.name,
          created_at = EXCLUDED.created_at
      SQL
    end
  end
end
