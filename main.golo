module main

import gololang.Errors
import gololang.Async

import goloctokit

function log = |txt, args...| -> println(java.text.MessageFormat.format(txt, args))

function main = |args| {

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GITHUB_ENTERPRISE")
  let TOKEN_GITHUB_DOT_COM = System.getenv("TOKEN_GITHUB_DOT_COM")

  let gitHubClientEnterprise = GitHubClient(
    uri= "http://ghe.k33g/api/v3",
    token= TOKEN_GITHUB_ENTERPRISE
  )
  let gitHubClient = GitHubClient(
    uri= "https://api.github.com",
    token= TOKEN_GITHUB_DOT_COM
  )

  let k33g = gitHubClientEnterprise: getUser("k33g")
  log("login: {0} email: {1}", k33g: login(), k33g: email())
  log("avatar url: {0}", k33g?: avatar_url())

  let k33gRepositories = gitHubClientEnterprise: getRepositories("k33g")
  k33gRepositories: each(|repo| {
    log("repo: {0} owner: {1}", repo: name(), repo: owner(): login())
  })

  let commits = gitHubClientEnterprise: getCommits(owner="k33g", repository="stunning-couscous")

  commits: each(|commit| {
    log("🍄 sha: {0} author: {1}", commit: sha(), commit: commit(): author(): name())
  })

  let users = gitHubClientEnterprise: searchUsers(keyword="bu")
  users: items(): each(|user| { log("user: {0} score: {1}", user: login(), user: score()) })

  let search = gitHubClient: searchUsers(keyword="k33g")
  log("Total: {0}", search: total_count())

  search: items(): each(|user| { log("user: {0} {1} score: {2}", user: login(), user: name(), user: score()) })


}
