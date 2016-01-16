class KeyValidator < ActiveModel::Validators
  #Remember to include this!
  def validate(registration_key)
    unless registration_key == "#{username}isallowed"
      record.errors[:registration_key] << "You don't have permission to sign up."
    end
  end
end
