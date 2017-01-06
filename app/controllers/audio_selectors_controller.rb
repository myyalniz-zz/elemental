class AudioSelectorsController < ApplicationController
  before_action :set_audio_selector, only: [:show, :edit, :update, :destroy]

  # GET /audio_selectors
  # GET /audio_selectors.json
  def index
    @audio_selectors = AudioSelector.all
  end

  # GET /audio_selectors/1
  # GET /audio_selectors/1.json
  def show
  end

  # GET /audio_selectors/new
  def new
    @audio_selector = AudioSelector.new
  end

  # GET /audio_selectors/1/edit
  def edit
  end

  # POST /audio_selectors
  # POST /audio_selectors.json
  def create
    @audio_selector = AudioSelector.new(audio_selector_params)

    respond_to do |format|
      if @audio_selector.save
        format.html { redirect_to @audio_selector, notice: 'Audio selector was successfully created.' }
        format.json { render :show, status: :created, location: @audio_selector }
      else
        format.html { render :new }
        format.json { render json: @audio_selector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /audio_selectors/1
  # PATCH/PUT /audio_selectors/1.json
  def update
    respond_to do |format|
      if @audio_selector.update(audio_selector_params)
        format.html { redirect_to @audio_selector, notice: 'Audio selector was successfully updated.' }
        format.json { render :show, status: :ok, location: @audio_selector }
      else
        format.html { render :edit }
        format.json { render json: @audio_selector.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audio_selectors/1
  # DELETE /audio_selectors/1.json
  def destroy
    @audio_selector.destroy
    respond_to do |format|
      format.html { redirect_to audio_selectors_url, notice: 'Audio selector was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio_selector
      @audio_selector = AudioSelector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audio_selector_params
      params.require(:audio_selector).permit(:default_selection, :track)
    end
end
