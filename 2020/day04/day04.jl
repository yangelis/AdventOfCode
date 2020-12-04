mutable struct Passport
    byr::String
    iyr::String
    eyr::String
    hgt::String
    hcl::String
    ecl::String
    pid::String
    cid::String
    Passport() = new("","","","","","","","")
    Passport(byr,iyr,eyr,hgt,hcl, ecl, pid, cid) =
        new(byr,iyr,eyr,hgt,hcl, ecl, pid, cid)
end

function is_valid(pass::Passport)::Bool
    for i in 1:(length(fieldnames(Passport))-1)
        if isempty(getfield(pass, i))
            return false
        end
    end
    return true
end

function is_valid2(pass::Passport)::Bool
    if !is_valid(pass)
        return false
    end

    # check birth, issue and expiration year
    if !(1920 <= parse(Int64, pass.byr) <= 2002) ||
        !(2010 <= parse(Int64, pass.iyr) <= 2020) ||
        !(2020 <= parse(Int64, pass.eyr) <= 2030)
        return false
    end

    # check height
    units = pass.hgt[end-1:end]
    if units == "cm"
        if !(150 <= parse(Int64, pass.hgt[1:end-2]) <= 193)
           return false
        end
    elseif units == "in"
        if !(59 <= parse(Int64, pass.hgt[1:end-2]) <= 76)
            return false
        end
    else
        return false
    end

    # check hair color
    if pass.hcl[1] != '#' || length(pass.hcl) != 7
        return false
    end

    for h in pass.hcl[2:end]
        if !('0' <= h <= '9') && !('a' <= h <= 'f')
            return false
        end
    end

    # check eye color
    avail_color = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    if !(pass.ecl in avail_color)
        return false
    end

    # check passport ID
    if length(pass.pid) != 9 || !any(isdigit, pass.pid)
       return false
    end

    return true
end

function main(filename::String)
    lines = ""
    for l in eachline(filename, keep=true)
        lines *= l
    end

    lines = replace(replace(replace(lines,"\n\n"=>"+"), "\n"=>" "), "+"=>'\n')

    lines = split(lines, '\n')

    passports = Vector{Passport}(undef, length(lines))
    for (i, line) in enumerate(lines)
        part_line = split(line, ' ')

        temp_pass = Passport()
        for part in part_line
            if findfirst("byr", part) !== nothing
                temp_pass.byr = String(part[5:end])
            elseif findfirst("iyr", part) !== nothing
                temp_pass.iyr = String(part[5:end])
            elseif findfirst("eyr", part) !== nothing
                temp_pass.eyr = String(part[5:end])
            elseif findfirst("hgt", part) !== nothing
                temp_pass.hgt = String(part[5:end])
            elseif findfirst("hcl", part) !== nothing
                temp_pass.hcl = String(part[5:end])
            elseif findfirst("ecl", part) !== nothing
                temp_pass.ecl = String(part[5:end])
            elseif findfirst("pid", part) !== nothing
                temp_pass.pid = String(part[5:end])
            elseif findfirst("cid", part) !== nothing
                temp_pass.cid = String(part[5:end])
            end
        end

        passports[i] = temp_pass
    end


    println("Part1: ", length(filter(is_valid, passports)))
    println("Part2: ", length(filter(is_valid2, passports)))

end
