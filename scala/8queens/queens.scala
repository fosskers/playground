/* The Eight Queens Problem
 * How can one place eight queens on a chess board such that none are
 * attacking each other?
 *
 * Heuristic: Each queen must be in a different row, and there are eight rows,
 * so all possible placements are just the permutations of 1 to 8 in a Vector,
 * where the element index indicates the column a queen is in.
 * This way, we know rows and columns will be unique, and thus the only
 * source of attack will be on the diagonals.
 *
 * Solution: 92 distinct solutions.
 */
object queens extends App {
  

  /* Two spots on a board are diagonal if they form a line with a 45 degree
   * angle. They do this when their vertical and horizontal lengths are the same.
   */
  def areDiag(a: (Int,Int), b: (Int,Int)): Boolean = {
    math.abs(a._1 - b._1) == math.abs(a._2 - b._2)
  }

  def diagsClear(board: Vector[Int]): Boolean = {
    def work(b: Vector[(Int,Int)]): Boolean = b match {
      case Vector()  => true
      case x +: rest => rest.map(y => !areDiag(x,y)).forall(identity) && work(rest)
    }

    work(board.map(x => (x, board.indexOf(x))))
  }

  println("Generating permutations...")
  val perms = Vector(1,2,3,4,5,6,7,8).permutations

  println("Filtering permutations...")
  println(perms.filter(diagsClear(_)).length)
}
