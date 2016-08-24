module gh.dsl

import goloctokit

#augmentation proposal = {
#  function propose = |this|
#}

#augment gitHubClient with proposal

function GH = |client| {
  let gitHubClient = client
  return DynamicObject()
    : proposeTo(|this, buddies, message| {

        # create branch -> to become method of the dynamic object
        client: createBranch(
          name= this: branch(),
          from= this: from(),
          owner= this: owner() orIfNull this: organization(),
          repository= this: repository()
        )

        # create commit -> to become method of the dynamic object
        client: createCommit(
          fileName= this: fileName(),
          message= this: commitMessage(),
          content= this: content(),
          branch=this: branch(),
          owner= this: owner() orIfNull this: organization(),
          repository= this: repository()
        )

        # propose pull request
        return client: createPullRequest(
          title= this: pullRequestTitle(),
          body= message + " " + buddies: join(",") + "\n" + this: pullRequestBody(),
          head= this: branch(),
          base= this: from(),
          owner= this: owner() orIfNull this: organization(),
          repository= this: repository()
        )

      })
    : branch("master")  # default
    : from("master")    # default
    : fileName("")
    : content("")
    : commitMessage("...")

}
