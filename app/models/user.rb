class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable, :registerable,
         :trackable, :recoverable

  ROLES = %w["admin", "non-admin"]

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
    "users/user"
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
end
