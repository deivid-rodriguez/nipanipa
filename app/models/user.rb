#
# Main class implementing both Host and Volunteer through STI
#
class User < ActiveRecord::Base
  devise :confirmable, :database_authenticatable, :recoverable, :registerable,
         :rememberable, :trackable, :validatable

  # validations
  validates :description, length: { maximum: 2500 }
  validates :name, presence: true, length: { maximum: 50 }

  # associations
  has_many :donations

  has_many :sectorizations
  has_many :work_types, through: :sectorizations

  has_many :language_skills, inverse_of: :user
  accepts_nested_attributes_for :language_skills
  has_many :languages, through: :language_skills

  has_many :pictures, dependent: :destroy

  belongs_to :region

  delegate :country, to: :region, allow_nil: true
  scope :from_country, ->(country_id) do
    where(regions: { country_id: country_id })
  end

  delegate :continent, to: :country, allow_nil: true
  scope :from_continent, ->(continent_id) do
    where(countries: { continent_id: continent_id })
  end

  scope :by_latest_sign_in, -> { order(last_sign_in_at: :desc) }

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  default_scope { includes(region: :country) }

  def blank_img_and_cache(att)
    att['image'].blank? && att['image_cache'].blank?
  end

  accepts_nested_attributes_for :pictures,
                                reject_if: ->(att) { blank_img_and_cache(att) }

  has_many :sent_feedbacks,
           -> { order(updated_at: :desc).includes(:recipient) },
           class_name: 'Feedback',
           foreign_key: 'sender_id',
           dependent: :destroy

  has_many :received_feedbacks,
           -> { order(updated_at: :desc).includes(:sender) },
           class_name: 'Feedback',
           foreign_key: 'recipient_id',
           dependent: :destroy

  def messages_with(uid)
    Message.between(id, uid).non_deleted_by(id)
  end

  AVAILABILITY = %w(jan feb mar apr may jun jul aug sep oct nov dec)

  scope :currently_available, -> { available_in?(Time.zone.now.mon) }
  scope :available_in?, ->(m) { where("availability_mask & #{2**(m - 1)} > 0") }

  def availability=(availability)
    self.availability_mask = ArrayMask.new(AVAILABILITY).mask(availability)
  end

  def availability
    ArrayMask.new(AVAILABILITY).unmask(availability_mask)
  end

  def available_in?(month)
    availability.include?(month)
  end

  # Fake class name in subclasses so URLs get properly generated
  def self.inherited(child)
    child.instance_eval do
      def model_name
        User.model_name
      end
    end
    super
  end

  # Use a single partial path for all subclasses
  def to_partial_path
    'users/user'
  end
end
