class LiveEventsController < ApplicationController
  before_action :set_live_event, only: [:edit, :update, :destroy]

  require 'rest-client'
  require 'nokogiri'

  include AuthElemental
  
  # GET /live_events
  # GET /live_events.json
  def index
    @result = headers("/live_events")

    @xml_response = RestClient::Request.execute(
       :method => :get,
       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events",
       :headers => { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
    )
    
    @doc = Nokogiri::XML(@xml_response)
    
    @live_events = @doc.xpath("//live_event")

  end

  # GET /live_events/1
  # GET /live_events/1.json
  def show

    if params[:id].present? then
        @id = params[:id].gsub(/\/live_events\/(\d*)/, '\1')
    end

    @result = headers("/live_events/" + @id)

    @xml_response = RestClient::Request.execute(
       :method => :get,
       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @id,
       :headers => { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
    )

    @doc = Nokogiri::XML(@xml_response)

    @live_event_name = @doc.xpath("live_event/name").text
    @live_event_event_id = @doc.xpath("live_event/id").text
    @input_elements = @doc.xpath("//input")

    @inputs = Input.where(live_event_id: @id )

  end

  # GET /live_events/new
  def new
    @live_event = LiveEvent.new
  end

  # GET /live_events/1/edit
  def edit
  end

  # POST /live_events
  # POST /live_events.json
  def create
    @live_event = LiveEvent.new(live_event_params)

    respond_to do |format|
      if @live_event.save
        format.html { redirect_to @live_event, notice: 'Live event was successfully created.' }
        format.json { render :show, status: :created, location: @live_event }
      else
        format.html { render :new }
        format.json { render json: @live_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /live_events/1
  # PATCH/PUT /live_events/1.json
  def update
    respond_to do |format|
      if @live_event.update(live_event_params)
        format.html { redirect_to @live_event, notice: 'Live event was successfully updated.' }
        format.json { render :show, status: :ok, location: @live_event }
      else
        format.html { render :edit }
        format.json { render json: @live_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /live_events/1
  # DELETE /live_events/1.json
  def destroy
    @live_event.destroy
    respond_to do |format|
      format.html { redirect_to live_events_url, notice: 'Live event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def start
    if params[:event_detail].present? then
        @id = params[:event_detail].gsub(/\/live_events\/(\d*)/, '\1')
    end
    
    @result = headers("/live_events/" + @id  + "/start" )

    @payload = "<start>" + @id + "</start>"

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @id + "/start"
    
    RestClient::Request.new({
      method: :post,
      url: @url,
      payload: @payload,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 422
        [ :error, response.to_str ]
      when 200
        [ :success, response.to_str ]
      else
        @failure =  response.to_str
      end
    end
    
    respond_to do |format|
      format.html { redirect_to live_events_url, notice: @failure }
      format.json { head :no_content }
    end
  end

  def stop
    if params[:event_detail].present? then
        @id = params[:event_detail].gsub(/\/live_events\/(\d*)/, '\1')
    end
    
    @result = headers("/live_events/" + @id  + "/stop" )

    @payload = "<stop>" + @id + "</stop>"

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @id + "/stop"

    RestClient::Request.new({
      method: :post,
      url: @url,
      payload: @payload,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 422
        [ :error, response.to_str ]
      when 200
        [ :success, response.to_str ]
      else
        @failure =  response.to_str
      end
    end
    
    respond_to do |format|
      format.html { redirect_to live_events_url, notice: @failure }
      format.json { head :no_content }
    end
  end

  def cancel
    if params[:event_detail].present? then
        @id = params[:event_detail].gsub(/\/live_events\/(\d*)/, '\1')
    end
    
    @result = headers("/live_events/" + @id  + "/cancel" )

    @payload = "<cancel>" + @id + "</cancel>"

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @id + "/cancel"

    RestClient::Request.new({
      method: :post,
      url: @url,
      payload: @payload,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 422
        [ :error, response.to_str ]
      when 200
        [ :success, response.to_str ]
      else
        @failure =  response.to_str
      end
    end
    
    respond_to do |format|
      format.html { redirect_to live_events_url, notice: @failure }
      format.json { head :no_content }
    end
  end
  
  def archive
    if params[:event_detail].present? then
        @id = params[:event_detail].gsub(/\/live_events\/(\d*)/, '\1')
    end
    
    @result = headers("/live_events/" + @id  + "/archive" )

    @payload = "<archive>" + @id + "</archive>"

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @id + "/archive"

    RestClient::Request.new({
      method: :post,
      url: @url,
      payload: @payload,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 422
        [ :error, response.to_str ]
      when 200
        [ :success, response.to_str ]
      else
        @failure =  response.to_str
      end
    end
    
    respond_to do |format|
      format.html { redirect_to live_events_url, notice: @failure }
      format.json { head :no_content }
    end
  end  
  
  def reset
    if params[:event_detail].present? then
        @id = params[:event_detail].gsub(/\/live_events\/(\d*)/, '\1')
    end
    
    @result = headers("/live_events/" + @id  + "/reset" )

    @payload = "<reset>" + @id + "</reset>"

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @id + "/reset"

    RestClient::Request.new({
      method: :post,
      url: @url,
      payload: @payload,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 422
        [ :error, response.to_str ]
      when 200
        [ :success, response.to_str ]
      else
        @failure =  response.to_str
      end
    end
    
    respond_to do |format|
      format.html { redirect_to live_events_url, notice: @failure }
      format.json { head :no_content }
    end
  end

  def priority
    if params[:priority].present? then
        @priority = params[:priority]
    end
    
    if params[:live_event_id].present? then
        @id = params[:live_event_id]
    end
  
    @result = headers("/live_events/" + @id  + "/priority" )

    @payload = "<priority>" + @priority + "</priority>"

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @id + "/priority"

    RestClient::Request.new({
      method: :post,
      url: @url,
      payload: @payload,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 422
        [ :error, response.to_str ]
      when 200
        [ :success, response.to_str ]
      else
        @failure =  response.to_str
      end
    end
    
    respond_to do |format|
      format.html { redirect_to live_events_url, notice: @failure }
      format.json { head :no_content }
    end
  end
  
  def set_priority
    
    if params[:event_detail].present? then
        @id = params[:event_detail].gsub(/\/live_events\/(\d*)/, '\1')
    end

    @result = headers("/live_events/" + @id)

    @xml_response = RestClient::Request.execute(
       :method => :get,
       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @id,
       :headers => { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
    )

    @doc = Nokogiri::XML(@xml_response)
    
    @priority = @doc.xpath("//priority").text

    respond_to do |format|
      format.html { redirect_to live_events_url, notice: @failure }
      format.json { head :no_content }
      format.js
    end
  end  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_live_event
      if params[:id].present? then
        @live_event = LiveEvent.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def live_event_params
      params.require(:live_event).permit(:name, :event_id)
    end
end
