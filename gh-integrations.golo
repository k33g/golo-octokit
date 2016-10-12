module ci_server

import spark.Spark

import gololang.Errors
import gololang.Async
import goloctokit

import gh.dsl

function log = |txt, args...| -> println(java.text.MessageFormat.format(txt, args))


----
GitHub Integration
- using webhook
- it's a post message

TODO:
- dsl
----
function main = |args| {
  setPort(8888)

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GITHUB_ENTERPRISE")

  let gitHubClientEnterprise = GitHubClient(
    uri= "http://ghe.k33g/api/v3",
    token= TOKEN_GITHUB_ENTERPRISE
  )


  spark.Spark.post("/golo_ci", |request, response| {
    response: type("application/json")

    let eventName = request: headers("X-GitHub-Event")
    let data =  JSON.toDynamicObjectTreeFromString(request: body())

    if eventName: equals("pull_request") {
      let action = data: action()
      log("GitHub Event: {0} action: {1}", eventName, action)

      # https://developer.github.com/guides/delivering-deployments/
      if action: equals("closed") and data: pull_request(): merged() {
        log("👍  {0}", "A pull request was merged! A deployment should start now...")
        # something todo
      }

    } # end of pull_request

    if eventName: equals("push") {
      log("GitHub Event: {0}", eventName)

      let owner = data: repository(): owner(): name()
      let repositoryName = data: repository(): name()

      let ref = data: ref()
      let sha = data: head_commit(): id()
      # TODO: try to do a println
      log("ref: {0} sha: {1}", ref, sha)
      log("after: {0}", data: after())
      log("Committer: {0}", data: head_commit(): committer(): username())
      log("Message: {0}", data: head_commit(): message())

      let statuses_url = "/repos/" + owner + "/" + repositoryName + "/statuses/" + sha

      # do something, install, test, ...

      # Create a Status:
      # see: https://developer.github.com/v3/repos/statuses/
      #   Users with push access can create commit statuses for a given ref:
      #   POST /repos/:owner/:repo/statuses/:sha
      #
      # "http://ghe.k33g/api/v3/repos/k33g/stools/statuses/{sha}"

      # TODO: change status (several status in threads and with timer?)
      # Warning: synchronous code
      let result = gitHubClientEnterprise: postData(statuses_url, map[
        ["state", "error"],
        ["description", "Hi, I'm JarvisCI :)"],
        ["context", "CIFaker"],
        ["target_url", "http://zeiracorp:8888/golo_ci"]
      ]): data()
      log("==>> {0}", result)


    } # end of push


    return JSON.stringify(DynamicObject(): message("Hello from Golo-CI"))
  })

  # eg for status
  spark.Spark.get("/golo_ci", |request, response| {
    response: type("application/json")
    return JSON.stringify(DynamicObject(): message("Hello from Golo-CI"))
  })


}
