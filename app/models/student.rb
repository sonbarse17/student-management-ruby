class Student < ApplicationRecord
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :date_of_birth, presence: true
  validates :grade, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def age
    return nil unless date_of_birth
    ((Date.current - date_of_birth) / 365.25).floor
  end
end
