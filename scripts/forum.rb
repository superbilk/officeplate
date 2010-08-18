require 'log4r'

=begin
Order of smallest possible part
=end
class SandwichOrder

  class SandwichError < RuntimeError; end
  
  Varieties = [
      "Turkey&Ham", "Italian B.M.T", 
      "Turkey, Ham&Beef",  "Beef", "Veggie Delite", 
      "Turkey", "Tuna", "Ham" ]

  attr_reader :variety
  attr_reader :owner
  
  def initialize(variety, owner)
    raise SandwichError, "Not a valid variety" unless Varieties.include?(variety)
    @variety = variety
    @owner = owner
  end
    
end


class Order

  attr_reader :orders
  
  def initialize( sandwiches_per_plate = 5, pieces_per_sandwich = 3)
    @sandwiches_per_plate = sandwiches_per_plate
    @pieces_per_sandwich = pieces_per_sandwich
    @orders = []
    @log = Log4r::Logger.new('Order')
    #~ @log.outputters << Log4r::StdoutOutputter.new('log_stdout', :level => Log4r::INFO)
  end
  
  def buy_piece(variety, who)
    begin 
      @orders << SandwichOrder.new(variety, who)
      true
    rescue SandwichOrder::SandwichError
      @log.error("Order not existing sandwich #{variety}")
      false
    end
  end
  def return_piece(variety, who)
    
    found = false
    @orders.each{|o|
      if o.variety == variety and o.owner == who
        @orders.delete(o)
        found = true
        break #leave loop
      end
    }
    
    @log.warn("Cancel unordered order %s/%s" % [variety, who ]) unless found
    found #return result
  end
  
  def order()
    order = {}
    @orders.each{|o| 
      order[o.variety] = [] unless order[o.variety]
      order[o.variety] << o.owner
    }
    
    result = {}
    order.each{|var, orders|
      result[var] = {}
      result[var]['full'] = orders.size.div(@pieces_per_sandwich)
      result[var]['parts'] = orders.size.divmod(@pieces_per_sandwich).last
      result[var]['orderer'] = Hash.new(0)
      orders.each{|o|
        result[var]['orderer'][o] += 1
      }
    }
    result
  end
end # class Order

######## Demo #########


require 'test/unit'
class SandwichTest < Test::Unit::TestCase
  def test_buy_ok
    SandwichOrder::Varieties.each{|var|
      p = nil #keep var from block
      owner = var.succ * 2  #just a nonsense string
      assert_nothing_raised{ p = SandwichOrder.new(var, owner) }
      assert_equal(var, p.variety)
      assert_equal(owner, p.owner)
    }
  end
  def test_buy_error
      assert_raise(SandwichOrder::SandwichError){ 
            SandwichOrder.new('Veggie-Beef', 'Klaus') 
          }
  end
end #class SandwichTest < Test::Unit::TestCase
class OrderTest < Test::Unit::TestCase
  
  def test_buy
    p = Order.new
    assert_equal(0, p.orders.size)
    assert_equal(true, p.buy_piece("Beef", "Klaus"))
    assert_equal(1, p.orders.size)
    assert_equal(false, p.buy_piece("Veggie-Beef", "Klaus"))
    assert_equal(1, p.orders.size)
  end

  def test_return
    p = Order.new
    assert_equal(true, p.buy_piece("Beef", "Klaus"))
    assert_equal(1, p.orders.size)
    #-> Warnung
    assert_equal(false, p.return_piece("Beef", "Werner"))
    assert_equal(1, p.orders.size)
    assert_equal(true, p.return_piece("Beef", "Klaus"))
    assert_equal(0, p.orders.size)
    #-> Warnung
    assert_equal(false, p.return_piece("Beef", "Klaus"))
  end

  def test_1
    p = Order.new

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