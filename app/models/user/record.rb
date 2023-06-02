class User::Record < ActiveRecord::Base
  self.table_name = 'users'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :account, class_name: '::Account::Record', foreign_key: :user_id

  after_create :init_account

  private

  def init_account
    create_account!(owner_name: email)
  end
end
