file_1 = open("data/2023-02-P1.txt", "r")
data_1 = readlines(file_1)

function part_1(data)
    ids = Int[]
    for (i, game) in enumerate(data)
        gs = Int[]
        rs = Int[]
        bs = Int[]

        game_id = parse(Int, match(r"Game (\d+)", game)[1])

        for m in eachmatch(r"(\d+) green", game)
            push!(gs, parse(Int, m[1]))
        end

        for m in eachmatch(r"(\d+) red", game)
            push!(rs, parse(Int, m[1]))
        end

        for m in eachmatch(r"(\d+) blue", game)
            push!(bs, parse(Int, m[1]))
        end
        if maximum(gs) <= 13 && maximum(rs) <= 12 && maximum(bs) <= 14
            push!(ids, game_id)
        end
    end
    return sum(ids)
end

function part_2(data)
    powers = Int[]
    for (i, game) in enumerate(data)
        gs = Int[]
        rs = Int[]
        bs = Int[]

        game_id = parse(Int, match(r"Game (\d+)", game)[1])

        for m in eachmatch(r"(\d+) green", game)
            push!(gs, parse(Int, m[1]))
        end

        for m in eachmatch(r"(\d+) red", game)
            push!(rs, parse(Int, m[1]))
        end

        for m in eachmatch(r"(\d+) blue", game)
            push!(bs, parse(Int, m[1]))
        end
        push!(powers, maximum(gs) * maximum(rs) * maximum(bs))
    end
    return sum(powers)
end

@show part_1(data_1)
@time part_2(data_1)
