import trees._

object treeTest extends App {
  println("Testing trees!")
  val fives = tree.balanced(5, "x")
  println("ZERO")
  tree.balanced(0, "x").foreach(println(_))
  println("ONE")
  tree.balanced(1, "x").foreach(println(_))
  println("TWO")
  tree.balanced(2, "x").foreach(println(_))
  println("THREE")
  tree.balanced(3, "x").foreach(println(_))

  println(fives.map(_.isSymmetric))
  println(tree.balanced(6, 1).map(_.isSymmetric))
  
  println("\nfromList")
  println(tree.fromList(List(3,2,5,7,1)))
  println(tree.fromList(List(5, 3, 18, 1, 4, 12, 21)).isSymmetric)
  println(tree.fromList(List(3, 2, 5, 7, 4)).isSymmetric)

  println(Node('x', Node('x'), End).leafCount)
  println(Node('a', Node('b'), Node('c', Node('d'), Node('e'))).leaves)
  println(Node('a', Node('b'), Node('c', Node('d'), Node('e'))).nodes)
  println(fives.head.leafCount)
  println(fives.head.leaves)
}
