#
# Main class implementing both Host and Volunteer through STI
#
class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable, :registerable,
         :trackable, :recoverable

  ROLES = %w(admin, non-admin)
  AFRICA = ['Angola','Burkina Faso','Burundi','Benin','Botswana','Democratic Republic of the Congo','Central African Republic','Republic of the Congo','Ivory Coast','Cameroon','Cape Verde','Djibouti','Algeria','Egypt','Western Sahara','Eritrea','Ethiopia','Gabon','Ghana','Gambia','Guinea','Equatorial Guinea','Guinea-Bissau','Kenya','Comoros','Liberia','Lesotho','Libya','Morocco','Madagascar','Mali','Mauritania','Mauritius','Malawi','Mozambique','Namibia','Niger','Nigeria','Réunion','Rwanda','Seychelles','Sudan','Saint Helena','Sierra Leone','Senegal','Somalia','South Sudan','São Tomé and Príncipe','Swaziland','Chad','Togo','Tunisia','Tanzania','Uganda','Mayotte','South Africa','Zambia','Zimbabwe']
  AMERICA = ['Antigua and Barbuda','Bahamas','Barbados','Belize','Canada','Costa Rica','Cuba','Dominica','Dominican Republic','El Salvador','Grenada','Guatemala','Haiti','Honduras','Jamaica','Mexico','Nicaragua','Panama','Saint Kitts and Nevis','Saint Lucia','Saint Vincent and the Grenadines','Trinidad and Tobago','United States','Argentina','Bolivia','Brazil','Chile','Colombia','Ecuador','Guyana','Paraguay','Peru','Suriname','Uruguay','Venezuela'] 
  ASIA = ['United Arab Emirates','Afghanistan','Armenia','Azerbaijan','Bangladesh','Bahrain','Brunei','Bhutan','Cocos [Keeling] Islands','China','Christmas Island','Georgia','Hong Kong','Indonesia','Israel','India','British Indian Ocean Territory','Iraq','Iran','Jordan','Japan','Kyrgyzstan','Cambodia','North Korea','South Korea','Kuwait','Kazakhstan','Laos','Lebanon','Sri Lanka','Myanmar [Burma]','Mongolia','Macao','Maldives','Malaysia','Nepal','Oman','Philippines','Pakistan','Palestine','Qatar','Saudi Arabia','Singapore','Syria','Thailand','Tajikistan','Turkmenistan','Turkey','Taiwan','Uzbekistan','Vietnam','Yemen'] 
  OCEANIA = ['Australia','Fiji','Kiribati','Marshall Islands','Micronesia','Nauru','New Zealand','Palau','Papua New Guinea','Samoa','Solomon Islands','Tonga','Tuvalu','Vanuatu'] 
  EUROPE = ['Andorra','Albania','Austria','Åland','Bosnia and Herzegovina','Belgium','Bulgaria','Belarus','Switzerland','Cyprus','Czech Republic','Germany','Denmark','Estonia','Spain','Finland','Faroe Islands','France','United Kingdom','Guernsey','Gibraltar','Greece','Croatia','Hungary','Ireland','Isle of Man','Iceland','Italy','Jersey','Liechtenstein','Lithuania','Luxembourg','Latvia','Monaco','Moldova','Montenegro','Macedonia','Malta','Netherlands','Norway','Poland','Portugal','Romania','Serbia','Russia','Sweden','Slovenia','Svalbard and Jan Mayen','Slovakia','San Marino','Ukraine','Vatican City','Kosovo']  




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
