# Pre-flight scan

Run it once, before Task 1, with the plan and the spec open. Write down what
you checked as you check it.

## What to look for

- **The plan against the spec.** For each spec requirement, the task that
  builds it. For each task, whether it builds what the spec says: the same
  behavior, the same values, nothing the spec rules out. A requirement no task
  covers, or a task that contradicts the spec on what gets built, is the
  fourth stop in SKILL.md: show the rows to the user and ask which one holds,
  before any code. Where the spec is silent and the plan decides, that is the
  plan doing its job, not a conflict.
- **Tasks against each other and the Global Constraints:** a task that
  produces one name or type and a later one that consumes another, two tasks
  that edit the same lines differently, a task that breaks a constraint.
- **What the plan mandates that the review rubric calls a defect:** a test
  that asserts nothing, a logic block duplicated verbatim.
- **Commands the plan tells you to run:** a script, flag or route that doesn't
  exist is a plan defect.

## The table

The output is a table, not a verdict:

- one row for every pair of tasks that share a file or an interface: the two
  tasks, what one produces against what the other consumes, what you found;
- one row for every task: whether its own text agrees with itself (the tests
  it specifies against the code it specifies, the files it creates against the
  files it later touches) and with the spec.

"The scan is clean" without those rows is not a scan you ran.

## Rulings

Write the table to the ledger. Rule on each conflict that isn't a stop, beside
its row, with the spec as the binding authority and the plan as its argument:
`Ruling: <what you decided> — <why> — <what it costs if wrong>`. A plan-mandated
defect still gets a ruling: weigh it against the plan text that mandates it.
If the scan is clean, start Task 1 without comment. The review loop remains
the net for conflicts that only show up during implementation.
