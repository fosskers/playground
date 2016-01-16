/* This is a modified example from Spark's "Quick Start" guide,
 * changed to involve the Play framework
 */

package controllers

import javax.inject._
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.SparkContext._
import play.api._
import play.api.mvc._

// --- //

@Singleton
class Application extends Controller {
  /* This will have to be changed to match where you installed Spark */
  val sparkHome = "/home/colin/building/spark-1.6.0-bin-hadoop2.6/"
  val logFile = sparkHome ++ "README.md"

  /* Spark Context */
  val conf = new SparkConf()
    .setAppName("Spark with Play")
    .setMaster("local[2]")  // Use two local cores
  val sc = new SparkContext(conf)

  /* Create an RDD, and mark it for caching */
  val logData = sc.textFile(logFile, 2).cache()

  def index = Action {
    val numAs = logData.filter(line => line.contains("a")).count()
    val numBs = logData.filter(line => line.contains("b")).count()

    Ok(s"Lines with a: ${numAs}, Lines with b: ${numBs}")
  }

}
