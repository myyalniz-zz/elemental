require 'test_helper'

class InputProcessingsControllerTest < ActionController::TestCase
  setup do
    @input_processing = input_processings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:input_processings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create input_processing" do
    assert_difference('InputProcessing.count') do
      post :create, input_processing: { event_id: @input_processing.event_id, input_id: @input_processing.input_id }
    end

    assert_redirected_to input_processing_path(assigns(:input_processing))
  end

  test "should show input_processing" do
    get :show, id: @input_processing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @input_processing
    assert_response :success
  end

  test "should update input_processing" do
    patch :update, id: @input_processing, input_processing: { event_id: @input_processing.event_id, input_id: @input_processing.input_id }
    assert_redirected_to input_processing_path(assigns(:input_processing))
  end

  test "should destroy input_processing" do
    assert_difference('InputProcessing.count', -1) do
      delete :destroy, id: @input_processing
    end

    assert_redirected_to input_processings_path
  end
end
