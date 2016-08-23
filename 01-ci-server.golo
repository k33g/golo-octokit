module ci_server

import spark.Spark

function main = |args| {
  setPort(8888)

  spark.Spark.get("/", |request, response| {
    response: type("application/json")
    return JSON.stringify(DynamicObject(): message("Hello from Golo-CI"))
  })

  spark.Spark.post("/golo_ci", |request, response| {
    response: type("application/json")
    println(request)
    return JSON.stringify(DynamicObject(): message("Hello from Golo-CI"))
  })

}
