package aoc2024
import "core:fmt"
import "core:os"
import "core:strings"

day6 :: proc()  {
    Vector2 :: [2]int
    ROT :: matrix[2,2]int{0, -1, 1, 0}

    input_filename :: "../../../inputs/day6.txt"
    data, _ := os.read_entire_file(input_filename)
    defer delete(data)
    string_data : = string(data)
    lines := strings.split_lines(string_data)

    hashes : [130][130]bool
    visited : map[Vector2]struct{}
    defer delete(visited)

    init_position : Vector2
    position      : Vector2
    direction    := Vector2{0, -1}

    for line, y in lines {
        for char, x in line {
            if char == '#' do hashes[x][y] = true
            else if char == '^' do init_position = {x, y}
        }
    }

    in_bounds :: proc (pos:Vector2) -> bool {
        return pos[0] >= 0 && pos[0] < 130 && pos[1] >= 0 && pos[1] < 130
    }

    // part 1
    position = init_position

    for in_bounds(position) {
        visited[position] = {}
        new_pos := position + direction
        for (in_bounds(new_pos) && hashes[new_pos[0]][new_pos[1]]) {
            direction = ROT*direction
            new_pos = position + direction
        }
        position = new_pos
    }

    part1 := len(visited)
    fmt.println("Part1:", part1)
    assert(part1 == 4964)

    // part 2
    part2 := 0

    idx_of :: proc(v:Vector2) -> int {
        if v[0] == 0 {
            if v[1] == -1 do return 0
            if v[1] == 1 do return 2
        }
        if v[0] == 1 do return 1
        if v[0] == -1 do return 3
        return -1
    }

    for new_hash in visited {
        hashes[new_hash[0]][new_hash[1]] = true
        position = init_position
        direction = Vector2{0, -1}
        super_visited : [4][130][130]bool

        for in_bounds(position) {
            super_visited[idx_of(direction)][position[0]][position[1]] = true

            new_pos := position + direction
            for (in_bounds(new_pos) && hashes[new_pos[0]][new_pos[1]]) {
                direction = ROT*direction
                new_pos = position + direction
            }

            position = new_pos

            if in_bounds(position) &&
                super_visited[idx_of(direction)][position[0]][position[1]] {
                    part2 += 1
                    break
                }
        }
        hashes[new_hash[0]][new_hash[1]] = false
    }

    fmt.println("Part2:", part2)
    assert(part2 == 1740)
}
