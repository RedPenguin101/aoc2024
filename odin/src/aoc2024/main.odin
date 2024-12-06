package aoc2024
import "core:fmt"
import "core:time"

main :: proc() {
    t_start := time.now()
    fmt.println("Day 1:")
    day1()
    fmt.println("Day 2:")
    day2()
    fmt.println("Day 3:")
    day3()
    fmt.println("Day 4:")
    day4()
    fmt.println("Day 5:")
    day5()
    fmt.println("Day 6:")
    day6()
    t_dur := time.diff(t_start, time.now())
    fmt.println("Time:", t_dur)
}
