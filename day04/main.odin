package main

import "core:crypto/hash"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	filename := "day04/input.txt"
	data, ok := os.read_entire_file(filename)
	if !ok {
		fmt.eprintfln("Couldn't read file \"%v\"", filename)
		os.exit(1)
	}
	defer delete(data)

	result1 := solve_for_prefix(data, "00000")
	result2 := solve_for_prefix(data, "000000")

	fmt.printfln("Part 1: %d", result1)
	fmt.printfln("Part 1: %d", result2)
}

solve_for_prefix :: proc(data: []byte, prefix: string) -> int {
	input_builder := strings.builder_make_none()
	defer strings.builder_destroy(&input_builder)

	hex_builder := strings.builder_make_none()
	defer strings.builder_destroy(&hex_builder)

	digest_buffer := make([]byte, hash.DIGEST_SIZES[hash.Algorithm.Insecure_MD5])
	defer delete(digest_buffer)

	for i := 1; true; i += 1 {
		defer strings.builder_reset(&input_builder)
		defer strings.builder_reset(&hex_builder)

		fmt.sbprintf(&input_builder, "%s%d", data, i)
		hash.hash_bytes_to_buffer(.Insecure_MD5, input_builder.buf[:], digest_buffer[:])
        fmt.sbprintf(&hex_builder, "%02x", string(digest_buffer[:]))

		hex_hash := strings.to_string(hex_builder)
		if strings.has_prefix(hex_hash, prefix) {
			return i
		}
	}

	return 0
}
