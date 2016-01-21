/**
  * A singleton class for injecting a Spark Context.
  */

package controllers

import javax.inject._
import org.apache.spark.{SparkConf, SparkContext}

// --- //

@Singleton
class Spark {

  val conf = new SparkConf()
    .setAppName("Spark with Play")
    .setMaster("local[2]") // Use two local cores

  val sc = new SparkContext(conf)
}
