function main(filename::String)
    report = [parse(Int64, i) for i in readlines(filename)]

    for i in 1:length(report), j in length(report):-1:i
        if (report[i] + report[j]) == 2020
            println(report[i], '*', report[j], " = ", report[i] * report[j])
        end
    end

    for i in 1:length(report), j in length(report):-1:i, k in length(report):-1:j
        if (report[i] + report[j] + report[k]) == 2020
            println(report[i], '*', report[j], '*', report[k], " = ", report[i] * report[j] * report[k])
        end
    end
end
