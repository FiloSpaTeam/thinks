class ElectionPollsController < ApplicationController
  before_action :set_election_poll, only: [:show, :edit, :update, :destroy]

  # GET /election_polls
  # GET /election_polls.json
  def index
    @election_polls = ElectionPoll.all
  end

  # GET /election_polls/1
  # GET /election_polls/1.json
  def show
  end

  # GET /election_polls/new
  def new
    @election_poll = ElectionPoll.new
  end

  # GET /election_polls/1/edit
  def edit
  end

  # POST /election_polls
  # POST /election_polls.json
  def create
    @election_poll = ElectionPoll.new(election_poll_params)

    respond_to do |format|
      if @election_poll.save
        format.html { redirect_to @election_poll, notice: 'Election poll was successfully created.' }
        format.json { render :show, status: :created, location: @election_poll }
      else
        format.html { render :new }
        format.json { render json: @election_poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /election_polls/1
  # PATCH/PUT /election_polls/1.json
  def update
    respond_to do |format|
      if @election_poll.update(election_poll_params)
        format.html { redirect_to @election_poll, notice: 'Election poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @election_poll }
      else
        format.html { render :edit }
        format.json { render json: @election_poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /election_polls/1
  # DELETE /election_polls/1.json
  def destroy
    @election_poll.destroy
    respond_to do |format|
      format.html { redirect_to election_polls_url, notice: 'Election poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_election_poll
      @election_poll = ElectionPoll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def election_poll_params
      params.fetch(:election_poll, {})
    end
end
