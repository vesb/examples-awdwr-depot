class User < ApplicationRecord
  after_destroy :ensure_an_admin_remains
  validates :name, presence: true, uniqueness: true
  has_secure_password

  class Error < StandardError
  end

  private

  def ensure_an_admin_remains
    if User.count.zero?
      # ActiveRecord::Rollback exception is not passed on in chain
      raise Error.new 'Can not delete the last user'
    end
  end
end
