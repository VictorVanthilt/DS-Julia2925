file_1 = open("data/2023-06-P1.txt", "r")
data_1 = split.(readlines(file_1))

file_2 = open("data/2023-06-P2.txt", "r")
data_2 = split.(readlines(file_2))

function generate_options(time)
    return [i * (time - i) for i in 1:time]
end

function count_wins(time, record)
    options = generate_options(time)
    return count(>(record), options)
end

function part_1(data)
    answer = 1
    for game in zip(data[1][2:end], data[2][2:end])
        time = parse(Int, game[1])
        record = parse(Int, game[2])
        answer *= count_wins(time, record)
    end
    return answer
end

part_2(data) = part_1(data)

@show part_1(data_1)
@time part_2(data_2)
