#
# Usuários administradores do PPA
#
class PPA::Administrator < ApplicationRecord
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :omniauthable, :registerable and :timeoutable
  devise :confirmable, :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable


  validates :cpf, presence: true, cpf: true, uniqueness: true
  validates :name, presence: true

  # Scopes

  def self.sorted
    order(:name)
  end

  # alias para método do devise Lockable#access_locked?
  def locked?
    access_locked?
  end

  # mecanismo para forçar a necessidade de preenchimento de senha
  def require_password!
    @force_password_required = true
  end

  def force_password_required?
    @force_password_required
  end

  def assign_secure_random_password
    self.password = SecureRandom.hex
  end

  protected

  # override
  # Devise mailer method
  def devise_mailer
    PPA::DeviseAdministratorMailer
  end

  # override
  # Devise method
  def password_required?
    force_password_required? || super
  end
end
