package trees

sealed abstract class Tree[+T] {
  def weight: Int
  def flip: Tree[T]
  def isMirrorOf[T](t: Tree[T]): Boolean
  def isSymmetric: Boolean
  def add[U >: T <% Ordered[U]](x: U): Tree[U]
  def leafCount: Int
  def nodes: Vector[T]
  def leaves: Vector[T]
}

case class Node[+T](value: T, left: Tree[T], right: Tree[T]) extends Tree[T] {
  override def toString = {
    def work(t: Tree[T], indent: Int): String = t match {
      case End => (1 to indent).map(_ => ' ').mkString ++ ".\n"
      case Node(x, l, r) => {
	work(r, indent + 2) ++
	(1 to indent).map(_ => ' ').mkString ++
	x.toString ++
	"\n" ++
	work(l, indent + 2)
      }
    }
    //"T(" + value.toString + " " + left.toString + " " + right.toString + ")"
    work(this, 0)
  }

  def weight: Int = {
    1 + left.weight + right.weight
  }

  def flip: Tree[T] = {
    Node(value, right.flip, left.flip)
  }

  def isMirrorOf[U](t: Tree[U]): Boolean = (t,left,right) match {
    case (End,_,_) => false
    case (Node(_,End,End),End,End) => true
    case (Node(_, l, r),_,_) => left.isMirrorOf(r) && right.isMirrorOf(l)
  }

  def isSymmetric: Boolean = {
    left.isMirrorOf(right)
  }

  def add[U >: T <% Ordered[U]](x: U): Tree[U] = x match {
    case x if x < value => Node(value, left.add(x), right)
    case _ => Node(value, left, right.add(x))
  }

  def leafCount: Int = (left,right) match {
    case (End,End) => 1
    case _         => left.leafCount + right.leafCount
  }

  def nodes: Vector[T] = (left,right) match {
    case (End,End) => Vector()
    case _ => value +: (left.nodes ++ right.nodes)
  }

  def leaves: Vector[T] = (left,right) match {
    case (End,End) => Vector(value)
    case _ => left.leaves ++ right.leaves
  }
}

case object End extends Tree[Nothing] {
  override def toString = "."

  def weight: Int = 0

  def flip: Tree[Nothing] = End

  def isMirrorOf[U](t: Tree[U]): Boolean = t match {
    case End => true
    case _   => false
  }

  def isSymmetric: Boolean = true

  def add[U <% Ordered[U]](x: U): Tree[U] = Node(x, End, End)

  def leafCount: Int = 0

  def nodes: Vector[Nothing] = Vector()

  def leaves: Vector[Nothing] = Vector()
}

object Node {
  def apply[T](value: T): Node[T] = Node(value, End, End)
}

object tree {
  def empty[A]: Tree[A] = End

  def single[A](x: A): Tree[A] = Node(x, End, End)

  /*
   * Generates all possible balanced trees of a given size.
   * A size `n` tree is based on trees of smaller `n`, depending on whether
   * `n` is even or odd.
   */
  def balanced[A](n: Int, x: A): Vector[Tree[A]] = n match {
    case n if n < 1 => Vector(empty)
    case n if n % 2 == 0 => {
      val lesserSubs  = balanced((n-1)/2, x)
      val greaterSubs = balanced((n-1)/2 + 1, x)
      lesserSubs.flatMap(l => greaterSubs.flatMap(g =>
	Vector(Node(x, l, g), Node(x, g, l))))
    }
    case _ => {
      val subs = balanced(n / 2, x)
      subs.flatMap(l => subs.map(r => Node(x, l, r)))
    }
  }

  def symBalanced[A](n: Int, x: A): Vector[Tree[A]] = {
    balanced(n, x).filter(_.isSymmetric)
  }

  def fromList[A <% Ordered[A]](list: Seq[A]): Tree[A] = {
    list.foldLeft[Tree[A]](End)((acc,x) => acc.add(x))
  }
}
