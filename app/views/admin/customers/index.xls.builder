xml.Worksheet 'ss:Name' => I18n.t(:tab_customers) do
  xml.Table do
    unless @customers.empty?
      # Header.
      xml.Row do
        heads = [I18n.t('id'),
                 I18n.t('first_name'),
                 I18n.t('last_name'),
                 I18n.t('company'),
                 I18n.t('date_created'),
                 I18n.t('date_updated')]

        # Append custom field labels to header
        Customer.fields.each do |field|
          heads << field.label
        end

        heads.each do |head|
          xml.Cell do
            xml.Data head,
                     'ss:Type' => 'String'
          end
        end
      end

      # Campaign rows.
      @customers.each do |customer|
        xml.Row do
          data    = [customer.id,
                     customer.first_name,
                     customer.last_name,
                     customer.company,
                     customer.created_at,
                     customer.updated_at]

          # Append custom field values.
          Customer.fields.each do |field|
            data << customer.send(field.name)
          end

          data.each do |value|
            xml.Cell do
              xml.Data value,
                       'ss:Type' => "#{value.respond_to?(:abs) ? 'Number' : 'String'}"
            end
          end
        end
      end
    end
  end
end
