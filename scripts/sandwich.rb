class Sandwich

  Pieces = 3

  attr_reader :varieties
  attr_reader :pieces
  attr_reader :variety
  
  def initialize(variety)
    @varieties = ["Turkey&Ham", "Italian B.M.T", "Turkey, Ham&Beef", "Beef", "Veggie Delite", "Turkey", "Tuna", "Ham" ]
    if @varieties.include?(variety)
      @variety = variety
    else
      raise "Not a valid variety"
    end
    @pieces = Array.new
  end
    
  def buy_piece(owner)
    if @pieces.size < Pieces
      @pieces.push(owner)
    else
      return FALSE
    end
  end
  
  def return_piece(owner)
    @pieces.delete_at( @pieces.rindex {|p| p == owner} )
  end
  
  def piece_available?
    @pieces.size < Pieces ? TRUE : FALSE
  end
end
