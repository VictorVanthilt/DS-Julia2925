file = open("data/2023-04-P1.txt", "r")
data_1 = readlines(file)

struct ScratchCard
    id::Int
    winners::Vector{Int}
    numbers::Vector{Int}
end

numbers(sc::ScratchCard) = sc.numbers
winners(sc::ScratchCard) = sc.winners
id(sc::ScratchCard) = sc.id

sc_data = process_input(data_1)

function process_input(data)
    cards = ScratchCard[]
    for line in data
        l = split(line, "|")
        winners = (eachmatch(r"(\d+)", l[1]) |> collect .|> Base.Fix2(getindex, 1) .|> Base.Fix1(parse, Int))[2:end]
        numbers = (eachmatch(r"(\d+)", l[2]) |> collect .|> Base.Fix2(getindex, 1) .|> Base.Fix1(parse, Int))
        id = parse(Int, match(r"(\d+)", l[1])[1])
        push!(cards, ScratchCard(id, winners, numbers))
    end
    return cards
end

function score(sc::ScratchCard)
    wins = 0
    for number in numbers(sc)
        if number in winners(sc)
            wins += 1
        end
    end

    return wins == 0 ? 0 : 2^(wins - 1)
end

function scratchcard_copies(data::Vector{ScratchCard}, sc::ScratchCard)
    wins = 0
    for number in numbers(sc)
        if number in winners(sc)
            wins += 1
        end
    end
    return wins == 0 ? nothing : data[(id(sc) + 1):(id(sc) + wins)]
end

function recurse_scratchcard_wins(data::Vector{ScratchCard})
    cards = copy(data)
    for sc in data
        if scratchcard_copies(sc_data, sc) !== nothing
            cards = vcat(cards, recurse_scratchcard_wins(scratchcard_copies(sc_data, sc)))
        end
    end
    return cards
end

# part 1
sum(score.(sc_data))

# part 2
scratchcard_copies(sc_data, sc_data[7])

length(recurse_scratchcard_wins(sc_data))
