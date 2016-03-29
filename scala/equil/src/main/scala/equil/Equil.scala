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

  /** One-iteration
    * Naively tries to minimize the distance between each sum at each
    * step.
    */
  def oneIter(xs: Array[Int]): Option[Int] = {
    def go(lIx: Int, rIx: Int, lSum: Int, rSum: Int): Option[Int] = xs match {
      case _ if lIx == rIx && lSum == rSum => Some(lIx)
      case _ if lIx >= rIx => None
      case _ => {
        val nextLSum = lSum + xs(lIx + 1)
        val nextRSum = rSum + xs(rIx - 1)

        /* Recurse on whichever side minimizes the sum difference */
        if((nextLSum - rSum).abs < (lSum - nextRSum).abs) {
          go(lIx + 1, rIx, nextLSum, rSum)
        } else {
          go(lIx, rIx - 1, lSum, nextRSum)
        }
      }
    }

    xs match {
      case Array() => None
      case _ => go(0, xs.length - 1, xs(0), xs(xs.length - 1))
    }
  }
}
