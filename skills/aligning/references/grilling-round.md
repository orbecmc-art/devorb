# Grilling round

Only when the user asks for it: to be grilled, to have a plan or idea stress-tested, or to get all the questions at once. Otherwise the conversation stays at one open question per message.

## The rounds

Map the decisions as a tree: every decision branches into the decisions that hang off it. The **open set** is every decision whose prerequisites are already settled: the questions you can ask now without guessing at answers you haven't heard yet.

Ask the whole open set in one round. Number each question and give your recommended answer. Word each question so "yes" accepts your recommendation. Then wait for the answers.

```
**Q1. <question title>:** <question body, possibly several paragraphs, possibly with choices>

Recommended: <your answer>

---

**Q2. <question title>:** <question body>

Recommended: <your answer>
```

Each answered round reshapes the tree: settled decisions unblock the ones that depended on them. Recompute the open set and ask the next round. A question whose answer depends on another question still open in this round belongs to a later round.

Facts stay yours, as in the skill: a question that needs a fact from the project waits for the subagent that finds it, and only the questions downstream of that fact wait. Ask the rest now. Decisions stay the user's. "Tree" and "open set" are your bookkeeping: don't use the words with the user.

## When it ends

The round is done when the open set is empty: every branch visited, nothing left silently assumed. Don't act on it until the user confirms you reached a shared understanding. Then go back to the skill at "Done understanding" and lay out the approaches.

If the user only wanted an idea or a plan questioned, stop at the shared understanding and offer the design doc; don't write it unasked.
