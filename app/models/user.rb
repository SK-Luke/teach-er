class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :bookings
  has_many :availabilities, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_one_attached :photo

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ROLES = %w[Teacher Student]
  validates :email, :username, presence: true
  validates :role, inclusion: { in: ROLES }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def student?
    self.role == "Student"
  end

  def teacher?
    self.role == "teacher"
  end

  def had_class_with_teacher?(teacher)
    bookings.find { |booking|
      (teacher.subjects.map{ |subj| subj.id }.include? booking.subject_id) && (Time.now > booking.end_time) && (booking.status == "confirmed")
    }
  end

  def lessons
      bookings = []

      self.subjects.each do |subject|
        bookings << subject.bookings
      end

      bookings.flatten
  end
end
