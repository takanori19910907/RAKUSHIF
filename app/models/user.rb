class User < ApplicationRecord
  belongs_to :shop 
  has_many :requested_shifts, dependent: :destroy
  has_many :fixed_shifts, dependent: :destroy
  has_secure_password

end
