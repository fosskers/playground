name := """pg-akka-http"""

version := "1.0"

scalaVersion := "2.11.8"

// Change this to another test framework if you prefer
libraryDependencies ++= Seq(
  "com.typesafe.akka" %% "akka-http-core" % "2.4.6",
  "com.typesafe.akka" %% "akka-http-experimental" % "2.4.6",
  "com.typesafe.akka" %% "akka-http-spray-json-experimental" % "2.4.6"
)

// Uncomment to use Akka
//libraryDependencies += "com.typesafe.akka" %% "akka-actor" % "2.3.11"
