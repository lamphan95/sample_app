class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_micropost.maximum_length}
  validate :picture_size
  scope :order_by_created_at, ->{order created_at: :desc}
  scope :find_user_id, ->(following_ids, id){where "user_id IN (?) OR user_id = ?", following_ids, id}

  private

  def picture_size
    if picture.size > Settings.micropost.picture_size.megabytes
      errors.add :picture, I18n.t(".microposts.model.picture_error")
    end
  end
end
