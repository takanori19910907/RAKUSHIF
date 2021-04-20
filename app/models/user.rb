class User < ApplicationRecord
  belongs_to :shop
  has_secure_password
end
