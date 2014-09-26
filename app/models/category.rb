class Category < ActiveRecord::Base
  belongs_to :user
  has_many :monuments, dependent: :destroy
  validates :name, presence: true, uniqueness: {scope: :user_id, case_sensitive: false}
end
