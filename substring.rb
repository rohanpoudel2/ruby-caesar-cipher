def substring (text, hash)
  result = Hash.new(0)

  hash.each do |item|
    length = text.scan(item).length
    unless length == 0
      result["#{item}"] = length
    end
  end
  return result
end

p substring("Howdy partner, sit down! How's it going?", ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"])
