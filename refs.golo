module refs

import gololang.Errors
import goloctokit

function log = |txt, args...| -> println(java.text.MessageFormat.format(txt, args))

function main = |args| {

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GITHUB_ENTERPRISE")

  let gitHubClientEnterprise = GitHubClient(
    uri= "http://ghe.k33g/api/v3",
    token= TOKEN_GITHUB_ENTERPRISE
  )

  let masterRef = gitHubClientEnterprise: getReference(
    ref="heads/master",
    owner="k33g",
    repository="my-little-demo"
  )
  log("sha of master: {0}", masterRef: object(): sha())

  gitHubClientEnterprise: createReference(
    ref="refs/heads/wip-killer-feature",
    sha=masterRef: object(): sha(),
    owner="k33g",
    repository="my-little-demo"
  )

  # no thread / synchronous :(

  println("---------------------------------------------")


}
