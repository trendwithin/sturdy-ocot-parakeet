require 'test_helper'

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:mackey)
  end

  test 'should not get new' do
    get new_subscription_path
    assert_response :redirect
  end

  test 'should get new for confirmed user' do
    sign_in @user
    get new_subscription_path
    assert_response :success
  end
end
