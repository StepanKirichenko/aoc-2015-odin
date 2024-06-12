package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

main :: proc() {
    filename := "day02/input.txt"
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.eprintf("Couldn't open file \"%v\"\n", filename)
        os.exit(1)
    }
    defer delete(data)

    paper_total := 0
    bow_total := 0

    input := string(data)
    for line in strings.split_lines_iterator(&input) {
        box := get_dimensions(line)

        area_a := box.x * box.y
        area_b := box.x * box.z
        area_c := box.z * box.y
        perim_a := 2 * (box.x + box.y)
        perim_b := 2 * (box.x + box.z)
        perim_c := 2 * (box.z + box.y)

        min_area := min(area_a, area_b, area_c)
        min_perim := min(perim_a, perim_b, perim_c)
        volume := box.x * box.y * box.z

        paper_needed := 2 * area_a + 2 * area_b + 2 * area_c + min_area
        bow_needed := min_perim + volume

        paper_total += paper_needed
        bow_total += bow_needed
    }

    fmt.printf("Part 1: %v\n", paper_total)
    fmt.printf("Part 2: %v\n", bow_total)
}

get_dimensions :: proc(box: string) -> [3]int {
    dimensions_strings := strings.split(box, "x")
    if len(dimensions_strings) != 3 {
        fmt.eprintf("Incorrect box format: \"%v\"\n", box)
        os.exit(1)
    }

    dimensions: [3]int
    for i := 0; i < 3; i += 1 {
        conv, ok := strconv.parse_int(dimensions_strings[i])
        if !ok {
            fmt.eprintf("Incorrect number format: \"%v\"\n", dimensions_strings[i])
            os.exit(1)
        }
        dimensions[i] = conv
    }

    return dimensions
}
