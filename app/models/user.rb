#
# Main class implementing both Host and Volunteer through STI
#
class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable, :registerable,
         :trackable, :recoverable

  ROLES = %w(admin, non-admin)
  AFRICA = ['Algeria','Angola','Benin','Botswana','Burkina','Burundi','Cameroon','Cape Verde','Central African Republic','Chad','Comoros','Congo','Congo, Democratic Republic of','Djibouti','Egypt','Equatorial Guinea','Eritrea','Ethiopia','Gabon','Gambia','Ghana','Guinea','Guinea-Bissau','Ivory Coast','Kenya','Lesotho','Liberia','Libya','Madagascar','Malawi','Mali','Mauritania','Mauritius','Morocco','Mozambique','Namibia','Niger','Nigeria','Rwanda','Sao Tome and Principe','Senegal','Seychelles','Sierra Leone','Somalia','South Africa','South Sudan','Sudan','Swaziland','Tanzania','Togo','Tunisia','Uganda','Zambia','Zimbabwe']
  AMERICA = ['Antigua and Barbuda','Bahamas','Barbados','Belize','Canada','Costa Rica','Cuba','Dominica','Dominican Republic','El Salvador','Grenada','Guatemala','Haiti','Honduras','Jamaica','Mexico','Nicaragua','Panama','Saint Kitts and Nevis','Saint Lucia','Saint Vincent and the Grenadines','Trinidad and Tobago','United States','Argentina','Bolivia','Brazil','Chile','Colombia','Ecuador','Guyana','Paraguay','Peru','Suriname','Uruguay','Venezuela'] 
  ASIA = ['Afghanistan','Bahrain','Bangladesh','Bhutan','Brunei','Burma (Myanmar)','Cambodia','China','East Timor','India','Indonesia','Iran','Iraq','Israel','Japan','Jordan','Kazakhstan','Korea, Republic of','Kuwait','Kyrgyzstan','Laos','Lebanon','Malaysia','Maldives','Mongolia','Nepal','Oman','Pakistan','Philippines','Qatar','Russian Federation','Saudi Arabia','Singapore','Sri Lanka','Syria','Tajikistan','Thailand','Turkey','Turkmenistan','United Arab Emirates','Uzbekistan','Vietnam','Yemen'] 
  OCEANIA = ['Australia','Fiji','Kiribati','Marshall Islands','Micronesia','Nauru','New Zealand','Palau','Papua New Guinea','Samoa','Solomon Islands','Tonga','Tuvalu','Vanuatu'] 
  EUROPE = ['Albania','Andorra','Armenia','Austria','Azerbaijan','Belarus','Belgium','Bosnia and Herzegovina','Bulgaria','Croatia','Cyprus','Czech Republic','Denmark','Estonia','Finland','France','Georgia','Germany','Greece','Hungary','Iceland','Ireland','Italy','Latvia','Liechtenstein','Lithuania','Luxembourg','Macedonia','Malta','Moldova','Monaco','Montenegro','Netherlands','Norway','Poland','Portugal','Romania','San Marino','Serbia','Slovakia','Slovenia','Spain','Sweden','Switzerland','Ukraine','United Kingdom','Vatican City']  

  # validations
  validates :description, length: { maximum: 2500 }
  validates :name, presence: true, length: { maximum: 50 }

  # geocoder
  geocoded_by :current_sign_in_ip do |obj, results|
    if (geo = results.first)
      obj.state     = geo.state
      obj.country   = geo.country
      obj.longitude = geo.longitude
      obj.latitude  = geo.latitude
    end
  end
  before_save :geocode, if: :current_sign_in_ip_changed?

  # associations
  has_many :donations

  has_many :sectorizations
  has_many :work_types, through: :sectorizations

  has_many :language_skills
  accepts_nested_attributes_for :language_skills
  has_many :languages, through: :language_skills

  has_many :pictures, dependent: :destroy

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

  has_many :sent_conversations,
           -> { order(updated_at: :desc).includes(:to) },
           class_name: 'Conversation',
           foreign_key: 'from_id',
           dependent: :destroy

  has_many :received_conversations,
           -> { order(updated_at: :desc).includes(:from) },
           class_name: 'Conversation',
           foreign_key: 'to_id',
           dependent: :destroy

  AVAILABILITY = %w(  jan feb mar apr may jun jul aug sep oct nov dec  )

  scope :currently_available,
        -> { where("availability_mask & #{2**(DateTime.now.mon - 1)} > 0") }

  def availability=(availability)
    self.availability_mask = ArrayMask.new(AVAILABILITY).mask(availability)
  end

  def availability
    ArrayMask.new(AVAILABILITY).unmask(availability_mask)
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
