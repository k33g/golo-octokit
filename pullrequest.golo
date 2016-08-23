module pull_request

import gololang.Errors
import goloctokit

function main = |args| {

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GITHUB_ENTERPRISE")

  let gitHubClientEnterprise = GitHubClient(
    uri= "http://ghe.k33g/api/v3",
    token= TOKEN_GITHUB_ENTERPRISE
  )

  # propose pull request
  gitHubClientEnterprise: createPullRequest(
    title="My pull request",
    body="hello :octocat:",
    head="wip-killer-feature-again",
    base="master",
    owner="k33g",
    repository="my-little-demo"
  )
}
