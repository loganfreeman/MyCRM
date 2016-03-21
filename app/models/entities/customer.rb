class Customer < ActiveRecord::Base
  # name or company is mandatory
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                              allow_nil: true, allow_blank: true


  def pretty_name
    result = []
    [full_name, company].each do |field|
      result << field unless field.blank?
    end

    result.join(', ')
  end

  def full_name
    first_name.blank? && last_name.blank? ? email : "#{first_name} #{last_name}".strip
  end

  private

  def company_unsetted
    company.blank?
  end
end
