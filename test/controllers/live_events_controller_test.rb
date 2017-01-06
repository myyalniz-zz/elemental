require 'test_helper'

class LiveEventsControllerTest < ActionController::TestCase
  setup do
    @live_event = live_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:live_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create live_event" do
    assert_difference('LiveEvent.count') do
      post :create, live_event: { event_id: @live_event.event_id, name: @live_event.name }
    end

    assert_redirected_to live_event_path(assigns(:live_event))
  end

  test "should show live_event" do
    get :show, id: @live_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @live_event
    assert_response :success
  end

  test "should update live_event" do
    patch :update, id: @live_event, live_event: { event_id: @live_event.event_id, name: @live_event.name }
    assert_redirected_to live_event_path(assigns(:live_event))
  end

  test "should destroy live_event" do
    assert_difference('LiveEvent.count', -1) do
      delete :destroy, id: @live_event
    end

    assert_redirected_to live_events_path
  end
end
