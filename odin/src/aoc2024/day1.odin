package aoc2024
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

day1 :: proc()  {
    input_filename :: "../../../inputs/day1.txt"
    data, ok := os.read_entire_file(input_filename)
    defer delete(data)
    string_data : = string(data)

    list1 : [dynamic]int
    list2 : [dynamic]int
    defer delete(list1)
    defer delete(list2)

    rows := 0

    for line in strings.split_lines_iterator(&string_data) {
        nums := strings.fields(line)
        l1, _ := strconv.parse_int(nums[0])
        append(&list1, l1)
        l2, _ := strconv.parse_int(nums[1])
        append(&list2, l2)
        rows += 1
    }

    slice.sort(list1[:])
    slice.sort(list2[:])

    part1: = 0
    for i := 0; i < rows; i+=1 {
       part1 += abs(list1[i] - list2[i])
    }
    fmt.printfln("Part 1: %d", part1)

    part2 := 0
    l2_idx := 0
    l2_count := 0
    for key in list1 {
        for (l2_idx < rows && list2[l2_idx] < key) {
            l2_idx += 1
        }
        for (l2_idx < rows && list2[l2_idx] == key) {
            l2_idx += 1
            l2_count += 1
        }
        part2 += key * l2_count
        l2_count = 0
    }
    fmt.printfln("Part 2: %d", part2)
    assert(part1 == 1651298)
    assert(part2 == 21306195)
}
