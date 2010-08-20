require 'log4r'

=begin
Order of smallest possible part
=end
class SandwichOrder

  class SandwichOrderError < RuntimeError; end
  
  Varieties = [
      "Turkey&Ham", "Italian B.M.T", 
      "Turkey, Ham&Beef",  "Beef", "Veggie Delite", 
      "Turkey", "Tuna", "Ham" ]

  attr_reader :variety
  attr_reader :owner
  
  def initialize(variety, owner)
    raise SandwichOrderError, "Not a valid variety" unless Varieties.include?(variety)
    @variety = variety
    @owner = owner
  end
    
end
