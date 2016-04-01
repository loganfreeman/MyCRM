xml.Worksheet 'ss:Name' => I18n.t(:itinerary_items) do
  xml.Table do
    unless @itinerary.itinerary_items.empty?
      # Header.
      xml.Row do
        heads = [I18n.t('id'),
                 I18n.t('order_date'),
                 I18n.t('description'),
                 I18n.t('breakfast'),
                 I18n.t('lunch'),
                 I18n.t('dinner'),
                 I18n.t('kind'),
                 I18n.t('description'),
                 I18n.t('cost'),
                 I18n.t('hotel_name'),
                 I18n.t('room_number'),
                 I18n.t('unit_cost'),
                 I18n.t('car'),
                 I18n.t('car_number'),
                 I18n.t('unit_cost'),
                 I18n.t('guide'),
                 I18n.t('driver'),
                 I18n.t('tip'),
                 I18n.t('other'),
                 I18n.t('overtime'),
                 I18n.t('park'),
                 I18n.t('cost')]

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
                     item.description,
                     item.meals.first.nil? ? '' : item.meals.first.breakfast,
                     item.meals.first.nil? ? '' : item.meals.first.lunch,
                     item.meals.first.nil? ? '' : item.meals.first.dinner,
                     item.snacks.first.nil? ? '' : item.snacks.first.kind,
                     item.snacks.first.nil? ? '' : item.snacks.first.description,
                     item.snacks.first.nil? ? '' : item.snacks.first.cost,
                     item.hotel_reservations.first.nil? ? '' : item.hotel_reservations.first.hotel_name,
                     item.hotel_reservations.first.nil? ? '' : item.hotel_reservations.first.room_number,
                     item.hotel_reservations.first.nil? ? '' : item.hotel_reservations.first.unit_cost,
                     item.transportations.first.nil? ? '' : item.transportations.first.car,
                     item.transportations.first.nil? ? '' : item.transportations.first.car_number,
                     item.transportations.first.nil? ? '' : item.transportations.first.unit_cost,
                     item.guide_drivers.first.nil? ? '' : item.guide_drivers.first.guide_contact.full_name,
                     item.guide_drivers.first.nil? ? '' : item.guide_drivers.first.driver_contact.full_name,
                     item.guide_drivers.first.nil? ? '' : item.guide_drivers.first.tip,
                     item.guide_drivers.first.nil? ? '' : item.guide_drivers.first.other,
                     item.guide_drivers.first.nil? ? '' : item.guide_drivers.first.overtime,
                     item.park_tickets.first.nil? ? '' : item.park_tickets.first.park,
                     item.park_tickets.first.nil? ? '' : item.park_tickets.first.cost]


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
