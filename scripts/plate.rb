require 'sandwich'

class Plate

  SandwichesPerPlate = 5

  attr_reader :sandwiches
  
  def initialize
    @sandwiches = Array.new  
  end
  
  def buy_piece(variety, who)
    p = self.find_available_by_variety(variety)
    if p
      @sandwiches[p].buy_piece(who)
    elsif @sandwiches.length == SandwichesPerPlate
      return FALSE
    else
      s = Sandwich.new(variety)
      s.buy_piece(who)
      @sandwiches.push s
    end
  end
  
  def find_available_by_variety(variety)
    @sandwiches.rindex { |p| p.piece_available? && p.variety == variety }
  end

  def return_piece(variety, who)
    @sandwiches[@sandwiches.rindex { |p| p.variety == variety && p.pieces.include?(who)}].return_piece(who)
  end
  
end # class Plate
