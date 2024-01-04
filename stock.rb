def stock_picker(prices)
  lowest, lowest_index, profit = prices[0], 0, 0
  result = []

  prices.each_with_index do |price, index|
    if price < lowest
      lowest, lowest_index = price, index
    elsif (diff = price - lowest) > profit
      profit, result = diff, [lowest_index, index]
    end
  end
  result
end

p stock_picker([17,10,6,9,15,8,6,1,10])
