import arithmetic.S99Int._

import scala.language.implicitConversions

object arithTest extends App {
  def average(ns: Seq[Long]): Double = ns match {
    case Nil => 0
    case _   => ns.sum.toDouble / ns.length
  }
  
  val phis = Vector(1,1,2,2,4,2,6,4,6,4,10,4,12,6,8,8,16,6,18)
  
  println("Testing arithmetic.scala")

  println("Prime Numbers")
  println((0 until 22).map(n => (n,n.isPrime)))

  println("\nGCD")
  println(gcd(14,7) == 7)
  println(gcd(5,5)  == 5)
  println(gcd(10,1) == 1)
  println(gcd(123,456) == 3)

  println("\nCoprime")
  println(35.isCoprimeTo(64))
  println(7.isCoprimeTo(97))

  println("\nTotient Function")
  println(phis)
  println((1 until 20).map(_.phi))
  println((1 until 20).map(_.phi2))
  test(10090)
  // println("-- Over first 10k primes.")
  // val ps = primes.take(10000)
  // println(average(ps.map(n => timeIt{n.phi})))
  // println(average(ps.map(n => timeIt{n.phi2})))
  // println("-- Over first 10k non-primes.")
  // val nps = Stream.from(1).filter(!_.isPrime).take(10000)
  // println(average(nps.map(n => timeIt{n.phi})))
  // println(average(nps.map(n => timeIt{n.phi2})))
  // println("-- Other values")
  // println(average((20000 to 30000).map(n => timeIt{n.phi})))
  // println(average((20000 to 30000).map(n => timeIt{n.phi2})))
  
  println("\nPrime Factors")
  println((1 to 15).map(n => (n,n.primeFactors)))
  println(315.primeFactors)
  println(315.primeFactorsMult)

  println("Goldbach's Conjecture")
  println("28.goldbach: " ++ 28.goldbach.toString)
  (9 to 20).filter(_.isEven).map { n => n.goldbach match {
      case None => n.toString ++ ": No Composition"
      case Some((x,y)) => n.toString ++ " = " ++ x.toString ++ " + " ++ y.toString
    }
  }.foreach(println(_))
}

