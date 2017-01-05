package playground

import io.dylemma.spac._
import javax.xml.stream.events.XMLEvent /* Sits on top of Java */
import org.joda.time.LocalDate
import org.joda.time.format.DateTimeFormat

// --- //

/* Classes to parse into */
case class Post(date: LocalDate, author: Author, stats: Stats, body: String, comments: List[Comment])
case class Author(id: String, name: String)
case class Stats(numLikes: Int, numTweets: Int)
case class Comment(date: LocalDate, author: Author, body: String)

object Parsers {
  val dateP = Parser.forMandatoryAttribute("date")
    .map(DateTimeFormat.forPattern("yyyy-MM-dd").parseLocalDate)

  // Hm, boilerplatey.
  implicit val authorP: Parser[Any, Author] = (
    Parser.forMandatoryAttribute("id") ~
      Parser.forMandatoryAttribute("name")
  ).as(Author)

  implicit val statsP: Parser[Any, Stats] = (
    Parser.forMandatoryAttribute("likes").map(_.toInt) ~
      Parser.forMandatoryAttribute("tweets").map(_.toInt)
  ).as(Stats)

  implicit val commentP: Parser[Any, Comment] = (
    dateP ~
      Splitter(* \ "author").first[Author] ~
      Splitter(* \ "body").first.asText
  ).as(Comment)

  implicit val postP: Parser[Any, Post] = (
    dateP ~
      Splitter(* \ "author").first[Author] ~
      Splitter(* \ "stats").first[Stats] ~
      Splitter(* \ "body").first.asText ~
      Splitter(* \ "comments" \ "comment").asListOf[Comment]
  ).as(Post)

  /* The final parser to call.
   * Usage: postT.consumeToList.consume(xml)
   */
  val postT: Transformer[XMLEvent, Post] = Splitter("blog" \ "post").as[Post]

  val xml = """
<blog>
  <post date="2015-11-16">
    <author name="dylemma" id="abc123"/>
    <stats likes="123" tweets="4"/>
    <body>Hello world!</body>
    <comments>
      <comment date="2015-11-18">
        <author name="anonymous" id="def456"/>
        <body>I'm commenting on your fake blog!</body>
      </comment>
    </comments>
  </post>
  <post date="2015-11-18">
    <author name="johndoe" id="004200"/>
    <stats likes="7" tweets="1"/>
    <body>A second blog post, huzzah!</body>
    <comments>
      <comment date="2015-11-19">
        <author name="anonymous" id="def456"/>
        <body>It's me again</body>
      </comment>
    </comments>
  </post>
</blog>
"""
}
