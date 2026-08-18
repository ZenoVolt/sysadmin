# Switching Git Credential Manager Provider for GitHub Enterprise

These instructions explain how to switch the Git Credential Manager provider used for:

`https://ghes.a-star.edu.sg`

## Use the GitHub Provider

To use the **GitHub** credential provider, run:

```powershell
git config --global credential.https://ghes.a-star.edu.sg.provider github
```

This may be required to switch from the generic Git Credential Manager authentication flow to the GitHub-specific authentication flow.

The GitHub provider should be used when authenticating with a **fine-grained Personal Access Token (PAT)**.

## Use the Generic Provider

To switch back to the **generic** credential provider, run:

```powershell
git config --global credential.https://ghes.a-star.edu.sg.provider generic
```

> **Note:** The generic provider does not work with fine-grained PAT authentication.

## Check the Current Provider

To see which provider is currently configured, run:

```powershell
git config --global --get credential.https://ghes.a-star.edu.sg.provider
```

The output will be either:

```text
github
```

or:

```text
generic
```

## Quick Reference

| Action | Command |
|---|---|
| Switch to GitHub provider | `git config --global credential.https://ghes.a-star.edu.sg.provider github` |
| Switch to generic provider | `git config --global credential.https://ghes.a-star.edu.sg.provider generic` |
| Check current provider | `git config --global --get credential.https://ghes.a-star.edu.sg.provider` |

### Recommended Configuration

For `ghes.a-star.edu.sg`, especially when using a **fine-grained PAT**, configure the provider as:

```powershell
git config --global credential.https://ghes.a-star.edu.sg.provider github
```