class FakeJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later
    puts 'Running Job! Performing time consumig task!'
    sleep 3
    puts 'Task done!'
  end
end
