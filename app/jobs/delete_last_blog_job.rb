
class DeleteLastBlogJob < ApplicationJob
  queue_as :default

  def perform
    Blog.last&.destroy
  end
end