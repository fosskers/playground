/**
  * Collaborative Filtering
  * https://spark.apache.org/docs/latest/mllib-collaborative-filtering.html
  */

package controllers

import javax.inject._
import org.apache.spark.mllib.recommendation.{ALS, Rating}

// --- //

@Singleton
class Collab @Inject() (spark: Spark) {

  /* Load and parse the data */
  val data = spark.sc.textFile(spark.sparkHome ++ "data/mllib/als/test.data")
  val ratings = data.map(_.split(',') match { case Array(user, item, rate) =>
    Rating(user.toInt, item.toInt, rate.toDouble)
  })

  /* Build the recommendation model using ALS */
  val rank = 10
  val numIterations = 10
  val model = ALS.train(ratings, rank, numIterations, 0.01)

}
