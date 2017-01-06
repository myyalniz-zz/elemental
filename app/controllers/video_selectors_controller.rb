class VideoSelectorsController < ApplicationController
  before_action :set_video_selector, only: [:show, :edit, :update, :destroy]

  # GET /video_selectors
  # GET /video_selectors.json
  def index
    @video_selectors = VideoSelector.all
  end

  # GET /video_selectors/1
  # GET /video_selectors/1.json
  def show
  end

  # GET /video_selectors/new
  def new
    @video_selector = VideoSelector.new
  end

  # GET /video_selectors/1/edit
  def edit
  end

  # POST /video_selectors
  # POST /video_selectors.json
  def create
    @video_selector = VideoSelector.new(video_selector_params)

    respond_to do |format|
      if @video_selector.save
        format.html { redirect_to @video_selector, notice: 'Video selector was successfully created.' }
        format.json { render :show, status: :created, location: @video_selector }
      else
        format.html { render :new }
        format.json { render json: @video_selector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /video_selectors/1
  # PATCH/PUT /video_selectors/1.json
  def update
    respond_to do |format|
      if @video_selector.update(video_selector_params)
        format.html { redirect_to @video_selector, notice: 'Video selector was successfully updated.' }
        format.json { render :show, status: :ok, location: @video_selector }
      else
        format.html { render :edit }
        format.json { render json: @video_selector.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /video_selectors/1
  # DELETE /video_selectors/1.json
  def destroy
    @video_selector.destroy
    respond_to do |format|
      format.html { redirect_to video_selectors_url, notice: 'Video selector was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_selector
      @video_selector = VideoSelector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_selector_params
      params.require(:video_selector).permit(:default_selection, :track)
    end
end
