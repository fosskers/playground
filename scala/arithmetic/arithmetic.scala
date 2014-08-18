package arithmetic

import problems.Lists._

object S99Int {
  implicit class S99Int(val start: Int) {
    def isEven: Boolean = start % 2 == 0

    def isOdd: Boolean = !start.isEven

    def divides(n: Int): Boolean = n % start == 0

    def pow(p: Int): Int = {
      replicate(p, start).product
    }

    def isPrime: Boolean = {
      (start > 1) && primes.takeWhile(_ <= math.sqrt(start)).forall(start % _ != 0)
    }

    def isCoprimeTo(n: Int): Boolean = {
      gcd(start, n) == 1
    }

    def primeFactors: List[Int] = {
      def work(n: Int, ps: Stream[Int]): List[Int] = (n,ps) match {
	case (n,_) if n < 2 => Nil
	case (n, p #:: rest) if p.divides(n) => p :: work(n / p, ps)
	case (n, _ #:: rest) => work(n, rest)
      }

      work(start, primes)
    }

    def primeFactorsMult: List[(Int,Int)] = {
      encode(start.primeFactors)
    }

    /* The Totient Function
     * Interesting discoveries:
     * 1. If x|2 and (x/2)|2, then phi(x) = 2 * phi(x/2)
     * 2. If x|2 but not (x/2)|2, then phi(x) = phi(x/2)
     * 3. If x.isPrime, then phi(x) = x - 1
     * 4. phi(2) == phi(1) == 1
     */
    def phi: Int = start match {
      case start if start.isEven && (start / 2).isEven => 2 * (start / 2).phi
      case start if start.isEven && (start / 2).isOdd  => (start / 2).phi
      case start if start.isPrime => start - 1
      case start => start.phi2
    }

    // phi can also be calculated if just the prime factors are known,
    // but the heuristics added above result in faster execution on average.
    def phi2: Int = {
      start.primeFactorsMult.map(x => (x._1 - 1) * x._1.pow(x._2 - 1)).product
    }

    def goldbach: Option[(Int,Int)] = {
      def work(ps: Stream[Int]): (Int,Int) = ps match {
	case p #:: rest if (start - p).isPrime => (p, start - p)
	case _ #:: rest => work(rest)
      }

      start match {
	case start if start < 4 || start.isOdd => None
	case start => Some(work(primes))
      }
    }
  } // implicit class S99Int

  val primes: Stream[Int] = 2 #:: Stream.from(3,2).filter(_.isPrime)

  def gcd(x: Int, y: Int): Int = (x,y) match {
    case (x,y) if (x < 0 || y < 0)   => gcd(math.abs(x), math.abs(y))
    case (x,y) if (x == 1 || y == 1) => 1
    case (x,y) if (x == y)           => x
    case (x,y) => gcd(math.min(x,y), x - y)
  }

  def primesWithin(n: Int, m: Int): Seq[Int] = {
    (n to m).filter(_.isPrime)
  }

  def time[A](label: String)(block: => A): A = {
    val now = System.currentTimeMillis()
    val ret = block
    println(label + ": " + (System.currentTimeMillis() - now) + " ms.")
    ret
   }

  def timeIt[A](block: => A): Long = {
    val now = System.currentTimeMillis()
    val ret = block
    System.currentTimeMillis() - now
  }

  def test(n: Int) {
    time("Preload primes") {
      primes.takeWhile(_ <= Math.sqrt(n)).force
    }

    time("phi (" + n + ")") {
      n.phi
    }

    time("phi2 (" + n + ")") {
      n.phi2
    }
  }
}
