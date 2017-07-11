package playground

import org.apache.spark._
import org.apache.spark.rdd.RDD
import org.apache.spark.sql._
import org.apache.spark.sql.hive._
import org.apache.log4j.{Level, Logger}

// --- //

/* Weird, `Map` must be typed in this verbose way */
case class Node(id: Long, tags: scala.collection.Map[String, String], lat: BigDecimal, lon: BigDecimal)
case class Way(id: Long, tags: scala.collection.Map[String, String], nds: Seq[Long])
case class Relation(id: Long, tags: scala.collection.Map[String, String], members: Seq[Member])
case class Member(`type`: String, ref: Long, role: String)

object Orc extends App {
  override def main(args: Array[String]): Unit = {

    val conf = new SparkConf()
      .setMaster("local[*]")
      .setAppName("orc")

    implicit val sc: SparkContext = new SparkContext(conf)
    implicit val hc: HiveContext = new HiveContext(sc)

    /* Magic. Things don't compile without this. */
    import hc.sparkSession.implicits._

    /* Silence the damn INFO logger */
    Logger.getRootLogger().setLevel(Level.ERROR)

    /* Necessary for "predicate push-down" */
    hc.setConf("spark.sql.orc.filterPushdown", "true")

    /* A lazy reader of some sort */
    val data: DataFrame = hc.read.format("orc").load("uku.orc")

    val nodes: RDD[Node] =
      data
        .select("id", "tags", "lat", "lon")
        .where("type = 'node'")
        .as[Node]
        .rdd

    /* There seems to be some runtime reflection that lets the results
     * actually parse into a `Way`. Notice there aren't any explicit typeclass
     * instances defined anywhere.
     */
    val ways: RDD[Way] =
      data
        .select($"id", $"tags", $"nds.ref".alias("nds"))
        .where("type = 'way'")
        .as[Way]
        .rdd

    val relations: RDD[Relation] =
      data
        .select($"id", $"tags", $"members")  // Why are the `$` necessary?
        .where("type = 'relation'")
        .as[Relation]
        .rdd

    try {
      println(s"NODES: ${nodes.count()}")
      println(s"WAYS: ${ways.count()}")
      println(s"RELATIONS: ${relations.count()}")
    } finally {
      /* Safely stop the Spark Context */
      sc.stop()
    }
  }
}
