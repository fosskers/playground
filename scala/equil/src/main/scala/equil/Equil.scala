/**
 * Equil.scala
 *
 * Functions to find the first equilibrium point of a list of Ints, if
 * there is one.
 *
 * An equilibrium point is defined as the index where the sum of all
 * elements to its left and right are equal.
 */

package equil

object Equil {

  /** Two-iteration solution */
  def equilibriumIx(xs: Stream[Int]): Option[Int] = {
    val rights: Stream[Int] = xs.foldRight(Stream[Int]()) {
      case (x, Stream()) => Stream(x)
      case (x, acc) => (x + acc.head) +: acc
    }

    /* Slightly janky folding */
    xs.zipWithIndex.foldLeft((0, None): (Int, Option[Int]))({
      case ((t, Some(i)), _) => (t, Some(i))
      case ((t, _), (n, i)) if t + n == rights(i) => (t + n, Some(i))
      case ((t, _), (n, _)) => (t + n, None)
    })._2
  }

  /** One-iteration */
  def oneIter(xs: Array[Int]): Option[Int] = {
    def work(lIx: Int, rIx: Int, leftSum: Int, rightSum: Int): Option[Int] = xs match {
      case _ if lIx > rIx => None
      case _ if lIx == rIx && leftSum == rightSum => Some(lIx)
      case _ if leftSum < rightSum => work(lIx + 1, rIx, leftSum + xs(lIx + 1), rightSum)
      case _ => work(lIx, rIx - 1, leftSum, rightSum + xs(rIx - 1))
    }

    xs match {
      case Array() => None
      case _ => work(0, xs.length - 1, xs(0), xs(xs.length - 1))
    }
  }
}
