package com.ignaciosuay

import java.util.UUID

import io.gatling.core.feeder.Feeder

object UuidFeeder {
  val feeder = Iterator.continually(Map("uuid" -> java.util.UUID.randomUUID.toString()))
}
