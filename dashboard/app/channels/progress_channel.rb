class ProgressChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    stream_from "progress:progress_#{params[:kind]}"
  end
end