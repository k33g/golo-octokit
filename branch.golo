module branch

import gololang.Errors
import goloctokit

function log = |txt, args...| -> println(java.text.MessageFormat.format(txt, args))

function main = |args| {

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GITHUB_ENTERPRISE")

  let gitHubClientEnterprise = GitHubClient(
    uri= "http://ghe.k33g/api/v3",
    token= TOKEN_GITHUB_ENTERPRISE
  )


  gitHubClientEnterprise: createBranch(
    name="wip-killer-feature-again",
    from="master",
    owner="k33g",
    repository="my-little-demo"
  )

  # no thread / synchronous :(

  println("---------------------------------------------")


}
