// This enables ScalaJS use
enablePlugins(ScalaJSPlugin)

// Use NodeJS
//scalaJSUseRhino in Global := false

skip in packageJSDependencies := false

// If you want `test`, etc, to run with `fullOptJS`
scalaJSStage in Global := FullOptStage

// To avoid manually launching the app in HTML
persistLauncher in Compile := true
persistLauncher in Test := false

name := """scalajs"""

version := "1.0"

scalaVersion := "2.11.8"

// Change this to another test framework if you prefer
libraryDependencies ++= Seq(
  "com.lihaoyi" %%% "utest" % "0.4.3" % "test",
  "be.doeraene" %%% "scalajs-jquery" % "0.9.0"
//  "org.scala-js" %%% "scalajs-dom" % "0.9.0"
)

jsDependencies ++= Seq(
  RuntimeDOM,
  "org.webjars" % "jquery" % "2.1.4" / "2.1.4/jquery.js"
)

testFrameworks += new TestFramework("utest.runner.Framework")

// Uncomment to use Akka
//libraryDependencies += "com.typesafe.akka" %% "akka-actor" % "2.3.11"
