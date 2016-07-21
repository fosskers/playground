package com.example

import com.websudos.phantom.dsl._
import scala.concurrent.Future

// --- //

/*
 * Commands to get a minimal Cassandra environment working:
 *   docker pull cassandra:2.1
 *   docker run --name cass-phan -d -p 9042:9042 cassandra:2.1
 *
 * Enter the Cassandra shell within the running container:
 *   docker exec -it cass-phan usr/bin/cqlsh
 *
 */

/* Cassandra connection config */
object Defaults {
  val connector: KeySpaceDef = ContactPoint.local.keySpace("bestKeySpace")
}

/* A programming language */
case class Language(
  name: String,
  created: DateTime,
  staticTyping: Boolean
)

/* A table of programming languages */
class Languages extends CassandraTable[ConcreteLanguages, Language] {
  object name extends StringColumn(this) with PartitionKey[String]
  object created extends DateTimeColumn(this)
  object staticTyping extends BooleanColumn(this)

  // Boilerplate.
  def fromRow(row: Row): Language = {
    Language(
      name(row),
      created(row),
      staticTyping(row)
    )
  }
}

// Not sure why this roundabout with typing is necessary
trait ConcreteLanguages extends Languages with RootConnector {
  def store(lang: Language): Future[ResultSet] = {
    // Boilerplate.
    insert.value(_.name, lang.name)
      .value(_.created, lang.created)
      .value(_.staticTyping, lang.staticTyping)
      .consistencyLevel_=(ConsistencyLevel.ALL)
      .future()
  }

  /* A sample query. `DB.languages.select...` does the same. */
  def getByName(name: String): Future[Option[Language]] = {
    select.where(_.name eqs name).one()
  }
}

class UnconnectedDB(val keyspace: KeySpaceDef) extends Database(keyspace) {
  object languages extends ConcreteLanguages with keyspace.Connector
}

/* Can create any number of interfaces to `DB` by passing different
 * `KeySpaceDef`s here. You can even be clever and have the `ContactPoint`s
 * be to entirely different IP address, say for testing purposes.
 */
object DB extends UnconnectedDB(Defaults.connector)

object Phantom extends Defaults.connector.Connector {
  def main(args: Array[String]): Unit = {
    println("Trying really hard...")

    val langs = Seq(
      Language("Haskell", new DateTime(1990, 1, 1, 6, 0), true),
      Language("Scala", new DateTime(2004, 1, 20, 6, 0), true),
      Language("Java", new DateTime(1995, 5, 23, 6, 0), true),
      Language("Python", new DateTime(1991, 2, 20, 6, 0), false),
      Language("Rust", new DateTime(2010, 1, 1, 6, 0), true),
      Language("C", new DateTime(1972, 1, 1, 6, 0), true),
      Language("Fortran", new DateTime(1956, 10, 15, 6, 0), true)
    )

    for {
      _ <- DB.autocreate.future()
      _ <- Future.sequence(langs.map(l => DB.languages.store(l)))
      _ <- Future.sequence(langs.map(l => DB.languages.store(l)))
      r <- DB.languages.getByName("Haskell")
      _ <- DB.autotruncate.future()  // Comment this out to make the data persist
    } yield {
      println(r)
    }

    println("[PG] Done")
  }
}
