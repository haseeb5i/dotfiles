## Code standards

- **Find before you build.** Before writing anything, search for code that already does it and
  extend or fix that. Unsure where something belongs or what exists? Ask before building.
- **Verify before asking for a merge.** Run type-check and tests yourself, and say so in the PR,
  especially in repos with no CI on PRs (e.g. fe-platforms).
- **One place per piece of logic.** A setting or rule pasted into several hand-built copies is a
  violation. When the diff touches code that is already duplicated, the change should consolidate it.
- **One version of what works.** The diff uses the existing state or mechanism (e.g. the form's own
  quantity) rather than recomputing it and syncing it back.
- **Fix the cause.** Code that corrects state after the fact (an effect that pushes values back into
  line) means the design is wrong.
- **Whole fixes.** A bug fix closes every path to the bug, including ones "one settings change away".
- **Provided types and helpers.** A hand-declared type a library already ships, or a helper our
  packages already export, is a violation.
- **Names and types over comments.** A comment saying what a name or type could say should become
  that name or type.
- **Compare with the old code.** When a change isn't meant to alter behaviour, check each rewritten
  path against what the old code did: order of calls, where rollback or undo reads its old value
  from, and what a failure leaves behind. "Matches the spec" is not enough on its own.

These apply to every repo; a standard the repo documents overrides one here where they conflict.
