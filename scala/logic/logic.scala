package logic

object logic {
  implicit class Bool(val b: Boolean) {
    def -->(c: => Boolean): Boolean = (b,c) match {
      case (true,false) => false
      case _ => true
    }

    def <+>(a: => Boolean): Boolean = {
      (a and not(b)) or (b and not(a))
    }

    def <=>(a: => Boolean): Boolean = a == b

    def and(a: => Boolean): Boolean = a && b

    def or(a: => Boolean): Boolean = a || b

    def nand(a: => Boolean): Boolean = !b.and(a)

    def nor(a: => Boolean): Boolean = not(b.and(a))
  }

  def not(a: Boolean): Boolean = !a

  def table2(f: (Boolean,Boolean) => Boolean): String = {
    val bs = Vector((false,false),(false,true),(true,false),(true,true))

    "A     B     result\n" ++
    bs.map { case (a,b) =>
      a.toString.padTo(6," ").mkString ++
      b.toString.padTo(6," ").mkString ++
      f(a,b).toString
    }.mkString("\n")
  }

  val grays: Stream[Vector[String]] = Vector("0","1") #:: Stream.from(1).map(gray(_))

  def gray(n: Int): Vector[String] = {
    val orig    = grays(n-1)
    val flipped = orig.reverse

    orig.map('0' +: _) ++ flipped.map('1' +: _)
  }
}
