require 'mechanize'
require 'ruport'
require 'pry'
load 'recipe.rb'
load 'recipe_book.rb'

def parse_main_text(text)
  
end

agent = Mechanize.new
page = agent.get('http://www.homebrewersassociation.org/sitemap/')

recipe_links = page.links_with(:href => /^http?/).select do |link|
  link.href =~ /recipe-of-the-week/
end

recipe_book = RecipeBook.new

recipe_links.each do |link|
  page = agent.get(link.href)
  main_text = page.at('div.mainText')

  if (name_node = main_text.at('h1').text.match(/Beer Recipe of the Week:\s*(.*\z)/))
    name = name_node[1]
  else
    name = nil
  end
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

  recipe_book.add(Recipe.new(name, size, link.to_s, yeast, temperatures))
end

recipe_book.to_html


