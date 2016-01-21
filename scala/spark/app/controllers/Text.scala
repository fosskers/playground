package controllers

import javax.inject._

// --- //

@Singleton
class Text @Inject() (spark: Spark) {

  val logFile = spark.sparkHome ++ "README.md"

  /* Create an RDD, and mark it for caching */
  val logData = spark.sc.textFile(logFile, 2).cache()
}
