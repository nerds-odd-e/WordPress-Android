# encoding: UTF-8

class WordPressApp
  require 'calabash-android/operations'
  include Calabash::Android::Operations

  def start_app
    wait_view_to_display 'main_view'
  end

  def assert_is_login
    there_is "博文"
  end
end
