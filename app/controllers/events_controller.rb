class EventsController < ApplicationController

  before_action :set_event, only: [:show]

  def index
    @events = EventFetch.get_events
  end

  def show
  end

    private

  def set_event
    @event = EventFetch.get_one_event(params[:id])
  end
end
