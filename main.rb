MAX_WEIGHT = 8;

#Algorithm to compar the each query with all pages and return a hash of the ranking strength
def search_strength_algo(pages, query)
  result = {}
  pages.each_with_index do |page, index|
    page_strength = 0
    page.keywords.each_with_index do |keyword, keyindex|
      query.keywords.each_with_index do |queryword, queryindex|
        if queryword == keyword
          match_value = (MAX_WEIGHT - keyindex) * (MAX_WEIGHT - queryindex)
          page_strength += match_value
        end
      end
      
    end
    result[page.name] = page_strength
  end

  result.select!{|k, v| v != 0 }
  sorted = result.sort_by{|k, v| -v}.to_h
  puts query.name + ": " + sorted.keys.join(" ")

end

# Query class for creating instances of queries
# naming them appropriately in sequential order
class Query
  @@query_list = []
  attr_reader :name, :keywords

  def initialize(name, keywords)
    #naming is done by appending an identifying number after Q
    @name = name + (@@query_list.length + 1).to_s
    @keywords = keywords
    #to include it in a class variable holding all the queries
    @@query_list << self
  end

  def self.all_query
    return @@query_list
  end

end

# Page class for creating instances of pages
# naming them appropriately in sequential order
class Page
  attr_reader :name, :keywords
  @@pages_list = []

  def initialize(name, keywords)
    #naming is done by appending an identifying number after P
    @name = name + (@@pages_list.length + 1).to_s
    @keywords = keywords
    #to include it in a class variable holding all the pages
    @@pages_list << self
  end

  def self.all_pages
    return @@pages_list
  end

end

def readInput(file)
  File.readlines('inputdata.txt').each do |entry|
    line = entry.capitalize
    if line.split[0] == "P"
      new_page = Page.new(line.split[0], line.split[1..line.split.length-1])
    elsif line.split[0] == "Q"
      new_query = Query.new(line.split[0], line.split[1..line.split.length-1])
    else
    end
  end

  Query.all_query.each do |query|
    search_strength_algo(Page.all_pages, query)
  end
end

ARGV.each do |file|
  readInput(file)
end
