# repo-template

Template for new `thomas-lg-lab` repositories: the standards digestarr and coffee-tracker follow,
ready from the first commit. Use it with **Use this template** on GitHub, or
`gh repo create thomas-lg-lab/<name> --template thomas-lg-lab/repo-template --public --clone`.

## What you get

| Area | In this template |
| --- | --- |
| Branching | Trunk-based: short branches, squash PRs into `main` ([AGENTS.md](AGENTS.md)) |
| Releases | release-drafter keeps a draft from PR labels; publishing it tags `vX.Y.Z` and builds `latest`; `main` builds `edge` |
| PR hygiene | Conventional Commit titles enforced, labels from the type, PR template, CODEOWNERS |
| Dependencies | Renovate through the central runner and shared preset of `thomas-lg-lab/renovate-config` (OSV security PRs, SHAs and digests pinned, 3-day release age) |
| Image | `image.yml`: build on every PR, Trivy gate on fixable criticals, multi-arch push, build provenance attestation |
| Supply chain | OpenSSF Scorecard (Security tab and badge), actions pinned to SHAs, `permissions` least-privilege |
| Protection | `.github/rulesets/main.json`: squash only, linear history, signed commits, required checks, no bypass. `.github/rulesets/code-owner-review.json` + `CODEOWNERS`: a change to `.github/` (the checks themselves) needs my approval |

## After creating a repository from it

1. `scripts/apply-standards.sh thomas-lg-lab/<name>`: merge settings, secret scanning, push protection
   and private vulnerability reporting, Dependabot alerts, the main ruleset.
2. Nothing for Renovate: the `thomas-lg-renovate` App is installed on every repository of the
   organisation, so the central runner picks the new one up on its next run.
3. Add the project's CI (build, tests, lint) and its job names to `required_status_checks` in
   `.github/rulesets/main.json`, then run the script again. Delete `image.yml` (and `docker-build`
   from the ruleset) if the project ships no image.
4. Replace this README, keep the badges:

```markdown
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/thomas-lg-lab/<name>/badge)](https://scorecard.dev/viewer/?uri=github.com/thomas-lg-lab/<name>)
```

