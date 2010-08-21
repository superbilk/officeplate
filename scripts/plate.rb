require 'log4r'
require 'SandwichPiece'

class Plate

  attr_reader :orders
  
  def initialize(sandwiches_per_plate = 5, pieces_per_sandwich = 3)
    @sandwiches_per_plate = sandwiches_per_plate
    @pieces_per_sandwich = pieces_per_sandwich
    @orders = []
    @log = Log4r::Logger.new('Order')
    #~ @log.outputters << Log4r::StdoutOutputter.new('log_stdout', :level => Log4r::INFO)
  end
  
  def buy_piece(variety, who)
    begin 
      @orders << SandwichPiece.new(variety, who)
      true
    rescue SandwichPiece::SandwichPieceError
      @log.error("Order not existing sandwich #{variety}")
      false
    end
  end
  
  def return_piece(variety, who)
    found = false
    @orders.each { |o|
      if o.variety == variety && o.owner == who
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
    @orders.each{ |o| 
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
    puts order.inspect
    puts result.inspect
    result
  end
end # class Order

