package main

import "core:fmt"
import "core:os"

Pos :: [2]int

Direction :: enum {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

char_to_dir := map[byte]Direction {
    '^' = .UP,
    'v' = .DOWN,
    '<' = .LEFT,
    '>' = .RIGHT,
}

dir_to_pos := [Direction]Pos {
	.UP    = {0, 1},
	.DOWN  = {0, -1},
	.LEFT  = {-1, 0},
	.RIGHT = {1, 0},
}

main :: proc() {
	filename := "day03/input.txt"
	data, ok := os.read_entire_file(filename)
	if !ok {
		fmt.eprintf("Couldn't read file %v\n", filename)
		os.exit(1)
	}
	defer delete(data)

	{
        // Part one
		visited := make(map[Pos]int)
        defer delete(visited)
		unique_count := 1

		current_pos := Pos{0, 0}
		visited[current_pos] = 1

		for c in data {
			dir, valid := char_to_dir[c]
			if !valid do continue
			move := dir_to_pos[dir]
			current_pos += move

			count := visited[current_pos]
			if count == 0 do unique_count += 1
			visited[current_pos] = count + 1
		}

		fmt.printf("Part 1: %v\n", unique_count)
	}

    {
        // Part two
		visited := make(map[Pos]int)
        defer delete(visited)
		unique_count := 1

		current_santa_pos := Pos{0, 0}
		current_robot_pos := Pos{0, 0}
		visited[Pos{0, 0}] = 1

		for c, i in data {
			dir, valid := char_to_dir[c]
			if !valid do continue
			move := dir_to_pos[dir]

			current_pos: Pos
            if i % 2 == 0 {
                current_santa_pos += move
                current_pos = current_santa_pos
            } else {
                current_robot_pos += move
                current_pos = current_robot_pos
            }

			count := visited[current_pos]
			if count == 0 do unique_count += 1
			visited[current_pos] = count + 1
		}

		fmt.printf("Part 2: %v\n", unique_count)
    }
}
