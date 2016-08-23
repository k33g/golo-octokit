module labels

import gololang.Errors
import goloctokit

function log = |txt, args...| -> println(java.text.MessageFormat.format(txt, args))

function main = |args| {

  let TOKEN_GITHUB_ENTERPRISE = System.getenv("TOKEN_GITHUB_ENTERPRISE")

  let gitHubClientEnterprise = GitHubClient(
    uri= "http://ghe.k33g/api/v3",
    token= TOKEN_GITHUB_ENTERPRISE
  )

  # Create labels
  trying({
    gitHubClientEnterprise: createLabel(name="point: 1", color="bfdadc", owner="k33g", repository="my-little-demo")
    gitHubClientEnterprise: createLabel(name="point: 2", color="d4c5f9", owner="k33g", repository="my-little-demo")
    gitHubClientEnterprise: createLabel(name="point: 3", color="c5def5", owner="k33g", repository="my-little-demo")
    gitHubClientEnterprise: createLabel(name="point: 5", color="1d76db", owner="k33g", repository="my-little-demo")
    gitHubClientEnterprise: createLabel(name="point: 8", color="006b75", owner="k33g", repository="my-little-demo")
    gitHubClientEnterprise: createLabel(name="point: 13", color="0e8a16", owner="k33g", repository="my-little-demo")
    gitHubClientEnterprise: createLabel(name="point: 21", color="5319e7", owner="k33g", repository="my-little-demo")
  })

  let label = |name, color|-> DynamicObject(): name(name): color(color)

  trying({

    let res = gitHubClientEnterprise: createLabels(labels=list[
      label("priority: high", "d93f0b"),
      label("priority: highest", "b60205"),
      label("priority: low", "fbca04"),
      label("priority: lowest", "fef2c0"),
      label("priority: medium", "f9d0c4"),
      label("type: bug", "d93f0b"),
      label("type: chore", "fbca04"),
      label("type: feature", "1d76db"),
      label("type: infrastructure", "5319e7"),
      label("type: performance", "006b75"),
      label("type: refactor", "c2e0c6"),
      label("type: test", "e99695"),
      label("type: implementation", "000000")
    ], owner="k33g", repository="my-little-demo")

  })

  gitHubClientEnterprise: getLabels(owner="k33g", repository="my-little-demo"): each(|label| {
    log("name: {0} color: {1}", label: name(), label: color())
  })

}
