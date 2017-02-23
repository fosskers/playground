package playground

import org.apache.spark._
import org.apache.spark.sql._
import org.apache.spark.sql.hive._

// --- //

/* Weird, `Map` must be typed in this verbose way */
case class Node(id: Long, tags: scala.collection.Map[String, String], lat: BigDecimal, lon: BigDecimal)
case class Way(id: Long, tags: scala.collection.Map[String, String], nds: Seq[Long])

object Orc extends App {
  override def main(args: Array[String]): Unit = {

    val conf = new SparkConf()
      .setMaster("local[*]")
      .setAppName("orc")

    implicit val sc: SparkContext = new SparkContext(conf)
    implicit val hc: HiveContext = new HiveContext(sc)

    import hc.sparkSession.implicits._

    /* Necessary for "predicate push-down" */
    hc.setConf("spark.sql.orc.filterPushdown", "true")

    /* A reader? */
    val data = hc.read.format("orc").load("VA.orc")

    val nodes =
      data
        .select("id", "tags", "lat", "lon")
        .where("type = 'node'")
        .as[Node]
        .rdd

    val ways =
      data
        .select($"id", $"tags", $"nds.ref".alias("nds"))
        .where("type = 'way'")
        .as[Way]
        .rdd

    /* `println(res)` prints something odd */
    //    res.show()
    println(s"NODES: ${nodes.count()}")
    println(s"WAYS: ${ways.count()}")
//    res.foreach(println)

    /* Safely stop the Spark Context */
    sc.stop()
  }
}
