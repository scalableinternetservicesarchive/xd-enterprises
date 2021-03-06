class Micropost < ActiveRecord::Base
  
  
  belongs_to :user

  default_scope -> { order(created_at: :desc) }
 
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, presence: true
  
  acts_as_commontable
  has_attached_file :image, :styles => { :medium => "400x400>", :thumb => "100x100>" }
  validates_attachment_content_type :image , :content_type => /\Aimage\/.*\Z/
  include SimpleHashtag::Hashtaggable
  hashtaggable_attribute :content
  
  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:image, "should be less than 5MB")
      end
    end

end
