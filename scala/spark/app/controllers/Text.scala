package controllers

import javax.inject._

// --- //

@Singleton
class Text @Inject() (spark: Spark) {

  /* This will have to be changed to match where you installed Spark */
  val sparkHome = "/home/colin/building/spark-1.6.0-bin-hadoop2.6/"
  val logFile = sparkHome ++ "README.md"

  /* Create an RDD, and mark it for caching */
  val logData = spark.sc.textFile(logFile, 2).cache()
}
