# Code floor

Read before the first code file of a task, and before grading a diff in review. Nine signals of junior code: it works today and charges the next person who touches it. Each line names the signal and what to write instead.

## How it binds

- **Writing:** leave none of the nine in your diff. One you keep needs a reason, written in your report.
- **Reviewing:** each signal in the lines the diff adds or changes, with no reason written, is a finding, **Important at least**, and higher when its effect is worse (a swallowed error that hides a failed write is Critical). Grade it where code quality is graded (the Standards axis, Part 2 of a task review), also when the same lines are listed elsewhere as beyond the spec. The fix is small only until something depends on the signal, so it is made before the merge, not after.
- **A reason** is a fact the reviewer can check: a second caller that exists, a requirement in the brief or spec, a documented constraint. It is written where the reviewer reads it: the implementer's report in a task review; in a branch review, the diff (a comment on the line), its description (commit message, pull request body) or a ruling handed with it. With a reason that checks out, the signal is not a finding. A reason that fails the check leaves the finding standing.
- **The repository's documented standards win.** Where a file that says how this repo writes code (`CLAUDE.md`, `CONTRIBUTING.md`, an ADR, linter config) asks for or allows something below, that line does not apply.
- **Signals, not style.** The floor refuses these nine and nothing else. Correct code that shows none of them passes it, also where a shorter version exists: length and taste are not findings.

## The nine signals

- **`useEffect` for derived state** (React code only): an effect that sets state computed from props or other state. Compute the value during render, inside `useMemo` when the computation is expensive.
- **Fetch inside a loop:** one network request per item, each awaited before the next. Ask once for the whole set (a batch endpoint, one request with the list of ids). Where the API has no batch form, send the requests together, with a bound on how many run at once.
- **A `catch` that swallows the error:** an empty `catch`, or one that only logs, after which the code carries on as if the call had worked. Let the error reach the caller, or handle it there: recover, or return a failure the caller has to check.
- **`any`** (TypeScript code only): written as a type, a cast or a parameter. Give the real type, or `unknown` with a check that narrows it where the shape is known only at run time.
- **An abstraction with a single use:** a factory, registry or lookup map, interface, base class, wrapper, generic parameter or option that has one implementation, one entry, or one caller that always passes the same value. Call the one thing directly; the abstraction arrives with the second real case. A plain function that names one step of a longer one is not this signal.
- **A new dependency for something of ten lines:** a package this diff adds to the manifest for what the language, the platform or a dependency already installed does in about ten lines (a date format, a deep clone, a debounce, a UUID). Write the lines or use what is installed, and take the package out of the manifest.
- **A comment that narrates the code:** it repeats what the next line does (`// loop over the users`) or tells the story of the change ("now uses the new helper"). Delete it, and rename where the code alone is unclear. A comment that gives the why (a constraint, a trade-off, a trap) stays.
- **A file that does everything:** one file this diff creates or grows that mixes responsibilities which change for different reasons (routing, business rules, storage, formatting). Split it by responsibility, along the plan's file structure when there is one. A long file with one responsibility is not this signal.
- **Dead code:** code this diff adds that nothing reaches: an exported function nothing calls and no requirement asks for, an unused variable, parameter or import, a branch that cannot run, code left commented out. Delete it; version control keeps it.

Reads over stored rows have four data-volume signals of their own. They are in `devorb:performance` and the reviewers' data-volume items grade them, so this list does not repeat them.
