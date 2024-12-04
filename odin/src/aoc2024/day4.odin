package aoc2024
import "core:fmt"
import "core:os"
import "core:strings"


day4 :: proc()  {
    input_filename :: "../../../inputs/day4.txt"
    data, _ := os.read_entire_file(input_filename)
    defer delete(data)
    string_data : = string(data)

    lines := strings.split_lines(string_data)
    cols := len(lines[0])
    rows := len(lines)-1
    rotated := make([]string, cols)
    defer delete(rotated)
    r_row : []u8
    for c in 0..<cols {
        r_row = make([]u8, rows)
        for r in 0..<rows {
            r_row[r] = lines[r][c]
        }
        rotated[c] = string(r_row)
    }

    in_col_bounds:bool
    in_row_bounds:bool

    part1 := 0
    part2 := 0
    for r in 0..<rows {
        for c in 0..<cols {
            in_col_bounds = c < (cols - 3)
            in_row_bounds = r < (rows - 3)
            if in_col_bounds && (lines[r][c:c+4] == "XMAS" || lines[r][c:c+4] == "SAMX") do part1 += 1
            if in_row_bounds && (rotated[c][r:r+4] == "XMAS" || rotated[c][r:r+4] == "SAMX") do part1 += 1
            if in_row_bounds && in_col_bounds &&
                (lines[r][c]     == 'X' &&
                 lines[r+1][c+1] == 'M' &&
                 lines[r+2][c+2] == 'A' &&
                 lines[r+3][c+3] == 'S' ||
                 lines[r][c]     == 'S' &&
                 lines[r+1][c+1] == 'A' &&
                 lines[r+2][c+2] == 'M' &&
                 lines[r+3][c+3] == 'X') { part1 += 1 }
            if in_col_bounds && r >= 3 &&
                (lines[r][c]     == 'X' &&
                 lines[r-1][c+1] == 'M' &&
                 lines[r-2][c+2] == 'A' &&
                 lines[r-3][c+3] == 'S' ||
                 lines[r][c]     == 'S' &&
                 lines[r-1][c+1] == 'A' &&
                 lines[r-2][c+2] == 'M' &&
                 lines[r-3][c+3] == 'X') { part1 += 1 }

            if (c > 0 && c < cols-1 && r > 0 && r < rows-1 &&
                lines[r][c] == 'A' &&
                (lines[r-1][c-1] == 'S' && lines[r+1][c+1] == 'M' ||
                 lines[r-1][c-1] == 'M' && lines[r+1][c+1] == 'S') &&
                (lines[r-1][c+1] == 'S' && lines[r+1][c-1] == 'M' ||
                 lines[r-1][c+1] == 'M' && lines[r+1][c-1] == 'S')) {
                part2 += 1
            }
        }
    }
    fmt.println("Part1:" , part1)
    fmt.println("Part2:" , part2)
    assert(part1 == 2390)
    assert(part2 == 1809)
}
