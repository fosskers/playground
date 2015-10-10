import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

// --- //

object Futures extends App {
  for {
    a <- Future { println("First one!");  1 }
    b <- Future { println("Second one!"); 2 }
  } yield {
    println(s"Result: ${a+b} ")
  }

  println("Done.")
}
