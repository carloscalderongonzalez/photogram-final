# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  comments_count       :integer
#  email                :string
#  followrequests_count :integer
#  likes_count          :integer
#  password_digest      :string
#  private              :boolean
#  sentrequest_count    :integer
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
end
