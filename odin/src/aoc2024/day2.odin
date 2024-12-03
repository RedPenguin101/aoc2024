package aoc2024
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

acceptable_part1 :: proc(numbers : []int) -> int {
    increasing := (numbers[1] > numbers[0])
    count := len(numbers)
    delta:int
    for i in 1..<count {
        delta = numbers[i] - numbers[i-1]
        if increasing && delta < 0 || !increasing && delta > 0 ||
           abs(delta) < 1 || abs(delta) > 3 {
            return 0
        }
    }
    return 1
}

acceptable_part2 :: proc(numbers:[]int, skip:int) -> int {
    comparison := numbers[1] if skip == 0 else numbers[0]
    first_check := 2 if skip < 2 else 1
    current := numbers[first_check]
    increasing := current > comparison
    delta:int

    for i in first_check..<len(numbers) {
        if i == skip do continue
        current = numbers[i]
        delta = current - comparison
        if increasing && delta < 0 || !increasing && delta > 0  ||
           abs(delta) < 1 || abs(delta) > 3 {
            if (skip < len(numbers)-1) {
                return acceptable_part2(numbers, skip+1)
            } else {
                return 0
            }
        }
        comparison = current
    }
    return 1
}

day2 :: proc() {
    input_filename :: "../../../inputs/day2.txt"
    data, ok := os.read_entire_file(input_filename)
    defer delete(data)
    string_data : = string(data)

    acceptable := 0
    part1 := 0
    part2 := 0
    numbers:[10]int
    c_numbers:int

    for line in strings.split_lines_iterator(&string_data) {
        s, _ := strings.fields(line)
        for n, i in s {
            numbers[i], _ = strconv.parse_int(n)
        }
        acceptable = acceptable_part1(numbers[:len(s)])
        part1 += acceptable
        if (acceptable == 1) {
            part2 += acceptable
        } else {
            part2 += acceptable_part2(numbers[:len(s)], 0)
        }
    }
    fmt.printfln("Part1: %d", part1)
    fmt.printfln("Part2: %d", part2)

    assert(part1 == 442)
    assert(part2 == 493)
}
