package controllers

import javax.inject._

// --- //

@Singleton
class Text @Inject() (spark: Spark) {

  val logFile = "sample.txt"

  /* Create an RDD, and mark it for caching */
  val logData = spark.sc.textFile(logFile, 2).cache()
}
