class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_acceptance_of :terms, :allow_nil => false,
  :accept => true, :message => "You must accept the Terms of use."

  has_many :documents
end
