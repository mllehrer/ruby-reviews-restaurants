class User < ActiveRecord::Base
  include BCrypt
  include ActiveModel::Validations
  validates_with KeyValidator
  has_many :reviews

  validates :username, uniqueness: true
  validates :email, uniqueness: true
  validates_format_of :email, :with => /@/

  def password
    password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(username, password)
    user = User.find_by(username: username)
    if user && user.password == password
      user
    else
      nil
    end
  end

end
