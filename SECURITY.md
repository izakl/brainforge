# Security Policy

## Scope

This repository is a documentation and process framework for AI-assisted software delivery.
It contains no runtime application code or production services.
The "security surface" is therefore primarily:

- GitHub Actions workflows under `.github/workflows/`
- Repository configuration (`.github/`, branch protections, CODEOWNERS)
- Documentation that could mislead operators into unsafe practices

## Supported versions

Only the `main` branch is supported. Tagged releases are not produced.

## Reporting a vulnerability

If you discover a security concern (for example: a workflow that could leak secrets, a
permissions misconfiguration, a supply-chain risk in a pinned action, or documentation
that recommends an unsafe pattern), please:

1. **Do not** open a public issue.
2. Use [GitHub's private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
   for this repository (Security tab → "Report a vulnerability").
3. Provide enough context for a maintainer to reproduce or assess the concern
   (file paths, workflow names, suspected impact).

See [`docs/security-and-secure-delivery.md`](docs/security-and-secure-delivery.md) for
framework-level guardrails on sensitive context handling, AI-agent safety, and secure-delivery checks.

You can expect an initial acknowledgement within a few business days.

## Non-security issues

For ordinary bugs, doc improvements, or framework suggestions, please open a regular issue
or pull request following [CONTRIBUTING.md](CONTRIBUTING.md).

For non-sensitive security hardening ideas (for example checklist improvements or sanitized process guidance), a regular public issue is appropriate.

## Hardening already in place

- GitHub Actions are pinned to major versions and updated weekly via Dependabot
  (`.github/dependabot.yml`).
- The markdown CI workflow uses least-privilege permissions (`contents: read`).
- Review routing is enforced via [CODEOWNERS](.github/CODEOWNERS).
- See [docs/governance-checklist.md](docs/governance-checklist.md) for the broader
  governance contract.
