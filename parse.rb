require 'mechanize'
require 'ruport'
load 'recipe.rb'
require 'pry'

def parse_main_text(text)
  
end

agent = Mechanize.new
page = agent.get('http://www.homebrewersassociation.org/sitemap/')

recipe_links = page.links_with(:href => /^http?/).select do |link|
  link.href =~ /recipe-of-the-week/
end

recipes = []

recipe_links[1..10].each do |link|
  page = agent.get(link.href)
  main_text = page.at('div.mainText')


  name = main_text.at('h1').text.match(/Beer Recipe of the Week:\s*(.*\z)/)[1]
  if (size_node = main_text.at("//*[contains(text(),'gal')]"))
    size = size_node.text
  else
    size = nil
  end

  if (yeast_node = main_text.at("//*[contains(text(),'yeast')]"))
    yeast = yeast_node.text
  else
    yeast = nil
  end

  if (temperature_nodes = main_text.search("//*[contains(text(),'°')]"))
    temperatures = main_text.search("//*[contains(text(),'°')]").map{|x| x.text }
  else
    temperatures = nil
  end

  recipes << Recipe.new(name, size, link.to_s, yeast, temperatures)
end
