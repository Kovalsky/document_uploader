module DocumentUploader
  class ProductStrategy < BaseStrategy

    TMP_TABLE = 'products_temp'

    private

    def copy_data_to_tmp_table
      super do |line|
        items = line.chop.split('|')
        violation = !(items[0] && items[1] && items[2] && items[8])
        Rails.logger.error("Upsert error: violation not-null constraint on product with sku=#{items[0]}}") if violation
        violation
      end
    end

    def create_tmp_table
      ActiveRecord::Base.connection.execute <<-SQL
        DROP TABLE IF EXISTS #{TMP_TABLE};
        CREATE TEMP TABLE #{TMP_TABLE}
        (
          sku character varying,
          supplier_code character varying,
          name character varying,
          field_0 character varying,
          field_1 character varying,
          field_2 character varying,
          field_3 character varying,
          field_4 character varying,
          price decimal
        )
      SQL
    end

    def insert_or_update
      ActiveRecord::Base.connection.execute <<-SQL
        insert into products(sku, supplier_code, name, field_0, field_1, field_2, field_3, field_4, price, created_at, updated_at)
        select sku, supplier_code, name, field_0, field_1, field_2, field_3, field_4, price, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        from #{TMP_TABLE}
        on conflict(sku) do
        update set
          supplier_code = EXCLUDED.supplier_code,
          name = EXCLUDED.name,
          field_0 = EXCLUDED.field_0,
          field_1 = EXCLUDED.field_1,
          field_2 = EXCLUDED.field_2,
          field_3 = EXCLUDED.field_3,
          field_4 = EXCLUDED.field_4,
          price = EXCLUDED.price,
          updated_at = EXCLUDED.updated_at
      SQL
    end
  end
end

