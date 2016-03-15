class PhilosophersController < ApplicationController
  use_petra_transaction :only => :show
  before_action :ensure_current_philosopher, :only => [:show, :think]

  # TODO: may not start until there are enough philosophers
  # TODO: Use/Generate the correct amount of sticks dynamically
  # TODO: Statt "take_stick" eher "Plan to take stick" und "execute plan!" als commit.
  def index
    respond_to do |format|
      format.html
      format.json do
        render :json => Philosopher.order(:number).all
      end
    end
  end

  #
  # Returns the current user's philosopher (if he has one) in its current transactional state.
  #
  def show
    @philosopher = current_philosopher.petra
  end

  def think
    if current_philosopher.sticks_taken?
      render_api_error :unprocessable_entity, :not_eating, 'You cannot eat and think at the same time!'
      return
    end

    current_philosopher.update_attribute(:thoughts, params.permit(:thoughts)[:thoughts])
    render :nothing => true, :status => :no_content
  end

  def create
    if current_philosopher
      render_api_error :unprocessable_entity, :already_philosopher, 'You already are a philosopher, my dear!'
      return
    end

    if (@philosopher = Philosopher.create(:session_id => session.id, :name => params[:name]))
      render :json => current_philosopher
    else
      render_api_error :unprocessable_entity, :not_created, @philosopher
    end
  end

  def leave
    unless current_philosopher
      render_api_error :unprocessable_entity, :no_philosopher
      return
    end

    if Stick.taken.any?
      render_api_error :unprocessable_entity, :sticks_are_taken, 'You may only leave the table when all sticks are down.'
      return
    end

    current_philosopher.destroy

    render :nothing => true, :status => :no_content
  end

  private

  def ensure_current_philosopher
    render_api_error :not_found, :no_philosopher unless current_philosopher
  end
end
