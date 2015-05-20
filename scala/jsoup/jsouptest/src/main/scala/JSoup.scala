/* JSoup - 2015 May 19 @ 18:37
 * JSoup is a Java library for parsing HTML. With one import to bring
 * in Java container conversion implicits, it's easily usable in Scala.
 */

import org.jsoup.Jsoup
import org.jsoup.nodes._
import scala.collection.JavaConversions._
import scalaz.std.option._
import scalaz.syntax.all._

// --- //

case class Response(dest: String, img: String, backup: String)

object JSoup {
  def main(args: Array[String]): Unit = {
    val html = "<a href=\"http://news.ycombinator.com\">" ++ 
               "<img src=\"http://i.imgur.com/51VsJTc.jpg\">" ++ 
               "</a>" ++ 
               "<img src=\"https://imgur.com/gallery/BDxC4Ol\">"

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

    /* Select on an attribute whose value matches a regex */
    lazy val backup: Option[String] = doc.select("img[src~=gallery]")
      .headOption
      .map(_.attr("src"))

    /* Consolidate everything via Applicative */
    val r: Option[Response] = (dest |@| img |@| backup) { Response(_,_,_) }

    println(r)
  }
}
