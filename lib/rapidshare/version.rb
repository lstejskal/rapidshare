# encoding: utf-8

module Rapidshare
  VERSION = "0.5.3"

  # CHANGELOG:
  #
  # 0.5.3
  # refactored helper method into Utils module
  # added basic support for free users
  # fixed escaping urls in rapidshare requests
  #
  # 0.5.2
  # update gemspec (remove httparty, update turn)
  # update and refactor examples
  #
  # 0.5.1
  # fixed ssl issues
  # add option to pass only cookie as a string to API#initialize
  #
  # 0.5.0
  # wrote documentation
  # wrote tests
  # refactored API class
  # changed HTTP client for API class: replace HTTParty with Net::HTTPS
  # removed obsolete Account class
  # enabled login with cookie only
  # add API#method_missing for unsupported Rapidshare service calls
  #
  # 0.4.5
  # rewrote download method from Net:HTTP to Curb gem
  # added download scripts as examples of use of rapidshare gem
  #
end
