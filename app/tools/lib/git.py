from typing import List
from subprocess import run


def git_ensure_status_clean():
    status = run(["git", "status", "--porcelain"], capture_output=True, check=True)
    assert status.stdout == b""


def git_push(refs: List[str], remote="origin"):
    run(["git", "push", remote, *refs], check=True)


def git_commit(message: str):
    run(["git", "commit", "-m", message], check=True)


def git_add(files: List[str]):
    run(["git", "add", *files], check=True)


def git_tag(tag: str):
    run(["git", "tag", tag], check=True)


# vim: set et ts=4 sw=4:
