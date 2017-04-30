# frozen_string_literal: true

#
# Base ActiveRecord class
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
