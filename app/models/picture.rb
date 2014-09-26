class Picture < ActiveRecord::Base
  belongs_to :monument
  
  has_attached_file :image, :styles => { :medium => "640x640>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates_presence_of :name
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :image
end
