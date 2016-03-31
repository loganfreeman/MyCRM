class Airport < ActiveRecord::Base

  def self.active
    where scheduled_service: true
  end

  def self.with_time_zone
    where "#{table_name}.time_zone IS NOT NULL"
  end

  def to_s
    if I18n.transliterate(name)[I18n.transliterate(city)]
      name
    else
      "(#{city}) #{name}"
    end
  end

end
