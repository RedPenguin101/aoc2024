package aoc2024
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Rule :: [2]int
AdjacencyGraph :: map[int][dynamic]int

sort :: proc (graph: ^AdjacencyGraph) -> [dynamic]int {
    topo_order := make([dynamic]int)

    in_degree := make(map[int]int)
    zero_id : [dynamic]int
    defer delete(in_degree)
    defer delete(zero_id)

    for from, tos in graph {
        for to in tos {
            val, ok := &in_degree[to]
            if ok do val^ += 1
            else do in_degree[to] = 1
        }
    }

    for k in graph {
        if k not_in in_degree do append(&zero_id, k)
    }

    for len(zero_id) > 0 {
        node := pop_front(&zero_id)
        append(&topo_order, node)

        if node in graph {
            for neighbour in graph[node] {
                val, ok := &in_degree[neighbour]
                val^ -= 1
                if in_degree[neighbour] == 0 do append(&zero_id, neighbour)
            }
        }
    }
    return topo_order
}

day5 :: proc()  {
    input_filename :: "../../../inputs/day5.txt"
    data, _ := os.read_entire_file(input_filename)
    defer delete(data)
    string_data : = string(data)

    lines := strings.split_lines(string_data)

    part1 := 0
    part2 := 0

    rules : [dynamic]Rule
    inputs : [dynamic]int
    input_set := make(map[int]bool)
    graph : AdjacencyGraph
    order : [dynamic]int
    position := make(map[int]int)

    defer delete(rules)
    defer delete(inputs)
    defer delete(input_set)
    defer delete(graph)
    defer delete(order)
    defer delete(position)

    hit_break := false

    for l in lines {
        if l == "" do hit_break = true
        else if !hit_break {
            x := strings.split(l, "|")
            a, _ := strconv.parse_int(x[0])
            b, _ := strconv.parse_int(x[1])
            append(&rules, Rule{a, b})
        }
        else {
            defer clear(&inputs)
            defer clear(&input_set)
            defer clear(&graph)
            defer clear(&order)
            defer clear(&position)

            x := strings.split(l, ",")
            for n in x {
                a, _ := strconv.parse_int(n)
                append(&inputs, a)
                input_set[a] = true
            }
            for rule in rules {
                if rule[0] in input_set && rule[1] in input_set {
                    val, ok := &graph[rule[0]]
                    if ok do append(val, rule[1])
                    else do graph[rule[0]] = {rule[1]}
                }
            }
            order = sort(&graph)

            center := order[len(order)/2]
            part2 += center

            for n, i in order do position[n] = i

            for i in 0..<len(inputs)-1 {
                if (position[inputs[i]] > position[inputs[i+1]]) do center = 0
            }
            part1 += center
        }
    }
    fmt.println("Part1:", part1)
    fmt.println("Part2:", part2-part1)
    assert(part1 == 5732)
    assert(part2-part1 == 4716)
}
