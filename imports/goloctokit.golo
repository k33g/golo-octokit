module goloctokit

import Http
import JSON

----
# GitHubClient
----
struct gitHubClient = {
  baseUri, prefix, credentials
}

augment gitHubClient {

  function getHeaders = |this| -> [
    Http.header("Content-Type", "application/json"),
    Http.header("User-Agent", "GitHubGolo/1.0.0"),
    Http.header("Accept", "application/vnd.github.v3.full+json"),
    Http.header("Authorization", this: credentials())
  ]

  function getUri = |this, path| {
    return this: baseUri() + match {
      when this: prefix() is null or path: startsWith(this: prefix()) then path
      otherwise this: prefix() + path
    }
  }
  function getData = |this, path| {
    return Http.request("GET", this: getUri(path), null, this: getHeaders())
  }

  function postData = |this, path, data| {
    return Http.request("POST", this: getUri(path), JSON.stringify(data), this: getHeaders())
  }

  function putData = |this, path, data| {
    return Http.request("PUT", this: getUri(path), JSON.stringify(data), this: getHeaders())
  }

  # TODO: deleteData

  ----
  # getUser
  ----
  function getUser = |this, user| -> JSON.toDynamicObjectTreeFromString(this: getData("/users/"+user): data())

  ----
  # getUsers
  {
  "total_count": 12,
  "incomplete_results": false,
  "items": [
    {
      "login": "mojombo",
      "id": 1,
      "avatar_url": "https://secure.gravatar.com/avatar/25c7c18223fb42a4c6ae1c8db6f50f9b?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
      "gravatar_id": "",
      "url": "https://api.github.com/users/mojombo",
      "html_url": "https://github.com/mojombo",
      "followers_url": "https://api.github.com/users/mojombo/followers",
      "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
      "organizations_url": "https://api.github.com/users/mojombo/orgs",
      "repos_url": "https://api.github.com/users/mojombo/repos",
      "received_events_url": "https://api.github.com/users/mojombo/received_events",
      "type": "User",
      "score": 105.47857
    }
  ]
}
  ----
  function searchUsers = |this, keyword| ->
    JSON.toDynamicObjectTreeFromString(
      this: getData("/search/users?q="+keyword): data()
    )

  function getRepositories = |this, user| {
    let repositoriesList = JSON.parse(this: getData("/users/"+user+"/repos"): data())
    return repositoriesList: reduce(
      list[],
      |repositories, repo| -> repositories: append(JSON.toDynamicObjectTree(repo))
    )
  }

  function getCommits = |this, owner, repository| {
    let commitsList = JSON.parse(this: getData("/repos/"+owner+"/"+repository+"/commits"): data())
    return commitsList: reduce(
      list[],
      |commits, commit| -> commits: append(JSON.toDynamicObjectTree(commit))
    )
  }

  ----
  # createRepository

  Create a new repository for the authenticated user.

      POST /user/repos

  Create a new repository in this organization. The authenticated user must be a member of the specified organization.

      POST /orgs/:org/repos

  TODO: create repository structure
  ----
  function createRepository = |this, name, description, private, hasIssues| {
    return JSON.toDynamicObjectTreeFromString(this: postData("/user/repos", map[
      ["name", name],
      ["description", description],
      ["private", private],
      ["has_issues", hasIssues],
      ["auto_init", true]
    ]): data())
  }

  function createRepository = |this, name, description, organization, private, hasIssues| {
    return JSON.toDynamicObjectTreeFromString(this: postData("/orgs/"+organization+"/repos", map[
      ["name", name],
      ["description", description],
      ["private", private],
      ["has_issues", hasIssues],
      ["auto_init", true]
    ]): data())
  }

  ----
  # createIssue

  Any user with pull access to a repository can create an issue.

      POST /repos/:owner/:repo/issues

  TODO: create issue structure
  TODO: create issue with labels and milestone + assignees
  ----
  function createIssue = |this, title, body, owner, repository| {
    return JSON.toDynamicObjectTreeFromString(this: postData("/repos/"+owner+"/"+repository+"/issues", map[
      ["title", title],
      ["body", body]
    ]): data())
  }

  ----
  # createLabel

      POST /repos/:owner/:repo/labels

  ## Parameters

  - name	string	Required. The name of the label.
  - color	string	Required. A 6 character hex code, without the leading #, identifying the color.

  ----
  function createLabel = |this, name, color, owner, repository| {
    return JSON.toDynamicObjectTreeFromString(this: postData("/repos/"+owner+"/"+repository+"/labels", map[
      ["name", name],
      ["color", color]
    ]): data())
  }

  function createLabel = |this, label, owner, repository| { # label is a DynamicObject
    return JSON.toDynamicObjectTreeFromString(this: postData("/repos/"+owner+"/"+repository+"/labels", map[
      ["name", label: name()],
      ["color", label: color()]
    ]): data())
  }

  function createLabels = |this, labels, owner, repository| {
    let labelsList = list[]
    labels: each(|label| { # label is a DynamicObject
      labelsList: append(this: createLabel(label, owner, repository))
    })
    return labelsList
  }

  ----
  # getLabels

  List all labels for this repository

    GET /repos/:owner/:repo/labels

  ----
  function getLabels = |this, owner, repository| {
    let labelsList = JSON.parse(this: getData("/repos/"+owner+"/"+repository+"/labels"): data())
    return labelsList: reduce(
      list[],
      |labels, label| -> labels: append(JSON.toDynamicObjectTree(label))
    )
  }

  ----
  Create a milestone

      POST /repos/:owner/:repo/milestones

  - title	string	Required. The title of the milestone.
  - state	string	The state of the milestone. Either open or closed. Default: open
  - description	string	A description of the milestone.
  - TODO: due_on	string	The milestone due date. This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.

  ----
  function createMilestone = |this, title, state, description, owner, repository| {
    return JSON.toDynamicObjectTreeFromString(this: postData("/repos/"+owner+"/"+repository+"/milestones", map[
      ["title", title],
      ["state", state],
      ["description", description]
    ]): data())
  }

  function createMilestone = |this, milestone, owner, repository| { # milestone is a DynamicObject
    return JSON.toDynamicObjectTreeFromString(this: postData("/repos/"+owner+"/"+repository+"/milestones", map[
      ["title", milestone: title()],
      ["state", milestone: state()],
      ["description", milestone: description()]
    ]): data())
  }

  function createMilestones = |this, milestones, owner, repository| {
    let milestonesList = list[]
    milestones: each(|milestone| { # milestone is a DynamicObject
      milestonesList: append(this: createMilestone(milestone, owner, repository))
    })
    return milestonesList
  }

  ----
  # getMilestones

  List all milestones for this repository

    GET /repos/:owner/:repo/milestones

  ----
  function getMilestones = |this, owner, repository| {
    let milestonesList = JSON.parse(this: getData("/repos/"+owner+"/"+repository+"/milestones"): data())
    return milestonesList: reduce(
      list[],
      |milestones, milestone| -> milestones: append(JSON.toDynamicObjectTree(milestone))
    )
  }

}

----
# Constructor
----
function GitHubClient = |host, port, scheme, token| {
  let prefix = match {
    when host: equals("api.github.com") then null
    otherwise "/api/v3"
  }
  let uri = match {
    when port > 0 then scheme + "://" + host + port
    otherwise scheme + "://" + host
  }
  let credentials = match {
    when token isnt null and token: length() > 0 then "token" + ' ' + token
    otherwise null
  }
  return gitHubClient(
    baseUri= uri,
    prefix= prefix,
    credentials= credentials
  )
}
