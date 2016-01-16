name := """Spark and Play"""

version := "1.0"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.10.5"

libraryDependencies ++= Seq(
  jdbc,
  cache,
  ws,
  "org.apache.spark" %% "spark-core" % "1.6.0"
)

// This fixes an injection execption that occurs due to differing
// versions of the Jackson library required by Play and Spark.
// See: http://stackoverflow.com/q/31039367
dependencyOverrides ++= Set(
  "com.fasterxml.jackson.core" % "jackson-databind" % "2.4.4"

)

resolvers += "scalaz-bintray" at "http://dl.bintray.com/scalaz/releases"

routesGenerator := InjectedRoutesGenerator
