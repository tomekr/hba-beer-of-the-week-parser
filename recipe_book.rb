require 'ruport'
class RecipeBook
  def initialize(recipes=[])
    @recipes = recipes
  end

  def add(recipe)
    @recipes << recipe
  end

  def to_html
    #TODO Should be more dynamic instead of changing list
    #everytime we add an attribute
    table = Table(%w[name size link yeast temperatures])

    # Add each recipe to the Ruport table
    @recipes.each do |recipe|
      table << [recipe.name,
                recipe.size,
                recipe.link,
                recipe.yeast,
                recipe.temperatures.join("\n")] 
    end

    # Write out to HTML file
    File.open("recipes.html", 'w') {|f| f.write(table.to_html(:style => :justified)) }
  end
end
