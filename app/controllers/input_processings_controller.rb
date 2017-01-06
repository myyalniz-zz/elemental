class InputProcessingsController < ApplicationController
  before_action :set_input_processing, only: [:show, :edit, :update, :destroy]

  require 'rest-client'
  require 'nokogiri'
  require 'uri'

  include AuthElemental


  # GET /input_processings
  # GET /input_processings.json
  def index
    @input_processings = InputProcessing.all
  end

  # GET /input_processings/1
  # GET /input_processings/1.json
  def show
  end

  # GET /input_processings/new
  def new
    @input_processing = InputProcessing.new
  end

  # GET /input_processings/1/edit
  def edit
  end

  # POST /input_processings
  # POST /input_processings.json
  def create
    @input_processing = InputProcessing.new(input_processing_params)

    respond_to do |format|
      if @input_processing.save
        format.html { redirect_to @input_processing, notice: 'Input processing was successfully created.' }
        format.json { render :show, status: :created, location: @input_processing }
      else
        format.html { render :new }
        format.json { render json: @input_processing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /input_processings/1
  # PATCH/PUT /input_processings/1.json
  def update
    respond_to do |format|
      if @input_processing.update(input_processing_params)
        format.html { redirect_to @input_processing, notice: 'Input processing was successfully updated.' }
        format.json { render :show, status: :ok, location: @input_processing }
      else
        format.html { render :edit }
        format.json { render json: @input_processing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /input_processings/1
  # DELETE /input_processings/1.json
  def destroy
    @input_processing.destroy
    respond_to do |format|
      format.html { redirect_to input_processings_url, notice: 'Input processing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def single_add_wids

    @selected_inputs = []
    @modal_content = ""
    @modal_show = false

    if params[:id].present? and params[:event_id].present?  then
      @inputs = Input.all 
      @selected_input = @inputs.find(params[:id])
      @modal_show = true
    end

    respond_to do |format|
      format.html 
      format.js
    end
  
  end
  
  def single_add

    @selected_inputs = []
    @modal_content = ""
    @modal_show = false

    if params[:id].present? then
      @inputs = Input.all 
      @selected_inputs = @inputs.find(params[:id])
      @modal_show = true
    end
    
    xml_to_be_posted = "<inputs>"
    
    @selected_inputs.each do |input|
      xml_to_be_posted = xml_to_be_posted + "<input>"
      xml_to_be_posted = xml_to_be_posted + "<input_labe>" + input.input_label + "</input_label>"
      xml_to_be_posted = xml_to_be_posted + "<loop_source>" + input.loop_source.to_s + "</loop_source>"
      if input.input_type == 1 then
        xml_to_be_posted = xml_to_be_posted + "<network_input><quad>" + input.quad.to_s + "</quad><uri>" 
                          + input.uri + "</uri></network_input>"
      end
      if input.input_type == 2 then
        xml_to_be_posted = xml_to_be_posted + "<file_input><quad>" + input.quad.to_s + "</quad><uri>" 
                          + input.uri + "</uri></file_input>"
      end
      
      xml_to_be_posted = xml_to_be_posted + "<audio_selector>"
      xml_to_be_posted = xml_to_be_posted + "<audio_id>" + input.audio_selector.audio_id.to_s + "</audio_id>"
      xml_to_be_posted = xml_to_be_posted + "<default_selection>"  + input.audio_selector.default_selection.to_s + "</default_selection>"
      xml_to_be_posted = xml_to_be_posted + "<track>" + input.audio_selector.track.to_s + "</track>"
      xml_to_be_posted = xml_to_be_posted + "</audio_selector>"

      xml_to_be_posted = xml_to_be_posted + "<video_selector>"
      xml_to_be_posted = xml_to_be_posted + "<video_id>" + input.video_selector.video_id.to_s + "</video_id>"
      xml_to_be_posted = xml_to_be_posted + "<default_selection>"  + input.video_selector.default_selection.to_s + "</default_selection>"
      xml_to_be_posted = xml_to_be_posted + "<track>" + input.video_selector.track.to_s + "</track>"
      xml_to_be_posted = xml_to_be_posted + "</video_selector>"
      
      xml_to_be_posted = xml_to_be_posted + "</input>"
    end

    xml_to_be_posted = xml_to_be_posted + "<inputs>"

    @result = headers("/live_events/" + params[:live_event_id].to_s  + "/inputs" )

    @payload = xml_to_be_posted

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s + "/inputs"

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
        [ :error,  "Invalid response #{response} received." ]
      end
    end
    
#    @xml_response = RestClient.post(@url, @payload, { "X-Auth-User" => @result["X-Auth-User"],
#                     "X-Auth-Expires" => @result['X-Auth-Expires'],
#                     "X-Auth-Key" => @result['X-Auth-Key'],
#                     "Accept" => "application/xml",
#                     "Content-Type" =>  "application/xml"
#                    }
#                    )

#    @doc = Nokogiri::Slop(@xml_response)

#    @input_element = @doc.xpath("//input[input_label[text()=" + params[:input_label].to_s + "]]")

    respond_to do |format|
      format.html {redirect_to inputs_path(live_event_id: params[:event_id])}
      format.js
    end
  
  end
  
  def add_wids

    @selected_inputs = []
    @modal_content = ""
    @modal_show = false

    if params[:checkedInputs].present? and params[:event_id].present?  then
      @ids = params[:checkedInputs].split(",")
      @inputs = Input.all 
      @selected_inputs = @inputs.where(id: [ params[:checkedInputs] ] )
      @modal_show = true
    end

    if @modal_show then     
      @modal_content = render_to_string partial: 'layouts/add_wids_modal', locals: { items: @selected_inputs, checkedInputs: params[:checkedInputs], event_id: params[:event_id] }
    else
      @modal_content = render_to_string partial: 'layouts/add_wids_modal_error' 
    end
    
    respond_to do |format|
      format.html
      format.js
      format.json { render :json =>  {:modal_show => @modal_show, selected_inputs: @selected_inputs, modal_content: @modal_content  } }
    end
  
  end

  def add

    @selected_inputs = []
    @modal_content = ""
    @modal_show = false


    if params[:checkedInputs].present? then
      @ids = params[:checkedInputs].split(",")
      @inputs = Input.all 
      @selected_inputs = @inputs.where(id: [ params[:checkedInputs].split(" ") ] )
      @modal_show = true
    end
    
    xml_to_be_posted = "<inputs>"
    
    @selected_inputs.each do |input|
        xml_to_be_posted = xml_to_be_posted + "<input>"
        xml_to_be_posted = xml_to_be_posted + "<active>false</active>"
        xml_to_be_posted = xml_to_be_posted + "<deblock_enable>Auto</deblock_enable>"
        xml_to_be_posted = xml_to_be_posted + "<deblock_strength>0</deblock_strength>"
        xml_to_be_posted = xml_to_be_posted + "<error_clear_time nil=\"true\"/>"
        xml_to_be_posted = xml_to_be_posted + "<failback_rule>immediately</failback_rule>"
        xml_to_be_posted = xml_to_be_posted + "<hot_backup_pair>false</hot_backup_pair>"
        xml_to_be_posted = xml_to_be_posted + "<input_label>" + input.input_label + "</input_label>"
        xml_to_be_posted = xml_to_be_posted + "<loop_source>" + input.loop_source.to_s + "</loop_source>"
        xml_to_be_posted = xml_to_be_posted + "<no_psi>false</no_psi>"
        xml_to_be_posted = xml_to_be_posted + "<service_name nil=\"true\"/>"
        xml_to_be_posted = xml_to_be_posted + "<service_provider_name nil=\"true\"/>"
        xml_to_be_posted = xml_to_be_posted + "<timecode_source>embedded</timecode_source>"
        if input.input_type == 1 then
          xml_to_be_posted = xml_to_be_posted + "<network_input><udp_igmp_source/><quad>" + input.quad.to_s + "</quad><uri>" + input.uri + "</uri></network_input>"
        end
        if input.input_type == 2 then
          xml_to_be_posted = xml_to_be_posted + "<file_input><quad>" + input.quad.to_s + "</quad><uri>" + input.uri + "</uri></file_input>"
        end
        xml_to_be_posted = xml_to_be_posted + "<input_info>"
        xml_to_be_posted = xml_to_be_posted + "<general>Waiting for network input...</general>"
        xml_to_be_posted = xml_to_be_posted + "</input_info>"

        xml_to_be_posted = xml_to_be_posted + "<video_selector>"
        xml_to_be_posted = xml_to_be_posted + "<color_space>follow</color_space>"
        xml_to_be_posted = xml_to_be_posted + "<program_id nil=\"true\"/>"
        xml_to_be_posted = xml_to_be_posted + "</video_selector>"
        xml_to_be_posted = xml_to_be_posted + "<audio_selector>"
        xml_to_be_posted = xml_to_be_posted + "<default_selection>true</default_selection>"
        xml_to_be_posted = xml_to_be_posted + "<program_selection>1</program_selection>"
        xml_to_be_posted = xml_to_be_posted + "</audio_selector>"

#        xml_to_be_posted = xml_to_be_posted + "<audio_selector>"
#        xml_to_be_posted = xml_to_be_posted + "<audio_id>" + input.audio_selector.audio_id.to_s + "</audio_id>"
#        xml_to_be_posted = xml_to_be_posted + "<default_selection>"  + input.audio_selector.default_selection.to_s + "</default_selection>"
#        xml_to_be_posted = xml_to_be_posted + "<track>" + input.audio_selector.track.to_s + "</track>"
#        xml_to_be_posted = xml_to_be_posted + "</audio_selector>"

#        xml_to_be_posted = xml_to_be_posted + "<video_selector>"
#        xml_to_be_posted = xml_to_be_posted + "<video_id>" + input.video_selector.video_id.to_s + "</video_id>"
#        xml_to_be_posted = xml_to_be_posted + "<default_selection>"  + input.video_selector.default_selection.to_s + "</default_selection>"
#        xml_to_be_posted = xml_to_be_posted + "<track>" + input.video_selector.track.to_s + "</track>"
#        xml_to_be_posted = xml_to_be_posted + "</video_selector>"
        xml_to_be_posted = xml_to_be_posted + "</input>"
    end

    xml_to_be_posted = xml_to_be_posted + "</inputs>"

    @result = headers("/live_events/" + params[:event_id].to_s  + "/inputs" )

    @payload = xml_to_be_posted

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:event_id].to_s + "/inputs"
    
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
      byebug
      case response.code
      when 422
        [ :error, response.to_str ]
      when 200
        [ :success, response.to_str ]
      else
        flash.now[:error] = "Invalid response #{response} received." 
      end
    end
    

    respond_to do |format|
      format.html {redirect_to live_event_path(id: params[:event_id])}
      format.js
    end
  
  end


  def replace_wids

    @selected_inputs = []
    @modal_content = ""
    @modal_show = false

    if params[:checkedInputs].present? and params[:event_id].present?  then
      @ids = params[:checkedInputs].split(",")
      @inputs = Input.all 
      @selected_inputs = @inputs.where(id: [ params[:checkedInputs] ] )
      @modal_show = true
    end

    if @modal_show then     
      @modal_content = render_to_string partial: 'layouts/replace_wids_modal', locals: { items: @selected_inputs, checkedInputs: params[:checkedInputs], event_id: params[:event_id] }
    else
      @modal_content = render_to_string partial: 'layouts/replace_wids_modal_error' 
    end
    
    respond_to do |format|
      format.html
      format.js
      format.json { render :json =>  {:modal_show => @modal_show, selected_inputs: @selected_inputs, modal_content: @modal_content  } }
    end
  
  end

  def replace

    @selected_inputs = []
    @modal_content = ""
    @modal_show = false


    if params[:checkedInputs].present? then
      @ids = params[:checkedInputs].split(",")
      @inputs = Input.all 
      @selected_inputs = @inputs.where(id: [ params[:checkedInputs].split(" ") ] )
      @modal_show = true
    end
    
    xml_to_be_posted = "<inputs>"
    
    @selected_inputs.each do |input|
      xml_to_be_posted = xml_to_be_posted + "<input>"
      xml_to_be_posted = xml_to_be_posted + "<input_labe>" + input.input_label + "</input_label>"
      xml_to_be_posted = xml_to_be_posted + "<loop_source>" + input.loop_source.to_s + "</loop_source>"
      if input.input_type == 1 then
        xml_to_be_posted = xml_to_be_posted + "<network_input><quad>" + input.quad.to_s + "</quad><uri>" 
                          + input.uri + "</uri></network_input>"
      end
      if input.input_type == 2 then
        xml_to_be_posted = xml_to_be_posted + "<file_input><quad>" + input.quad.to_s + "</quad><uri>" 
                          + input.uri + "</uri></file_input>"
      end
      
      xml_to_be_posted = xml_to_be_posted + "<audio_selector>"
      xml_to_be_posted = xml_to_be_posted + "<audio_id>" + input.audio_selector.audio_id.to_s + "</audio_id>"
      xml_to_be_posted = xml_to_be_posted + "<default_selection>"  + input.audio_selector.default_selection.to_s + "</default_selection>"
      xml_to_be_posted = xml_to_be_posted + "<track>" + input.audio_selector.track.to_s + "</track>"
      xml_to_be_posted = xml_to_be_posted + "</audio_selector>"

      xml_to_be_posted = xml_to_be_posted + "<video_selector>"
      xml_to_be_posted = xml_to_be_posted + "<video_id>" + input.video_selector.video_id.to_s + "</video_id>"
      xml_to_be_posted = xml_to_be_posted + "<default_selection>"  + input.video_selector.default_selection.to_s + "</default_selection>"
      xml_to_be_posted = xml_to_be_posted + "<track>" + input.video_selector.track.to_s + "</track>"
      xml_to_be_posted = xml_to_be_posted + "</video_selector>"
      
      xml_to_be_posted = xml_to_be_posted + "</input>"
    end

    xml_to_be_posted = xml_to_be_posted + "</inputs>"

    @result = headers("/live_events/" + params[:live_event_id].to_s  + "/playlist" )

    @payload = xml_to_be_posted

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s + "/playlist"
    
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
        flash.now[:error] = "Invalid response #{response} received." 
      end
    end
    
    respond_to do |format|
      format.html {redirect_to live_event_path(id: params[:event_id])}
      format.js
    end
  
  end
  
  def change_attributes_wid

    @result = headers("/live_events/" + params[:live_event_id].to_s  )

    @xml_response = RestClient::Request.execute(
       :method => :get,
       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s,
       :headers => { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
    )

    @doc = Nokogiri::Slop(@xml_response)
    
    @input_element = @doc.xpath("//input[id[text()=" + params[:input_id].to_s + "]]")

    respond_to do |format|
      format.html
      format.js
    end
  
  end
  
  def change_attributes_wlabel

    @result = headers("/live_events/" + params[:live_event_id].to_s  )

    @xml_response = RestClient::Request.execute(
       :method => :get,
       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/"+ params[:live_event_id].to_s ,
       :headers => { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
    )

    @doc = Nokogiri::Slop(@xml_response)

    @input_element = @doc.xpath("//input[input_label[text()=\"" + params[:input_label].to_s + "\"]]")

    respond_to do |format|
      format.html
      format.js
    end
  
  end

  def prepare_wid

    @result = headers("/live_events/" + params[:live_event_id].to_s  )

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s
    
    @xml_response = RestClient::Request.new({
      method: :get,
      url: @url,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 404
        [ :error, response ]
      when 200
        [ :success, response ]
      else
        [ :error,  "Invalid response #{response} received." ]
      end
    end

    @event_id = params[:live_event_id].to_s
    @input_id = params[:input_id].to_s

    respond_to do |format|
      format.html
      format.js
    end
  
  end

  def prepare_wlabel

    @result = headers("/live_events/" + params[:live_event_id].to_s  )

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s
    
    RestClient::Request.new({
      method: :get,
      url: @url,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      
      case response.code
      when 404
        [ :error, response ]
      when 200
        [ :success, response ]
        @xml_response = response.body
      else
        [ :error,  "Invalid response #{response} received." ]
      end
    end

#    @xml_response = RestClient::Request.execute(
#       :method => :get,
#       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s,
#       :headers => { "X-Auth-User" => @result["X-Auth-User"],
#                     "X-Auth-Expires" => @result['X-Auth-Expires'],
#                     "X-Auth-Key" => @result['X-Auth-Key'],
#                     "Accept" => "application/xml",
#                     "Content-Type" =>  "application/xml"
#                    }
#    )

    @doc = Nokogiri::Slop(@xml_response)

    @input_element = @doc.xpath("//input[input_label[text()=" + params[:input_label].to_s + "]]")

    @event_id = params[:live_event_id].to_s
    @input_label = params[:input_label].to_s


    respond_to do |format|
      format.html
      format.js
    end
  
  end


  # ACTIVATE
  def activate_wid

    @result = headers("/live_events/" + params[:live_event_id].to_s  )

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s
    
    @xml_response = RestClient::Request.new({
      method: :get,
      url: @url,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 404
        [ :error, response ]
      when 200
        [ :success, response ]
      else
        [ :error,  "Invalid response #{response} received." ]
      end
    end

    @event_id = params[:live_event_id].to_s
    @input_id = params[:input_id].to_s


    respond_to do |format|
      format.html
      format.js
    end
  
  end

  def activate_wlabel

    @result = headers("/live_events/" + params[:live_event_id].to_s  )

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s
    
    @xml_response = RestClient::Request.new({
      method: :get,
      url: @url,
      headers: { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml" }
    }).execute do |response, request, result|
      case response.code
      when 422
        [ :error, response ]
      when 200
        [ :success, response ]
      else
        [ :error,  "Invalid response #{response} received." ]
      end
    end
    
    @event_id = params[:live_event_id].to_s
    @input_label = params[:input_label].to_s


    respond_to do |format|
      format.html
      format.js
    end
  
  end  

  def prepare
    @result = headers("/live_events/" + params[:live_event_id].to_s  + "/prepare_input" )

    if params[:input_id].present? 
      @payload = "<prepare_input><input_id>" + params[:input_id].to_s + "</input_id></prepare_input>"
    end
    
    if params[:input_label].present? 
      @payload = "<prepare_input><input_label>" + params[:input_label].to_s + "</input_label></prepare_input>"
    end
    
    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s + "/prepare_input"

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
        [ :error,  "Invalid response #{response} received." ]
      end
    end

    
#    @xml_response = RestClient.post(@url, @payload, { "X-Auth-User" => @result["X-Auth-User"],
#                     "X-Auth-Expires" => @result['X-Auth-Expires'],
#                     "X-Auth-Key" => @result['X-Auth-Key'],
#                     "Accept" => "application/xml",
#                     "Content-Type" =>  "application/xml"
#                    }
#                    )

#    @doc = Nokogiri::Slop(@xml_response)

#    @input_element = @doc.xpath("//input[input_label[text()=" + params[:input_label].to_s + "]]")

#    @event_id = params[:live_event_id].to_s
#    @input_label = params[:input_label].to_s


    respond_to do |format|
      format.html {redirect_to live_event_path(params[:live_event_id])}
      format.js
    end
    
  end

  
  def activate
    @result = headers("/live_events/" + params[:live_event_id].to_s  + "/activate_input" )

    if params[:input_id].present? 
      @payload = "<input_id>" + params[:input_id].to_s + "</input_id>"
    end

    if params[:input_label].present? 
      @payload = "<input_label>" + params[:input_label].to_s + "</input_label>"
    end

    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s + "/activate_input"
    
    
    @xml_response = RestClient::Request.new({
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
        [ :error, response ]
      when 200
        [ :success, response ]
      else
        [ :error,  "Invalid response #{response} received." ]
      end
    end
    
#    @xml_response = RestClient.post(@url, @payload, { "X-Auth-User" => @result["X-Auth-User"],
#                     "X-Auth-Expires" => @result['X-Auth-Expires'],
#                     "X-Auth-Key" => @result['X-Auth-Key'],
#                     "Accept" => "application/xml",
#                     "Content-Type" =>  "application/xml"
#                    }
#                    )

    @event_id = params[:live_event_id].to_s
    @input_label = params[:input_label].to_s

    respond_to do |format|
      format.html {redirect_to live_event_path(params[:live_event_id])}
      format.js
    end
    
  end


  def delete_wid

    @result = headers("/live_events/" + params[:live_event_id].to_s  )

    @xml_response = RestClient::Request.execute(
       :method => :get,
       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s,
       :headers => { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
    )

#    @doc = Nokogiri::Slop(@xml_response)
    
#    @input_element = @doc.xpath("//input[id[text()=" + params[:input_id].to_s + "]]")

    @event_id = params[:live_event_id].to_s
    @input_id = params[:input_id].to_s


    respond_to do |format|
      format.html
      format.js
    end
  
  end

  def delete_wlabel

    @result = headers("/live_events/" + params[:live_event_id].to_s  )

    @xml_response = RestClient::Request.execute(
       :method => :get,
       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s,
       :headers => { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
    )

#    @doc = Nokogiri::Slop(@xml_response)
    
#    @input_element = @doc.xpath("//input[input_label[text()=" + params[:input_label].to_s + "]]")

    @event_id = params[:live_event_id].to_s
    @input_label = params[:input_label].to_s


    respond_to do |format|
      format.html
      format.js
    end
  
  end  
  
  def delete
  
    @result = ""
    @url = ""
    
    if params[:input_label].present? 
      @result = headers("/live_events/" + params[:live_event_id].to_s  + "/inputs/by_label/" + params[:input_label].to_s )
      @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s   + "/inputs/by_label/" + params[:input_label].to_s
    elsif params[:input_id].present? 
      @result = headers("/live_events/" + params[:live_event_id].to_s  + "/inputs/" + params[:input_id].to_s )
      @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + params[:live_event_id].to_s   + "/inputs/" + params[:input_id].to_s
    end
  
    @xml_response = RestClient.delete(@url, { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
                    )

    @doc = Nokogiri::Slop(@xml_response)

    respond_to do |format|
      format.html {redirect_to live_event_path(params[:live_event_id])}
      format.js
    end
    
  end
  
  def reorder
    
    if params[:order].present? then
       order_raw = params[:order].gsub(/item\[\]=(\d*)/, '\1')
       @new_order = order_raw.split("&")
    end
    
    @event_id = params[:live_event_id]
    
    @result = headers("/live_events/" + @event_id)

    @xml_response = RestClient::Request.execute(
       :method => :get,
       :url => "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + @event_id,
       :headers => { "X-Auth-User" => @result["X-Auth-User"],
                     "X-Auth-Expires" => @result['X-Auth-Expires'],
                     "X-Auth-Key" => @result['X-Auth-Key'],
                     "Accept" => "application/xml",
                     "Content-Type" =>  "application/xml"
                    }
    )

    @doc = Nokogiri::XML(@xml_response)

    @input_elements = @doc.xpath("//input")

    @order = []
    @id_index = []
    @input_id = []

    @input_elements.each_with_index do |input, index|
      @order = @order.push( input.xpath("order").text.to_s ) 
      @id_index = @id_index.push( index.to_s )
      @input_id = @input_id.push(input.xpath("id").text.to_s) 
    end
    
    @new_order_ids = []
    
    for @recurse in 1..@order.size
      if @order[@recurse.to_i - 1] != @new_order[@recurse.to_i - 1] then
        @new_order_ids = @new_order_ids.push(@input_id[@new_order[@recurse.to_i - 1].to_i - 1].to_i)
      else
        @new_order_ids = @new_order_ids.push(@input_id[@recurse.to_i - 1].to_i )
      end
    end

    
    for index_of_input in 0..( @order.size - 1 )
        setInputOrder(@new_order_ids[index_of_input], index_of_input+1, @event_id)
    end    
    
    
    respond_to do |format|
      format.html {redirect_to live_event_path(params[:live_event_id])}
      format.json { render :json =>  {:order => "done" } }
  
    end
  end
  
  def setInputOrder(id, input_order, event_id)

    @result = headers("/live_events/" + event_id.to_s  + "/inputs/" + id.to_s )

    @payload = "<input><order>" + input_order.to_s + "</order></input>"
  
    @url = "http://nqm7e3lvuev71.cloud.elementaltechnologies.com/live_events/" + event_id.to_s  + "/inputs/" + id.to_s

    RestClient::Request.new({
      method: :put,
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
        fail "Invalid response #{response} received." 
      end
    end
    
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_input_processing
      @input_processing = InputProcessing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def input_processing_params
      params.require(:input_processing).permit(:event_id, :input_id)
    end
end
