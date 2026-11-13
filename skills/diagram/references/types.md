# Diagram types

Twelve types cover what this skill draws. Pick by the question the reader brings, not by what looks richest. The limit column tightens the general budget of 9 nodes and 12 connectors; it never loosens it.

| Type | Reader's question | Mermaid | Own limit |
|---|---|---|---|
| Flowchart | What happens next, and where does it branch? | `flowchart TD` or `LR` | 9 nodes, 3 decision points |
| Sequence | Who sends what to whom, in what order? | `sequenceDiagram` | 5 participants, 1 `alt` or `loop` block |
| State machine | What states can one thing be in, and what moves it between them? | `stateDiagram-v2` | 8 states, one start, each end named |
| Architecture | Which parts exist, and which talk to which? | `flowchart LR` with `subgraph` per boundary | 8 parts, 2 boundaries |
| Data flow | Where does the data come from, what transforms it, where does it land? | `flowchart LR` | sources on the left, stores on the right |
| Entity relationship | What records exist and how do they relate? | `erDiagram` | 8 entities, key fields only |
| Swimlane | Who owns each step of a process that crosses people or teams? | `flowchart LR` with one `subgraph` per lane | 5 lanes |
| Timeline | What happened, or will, and when? | `timeline` | 8 events |
| Schedule | Which tasks overlap, and what blocks what? | `gantt` | 12 tasks |
| Tree | What contains or reports to what? | `flowchart TD` | depth 4 |
| Layer stack | What sits on what, from user to hardware? | `flowchart TB` with stacked `subgraph` | 6 layers |
| Quadrant | Where do items fall on two axes? | `quadrantChart` | 12 items, both axes named with their direction |

## Choosing between neighbours

- **Flowchart or state machine:** steps a process walks through are a flowchart; conditions one object stays in until an event moves it are a state machine. A login flow is a flowchart; an account that is `active`, `locked` or `pending reset` is a state machine.
- **Flowchart or sequence:** if the order of messages between named parties matters (browser, API, mail service), use a sequence. If only the path of decisions matters, use a flowchart.
- **Architecture or data flow:** architecture shows what exists and its connections at one moment; data flow follows one kind of data from start to rest. Draw the one the question asks; never both in one figure.
- **Swimlane or flowchart:** add lanes only when the handoffs between owners are the point.
- **Tree or layer stack:** a tree branches; layers do not. If every level has exactly one box, it is a stack, or a list.
- **Quadrant or table:** if the reader needs the exact values, use a table. A quadrant only says which side of each axis an item falls on.

## Per-type notes

- **Flowchart:** one start and named ends. A decision is a question with labelled exits (`yes`, `no`, or the actual values). The main path runs straight in one direction; exceptions branch off to the side.
- **Sequence:** participants in the order they first act, left to right. Replies dashed. One optional or repeated block at most; a second one means two diagrams.
- **State machine:** every arrow is labelled with the event that causes it. A guard condition goes in brackets after the event.
- **Architecture:** a boundary (network, trust zone, service) is a container drawn first, under its parts. External systems sit outside every boundary.
- **Entity relationship:** show the cardinality on every relationship. Leave out timestamps and fields the question does not need.
- **Timeline and schedule:** time runs left to right at an even scale. Mark today when it matters.
- **Quadrant:** name each axis with its low and high end, and each quadrant with what it means for a decision.

## Out of scope

Charts of quantities (bar, line, scatter, pie, treemap, Sankey) belong to data visualization, not here. Mind maps, Venn diagrams, journeys, blueprints and Wardley maps are not covered: use the nearest type above or a table. Importing draw.io, Excalidraw or another tool's file is also out: read its content and draw fresh.
