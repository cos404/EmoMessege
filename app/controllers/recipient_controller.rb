class RecipientController < ApplicationController

  def show
    puts "Recipient STATS"
  end

  private

  def recipient_params
    params.permit(:token, :telegram, :whats_up, :viber)
  end

end