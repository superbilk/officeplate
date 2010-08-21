require 'log4r'

=begin
Order of smallest possible part
=end
class SandwichPiece

  class SandwichPieceError < RuntimeError; end
  
  Varieties = [
      "Turkey&Ham", "Italian B.M.T",    "Ham&Beef",  
      "Beef",       "Veggie Delite",    "Turkey",
      "Tuna",       "Ham" ]

  attr_reader :variety
  attr_reader :owner
  
  def initialize(variety, owner)
    raise SandwichPieceError, "Not a valid variety" unless Varieties.include?(variety)
    @variety = variety
    @owner = owner
  end
    
end
