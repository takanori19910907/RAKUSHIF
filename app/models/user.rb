class User < ApplicationRecord
  belongs_to :shop
  has_many :requested_shifts
  has_many :fixed_shifts
  has_secure_password

end
