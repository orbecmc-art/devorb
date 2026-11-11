# When a control does nothing

Use this when a button, toggle or command runs without an error but nothing changes.

Read its handler and write the calls it makes in the order they run. Beside each call, note the state it sets and any state it clears or resets on the side. Look for a later call that puts back what an earlier one changed: that pair is usually the bug.

Then compare the state at the end of the handler with what the label tells the user will happen. The gap is evidence for phase 3: turn it into a hypothesis with a prediction, like any other.
