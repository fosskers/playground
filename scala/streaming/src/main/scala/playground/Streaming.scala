package Streaming

import java.nio.file.Paths

import scala.concurrent._
import scala.concurrent.duration._

import akka.NotUsed
import akka.actor.ActorSystem
import akka.stream._
import akka.stream.scaladsl._
import akka.stream.scaladsl.GraphDSL.Implicits._
import akka.util.ByteString

// --- //

final case class Author(name: String)

final case class Hashtag(hash: String)

final case class Tweet(author: Author, time: Long, body: String) {
  def hashtags: Set[Hashtag] =
    body.split(" ").collect({ case t if t.startsWith("#") => Hashtag(t)}).toSet
}

object Streaming extends App {

  /** A normal-seeming `Consumer`.
    * `Keep.right` ensures that the "rightmost" return value is kept.
    */
  def lineSink(file: String): Sink[String, Future[IOResult]] =
    Flow[String]
      .map(s => ByteString(s"${s}\n"))
      .toMat(FileIO.toPath(Paths.get(file)))(Keep.right)

  override def main(args: Array[String]): Unit = {

    /* Setup. A materializer "runs" the stream, in lieu of Monads */
    implicit val system = ActorSystem("AkkaStreams")
    implicit val materializer = ActorMaterializer()

    /* `Source` from an `Iterator` */
    val source: Source[Int, NotUsed] = Source(1 to 10)

    /* Transform a Stream via an `iterate`-late operation */
    val factorials: Source[Int, NotUsed] = source.scan(1)(_ * _)

    /* Attach a `Source` and `Sink` */
    val work: Future[IOResult] =
      factorials.map(_.toString).runWith(lineSink("factorials.txt"))

    /* Await the result, or the Actor system will exit too quickly */
    Await.result(work, Duration.Inf)

    /* Shut down the Actor system, or else the program will hang */
    system.terminate()
  }

  def twitter(implicit m: Materializer) = {
    /* Some Stream of Tweets */
    val tweets: Source[Tweet, NotUsed] = ???

    /* Output sinks */
    val writeAuthors: Sink[Author, Unit] = ???
    val writeHashtags: Sink[Hashtag, Unit] = ???

    /* All akka-interested authors in the Stream */
    val authors: Source[Author, NotUsed] =
      tweets
        .filter(_.hashtags.contains(Hashtag("#akka")))
        .map(_.author)

    /* "flatmapping" (not quite) a Stream */
    val hashtags: Source[Hashtag, NotUsed] = tweets.mapConcat(_.hashtags)

    /* A Stream Graph */
    val g = RunnableGraph.fromGraph(GraphDSL.create() { implicit b =>
      /* Add a `Broadcast`, a Graph node that can fan results out to multiple Sinks */
      val bcast = b.add(Broadcast[Tweet](2))

      tweets ~> bcast.in
      bcast.out(0) ~> Flow[Tweet].map(_.author) ~> writeAuthors
      bcast.out(1) ~> Flow[Tweet].mapConcat(_.hashtags) ~> writeHashtags
      ClosedShape
    })

    g.run()
  }
}
