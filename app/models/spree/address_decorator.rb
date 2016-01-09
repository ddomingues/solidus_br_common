Spree::Address.class_eval do
  belongs_to :city, class_name: 'Spree::City'

  validates :number, :numericality => {greater_than: 0}, :presence => true
  validates :district, length: { maximum: 150}, presence: true

  before_validation :sanitize_phone

  def phone_area_code
    phone[0..1] if phone
  end

  def phone_number
    phone[2..-1] if phone
  end

  private
  def sanitize_phone
    phone.gsub!(/[^\d]/, '')
  end
end