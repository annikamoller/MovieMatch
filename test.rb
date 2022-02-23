#Hi

#["hej", -1, 1, 2, 3, 1, 3, 1]

#{"hej" => 1, 1 => 3, 2 => 1}

def tally(arr)
    count = Hash.new(0)
    for item in arr
        count[item] += 1
    end
end

count.each do |key, value|
    if value >= 2
        return "Its a match: #{key}"
    end
end