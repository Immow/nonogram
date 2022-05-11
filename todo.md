- Hint button (limited use).
- More menu's
- Editor to make puzzles?
- Credits screen?
- Puzzle generator
- Pause button?

- Puzzle generator rules (make it possible for humans to solve)
	- Large numbers, the number is greater than half the row or column length
	- Combined numbers (chunks) plus empty space result in finding valid results
	- At least 1 number per column or row
	- Check the density of numbers, if there are not enough numbers we can't solve the problem

Preventing deselection of marked cells when you start dragging, this can be done by checking if the cell you start from is marked or not.

- Nonogram Solver
	- Display remaing moves (it will keep trying until fails to mark a cell).
	- We can generate chunk lengths and use that to mark cells.
	- We can detect if a chunks fits withing it's borders and do that from both directions marking the cells
	- Mark chunk borders
	- The left and top have the same amount of numbers, each row and column has to have one number at least.
	