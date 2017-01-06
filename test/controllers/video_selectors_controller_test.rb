require 'test_helper'

class VideoSelectorsControllerTest < ActionController::TestCase
  setup do
    @video_selector = video_selectors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:video_selectors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create video_selector" do
    assert_difference('VideoSelector.count') do
      post :create, video_selector: { default_selection: @video_selector.default_selection, track: @video_selector.track }
    end

    assert_redirected_to video_selector_path(assigns(:video_selector))
  end

  test "should show video_selector" do
    get :show, id: @video_selector
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @video_selector
    assert_response :success
  end

  test "should update video_selector" do
    patch :update, id: @video_selector, video_selector: { default_selection: @video_selector.default_selection, track: @video_selector.track }
    assert_redirected_to video_selector_path(assigns(:video_selector))
  end

  test "should destroy video_selector" do
    assert_difference('VideoSelector.count', -1) do
      delete :destroy, id: @video_selector
    end

    assert_redirected_to video_selectors_path
  end
end
