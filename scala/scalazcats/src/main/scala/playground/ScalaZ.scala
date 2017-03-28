package playground

import scala.concurrent.{ExecutionContext, Future}

import scalaz.OptionT
import scalaz.std.scalaFuture._

// --- //

object ScalaZ {

  def rawdbCall: Future[Int] = ???

  def dbCall(implicit ec: ExecutionContext): OptionT[Future, Int] = {
    val fut: Future[Option[Int]] = rawdbCall
      .map(i => Some(i))
      .recover({ case e: Throwable => None })

    OptionT(fut)
  }

  /* Could be an akka-http endpoint, which expects a `Future` */
  def work(implicit ec: ExecutionContext): Future[Option[Int]] = {
    val res = for {
      a <- dbCall
      b <- dbCall
      c <- dbCall
    } yield a + b + c

    res.run
  }

}
