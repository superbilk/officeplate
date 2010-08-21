require 'test/unit'
require 'Plate'
require 'yaml'

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
      }, p.summary
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
      }, p.summary
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
      }, p.summary
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
      }, p.summary
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
      }, p.summary
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
      }, p.summary
    )

  end

  def test_2
    p = Plate.new
  
    3.times { p.buy_piece "Beef", "Klaus" }
    assert_equal(
      { "Beef" => { 
                'full' => 1, 
                'parts' => 0, 
                'orderer' => { 'Klaus' => 3}
          },
      }, p.summary
    )
  
    3.times { p.buy_piece "Ham", "Peter" }
    assert_equal(
      { "Beef" => { 
                'full' => 1, 
                'parts' => 0, 
                'orderer' => { 'Klaus' => 3}
          },
        "Ham" => { 
                'full' => 1, 
                'parts' => 0, 
                'orderer' => { 'Peter' => 3}
          }
      }, p.summary
    )
  
    3.times { p.buy_piece "Beef", "Dieter" }
    assert_equal(
      { "Beef" => { 
                'full' => 2, 
                'parts' => 0, 
                'orderer' => { 'Dieter' => 3, 'Klaus' => 3}
          },
        "Ham" => { 
                'full' => 1, 
                'parts' => 0, 
                'orderer' => { 'Peter' => 3}
          }
      }, p.summary
    )

    3.times { p.return_piece "Ham", "Peter" }
    assert_equal(
      { "Beef" => { 
                'full' => 2, 
                'parts' => 0, 
                'orderer' => { 'Dieter' => 3, 'Klaus' => 3}
          }
      }, p.summary
    )
  
    2.times { p.return_piece "Beef", "Klaus" }
    2.times { p.return_piece "Beef", "Dieter" }
    assert_equal(
      { "Beef" => { 
                'full' => 0, 
                'parts' => 2, 
                'orderer' => { 'Dieter' => 1, 'Klaus' => 1}
          }
      }, p.summary
    )
  
  end

  def test_no_availability
    p = Plate.new
    15.times { p.buy_piece "Beef", "Klaus" }
    assert_equal( {} , p.available_varieties)
  end
  
#  def test_all_varieties_available
#    10.times { p.buy_piece "Beef", "Klaus" }
#    assert_equal( {} , p.available_varieties)
#  end
#  

def testing
  p = Plate.new
  5.times { p.buy_piece "Beef", "Klaus" }
  p.available_varieties
end
  
# Order{ "Beef" => 3, "Ham" => 2}


end
