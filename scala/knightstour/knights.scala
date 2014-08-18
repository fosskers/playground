// The Knight's Tour in Scala - 2014 Mar 03

import scala.util.Random

// Any type whose values can be combined associatively.
trait Semigroup[T] {
  def |+|(v2: => T): T
}
  
trait Monoid[T] extends Semigroup[T] {
  def zero: T
}

case class Pos(val x: Int, val y: Int) extends Monoid[Pos] {
  // Monoid Instance
  def zero: Pos = new Pos(0,0)

  def |+|(p2: => Pos) = {
    val p = p2
    new Pos(x + p.x, y + p.y)
  } // Monoid Instance

  override def toString: String = {
    "(" ++ x.toString ++ "," ++ y.toString ++ ")"
  }
}

object knights extends App {
  type Path = Vector[Pos]

  val dim: Int  = 8
  val r: Random = new Random()

  // IO not being restricted?
  def randPos: Pos = {
    new Pos(r.nextInt(dim), r.nextInt(dim))
  }

  def inBoard(p: Pos): Boolean = {
    Vector(dim > p.x, dim > p.y, p.x >= 0, p.y >= 0).forall(identity)
  }

  def isLegalMove(path: Path, p: Pos): Boolean = {
    inBoard(p) && !path.contains(p)
  }

  val deltas: Vector[Pos] = {
    val ps = Vector((-2,-1),(-2,1),(-1,-2),(-1,2),(1,-2),(1,2),(2,-1),(2,1))
    ps.map{case (x,y) => new Pos(x,y)}
  }

  def movesFrom(p: Pos): Vector[Pos] = {
    deltas.map(_ |+| p)
  }

  def legalMoves(path: Path): Vector[Pos] = path match {
    case (p +: _) => movesFrom(p).filter(isLegalMove(path,_))
  }
  
  def wSort(path: Path): Vector[Pos] = {
    val f = (p: Pos) => legalMoves(p +: path).length

    legalMoves(path).sortWith{ f(_) < f(_) }
  }

  def findPath(path: Path): Option[Path] = path match {
    case path if path.length == dim * dim => Some(path)
    case path => {
      val f = (curr: Option[Path], p: Pos) => curr match {
	case Some(_) => curr
	case None    => findPath(p +: path)
      }

      wSort(path).foldLeft[Option[Path]](None)(f(_,_))
    }
  }

  // Go!
  println("Knight's Tour!")
  val pos = randPos
  println(findPath(Vector(pos)).toString)
}
