# frozen_string_literal: true

#
# An admin, with permissions to access the admin console
#
class AdminUser < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable
end
