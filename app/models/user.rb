# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  email            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  password_digest  :string(255)
#  remember_token   :string(255)
#  admin            :boolean          default(FALSE)
#  description      :text
#  location_id      :integer
#  work_description :text
#  type             :string(255)
#

class User < ActiveRecord::Base
  attr_protected :admin

  has_secure_password

  belongs_to :location

  has_many :sectorizations
  has_many :work_types, through: :sectorizations

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

  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 1000 }
  validates :password, length: { minimum: 6 }

  # Keep same routes for subclasses
  def self.inherited(child)
    child.instance_eval do
      alias :original_model_name :model_name
      def model_name
        User.model_name
      end
    end
    super
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
