require 'test_helper'

class WebpagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @webpage = webpages(:one)
  end

  test "should get index" do
    get webpages_url
    assert_response :success
  end

  test "should get new" do
    get new_webpage_url
    assert_response :success
  end

  test "should create webpage" do
    assert_difference('Webpage.count') do
      post webpages_url, params: { webpage: { element: @webpage.element, url: @webpage.url, user_id: @webpage.user_id } }
    end

    assert_redirected_to webpage_url(Webpage.last)
  end

  test "should show webpage" do
    get webpage_url(@webpage)
    assert_response :success
  end

  test "should get edit" do
    get edit_webpage_url(@webpage)
    assert_response :success
  end

  test "should update webpage" do
    patch webpage_url(@webpage), params: { webpage: { element: @webpage.element, url: @webpage.url, user_id: @webpage.user_id } }
    assert_redirected_to webpage_url(@webpage)
  end

  test "should destroy webpage" do
    assert_difference('Webpage.count', -1) do
      delete webpage_url(@webpage)
    end

    assert_redirected_to webpages_url
  end
end
