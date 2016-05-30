package fosskers

import scala.concurrent.ExecutionContext
import scala.io.StdIn
import scala.util.Random

import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport
import akka.http.scaladsl.model.{ContentTypes, HttpEntity}
import akka.http.scaladsl.server.Directives._
import akka.stream.ActorMaterializer
import akka.stream.scaladsl.Source
import akka.util.ByteString
import spray.json.DefaultJsonProtocol

// --- //

/* Everyone loves cats */
case class Cat(name: String, age: Int)

/* JSON conversion for the `Cat` type */
trait CatJson extends SprayJsonSupport with DefaultJsonProtocol {
  implicit val catFormat = jsonFormat2(Cat)
}

object WebServer extends CatJson {

  val cats: Seq[Cat] = Seq(
    Cat("Jack", 3),
    Cat("Qtip", 10),
    Cat("Pip", 1)
  )

  def main(args: Array[String]) = {
    implicit val system: ActorSystem = ActorSystem("pg-akka-http")
    implicit val materializer: ActorMaterializer = ActorMaterializer()
    implicit val ec: ExecutionContext = system.dispatcher

    /* Iterator for streaming random number generation */
    val numbers = Source.fromIterator(() =>
      Iterator.continually(Random.nextInt())
    )

    /* Routes */
    val route = get {
      path("random") {
        complete(HttpEntity(
          ContentTypes.`text/plain(UTF-8)`,
          numbers.map(n => ByteString(s"${n}\n"))
        ))
      } ~
      pathPrefix("cats" / IntNumber) { numCats =>
        complete(cats.take(numCats))
      }
    }

    val bindingFuture = Http().bindAndHandle(route, "localhost", 8080)

    println(s"Server up on localhost:8080... Press ENTER to kill")
    StdIn.readLine()
    bindingFuture
      .flatMap(_.unbind())
      .onComplete(_ => system.terminate())
  }
}
