name := """xml-spac"""

version := "1.0.0"

scalaVersion := "2.11.8"

// Change this to another test framework if you prefer
libraryDependencies ++= Seq(
  "io.dylemma" %% "xml-spac" % "0.3-SNAPSHOT",  // Published locally
  "joda-time" % "joda-time" % "2.9.7",
  "org.scalatest" %% "scalatest" % "3.0.0" % "test"
)
