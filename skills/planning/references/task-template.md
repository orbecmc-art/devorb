# Plan Template

Every plan starts with this header and uses this task layout. Replace the
bracketed text; keep the headings.

## Header

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use devorb:implementing to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about the approach]

**Tech Stack:** [Key technologies and libraries]

**Spec:** [path to the design doc this plan implements, usually
`docs/devorb/specs/YYYY-MM-DD-<topic>-design.md`. The plan argues from the
spec, so the spec travels with it; executors read both.]

## Global Constraints

[The spec's project-wide requirements (version floors, dependency limits,
naming and copy rules, platform requirements), one line each, with exact
values copied verbatim from the spec. Every task's requirements include this
section.]

## Review Focus

[The five input classes or failure modes the spec implies but no task's tests
exercise that are most likely to bite a person using this software, one line
each, naming the input or condition and the behavior a reasonable person would
expect, most likely first. The spec says what the software must do, not
everything it will meet; its silence on an input is not permission for that
input to break the program. For each line, add the test that pins it to the
task that owns the code, in that task's own step style.]

## Rollout

[Only when the plan migrates data, changes a public interface, touches
authentication or ships a release. All four items, or the plan isn't ready.]

- **Order:** [which piece goes out first, and what each step waits for]
- **Side by side:** [how long old and new must both work, and what ends that period]
- **Getting back:** [how to return code and data to a good state, and who runs it]
- **Stays changed:** [what no rollback undoes: deleted data, sent messages, rotated keys]

---
```

## Task

The `### Task N:` header is a contract with `devorb:implementing`. Keep it
exactly: three hashes, `Task`, the number from 1 with no gaps, a colon, the name.

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Seam:** [the public interface this task's tests go through]

**Performance budget:** [only for a task that reads stored data: the volume it must hold and the time it must answer in, from the spec; default budget in `devorb:performance`]

**Interfaces:**
- Consumes: [what this task uses from earlier tasks, exact signatures]
- Produces: [what later tasks rely on: exact function names, parameter and
  return types. An implementer sees only their own task; this block is how
  they learn the names and types neighboring tasks use.]

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Implement `function(input: InputType) -> ResultType` in `exact/path/to/file.py`**

One line on the approach when the signature and the test leave a choice
(which library call, which data structure); a code block only for an
algorithm they do not determine.

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## Wide refactor tasks

Expand-contract keeps the same task layout. Name the batch in the task
(`### Task 3: Migrate callers in packages/billing`), and let Consumes point at
the expand task. The contract task's verification step shows that no caller of
the old form remains (the search command and its empty output).
