using DataStructures
file = open("data/2023-07-P1.txt", "r")
data_1 = split.(readlines(file), " ")

file = open("data/2023-07-EX.txt", "r")
data_ex = split.(readlines(file), " ")

struct Hand
    cards::String
    value::Int
end

data = [Hand(d[1], parse(Int, d[2])) for d in data_1]
data_ex = [Hand(d[1], parse(Int, d[2])) for d in data_ex]

function occurance_map(h::Hand)
    return hcat([[i, count(==(i), h.cards)] for i in unique(h.cards)]...)
end

function Base.isless(h1::Hand, h2::Hand)
    cardstrengthmap = reverse("AKQJT98765432")
    handstrengthmap = reverse([[5], [4, 1], [3, 2], [3, 1, 1], [2, 2, 1], [2, 1, 1, 1], [1, 1, 1, 1, 1]])
    o1 = sort(collect(values(counter(h1.cards))), rev = true)
    o2 = sort(collect(values(counter(h2.cards))), rev = true)

    handstrength_1 = findfirst(==(o1), handstrengthmap)
    handstrength_2 = findfirst(==(o2), handstrengthmap)

    if handstrength_1 < handstrength_2
        return true
    elseif handstrength_1 > handstrength_2
        return false
    else # iterate over hand
        for i in eachindex(h1.cards)
            cardstrength_1 = findfirst(==(h1.cards[i]), cardstrengthmap)
            cardstrength_2 = findfirst(==(h2.cards[i]), cardstrengthmap)
            if cardstrength_1 < cardstrength_2
                return true
            elseif cardstrength_1 > cardstrength_2
                return false
            end
        end
    end
    return @show "equal hands", h1, h2
end

function part_1(data::Vector{Hand})
    count = 0
    sorteddata = sort(data)
    for i in eachindex(sorteddata)
        count += i * sorteddata[i].value
    end
    return count
end

sort(data, rev = true)

part_1(data)
