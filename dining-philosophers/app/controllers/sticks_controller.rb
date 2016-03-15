class SticksController < ApplicationController
  before_action :enforce_philosopher_existence, :except => :index

  def index
    render :json => Stick.order(:number).limit(Philosopher.count).all
  end

  #
  # Prepares to take the left stick inside the transaction
  #
  def take_left
    if take_stick(current_philosopher.left_stick)
      render :json => {:status => 'success'}
    else
      render_api_error :unprocessable_entity, 'already_taken', 'The stick is already taken by another philosopher.'
    end
  end

  #
  # Prepares to take the right stick inside the transaction
  #
  def take_right
    if take_stick(current_philosopher.right_stick)
      render :json => {:status => 'success'}
    else
      render_api_error :unprocessable_entity, 'already_taken', 'The stick is already taken by another philosopher.'
    end
  end

  #
  # Prepares to put the left stick away in the transaction
  #
  def put_left
    if put_stick(current_philosopher.left_stick)
      render :json => {:status => 'success'}
    else
      render_api_error :unprocessable_entity, 'stick_not_taken', 'You have to hold a stick to put it down.'
    end
  end

  #
  # Prepares to put the right stick away in the transaction
  #
  def put_right
    if put_stick(current_philosopher.right_stick)
      render :json => {:status => 'success'}
    else
      render_api_error :unprocessable_entity, 'stick_not_taken', 'You have to hold a stick to put it down.'
    end
  end

  #
  # Commits the current actions
  #
  def commit
    petra_transaction do
      if [current_philosopher.left_stick, current_philosopher.right_stick].all? { |s| stick_taken_by_current?(s) }
        Petra.commit!
      elsif [current_philosopher.left_stick, current_philosopher.right_stick].none? { |s| stick_taken_by_current?(s) }
        Petra.commit!
      else
        render_api_error :bad_request, 'not_both_sticks_taken', 'You have to handle both sticks at once!'
        return
      end
    end
    render :json => {:status => :success}
  end

  private

  def take_stick(stick)
    success = false
    petra_transaction do
      if stick.petra.taken_by
        raise Petra::Reset
      else
        stick.petra.taken_by = current_philosopher.identifier
        stick.petra.save
        success = true
      end
    end
    success
  end

  def put_stick(stick)
    success = false
    petra_transaction do
      if stick.petra.taken_by == current_philosopher.identifier
        stick.petra.taken_by = nil
        stick.petra.save
        success = true
      else
        raise Petra::Reset
      end
    end
    success
  end

  def enforce_philosopher_existence
    unless current_philosopher
      render_api_error :bad_request, :no_philosopher
      false
    end
  end

  def stick_taken_by_current?(stick)
    stick.petra.taken_by == current_philosopher.identifier
  end
end
