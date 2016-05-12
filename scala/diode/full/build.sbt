// This enables ScalaJS use
enablePlugins(ScalaJSPlugin)

// Use NodeJS
//scalaJSUseRhino in Global := false

// To avoid manually launching the app in HTML
persistLauncher in Compile := true
persistLauncher in Test := false

name := """diode-full"""

version := "1.0"

scalaVersion := "2.11.8"

// Change this to another test framework if you prefer
libraryDependencies ++= Seq(
  "org.scala-js" %%% "scalajs-dom" % "0.9.0",
  "me.chrons" %%% "diode" % "0.5.1",
  "me.chrons" %%% "diode-react" % "0.5.1"
)

// Uncomment to use Akka
//libraryDependencies += "com.typesafe.akka" %% "akka-actor" % "2.3.11"

