# Git configuration

## Setup

Link this directory to Git's XDG configuration directory:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
ln -s /path/to/dotfiles/git "${XDG_CONFIG_HOME:-$HOME/.config}/git"
```

## Review aliases

These aliases support a review-first workflow for AI-assisted changes:

| Alias | Command | Purpose |
| --- | --- | --- |
| `git st` | `git status --short --branch` | Summarize the branch and worktree |
| `git d` | `git diff` | Review unstaged changes |
| `git ds` | `git diff --staged` | Review staged changes |
| `git ck` | `git diff --staged --check` | Check staged whitespace errors |
| `git ap` | `git add --patch` | Stage selected hunks interactively |
| `git lg` | `git log --oneline --decorate --graph -20` | Inspect recent history |
| `git last` | `git show --patch-with-stat --oneline` | Review the latest commit |

A typical review flow is:

```sh
git st
git d
git ap
git ds
git ck
git commit
git last
```
