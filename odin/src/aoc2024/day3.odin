package aoc2024
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:math"

parse_next_mul :: proc(s : string) -> int {
    x, x_err := strconv.parse_int(s[:])
    if x_err do return 0
    x_digits := int(math.floor(math.log10(f32(x))+1))
    if s[x_digits] != ',' do return 0

    y, y_err := strconv.parse_int(s[x_digits+1:])
    if y_err do return 0

    y_digits := int(math.floor(math.log10(f32(y))+1))
    if s[x_digits+1+y_digits] != ')' do return 0

    return x*y
}

day3 :: proc()  {
    input_filename :: "../../../inputs/day3.txt"
    data, _ := os.read_entire_file(input_filename)
    defer delete(data)
    string_data : = string(data)

    part1 := 0
    for i in  0..<len(string_data) {
        if strings.starts_with(string_data[i:], "mul(") do part1 += parse_next_mul(string_data[i+4:])
    }

    part2 := 0
    enabled := true
    for i in 0..<len(string_data) {
        if strings.starts_with(string_data[i:], "mul(") && enabled do part2 += parse_next_mul(string_data[i+4:])
        else if strings.starts_with(string_data[i:], "don't") do enabled = false
        else if strings.starts_with(string_data[i:], "do") do enabled = true
    }

    fmt.printfln("Part1: %d",  part1)
    fmt.printfln("Part2: %d",  part2)
    assert(part1 == 156388521)
    assert(part2 == 75920122)
}
