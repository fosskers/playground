name := """orc"""

version := "1.0.0"

scalaVersion := "2.11.11"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % "2.2.0",
  "org.apache.spark" %% "spark-hive" % "2.2.0",
  "org.scalatest"    %% "scalatest"  % "2.2.4" % "test"
)
