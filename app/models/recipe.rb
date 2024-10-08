require 'open-uri'

class Recipe < ApplicationRecord
  validates :name, presence: true
  after_save if: -> { saved_change_to_name? || saved_change_to_ingredients? } do
    set_content
    # set_picture
  end

  has_one_attached :picture

  # def content
    #   # if the column content is blank ("" or nil)
    #   if super.blank?
    #     # I want to call set content
    #     set_content
    #   else
    #     super
    #   end
    #   # if it's not blank
    #   # I want to return the column value
  # end

  private

  def set_content
    RecipeContentJob.perform_later(self)
  end

  def set_picture
    client = OpenAI::Client.new
    response = client.images.generate(parameters: {
      prompt: "A recipe image for #{name}" ,
      size: "256x256"
    })

    url = response["data"][0]['url']
    file = URI.open(url)

    picture.attach(io: file, filename: "#{name}_ai_image.jpg", content_type: "image/png")
    return picture
  end
end
