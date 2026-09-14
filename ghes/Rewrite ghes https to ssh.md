# Git HTTPS to SSH Rewrite for A*STAR GitHub Enterprise

## Purpose

This configuration allows Git repositories and `.gitmodules` files to continue using HTTPS URLs while Git automatically connects using SSH.

For example:

HTTPS:

https://ghes.a-star.edu.sg/tangtwk/test.git

is automatically rewritten to:

git@ghes.a-star.edu.sg:tangtwk/test.git

This is useful when you do not have HTTPS credentials but have a working SSH key.

It also works with TortoiseGit because TortoiseGit uses Git's configuration.

---

## 1. Configure the Git URL Rewrite

Run this command in Git Bash, PowerShell, or Command Prompt:

```bash
git config --global url."git@ghes.a-star.edu.sg:".insteadOf "https://ghes.a-star.edu.sg/"
```bash


## 8. Undo / Remove the SSH Rewrite

If you want Git to stop automatically converting the A*STAR HTTPS URLs to SSH, remove the global rewrite rule:


git config --global --unset url."git@ghes.a-star.edu.sg:".insteadOf