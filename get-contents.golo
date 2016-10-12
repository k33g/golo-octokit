#!/usr/bin/env golosh
module get_contents

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

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GHE_27_K33G")

  let ghCli = GitHubClient(
    uri= "http://github.at.home/api/v3",
    token= TOKEN_GITHUB_ENTERPRISE
  )

  # read content
  try {
    let content = ghCli: fetchContent(
      path="src/Container.js",
      owner="ACME",
      repository="stools",
      decode=true
    )
    #: content()

    println(content: get("content"))
    #println(content: getClass(): getName())

    let decodedContent = java.util.Base64.getDecoder(): decode(content: get("content"))

  } catch (err) {
    err: printStackTrace()
  }

  try {
    let content = ghCli: fetchContent(
      path="src/Maybe.js?ref=wip-maybe",
      owner="ACME",
      repository="stools",
      decode=true
    )
    #: content()

    println(content)
    #let decodedContent = java.util.Base64.getDecoder(): decode(content)

  } catch (err) {
    err: printStackTrace()
  }





  println("---------------------------------------------")
}
