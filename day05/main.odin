package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
	filename := "day05/input.txt"
	data, ok := os.read_entire_file(filename)
	if !ok {
		fmt.eprintfln("Couldn't read file \"%s\"", filename)
	}
	defer delete(data)

	count1: int
    count2: int
	input_iter := string(data)
	for line in strings.split_lines_iterator(&input_iter) {
		if nice_part_one(line) do count1 += 1
		if nice_part_two(line) do count2 += 1
	}

	fmt.printfln("Part 1: %d", count1)
	fmt.printfln("Part 2: %d", count2)
}

nice_part_one :: proc(str: string) -> bool {
	return has_three_vowels(str) && has_doulbe_letter(str) && !has_forbidden_strings(str)
}

nice_part_two :: proc(str: string) -> bool {
    return has_doulbe_pair(str) && has_repeating_over_one(str)
}

is_vowel :: proc(letter: rune) -> bool {
	switch letter {
	case 'a', 'e', 'i', 'o', 'u':
		return true
	case:
		return false
	}
}

has_three_vowels :: proc(str: string) -> bool {
	count: int
	for letter in str {
		if is_vowel(letter) do count += 1
		if count >= 3 do return true
	}
	return false
}

has_doulbe_letter :: proc(str: string) -> bool {
	for i := 1; i < len(str); i += 1 {
		if str[i] == str[i - 1] do return true
	}
	return false
}

has_forbidden_strings :: proc(str: string) -> bool {
	forbidden :: []string{"ab", "cd", "pq", "xy"}
	for seq in forbidden {
		if strings.contains(str, seq) do return true
	}
	return false
}

has_doulbe_pair :: proc(str: string) -> bool {
	pairs := make(map[string]int)
	defer delete(pairs)

	for i := 2; i <= len(str); i += 1 {
		pair := str[i-2:i]
        prev_i, ok := pairs[pair]
        if ok && prev_i < i - 1 do return true
        if !ok do pairs[pair] = i
	}

    return false
}

has_repeating_over_one :: proc(str: string) -> bool {
    for i := 2; i < len(str); i += 1 {
        if str[i - 2] == str[i] do return true
    }
    return false
}
