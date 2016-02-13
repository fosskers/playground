package types

import org.apache.spark.mllib.linalg.DenseVector

// --- //

object Vectors {
  implicit class VecOps(v: DenseVector) {
    /* For some reason, MLlib doesn't provide algebra operations for Vectors */
    def |+|(other: DenseVector): DenseVector = {
      new DenseVector(v.values.zip(other.values).map({ case (a,b) => a + b }))
    }

    def |-|(other: DenseVector): DenseVector = {
      new DenseVector(v.values.zip(other.values).map({ case (a,b) => a - b }))
    }
  }
}
