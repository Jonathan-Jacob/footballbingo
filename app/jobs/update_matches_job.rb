class UpdateMatchesJob < ApplicationJob
  queue_as :important

  def perform
    puts "update matches..."
    # Match.update_matches
    puts "done."
  end
end
