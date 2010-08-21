require 'test/unit'
require 'Plate'


class SandwichPieceTest < Test::Unit::TestCase
  def test_buy_ok
    SandwichPiece::Varieties.each{|var|
      p = nil #keep var from block
      owner = var.succ * 2  #just a nonsense string
      assert_nothing_raised{ p = SandwichPiece.new(var, owner) }
      assert_equal(var, p.variety)
      assert_equal(owner, p.owner)
    }
  end
  
  def test_buy_error
    assert_raise(SandwichPiece::SandwichPieceError){ 
      SandwichPiece.new('Veggie-Beef', 'Klaus') 
    }
  end
  
end #class SandwichPieceTest < Test::Unit::TestCase



class PlateTest < Test::Unit::TestCase
  
  def test_buy
    p = Plate.new
    assert_equal(0, p.orders.size)
    assert_equal(true, p.buy_piece("Beef", "Klaus"))
    assert_equal(1, p.orders.size)
    assert_equal(false, p.buy_piece("Veggie-Beef", "Klaus"))
    assert_equal(1, p.orders.size)
  end

  def test_return
    p = Plate.new
    assert_equal(true, p.buy_piece("Beef", "Klaus"))
    assert_equal(1, p.orders.size)

    assert_equal(false, p.return_piece("Beef", "Werner"))
    assert_equal(1, p.orders.size)

    assert_equal(true, p.return_piece("Beef", "Klaus"))
    assert_equal(0, p.orders.size)

    assert_equal(false, p.return_piece("Beef", "Klaus"))
  end

  def test_1
    p = Plate.new

    3.times { p.buy_piece "Beef", "Klaus" }
    assert_equal(
      { "Beef" => { 
                'full' => 1, 
                'parts' => 0, 
                'orderer' => { 'Klaus' => 3}
          },
      }, p.order
    )
    
    10.times { p.buy_piece "Ham", "Klaus" }
    assert_equal(
      { "Beef" => { 
                'full' => 1, 
                'parts' => 0, 
                'orderer' => { 'Klaus' => 3}
          },
        "Ham" => { 
                'full' => 3, 
                'parts' => 1, 
                'orderer' => { 'Klaus' => 10}
          },
      }, p.order
    )
    
    3.times { p.buy_piece "Beef", "Peter" }
    assert_equal(
      { "Beef" => { 
                'full' => 2, 
                'parts' => 0, 
                'orderer' => { 'Klaus' => 3, 'Peter' => 3}
          },
        "Ham" => { 
                'full' => 3, 
                'parts' => 1, 
                'orderer' => { 'Klaus' => 10}
          },
      }, p.order
    )


    1.times { p.return_piece "Beef", "Klaus" }
    assert_equal(
      { "Beef" => { 
                'full' => 1, 
                'parts' => 2, 
                'orderer' => { 'Klaus' => 2, 'Peter' => 3}
          },
        "Ham" => { 
                'full' => 3, 
                'parts' => 1, 
                'orderer' => { 'Klaus' => 10}
          },
      }, p.order
    )
    
    2.times { p.return_piece "Beef", "Peter" }
    assert_equal(
      { "Beef" => { 
                'full' => 1, 
                'parts' => 0, 
                'orderer' => { 'Klaus' => 2, 'Peter' => 1}
          },
        "Ham" => { 
                'full' => 3, 
                'parts' => 1, 
                'orderer' => { 'Klaus' => 10}
          },
      }, p.order
    )
    
    2.times { p.return_piece "Ham", "Klaus" }
    assert_equal(
      { "Beef" => { 
                'full' => 1, 
                'parts' => 0, 
                'orderer' => { 'Klaus' => 2, 'Peter' => 1}
          },
        "Ham" => { 
                'full' => 2, 
                'parts' => 2, 
                'orderer' => { 'Klaus' => 8}
          },
      }, p.order
    )

  end
end
