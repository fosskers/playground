package problems

import scala.util.Random

object Lists {
  def last[A](list: List[A]): Option[A] = list match {
    case Nil      => None
    case x :: Nil => Some(x)
    case _ :: xs  => last(xs)
  }

  def penultimate[A](list: List[A]): Option[A] = list match {
    case Nil           => None
    case x :: _ :: Nil => Some(x)
    case _ :: xs       => penultimate(xs)
  }

  def nth[A](n: Int, list: List[A]): Option[A] = (n,list) match {
    case (_, Nil)     => None
    case (0, x :: _)  => Some(x)
    case (n, _ :: xs) => nth(n-1, xs)
  }

  def length[A](list: List[A]): Int = list match {
    case Nil     => 0
    case _ :: xs => 1 + length(xs)
  }

  def reverse[A](list: List[A]): List[A] = {
    list.foldLeft (List[A]()) ((acc,x) => x :: acc)
  }

  def isPalindrome[A](list: List[A]): Boolean = {
    reverse(list) == list
  }

  def flatten[A](list: List[List[A]]): List[A] = {
    list.foldRight (List[A]()) ((x,acc) => x ::: acc)
  }

  def replicate[A](n: Int, x: A): List[A] = n match {
    case 0 => Nil
    case n => x :: replicate(n-1, x)
  }

  def group[A](list: List[A]): List[List[A]] = {
    groupBy[A](_ == _, list)
  }

  def groupBy[A](f: (A,A) => Boolean, list: List[A]): List[List[A]] = list match {
    case Nil => Nil
    case _   => list.foldRight (List(List[A]())) { (x,acc) => acc match {
      case Nil :: rest => List(x) :: rest
      case xs  :: rest =>
	if (f(x, xs.head)) (x :: xs) :: rest
	else               List(x) :: xs :: rest
      }
    }
  }

  // Compresses consecutive duplicates.
  // (1,1,1,2,2,3,3,3,3) => (1,2,3)
  def compress[A](list: List[A]): List[A] = {
    group(list).map(x => x.head)
  }

  // Run-length encoding.
  def encode[A](list: List[A]): List[(A,Int)] = {
    group(list).map(x => (x.head, x.length))
  }

  // Run-length decoding.
  def decode[A](list: List[(A,Int)]) = {
    flatten(list.map { case (x,n) => replicate(n,x) })
  }

  // Functions with functions works.
  def dropNth[A](n: Int, list: List[A]): List[A] = {
    def work(m: Int, list2: List[A]): List[A] = (m,list2) match {
      case (_, Nil)     => Nil
      case (1, _ :: xs) => work(n, xs)
      case (m, x :: xs) => x :: work(m-1, xs)
    }

    work(n, list)
  }

  def splitAt[A](n: Int, list: List[A]): (List[A],List[A]) = {
    (list.take(n), list.drop(n))
  }

  def slice[A](n: Int, m: Int, list: List[A]) : List[A] = {
    list.drop(n).take(m-n)
  }

  def rotate[A](n: Int, list: List[A]): List[A] = {
    val len = length(list)
    val m   = (n + len) % len

    list.drop(m) ++ list.take(m)
  }

  def removeNth[A](n: Int, list: List[A]): (List[A],Option[A]) = {
    def del(m: Int, xs: List[A]): List[A] = (m,xs) match {
      case (_, Nil)     => Nil
      case (0, _ :: xs) => xs
      case (m, x :: xs) => x :: del(m-1, xs)
    }

    (del(n, list), nth(n, list))
  }

  def insertAt[A](x: A, n: Int, list: List[A]): List[A] = (n,list) match {
    case (_,Nil)      => List(x)
    case (0,ys)       => x :: ys
    case (m, y :: ys) => y :: insertAt(x, m-1, ys)
  }

  def range(j: Int, k: Int): List[Int] = {
    if (j >= k) List(j) else j :: range(j+1, k)
  }

  def nRandoms[A](n: Int, list: List[A]): List[A] = {
    Random.shuffle(list).take(n)
  }

  def lotto(n: Int, k: Int): List[Int] = {
    nRandoms(n, range(1,k))
  }

  // Mathematical `choose`.
  def combinations[A](n: Int, list: List[A]): List[List[A]] = {
    def nht(m: Int, xs: List[A]): List[List[A]] = (m,xs) match {
      case (0,_)   => Nil
      case (_,Nil) => Nil
      case _       => xs :: nht(m-1, xs.tail)
    }

    if (n <= 1 || list.isEmpty) list.map(x => List(x))  // Handles `Nil` case.
    else {
      val ys = nht(list.length - n + 1, list)
      ys.flatMap { xs => combinations(n-1, xs.tail).map(xs.head :: _) }
    }
  }

  def lsort[A](list: List[List[A]]): List[List[A]] = {
    list.sortBy(_.length)
  }

  def lsortFreq[A](list: List[List[A]]): List[List[A]] = {
    flatten(lsort(groupBy[List[A]](_.length == _.length, lsort(list))))
  }
}
