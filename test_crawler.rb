require 'capybara/dsl'
require 'capybara/poltergeist'

class TestCrawler
  DEFAULT_URL = 'http://stuerzer.de'

  include Capybara::DSL
  def initialize(url = DEFAULT_URL)
    Capybara.default_driver = :poltergeist
    @url = url
  end

  def scrape
    products = []
    visit @url
    find('a.submenu.first').click

    all('.shortDescription').each do |short_description|
      keys    = short_description.all('strong').map{ |s| s.text.strip.delete(':') }
      val_str = short_description.text

      keys.each{|s| val_str.gsub!(s, '')}
      values  = val_str.split(':').map(&:strip)

      values.slice!(0)
      product = {}
      keys.each_with_index {|key, i| product[key] = values[i] }
      products << product
    end
    products
  end
end

TestCrawler.new.scrape
