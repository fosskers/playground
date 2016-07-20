package com.example

import com.websudos.phantom.dsl._
import scala.concurrent.Future
//import scala.concurrent.ExecutionContext.Implicits.global

// --- //

/*
 * Commands to get a minimal Cassandra environment working:
 *
 * docker pull cassandra
 * docker run --name cass-phan -d -p 9042:9042 cassandra
 *
 */

/* Cassandra connection config */
object Defaults {
  val connector: KeySpaceDef = ContactPoint.local.keySpace("bestKeySpace")
}

/* A table of programming languages */
case class Language(
  name: String,
  created: DateTime,
  power: Int
)

class Languages extends CassandraTable[ConcreteLanguages, Language] {
  object name extends StringColumn(this) with PartitionKey[String]
  object created extends DateTimeColumn(this)
  object power extends IntColumn(this)

  def fromRow(row: Row): Language = {
    Language(
      name(row),
      created(row),
      power(row)
    )
  }
}

// Not sure why this roundabout with typing is necessary
trait ConcreteLanguages extends Languages with RootConnector {
  def store(lang: Language): Future[ResultSet] = {
    insert.value(_.name, lang.name)
      .value(_.created, lang.created)
      .value(_.power, lang.power)
      .consistencyLevel_=(ConsistencyLevel.ALL)
      .future()
  }

  def getByName(name: String): Future[Option[Language]] = {
    select.where(_.name eqs name).one()
  }
}

class DB(val keyspace: KeySpaceDef) extends Database(keyspace) {
  object languages extends ConcreteLanguages with keyspace.Connector
}

/* Can create any number of interfaces to `DB` by passing different
 * `KeySpaceDef`s here. You can even be clever and have the `ContactPoint`s
 * be to entirely different IP address, say for testing purposes.
 */
object DB extends DB(Defaults.connector)

object Phantom {
  def main(args: Array[String]): Unit = {
    println("Trying really hard...")

    // TODO Here. It can't find an implicit session?
    for {
      _ <- DB.autocreate.future()
      _ <- DB.languages.store(Language("Haskell", new DateTime(1990, 1, 1, 6, 0), 10))
      r <- DB.languages.getByName("Haskell")
      _ <- DB.autotruncate.future()
    } yield {
      println(r)
    }

    println("[PG] Done")
  }
}
