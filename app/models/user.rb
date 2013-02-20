# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)      default(""), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  description         :text
#  work_description    :text
#  type                :string(255)
#  encrypted_password  :string(255)      default(""), not null
#  remember_created_at :datetime
#  role                :string(255)      default("non-admin")
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  state               :string(255)
#  country             :string(255)
#  latitude            :float
#  longitude           :float
#

class User < ActiveRecord::Base
  # :token_authenticatable, :confirmable, :lockable, :timeoutable,
  # :omniauthablAe, :recoverable
  devise :database_authenticatable, :rememberable, :validatable, :registerable,
         :trackable

  ROLES = %w["admin", "non-admin"]

  # accessible (or protected) attributes
  attr_accessible :name, :email, :password, :password_confirmation,
                  :description, :work_description, :work_type_ids, :remember_me,
                  :state, :country

  # validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 2500 }

  # geocoder
  geocoded_by :current_sign_in_ip do |obj, results|
    if geo = results.first
      obj.state     = geo.state
      obj.country   = geo.country
      obj.longitude = geo.longitude
      obj.latitude  = geo.latitude
    end
  end
  after_validation :geocode, if: :current_sign_in_ip_changed?

  # associations
  has_many :donations

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
# def to_partial_path
#   "users/user"
# end

end
