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
      keys   = short_description.all('strong').map{ |s| s.text.strip.delete(':') }
      values = short_description.text.split(':').map(&:strip)
      values.slice!(0)
      product = {}
      keys.each_with_index do |key, i|
        product[key] = values[i]
      end
      products << product
    end
    products
  end
end

TestCrawler.new.scrape
