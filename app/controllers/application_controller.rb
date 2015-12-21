class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_for_doc_changes
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    documents_path
  end

  def check_for_doc_changes
    if current_user
      @notifications = current_user.documents.select do |doc|
        doc.references.find { |ref| ref.status == "changed" }
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:new) { |u| u.permit(:email, :password, :password_confirmation, :terms) }
  end

end
