package com.ignaciosuay

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class BasicSimulation extends Simulation {

  val httpProtocol = http
    .baseUrl("http://springecs-41565405.eu-west-1.elb.amazonaws.com/") // Here is the root for all relative URLs
    .acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8") // Here are the common headers
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

  val scn = scenario("Scenario Name")
    .feed(UuidFeeder.feeder)// A scenario is a chain of requests and pauses
    .exec(http("get All products")
      .get("/products"))
    .pause(10)
    .exec(http("Save new product")
      .post("/products")
      .header("Content-Type", "application/json")
      .body(StringBody("""{ "id": "${uuid}", "name": "new product" }""")))
    .pause(10)
    .exec(http("get latest saved product")
      .get("/products/${uuid}"))

  setUp(scn.inject(
    rampConcurrentUsers(0) to (100) during (60 seconds),
    constantConcurrentUsers(100) during (2 minutes))
    .protocols(httpProtocol))
}
