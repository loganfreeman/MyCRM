class Customer < ActiveRecord::Base
  # name or company is mandatory
  validates_presence_of :name, if: :company_unsetted
  validates_presence_of :company, if: :name_unsetted
  validates_uniqueness_of :name, scope: :company
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                              allow_nil: true, allow_blank: true

  def pretty_name
    result = []
    [name, company].each do |field|
      result << field unless field.blank?
    end

    result.join(', ')
  end

  private

  def name_unsetted
    name.blank?
  end

  def company_unsetted
    company.blank?
  end
end
