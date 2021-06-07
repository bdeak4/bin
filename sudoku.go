package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	table := generate()
	printTable(table)
}

func generate() [][]int {
	var table [][]int
	firstRow := shuffleRow([]int{1, 2, 3, 4, 5, 6, 7, 8, 9})

	for i := 0; i < 9; i++ {
		if i == 0 {
			table = append(table, firstRow)
			continue
		}

		if i%3 == 0 {
			shiftedRow := shiftBlock(table[i-3])
			table = append(table, shiftedRow)
			continue
		}

		shiftedRow := shiftRow(table[i-1])
		table = append(table, shiftedRow)
	}

	return table
}

func shuffleRow(row []int) []int {
	rand.Seed(time.Now().UnixNano())
	for i := len(row) - 1; i > 0; i-- {
		j := rand.Intn(i + 1)
		row[i], row[j] = row[j], row[i]
	}
	return row
}

// input:  [1, 2, 3, 4, 5, 6, 7, 8, 9]
// output: [4, 5, 6, 7, 8, 9, 1, 2, 3]
func shiftRow(row []int) []int {
	return append(row[3:], row[:3]...)
}

// input:  [1, 2, 3, 4, 5, 6, 7, 8, 9]
// output: [2, 3, 1, 5, 6, 4, 8, 9, 7]
func shiftBlock(row []int) []int {
	shiftedRow := make([]int, 9)
	for i, v := range row {
		if i%3 == 0 {
			shiftedRow[i+2] = v
			continue
		}
		shiftedRow[i-1] = v
	}
	return shiftedRow
}

func printTable(table [][]int) {
	for i, row := range table {
		if i > 0 && i%3 == 0 {
			fmt.Println("-----------|-----------|-----------")
		}

		for j, cell := range row {
			if j > 0 && j%3 == 0 {
				fmt.Print("  |")
			}
			fmt.Printf("  %d", cell)
		}
		fmt.Print("\n")
	}
}
