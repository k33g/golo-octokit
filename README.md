# golOctokit

GitHub API + Golo

## Prerequisites

## Install Golo

- see http://golo-lang.org/

## Environment variables

- You have to create **personal access token** in your GitHub (.com, Enterprise, ...) settings with all rights
- Then, you have to set some environment variables:
  - type ``
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
