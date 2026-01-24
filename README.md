# gocode-shell / gomenu helpers

This mini-project contains the shell helpers used to jump into your code folder and interactively
choose a project with `gomenu`.

## Functions

- `gocode`: `cd` to `~/CodeFolder`.
- `gomenu`: interactive, colored project picker that:
  - sorts projects by most-recently-modified
  - lets you page through them (5 per page)
  - jumps into the selected project
  - detects virtualenvs, offers to activate/deactivate
  - can create a new `.venv` from `requirements.txt` when no venv exists.

## Usage

Source the functions from your shell config (already in `~/.bashrc`) and run:

```bash
gocode
gomenu
```
