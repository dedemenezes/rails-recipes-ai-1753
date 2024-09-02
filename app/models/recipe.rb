require 'open-uri'

class Recipe < ApplicationRecord
  validates :name, presence: true
  after_save if: -> { saved_change_to_name? || saved_change_to_ingredients? } do
    set_content
    set_picture
  end

  has_one_attached :picture

  def content
    # if the column content is blank ("" or nil)
    if super.blank?
      # I want to call set content
      set_content
    else
      super
    end
    # if it's not blank
    # I want to return the column value
  end

  private

  def set_content
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "Give me a simple recipe for #{self.name} with the ingredients #{ingredients}. Give me only the text of the recipe, without any of your own answer like 'Here is a simple recipe'."}]
    })
    new_content = chatgpt_response['choices'][0]['message']['content']

    self.update(content: new_content)

    return new_content
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
