require 'test_helper'

class InputsControllerTest < ActionController::TestCase
  setup do
    @input = inputs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inputs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create input" do
    assert_difference('Input.count') do
      post :create, input: { audio_selector_id: @input.audio_selector_id, input_label: @input.input_label, input_type: @input.input_type, live_event_id: @input.live_event_id, loop_source: @input.loop_source, quad: @input.quad, uri: @input.uri, video_selector_id: @input.video_selector_id }
    end

    assert_redirected_to input_path(assigns(:input))
  end

  test "should show input" do
    get :show, id: @input
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @input
    assert_response :success
  end

  test "should update input" do
    patch :update, id: @input, input: { audio_selector_id: @input.audio_selector_id, input_label: @input.input_label, input_type: @input.input_type, live_event_id: @input.live_event_id, loop_source: @input.loop_source, quad: @input.quad, uri: @input.uri, video_selector_id: @input.video_selector_id }
    assert_redirected_to input_path(assigns(:input))
  end

  test "should destroy input" do
    assert_difference('Input.count', -1) do
      delete :destroy, id: @input
    end

    assert_redirected_to inputs_path
  end
end
