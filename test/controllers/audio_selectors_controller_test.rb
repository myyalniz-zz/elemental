require 'test_helper'

class AudioSelectorsControllerTest < ActionController::TestCase
  setup do
    @audio_selector = audio_selectors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:audio_selectors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audio_selector" do
    assert_difference('AudioSelector.count') do
      post :create, audio_selector: { default_selection: @audio_selector.default_selection, track: @audio_selector.track }
    end

    assert_redirected_to audio_selector_path(assigns(:audio_selector))
  end

  test "should show audio_selector" do
    get :show, id: @audio_selector
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @audio_selector
    assert_response :success
  end

  test "should update audio_selector" do
    patch :update, id: @audio_selector, audio_selector: { default_selection: @audio_selector.default_selection, track: @audio_selector.track }
    assert_redirected_to audio_selector_path(assigns(:audio_selector))
  end

  test "should destroy audio_selector" do
    assert_difference('AudioSelector.count', -1) do
      delete :destroy, id: @audio_selector
    end

    assert_redirected_to audio_selectors_path
  end
end
