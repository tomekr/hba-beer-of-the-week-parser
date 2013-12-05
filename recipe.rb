require 'ruport'
class Recipe
  attr_reader :name, :size, :link, :yeast, :temperatures
  def initialize(name, size, link, yeast, temperatures)
    @name = name
    @size = size
    @link = link
    @yeast = yeast
    @temperatures = temperatures

    #TODO 
    #@grains = grains
    #@hops = hops
    #@gravity = gravity
  end

  def to_hash
    {
      name: @name,
      size: @size,
      link: @link,
      yeast: @yeast,
      temperatures: @temperatures
    }
  end

  def to_html
    #TODO
  end
end
