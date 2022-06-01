class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :availabilities, dependent: :destroy
  has_many :bookings, through: :subjects, dependent: :destroy
  has_one :schedule, through: :availabilities, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ROLES = %w[Teacher Student]
  validates :email, :username, presence: true
  validates :role, inclusion: { in: ROLES }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
