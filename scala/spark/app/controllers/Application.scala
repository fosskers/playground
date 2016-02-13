/* This is a modified example from Spark's "Quick Start" guide,
 * changed to involve the Play framework
 */

package controllers

import javax.inject._
import org.apache.spark.SparkContext._
import org.apache.spark.mllib.linalg.DenseVector
import org.apache.spark.mllib.recommendation.Rating
import play.api._
import play.api.libs.json.Json
import play.api.mvc._
import scala.util.{Failure, Success, Try}
import types.Vectors._

// --- //

class Application @Inject() (t: Text, c: Collab, w: W2V) extends Controller {

  def index = Action {
    val numAs = t.logData.filter(line => line.contains("a")).count()
    val numBs = t.logData.filter(line => line.contains("b")).count()

    Ok(s"Lines with a: ${numAs}, Lines with b: ${numBs}")
  }

  /* Evaluate the model on rating data */
  def collab = Action {
    val usersProducts = c.ratings.map { case Rating(user, product, rate) =>
      (user, product)
    }
    val predictions = c.model.predict(usersProducts)
      .map { case Rating(user, product, rate) =>
        ((user, product), rate)
    }

    val ratesAndPreds = c.ratings.map { case Rating(user, product, rate) =>
      ((user, product), rate)
    }.join(predictions)

    val MSE = ratesAndPreds.map { case ((user, product), (r1, r2)) =>
      val err = (r1 - r2)
      err * err
    }.mean()

    Ok(s"Mean Squared Error = ${MSE}")
  }

  /* Find words thematically related to the input */
  def word2vec(word: String) = Action {
    Try {
      w.model.findSynonyms(word, 20).map({ case (w,r) => s"$w => $r" })
    } match {
      case Success(s) => Ok(Json.toJson(s))
      case Failure(_) => Ok(Json.obj("error" -> s"${word} wasn't found."))
    }
  }

  def assoc(w1: String, w2: String, w3: String) = Action {
    Try {
      val v1: DenseVector = w.model.transform(w1).toDense
      val v2: DenseVector = w.model.transform(w2).toDense
      val v3: DenseVector = w.model.transform(w3).toDense

      w.model.findSynonyms(v1 |-| v2 |+| v3, 20)
        .map({ case (w,r) => s"$w => $r" })
    } match {
      case Success(s) => Ok(Json.toJson(s))
      case Failure(_) => Ok(Json.obj("error" -> "One of the words couldn't be found."))
    }
  }
}
