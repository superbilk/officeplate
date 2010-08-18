require 'plate'

p = Plate.new

3.times { p.buy_piece "Beef", "Klaus" }
9.times { p.buy_piece "Ham", "Klaus" }
3.times { p.buy_piece "Beef", "Peter" }



1.times { p.return_piece "Beef", "Klaus" }
#2.times { p.return_piece "Beef", "Peter" }
#2.times { p.return_piece "Ham", "Klaus" }


p.sandwiches.each do |x| puts x.variety + ": " + x.pieces.inspect + "\n" end
