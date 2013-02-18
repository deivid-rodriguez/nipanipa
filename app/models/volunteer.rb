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

class Volunteer < User

end
