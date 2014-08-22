# encoding: utf-8
# language: zh-CN
STEP_PAUSE=4
WAIT_TIMEOUT=50

def step_pause
  sleep(STEP_PAUSE)
end

def is_view_exist view
  not is_view_not_exist view
end

def is_view_not_exist view
  query("* marked:'#{view}'").empty?
end

def is_exist_view_id id
  query("* id:'#{id}'").count > 0
end

def is_not_navigation title
  query("navigationBar id:'#{title}'").empty?
end

def is_exists_loadingCell  #气泡左边的loading图标是否存在
  query("android.widget.ImageView id:'message_uploading'").count > 0
end

def is_exists_chat_record  #界面上是否存在气泡
  query("android.widget.FrameLayout id:'item_container'").count > 0
end

def wait_view_to_display text
  wait_for(WAIT_TIMEOUT) {
    query("* marked:'#{text}'").size > 0
  }
end

def click_anywhere
  touch(nil, {:offset => {:x => 50, :y => 50}})
  step_pause
end

def touch_view(text, index=1)
  wait_view_to_display text

  type = ['org.wordpress.android.widgets.WPTextView',
    'com.android.internal.widget.ActionBarView',
    'button'].find { |t|
    not query("#{t} marked:'#{text}'").empty?
  }
  touch("#{type || '*'} marked:'#{text}' index:#{index - 1}")
end

def touch_view_if_exist text
  if is_view_exist text then
    touch_view text
  end
end

def touch_alert_button(name)
  touch("alertButton marked:'#{name}'")
  step_pause
end

def touch_hold_view view_id
  long_press("* marked:'#{view_id}'")
  #step_pause
end

def touch_button(button_name)
  wait_view_to_display button_name
  touch("* marked:'#{button_name}'")
end

def touch_tab_bar_button button_name
  touch("tabBarButton marked:'#{button_name}'")
  step_pause
end

def clear_text_field field_name
  wait_view_to_display field_name
  clear_text("org.wordpress.android.widgets.OpenSansEditText marked:'#{field_name}'")
  step_pause
end

def clear_textView field_name
 clear_text_field field_name
end

def type_text(field_name, text)
    wait_view_to_display field_name
    type_text_in "org.wordpress.android.widgets.OpenSansEditText marked:'#{field_name}'", text
end

def type_text_in_first_field(text)
    type_text_in "org.wordpress.android.widgets.OpenSansEditText index:0", text
end

def type_text_in query, text
    enter_text(query, text)
end

def type_textView(field_name, text)
    type_text(field_name, text)
end

def there_is(expected_mark)
    wait_for(WAIT_TIMEOUT) { view_with_mark_exists( expected_mark ) }
end

def assert_alert_message text
  if query("textView marked:'#{text}'").empty? then
    screenshot_and_raise "Alert with message '#{text}' not found."
  end
end

def keyboard_enter_text_is text
    if query("expandingTextView {description LIKE '*\\'#{text}\\'*'}").empty?
        screenshot_and_raise "Expect keyboard has type '#{text}'"
    end
end

def scroll_default_view direction
    if '上'==direction
      scroll_up if query("android.widget.ListView").empty?  #如果是ListView就使用默认的scroll_up
      scroll("android.widget.ListView", :up) if query("android.widget.ScrollView").empty?
    elsif '下'==direction
      scroll_down if query("android.widget.ListView").empty? #如果是ListView就使用默认的scroll_down
      scroll("android.widget.ListView", :down)  if query("android.widget.ScrollView").empty?
    elsif '左'==direction
      perform_action('swipe', 'left')
    elsif '右'==direction
      perform_action('swipe', 'right')
    end
    step_pause
end

def scroll_view view_id,direction
    directions = { '上' => 'up', '下' => 'down', '左' => 'left', '右' => 'right' }
    scroll("scrollView marked:'#{view_id}'", directions[direction])  #'Only upwards and downwards scrolling is supported for now'
    # view = query("* marked:'#{view_id}'")[0]
    # fromX = view.fetch('rect').fetch('x')
    # fromY = view.fetch('rect').fetch('y')
    # distance = 100
    # case direction
      # when "上"
        # puts "往上滑动"
        # perform_action('drag',fromX,fromX,fromY,fromY-distance,1)
      # when "下"
        # puts "往下滑动"
        # perform_action('drag',fromX,fromX,fromY,fromY+distance,1)
      # when "左"
        # puts "往左滑动"
        # perform_action('drag',fromX,fromX-distance,fromY,fromY,1)
      # when "右"
        # puts "往右滑动"
        # perform_action('drag',fromX,fromX+distance,fromY,fromY,1)
    # end
    step_pause
end

def scroll_down_if_view_not_exist view
  max_step = 10
  while is_view_not_exist view
    if max_step <= 0 then
      break
    end
    scroll_default_view "下"
    max_step -= 1
  end
end

def assert_view_exist text
  wait_for_text(text, timeout: 10)
end

def wait_for_any_button
  wait_for(WAIT_TIMEOUT) {
    not query("button").empty?
  }
end

def wait_for_dismiss text
  wait_for(WAIT_TIMEOUT) {
    query("* {description LIKE[c] '*#{text}*'}").empty?
  }
end
