# Working on this repository (humans and agents)

- **Trunk-based.** `main` is the only long-lived branch. Work on a short-lived branch and open one
  PR into `main`; it is squash-merged once the required checks pass. Never push to `main`.
- **Merging is not releasing.** `main` builds the `edge` image; only a published release (a `v*`
  tag, from the draft release) builds `latest`.
- **PR titles follow Conventional Commits** with a type from `.github/conventional-commit-types.json`
  (checked by CI, and the label and release notes come from it).
- **Dependencies** are updated by Renovate (shared config in `thomas-lg/renovate-config`); do not
  bump them by hand in a feature PR. Security fixes arrive as `security` PRs at any time.
- **Supply chain.** Actions are pinned to commit SHAs and images to digests; keep it that way when
  adding one (Renovate keeps them current).
- **Secrets** never go in the repository, in a commit message or in a log.
- Technical files are written in English.
