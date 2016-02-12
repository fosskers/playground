package controllers

import javax.inject._
import org.apache.spark.mllib.feature.{Word2Vec, Word2VecModel}
import org.apache.spark.rdd.RDD
import play.api.Logger

// --- //

@Singleton
class W2V @Inject() (spark: Spark) {
  val modelPath: String = "text8-model"

  lazy val model: Word2VecModel = if (new java.io.File(modelPath).exists) {
    /* Read the trained model */
    Logger.debug("Reading trained model...")
    Word2VecModel.load(spark.sc, modelPath)
  } else {
    /* Train the model */
    Logger.debug("Reading file...")

    val input: RDD[Seq[String]] = spark.sc.textFile("text8-smaller")
      .map(line => line.split(" ").toSeq)
      .repartition(4)
      .cache

    Logger.debug(s"${input.count} lines in the RDD")

    val word2vec = new Word2Vec()

    Logger.debug("Training model...")
    val m = word2vec.fit(input)
    Logger.debug("Model trained! Saving it...")
    m.save(spark.sc, "text8-model")
    Logger.debug("Model saved.")
    m
  }
}
