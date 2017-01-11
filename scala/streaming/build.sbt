name := """streaming"""

version := "1.0.0"

scalaVersion := "2.11.8"

// Change this to another test framework if you prefer
libraryDependencies ++= Seq(
  "com.typesafe.akka" %% "akka-stream" % "2.4.16",
  "org.scalatest"     %% "scalatest"  % "2.2.4" % "test"
)
