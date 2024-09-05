class RecipeContentJob < ApplicationJob
  queue_as :default

  def perform(recipe)
    # Do something later
    puts "Starting RecipeContentJob!"
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "Give me a simple recipe for #{recipe.name} with the ingredients #{recipe.ingredients}. Give me only the text of the recipe, without any of your own answer like 'Here is a simple recipe'."}]
    })
    new_content = chatgpt_response['choices'][0]['message']['content']

    recipe.update(content: new_content)
    puts "Done w/ RecipeContentJob! \o/"
  end
end
