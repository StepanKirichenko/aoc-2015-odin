package main

import "core:fmt"
import "core:os"

main :: proc() {
	filename := "day01/input.txt"
	data, ok := os.read_entire_file_from_filename(filename)
	if !ok {
		fmt.eprintf("Couldn't read file \"%v\"\n", filename)
		os.exit(1)
	}
	defer delete(data)

	floor := 0
	first_basement_char := 0
	for c, i in data {
		switch c {
		case '(':
			floor += 1
		case ')':
			floor -= 1
		}

		if floor < 0 && first_basement_char == 0 {
			first_basement_char = i + 1
		}
	}

	fmt.printf("Part 1: %v\n", floor)
	fmt.printf("Part 2: %v\n", first_basement_char)
}
