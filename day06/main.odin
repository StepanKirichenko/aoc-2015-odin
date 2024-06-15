package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Action :: enum {
	Toggle,
	TurnOn,
	TurnOff,
}

ROW_LENGTH :: 1000

main :: proc() {
	filename := "day06/input.txt"
	data, ok := os.read_entire_file(filename)
	if !ok {
		fmt.printfln("Couldn't open file \"%s\"", filename)
		os.exit(1)
	}

	lights1 := make([]bool, ROW_LENGTH * ROW_LENGTH)
	defer delete(lights1)

    lights2 := make([]int, ROW_LENGTH * ROW_LENGTH)
    defer delete(lights2)

	lines_iter := string(data)
	for line in strings.split_lines_iterator(&lines_iter) {
		words_iter := line

		action := parse_action(&words_iter)
		from_x, from_y := parse_position(&words_iter)
		skip_word(&words_iter)
		to_x, to_y := parse_position(&words_iter)

		for y := from_y; y <= to_y; y += 1 {
			for x := from_x; x <= to_x; x += 1 {
				i := y * ROW_LENGTH + x
				switch action {
				case .TurnOn:
					lights1[i] = true
                    lights2[i] += 1
				case .TurnOff:
					lights1[i] = false
                    lights2[i] -= 1
                    if lights2[i] < 0 do lights2[i] = 0
				case .Toggle:
					lights1[i] = !lights1[i]
                    lights2[i] += 2
				}
			}
		}
	}

    count1: int
    for light in lights1 {
        if light do count1 += 1
    }

    count2: int
    for light in lights2 {
        count2 += light
    }

    fmt.printfln("Part 1: %d", count1)
    fmt.printfln("Part 2: %d", count2)
}

parse_action :: proc(iter: ^string) -> Action {
	word1, _ := strings.split_iterator(iter, " ")
	if strings.compare(word1, "toggle") == 0 do return .Toggle

	word2, _ := strings.split_iterator(iter, " ")
	if strings.compare(word2, "on") == 0 do return .TurnOn
	if strings.compare(word2, "off") == 0 do return .TurnOff

	fmt.println("Couldn't parse a command")
	os.exit(1)
}


parse_position :: proc(iter: ^string) -> (x, y: int) {
	word, _ := strings.split_iterator(iter, " ")

	x_str, _ := strings.split_iterator(&word, ",")
	y_str := word

	x = strconv.atoi(x_str)
	y = strconv.atoi(y_str)

	return
}

skip_word :: proc(iter: ^string) {
	strings.split_iterator(iter, " ")
}
