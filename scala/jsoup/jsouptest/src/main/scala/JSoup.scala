/* JSoup - 2015 June 29 @ 11:07
 * JSoup is a Java library for parsing HTML. With one import to bring
 * in Java container conversion implicits, it's easily usable in Scala.
 */

import org.jsoup.Jsoup
import org.jsoup.nodes._
import scala.collection.JavaConversions._
import scalaz.std.option._
import scalaz.syntax.all._

// --- //

case class Response(dest: String, img: String, others: Seq[String])

object JSoup {
  def main(args: Array[String]): Unit = {
    val html = "<img src=\"https://imgur.com/BETTERSEETHIS\">" ++
    "<p><a href=\"http://news.ycombinator.com\">" ++
    "<img src=\"http://i.imgur.com/51VsJTc.jpg\">" ++
    "</a>" ++
    "<img src=\"https://imgur.com/gallery/BDxC4Ol\">" ++
    "<img src=\"https://imgur.com/gallery/BDxC4Ol\">" ++
    "<img src=\"https://imgur.com/gallery/BDxC4Ol\"></p>"

    /* Parse the HTML */
    val doc: Document = Jsoup.parse(html)

    /* Search for a tag, and only operate on it if it exists.
     * `headOption` and `map` work thanks to JavaConversions.
     */
    lazy val dest: Option[String] = doc.getElementsByTag("a")
      .headOption
      .map(_.attr("href"))

    /* Select like jQuery */
    lazy val img: Option[String] = doc.select("a img")
      .headOption
      .map(_.attr("src"))

    /* Select with parent/child relationships */
    lazy val others: Seq[String] = doc.select("body > img, body > p > img")
      .map(_.attr("src"))

    /* Consolidate everything via Applicative */
    val r: Option[Response] = (dest |@| img) { Response(_,_,others) }

    println(r)
  }
}
