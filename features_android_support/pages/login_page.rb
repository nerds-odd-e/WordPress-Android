# encoding: utf-8

class LoginPage

  def logout
    step_pause
    touch_view "更多选项"
    touch_view "退出"
    touch_view "退出"
  end

  def click_login
    touch_view "登录"
  end

  def input_username username
    type_text "nux_username", username
  end

  def input_password password
    type_text "nux_password", password
  end

  def add_custom_host url
    touch_view "添加一个自己的站点"
    type_text "nux_url", url
  end

  def assert_invalid_password
    there_is "你输入的用户名或密码错误"
  end
end
