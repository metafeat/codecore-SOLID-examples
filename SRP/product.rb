require 'awesome_print'
require_relative 'product_importer'
class Product
  attr_accessor :name, :description, :cost, :inventory

  def self.all
    @all ||= []
  end

  def initialize(args)
    @name = args[:name]
    @description = args[:description]
    @cost = args[:cost]
    @inventory = args[:inventory] || 0
  end

  def create
    Product.all << self
  end

  def price
    cost * 2
  end

  def order(qty)
    if inventory >= qty
      inventory -= qty
      true
    else
      false
    end
  end

  def resupply(qty)
    inventory += qty
  end

  def header
    <<-eos.gsub(/^ {6}/, '')
      <div class="product-header">
        <h1>#{@name}</h1>
        <p>#{@description}<p>
      </div>
    eos
  end
end


if __FILE__ == $0
  importer = ProductImporter.new <<-eos.gsub(/^ {4}/, '')
    mop, a tool for cleaning, 4.00, 100
    shiny tool, a tool for playing, 2.00, 200
  eos

  importer.import

  wonky_importer = WonkyOrderProductImporter.new <<-eos.gsub(/^ {4}/, '')
    Acme, B104, a tool for cleaning, 3.00, broom, 100
    ToysCo, T90, a fun toy for playing, 1.00, fun toy, 100
  eos

  wonky_importer.import

  xml_importer = XMLProductImporter.new <<-eos.gsub(/^ {4}/, '')
    meat, <desc>a product for eating</desc>, 1.00, 100
    ball, <desc>a thing for bouncing</desc>, 0.5, 200
  eos

  xml_importer.import



  puts "All Products:"
  ap Product.all

  puts "Product Header of first Product:"
  puts Product.all.first.header
end
