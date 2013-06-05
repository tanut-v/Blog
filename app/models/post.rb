class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :picture
  has_attached_file :picture, :styles => { :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  has_many :comments
  has_many :likes
end
