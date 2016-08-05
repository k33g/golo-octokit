# golOctokit

GitHub API + Golo

```golo
# search users
let search = gitHubClient: searchUsers(keyword="k33g")
log("Total: {0}", search: total_count())

search: items(): each(|user| {
  log("user: {0} {1} score: {2}", user: login(), user: name(), user: score())
})

# create repository
let res = gitHubClientEnterprise: createRepository(
  name="my-little-demo",
  description="this is my repository",
  private=false,
  hasIssues=true
)

# add issue
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
  repository="my-little-demo"
)

# more to come...
# WIP
```

## Prerequisites

## Install Golo

- see http://golo-lang.org/

## Environment variables

- You have to create **personal access token** in your GitHub (.com, Enterprise, ...) settings with all rights
- Then, you have to set some environment variables:
  - eg: `sudo pico ~/.bash_profile`
  ```shell
  # === GitHub ===
  export TOKEN_GITHUB_DOT_COM=your_generated_token_for_dot_com
  export TOKEN_GITHUB_ENTERPRISE=your_generated_token_for_enterprise
  ```
It will be useful to authenticate and authorize your scripts.

## Run samples

- `golo golo --files imports/*.golo main.golo`
- `golo golo --files imports/*.golo repository.golo`
- `golo golo --files imports/*.golo issues.golo`
- `golo golo --files imports/*.golo labels.golo`
- `golo golo --files imports/*.golo milestones.golo`
- `golo golo --files imports/*.golo big-issue.golo`
- `golo golo --files imports/*.golo refs.golo`
- `golo golo --files imports/*.golo branch.golo`
- `golo golo --files imports/*.golo commits.golo`
- `golo golo --files imports/*.golo pullrequest.golo`
