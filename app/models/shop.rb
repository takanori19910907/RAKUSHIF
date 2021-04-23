class Shop < ApplicationRecord
  has_many :users
  has_many :requested_shifts
  has_many :fixed_shifts
end
