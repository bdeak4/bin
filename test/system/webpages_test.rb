require "application_system_test_case"

class WebpagesTest < ApplicationSystemTestCase
  setup do
    @webpage = webpages(:one)
  end

  test "visiting the index" do
    visit webpages_url
    assert_selector "h1", text: "Webpages"
  end

  test "creating a Webpage" do
    visit webpages_url
    click_on "New Webpage"

    fill_in "Element", with: @webpage.element
    fill_in "Url", with: @webpage.url
    fill_in "User", with: @webpage.user_id
    click_on "Create Webpage"

    assert_text "Webpage was successfully created"
    click_on "Back"
  end

  test "updating a Webpage" do
    visit webpages_url
    click_on "Edit", match: :first

    fill_in "Element", with: @webpage.element
    fill_in "Url", with: @webpage.url
    fill_in "User", with: @webpage.user_id
    click_on "Update Webpage"

    assert_text "Webpage was successfully updated"
    click_on "Back"
  end

  test "destroying a Webpage" do
    visit webpages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Webpage was successfully destroyed"
  end
end
