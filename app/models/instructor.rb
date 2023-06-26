class Instructor < ApplicationRecord
  has_many :students
# Validation happens in the model 
  validates :name, presence: true
end
