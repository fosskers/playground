/**
  * A singleton class for injecting a Spark Context.
  */

package controllers

import javax.inject._
import org.apache.spark.{SparkConf, SparkContext}

// --- //

@Singleton
class Spark {

  /* This will have to be changed to match where you installed Spark */
  val sparkHome = "/home/colin/building/spark-1.6.0-bin-hadoop2.6/"

  val conf = new SparkConf()
    .setAppName("Spark with Play")
    .setMaster("local[2]") // Use two local cores

  val sc = new SparkContext(conf)
}
