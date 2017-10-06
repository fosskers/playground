name := """pg-geotrellis"""

version := "1.0.0"

scalaVersion in ThisBuild := "2.11.11"

libraryDependencies ++= Seq(
  "org.locationtech.geotrellis" %% "geotrellis-spark"  % "1.1.1",
  "org.apache.spark"            %% "spark-core"        % "2.2.0"
)
