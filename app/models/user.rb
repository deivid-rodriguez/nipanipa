class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable, :registerable,
         :trackable, :recoverable

  ROLES = %w["admin", "non-admin"]

  # accessible (or protected) attributes
  attr_accessible :country, :description, :email, :karma,
                  :language_skills_attributes, :name, :password,
                  :password_confirmation, :pictures_attributes, :remember_me,
                  :skills, :state, :work_type_ids

  # validations
  validates :description, length: { maximum: 2500 }
  validates :name, presence: true, length: { maximum: 50 }

  # geocoder
  geocoded_by :current_sign_in_ip do |obj, results|
    if geo = results.first
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
  accepts_nested_attributes_for :pictures,
    reject_if: proc { |att| att['image'].blank? && att['image_cache'].blank? }

  has_many :sent_feedbacks,
            class_name: 'Feedback',
           foreign_key: 'sender_id',
               include: :recipient,
             dependent: :destroy,
                 order: "updated_at DESC"
  has_many :received_feedbacks,
              class_name: 'Feedback',
             foreign_key: 'recipient_id',
                 include: :sender,
               dependent: :destroy,
                   order: "updated_at DESC"

  has_many :sent_conversations,
            class_name: 'Conversation',
           foreign_key: 'from_id',
               include: :to,
             dependent: :destroy,
                 order: "updated_at DESC"
  has_many :received_conversations,
            class_name: 'Conversation',
           foreign_key: 'to_id',
               include: :from,
             dependent: :destroy,
                 order: "updated_at DESC"

  # Fake class name in subclasses so URLs get properly generated
  def self.inherited(child)
    child.instance_eval do
      def model_name
        User.model_name
      end
    end
    super
  end

  def non_deleted_conversations
    sent_conversations.deleted_by_sender + received_conversations.deleted_by_recipient
  end

  def feedback_pairs
    result_list  = []
    sent_list = self.sent_feedbacks
    self.received_feedbacks.each do |feedback|
      result_list << [feedback, feedback.complement]
      sent_list -= [feedback.complement]
    end
    result_list.concat(sent_list.map { |x| [nil, x] })
  end

  def main_picture
    pictures.select { |p| p.avatar }.first
  end
end
