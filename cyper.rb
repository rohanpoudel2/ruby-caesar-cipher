def caesar_cipher(name, shift)
  ascii = name.bytes
  new_name = ascii.map do |character|
    case character
    when "z".ord, "Z".ord
      base = character == "z".ord ? "a".ord : "A".ord
      base + (shift - 1)
    else
      character + shift
    end
  end
  return new_name.map {|character| character.chr}.join
end

p caesar_cipher("Rohan", 5);
