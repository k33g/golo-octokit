module milestones

import gololang.Errors
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

  # Create milestones


  let milestone = |title, state, description|->
    DynamicObject()
      : title(title)
      : state(state)
      : description(description)

  trying({
    return gitHubClientEnterprise: createMilestone(
      title="Inception",
      state="open",
      description="A discover phase, where an initial problem statement and functional requirements are created.",
      owner="k33g", repository="my-little-demo"
    )
  }): either(
    |value| -> println(value),
    |error| -> println(error)
  )

  trying({
    return  gitHubClientEnterprise: createMilestones(milestones=list[
      milestone("Elaboration", "open", "The product vision and architecture are defined, construction cycles are planned."),
      milestone("Construction", "open", "The software is taken from an architectural baseline to the point where it is ready to make the transition to the user community."),
      milestone("Transition", "open", "The software is turned into the hands of the user's community.")
    ], owner="k33g", repository="my-little-demo")

  }): either(
    |value| -> println(value),
    |error| -> println(error)
  )

  gitHubClientEnterprise: getMilestones(owner="k33g", repository="my-little-demo"): each(|milestone| {
    log("title: {0} state: {1}", milestone: title(), milestone: state())
  })

}
