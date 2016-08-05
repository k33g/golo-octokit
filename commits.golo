module commits

import gololang.Errors
import goloctokit

function log = |txt, args...| -> println(java.text.MessageFormat.format(txt, args))

function someMarkdownContent = ->
"""
# Big Title

Hello my name is @k33g
I :heart: Golo
```golo
let geek = -> 42
println(geek())
```
"""

function main = |args| {

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GITHUB_ENTERPRISE")

  let gitHubClientEnterprise = GitHubClient(
    scheme= "http",
    host= "ghe.k33g",
    port= -1,
    token= TOKEN_GITHUB_ENTERPRISE
  )

  # commit file
  gitHubClientEnterprise: createCommit(
    fileName="hello-world.md",
    message="this is my commit :octocat: :heart:",
    content= someMarkdownContent(),
    branch="wip-killer-feature-again",
    owner="k33g",
    repository="my-little-demo"
  )

  println("---------------------------------------------")
}
