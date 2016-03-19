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
    "#{full_name} #{last_name}"
  end

  private

  def company_unsetted
    company.blank?
  end
end
