require_relative "model.rb"
module Figo
  # Retrieve current User
  #
  # @return [User] the current user
  def user
    query_api_object User, "/rest/user"
  end

  # Modify the current user
  #
  # @param user [User] the modified user object to be saved
  # @return [User] the modified user returned
  def modify_user(user)
    query_api_object User, "/rest/user", user.dump(), "PUT"
  end

  # Remove the current user
  # Note: this has immidiate effect and you wont be able to interact with the user after this call
  #
  def remove_user
    query_api "/rest/user", nil, "DELETE"
  end

  # Re-send verification email
  #
  def resend_verification
    query_api "/rest/user/resend_verification", nil, "POST"
  end
end
