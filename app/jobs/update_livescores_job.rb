class UpdateLivescoresJob < ApplicationJob
  queue_as :default

  def perform
    puts "update livescores..."
    # Match.update_livescores
    puts "done."
  end
end
