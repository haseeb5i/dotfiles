#!/usr/bin/env python3
"""Custom Antigravity CLI status line showing model, context usage, quota, cost, and git state."""

import json
import os
import re
import subprocess
import sys

RESET = "\033[0m"
BOLD = "\033[1m"
DIM = "\033[2m"

CYAN = "\033[36m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
MAGENTA = "\033[35m"
BLUE = "\033[34m"
GRAY = "\033[90m"
WHITE = "\033[97m"

ANSI_RE = re.compile(r"\033\[[0-9;]*m")

VIM_BADGES = {
    "NORMAL": "-- NORMAL --",
    "INSERT": "-- INSERT --",
    "VISUAL": "-- VISUAL --",
    "VISUAL LINE": "-- V-LINE --",
}


def fmt_tokens(n: float | int) -> str:
    """Format token counts compactly (e.g. 84k, 1.0M)."""
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M"
    if n >= 1_000:
        return f"{round(n / 1_000)}k"
    return str(int(n))


def fmt_duration(seconds: int | float) -> str:
    """Format reset countdown seconds concisely."""
    s = max(0, int(seconds))
    days, rem = divmod(s, 86400)
    hours, rem = divmod(rem, 3600)
    mins = rem // 60
    if days > 0:
        return f"{days}d{hours}h" if hours else f"{days}d"
    if hours > 0:
        return f"{hours}h{mins}m" if mins else f"{hours}h"
    return f"{mins}m" if mins > 0 else "<1m"


def visible_len(text: str) -> int:
    return len(ANSI_RE.sub("", text))


def git_info(vcs: dict | None, cwd: str) -> tuple[str, bool]:
    """Return (branch, dirty) from payload vcs or a fast git fallback."""
    if vcs and vcs.get("branch"):
        return str(vcs["branch"]), bool(vcs.get("dirty"))
    if not cwd or not os.path.isdir(cwd):
        return "", False
    if vcs and vcs.get("type") not in (None, "git"):
        return "", False
    try:
        branch = subprocess.check_output(
            ["git", "-C", cwd, "--no-optional-locks", "rev-parse", "--abbrev-ref", "HEAD"],
            stderr=subprocess.DEVNULL,
            timeout=0.4,
            text=True,
        ).strip()
        if not branch:
            return "", False
        dirty_out = subprocess.check_output(
            ["git", "-C", cwd, "--no-optional-locks", "status", "--porcelain", "--untracked-files=no"],
            stderr=subprocess.DEVNULL,
            timeout=0.4,
            text=True,
        ).strip()
        return branch, bool(dirty_out)
    except Exception:
        return "", False


def format_context(ctx: dict | None) -> str:
    """Format context window token usage (e.g. ctx 231k/1.0M)."""
    if not isinstance(ctx, dict):
        return f"{GRAY}ctx 0%{RESET}"
    pct = float(ctx.get("used_percentage") or 0.0)
    win = int(ctx.get("context_window_size") or 0)
    color = RED if pct >= 90 else YELLOW if pct >= 60 else WHITE

    if win > 0:
        used_tokens = pct / 100.0 * win
        return f"{GRAY}ctx{RESET} {color}{fmt_tokens(used_tokens)}/{fmt_tokens(win)}{RESET}"
    return f"{GRAY}ctx{RESET} {color}{pct:.1f}%{RESET}" if pct > 0 else f"{GRAY}ctx 0%{RESET}"


def format_quota(quota: dict | None) -> str:
    """Format the lowest active quota bucket remaining percentage and reset time."""
    if not isinstance(quota, dict) or not quota:
        return ""
    candidates = []
    for bucket_id, info in quota.items():
        if not isinstance(info, dict) or info.get("disabled"):
            continue
        frac = info.get("remaining_fraction")
        if frac is not None:
            candidates.append((float(frac), bucket_id, info))
    if not candidates:
        return ""

    frac, _, info = min(candidates, key=lambda item: item[0])
    pct_used = max(0.0, min(100.0, (1.0 - frac) * 100.0))
    color = RED if pct_used >= 80 else YELLOW if pct_used >= 50 else GREEN
    reset_sec = info.get("reset_in_seconds")
    reset_str = f" {GRAY}({fmt_duration(reset_sec)}){RESET}" if reset_sec is not None else ""
    return f"{GRAY}used{RESET} {color}{pct_used:.0f}%{RESET}{reset_str}"


def build_statusline(data: dict) -> str:
    sep = f" {GRAY}│{RESET} "
    width = int(data.get("terminal_width") or 120)
    parts: list[str] = []

    vim = (data.get("vim") or {}).get("mode")
    if vim:
        badge = VIM_BADGES.get(vim, f"-- {vim} --")
        if badge:
            style = GRAY if vim == "NORMAL" else f"{BLUE}{BOLD}"
            parts.append(f"{style}{badge}{RESET}")

    cycle = data.get("cycle_mode")
    if cycle:
        parts.append(f"{YELLOW}{cycle}{RESET}")

    model_name = (data.get("model") or {}).get("display_name")
    if model_name:
        parts.append(f"{CYAN}{model_name}{RESET}")

    parts.append(format_context(data.get("context_window")))

    quota_part = format_quota(data.get("quota"))
    if quota_part:
        parts.append(quota_part)

    ws = data.get("workspace") or {}
    cwd = ws.get("current_dir") or data.get("cwd") or ""
    branch, dirty = git_info(data.get("vcs"), cwd)
    if branch:
        dirty_mark = f"{YELLOW}*{RESET}" if dirty else ""
        parts.append(f"{MAGENTA}{branch}{RESET}{dirty_mark}")

    subagents = data.get("subagents") or []
    running_subs = sum(1 for s in subagents if isinstance(s, dict) and s.get("status") == "running")
    if running_subs:
        parts.append(f"{CYAN}agents:{running_subs}{RESET}")

    tasks = int(data.get("task_count") or 0)
    if tasks:
        parts.append(f"{CYAN}tasks:{tasks}{RESET}")

    queued = int(data.get("pending_input_count") or 0)
    if queued:
        parts.append(f"{YELLOW}queued:{queued}{RESET}")

    if (data.get("sandbox") or {}).get("enabled"):
        parts.append(f"{GREEN}sandbox{RESET}")

    line = sep.join(p for p in parts if p)
    while len(parts) > 2 and visible_len(line) > width:
        parts.pop()
        line = sep.join(p for p in parts if p)
    return line


def main() -> int:
    raw = sys.stdin.read().strip()
    data = json.loads(raw) if raw else {}
    if not isinstance(data, dict):
        data = {}
    sys.stdout.write(build_statusline(data))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception:
        raise SystemExit(0)
