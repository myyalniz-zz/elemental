class InputsController < ApplicationController
  before_action :set_input, only: [:show, :edit, :update, :destroy]

  # GET /inputs
  # GET /inputs.json
  def index
    
    @selected = -1

    @inputs = [] 
    
    if params[:live_event].present? then 
      if params[:live_event][:event_id].present? then
        @selected = params[:live_event][:event_id]
        @inputs = Input.where(live_event_id: params[:live_event][:event_id] )
      end
    end
    if params[:live_event_id].present? then
      @inputs = Input.where(live_event_id: params[:live_event_id] )
    end

  end

  # GET /inputs/1
  # GET /inputs/1.json
  def show
  end

  # GET /inputs/new
  def new
    if params[:live_event_id].present? then
      @live_event_id = params[:live_event_id]
    end

    @input = Input.new
    @input.build_audio_selector
    @input.build_video_selector
  end

  # GET /inputs/1/edit
  def edit
    if params[:live_event_id].present? then
      @live_event_id = params[:live_event_id]
    end

  end

  # POST /inputs
  # POST /inputs.json
  def create
    @input = Input.new(input_params)

    respond_to do |format|
      if @input.save
        format.html { redirect_to @input, notice: 'Input was successfully created.' }
        format.json { render :show, status: :created, location: @input }
      else
        format.html { render :new }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inputs/1
  # PATCH/PUT /inputs/1.json
  def update
    respond_to do |format|
      if @input.update(input_params)
        format.html { redirect_to @input, notice: 'Input was successfully updated.' }
        format.json { render :show, status: :ok, location: @input }
      else
        format.html { render :edit }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inputs/1
  # DELETE /inputs/1.json
  def destroy
    @input.destroy
    respond_to do |format|
      format.html { redirect_to inputs_url, notice: 'Input was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_input
      @input = Input.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def input_params
      params.require(:input).permit(:live_event_id, :input_label, :loop_source, :input_type, :quad, :uri, audio_selector_attributes: [ :audio_id, :id, :default_selection, :track ], video_selector_attributes: [  :video_id, :id, :default_selection, :track ])
    end
end
