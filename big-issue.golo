module bigIssues

import goloctokit

function log = |txt, args...| -> println(java.text.MessageFormat.format(txt, args))

function main = |args| {

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GITHUB_ENTERPRISE")

  let gitHubClientEnterprise = GitHubClient(
    scheme= "http",
    host= "ghe.k33g",
    port= -1,
    token= TOKEN_GITHUB_ENTERPRISE
  )

  # Create a repository for the authenticated user
  #let res = gitHubClientEnterprise: createRepository(
  #  name="my-little-demo",
  #  description="this is my repository",
  #  private=false,
  #  hasIssues=true
  #)

let issueDescription =
"""
## this is my issue

:warning: I'm having a problem with this:

`JSON.parse(all)`
"""

  let issue = gitHubClientEnterprise: createIssue(
    title="Ouch!",
    body=issueDescription,
    owner="k33g",
    repository="my-little-demo",
    labels=["point: 21", "priority: high", "type: bug"],
    milestone=1
  )

  println(issue: number())

}
