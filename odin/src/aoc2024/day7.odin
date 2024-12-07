package aoc2024
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:math"

day7 :: proc()  {
    p1 :: proc (test_value:int, inputs:[]int, acc:int=0) -> bool {
        if len(inputs)==0 do return test_value == acc
        new_acc1 := acc + inputs[0]
        new_acc2 := inputs[0] if acc==0 else inputs[0]*acc

        return p1(test_value, inputs[1:], new_acc1) ||
            p1(test_value, inputs[1:], new_acc2)
    }

    p2 :: proc (test_value:int, inputs:[]int, acc:int=0) -> bool {
        if acc > test_value || len(inputs)==0 do return test_value == acc
        new_acc1 := acc + inputs[0]
        new_acc2 := inputs[0] if acc==0 else inputs[0]*acc
        digits := math.floor(math.log10(f32(inputs[0]))+1)
        new_acc3 := inputs[0] if acc==0 else int(math.pow10(digits))*acc + inputs[0]

        return p2(test_value, inputs[1:], new_acc1) ||
            p2(test_value, inputs[1:], new_acc2) ||
            p2(test_value, inputs[1:], new_acc3)
    }

    p2_opt :: proc (test_value:int, inputs:[]int) -> bool {
        // https://www.reddit.com/r/adventofcode/comments/1h8l3z5/comment/m0tv6di/

        // The key realization is to work through the list of numbers
        // in reverse, and checking whether each operator can possibly
        // yield the test value with the last number in the list, n and
        // some unknown precursor value.

        // If an operation can return the test value, we recursively
        // do the same check, swapping out test_value for the precursor
        // value, and removing n from the list of numbers.

        if len(inputs)==1 do return test_value == inputs[0]
        head := inputs[:len(inputs)-1]
        n := inputs[len(inputs)-1]

        // multiplication can only return test_value if it is divisible by n
        // Then check the rest of the values against the quotient
        r := test_value %% n
        q := test_value / n
        if r == 0 && p2_opt(q, head) do return true

        // concatenation can only return test_value if the last digits
        // of the test value are equal to n.
        // Then strip off the digits of n and check that against the rest.
        digits := math.floor(math.log10(f32(n))+1)
        if math.pow(f32((test_value - n)%10), digits) == 0 &&
            p2_opt(test_value/int(math.pow10(digits)), head) {
                return true
            }

        // There are no restrictions on addition, so that ends up
        // being a fallback case.
        return p2_opt(test_value-n, head)
    }

    input_filename :: "../../../inputs/day7.txt"
    data, _ := os.read_entire_file(input_filename)
    defer delete(data)
    string_data : = string(data)
    lines := strings.split_lines(string_data)

    result:int
    v_buff:[15]int
    values:[]int
    c_values:int

    part1 := 0
    part2 := 0

    for line in lines {
        s, _ := strings.fields(line)
        if len(s) == 0 do continue
        result, _ = strconv.parse_int(s[0])
        for i in 1..<len(s) {
            x, _ := strconv.parse_int(s[i])
            v_buff[i-1] = x
        }
        values = v_buff[:len(s)-1]
        if p1(result, values) {
            part1 += result
            part2 += result
        } else {
            if p2_opt(result, values) do part2 += result
        }
    }
    fmt.println("Part1:", part1)
    fmt.println("Part2:", part2)
    assert(part1==1620690235709)
    assert(part2==145397611075341)
}
