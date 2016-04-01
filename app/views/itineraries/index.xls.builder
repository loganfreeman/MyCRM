xml.Worksheet 'ss:Name' => I18n.t(:itinerary_items) do
  xml.Table do
    unless @itinerary.itinerary_items.empty?
      # Header.
      xml.Row do
        heads = [I18n.t('id'),
                 I18n.t('order_date'),
                 I18n.t('description')]

        heads.each do |head|
          xml.Cell do
            xml.Data head,
                     'ss:Type' => 'String'
          end
        end
      end

      # Contact rows.
      @itinerary.itinerary_items.each do |item|
        xml.Row do
          data    = [item.id,
                     item.order_date.to_date,
                     item.description]


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
