require 'test_helper'

class InputTypesControllerTest < ActionController::TestCase
  setup do
    @input_type = input_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:input_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create input_type" do
    assert_difference('InputType.count') do
      post :create, input_type: { type_name: @input_type.type_name }
    end

    assert_redirected_to input_type_path(assigns(:input_type))
  end

  test "should show input_type" do
    get :show, id: @input_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @input_type
    assert_response :success
  end

  test "should update input_type" do
    patch :update, id: @input_type, input_type: { type_name: @input_type.type_name }
    assert_redirected_to input_type_path(assigns(:input_type))
  end

  test "should destroy input_type" do
    assert_difference('InputType.count', -1) do
      delete :destroy, id: @input_type
    end

    assert_redirected_to input_types_path
  end
end
