require 'mechanize'
require 'ruport'
require 'pry'
load 'recipe.rb'
load 'recipe_book.rb'

def parse_main_text(text)
  
end

def search_text_blobs_for(text, regex)
  results = text.search('//text()').reject{|text_node| text_node.text =~ /javascript/i}
                                   .select{|text_node| text_node.text =~ regex}
  return nil if results.empty?
  results
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

  if (name_node = main_text.at('h1').text.match(/Beer Recipe of the Week:\s*(.*\z)/i))
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

  # Regular expressions are AWESOME
  if (temperature_nodes = search_text_blobs_for(main_text, /(°|\d+[FfCc])/))
    temperatures = temperature_nodes.map{|x| x.text }.join("\n")
  else
    temperatures = nil
  end

  if (fermentation_nodes = search_text_blobs_for(main_text, /ferment.*(week|day)/i))
    fermentation_time = fermentation_nodes.map{|x| x.text }.join("\n")
  else
    fermentation_time = nil
  end

  recipe_book.add(Recipe.new(name, size, link.to_s, yeast, temperatures, fermentation_time))
end

recipe_book.to_html


