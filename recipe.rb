require 'ruport'
class Recipe
  attr_reader :name, :size, :link, :yeast, :temperatures, :fermentation_time

  def initialize(name, size, link, yeast, temperatures, fermentation_time)
    @name = name
    @size = size
    @link = link
    @yeast = yeast
    @temperatures = temperatures
    @fermentation_time = fermentation_time

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
      fermentation_time: @fermentation_time,
      temperatures: @temperatures
    }
  end

end
