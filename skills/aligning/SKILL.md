---
name: aligning
description: Use when asked for a new feature, component, behavior change or project, before any plan or code, or when the user wants an idea or plan questioned hard
---

# Aligning

You are good at building, and you build what you believe the user wants. That belief is usually thinner than it feels. This skill finds out what they want, and why, before anything is built. Knowing the why, you make the hundred decisions they never mention the way they would.

## First: what do you know?

- **Everything that matters is in the request** ("make the icon cornflower blue"): do it, and say what you did.
- **Something non-trivial is missing:** start the conversation.

Otherwise, before building, in order: lay out the approaches in a message of their own and have the user pick one; write the design doc; get their approval of it; invoke `devorb:planning`. If nothing is open at your first message and there is one sensible way, the first three happen in that message.

## Facts are yours, decisions are theirs

Never ask what the project already answers, or reopen what they decided. In an existing project, or when they point at context (a spec, files, a handoff), dispatch a fresh subagent before your first message to report how the relevant parts work today and what the change would touch. Dispatch one for later facts too; don't wait on it, only questions that depend on the fact do. No subagent tool: look yourself. Decisions (what it does, for whom, which trade-off) are the user's: put each to them and wait.

**Code is not intent.** It records what the system does now, maybe by accident. A retention period, SLA, price or compliance duty you find in it is a guess about the business: write it as an assumption and have the user confirm it.

## Your first message

No "Using …" line and no skill or process names: open with the content. The message asks the user exactly one thing: one question with one unknown. Not "who, what and with whom?", not numbered options to pick from, not "correct me if I got it wrong" on top of the question (the question invites that already). Business rules you found in the code (deadlines, prices, retention) appear as assumptions ("the code uses 7 days; I'm treating that as an assumption"), never as settled facts.

- **They said what they want** (a spec, a plan, a detailed request): about 200 words. Echo it in your own words (what, for whom, why, as far as they said) and add what you found that bears on it. Say plainly anything they may not have considered that would change the request or how it's built: a constraint, a conflict, a cheaper path. End with one line inviting corrections. Then, if they haven't said why, ask that: one open question in their terms, with nothing to pick from. If they have, ask about the open point that would most change what gets built; when its choices can be named, sketch each with its trade-off and your pick. Nothing open: end with the short design (the approach, why the others don't fit, the design in a few lines) and ask them to approve it. That approval covers approach and design: then write the short doc as approved and invoke `devorb:planning`.
- **They haven't:** one open question with a single unknown (no "and" joining two asks, no second request), in their terms, about the biggest thing left unsettled, saying what the answer would change. For "a website for my bakery": "If it's mostly for people deciding whether to stop by, I'd lead with hours and what's in the case today; taking orders is a different site. What do you want someone to do when they land on it?"

Unless they asked for this conversation, end with a light offer: "Or if you'd rather I just dive in, say so." If they take it, or already said to just build it, state any big how-it-gets-made choice (platform, language) in one line and do the work through the normal flow. This skill and its gate end there.

## The conversation

Ask only when the answer changes what gets built and neither the request nor the project answers it. Otherwise state your call and its reason as a proposal they can correct. Process steps (writing up, where files go, looking further, how to show something) are your calls: do them and say so.

- **One open question per message.** Until you know why they want it, attach no example answers: their words carry intent your options can't. Once you know why, sketch the nameable choices of a decision, with trade-offs and your pick. "Just guess" or "what do you think?": propose something concrete.
- **Grilling round only on request.** When they ask to be grilled or for all the questions at once, follow `references/grilling-round.md`.
- **Plain words.** Match their vocabulary, pitched a little above it. No process jargon; never quote this skill.
- **Specific questions,** built on their last answer or on something found, so they think through a consequence they may have missed: "Voting closes before the meeting, and two members joined this month. Does someone who joins mid-round get a vote?"
- **Ground to cover, never read out as a list:** what it is and what makes it special; why now and what success looks like; goals, what's out, and what would make it a failure even if it works; prior art they loved or hated; what exists and what they tried; details they care about.
- **How it gets made** (platform, language, libraries): someone who raises the how wants options with your pick; someone who talks about outcomes hands it to you, so decide and state each call in a line. Build on what existing work uses. Your calls go in the design as yours, never as agreed.
- **Domain words.** A vague or overloaded term, or a hard-to-reverse decision settling: invoke `devorb:domain-modeling`.
- **Spike.** A quick throwaway build is often the cheapest way to learn. Offer one ("a quick throwaway version") when it helps. It skips the plan and the full process, and what it taught comes back into the conversation.

**Play it back.** As soon as you understand one part (who it serves, how one piece behaves), describe it back in about 200-300 words, then return to questions. Only what they said goes in as theirs; what you filled in is your proposal, with its reason. End each chunk asking what's wrong or missing. A part they'll look at (a screen, a page, a schedule) gets a text sketch beside it.

## Done understanding

You understand what they want when nothing that changes the build is open or silently assumed, and they have confirmed your playback. Then:

1. **Lay out the approaches** in a message of their own. Drop the weak ones (against their why, or ruled out by existing work). Sketch two or three concretely, grounded in the project, with trade-offs; recommend one and ask. If they handed you the how, say you'll go with your pick. One sensible way: say so and why the others don't fit.
2. **Size the work** in plain words: a small change gets a short doc, a project the full one and the reviewer (`references/size-and-red-flags.md`).
3. **Write the design doc**, one a talented builder could plan from without asking the user: intent and why; goals, non-goals, anti-goals; constraints; assumptions to confirm; approaches (considered, trade-offs, picked, why); the how they decided, as decided; what's left to the builder. Short doc: a line or two each. Save it to `docs/devorb/specs/YYYY-MM-DD-<topic>-design.md`, committed. You own this file: keep it current when a decision changes.
4. **Reviewer, for a project.** Tell the user a reviewer reads it first and you may come back once with a few questions. Dispatch a fresh subagent with `references/builder-check-prompt.md`. Sort what it asks: answered already (put the answer in the doc); minor (settle it, mark it as your call); theirs (only the user can answer, and it changes the build). Bring "theirs" in one message, most important first (one round only), update the doc, and hand it over with a short list of your calls. No subagent tool: read it as that builder yourself.

<HARD-GATE>
Nothing gets built until the user approves the design doc, short or full. Building includes product code, scaffolding, installing dependencies, creating projects and invoking an implementation skill. Reading and exploring are fine. Exceptions: they opted out of the conversation, or a spike they said yes to, which stays labeled throwaway; keeping it is a new request, back through this gate. After approval, the next step is `devorb:planning` and no other skill.
</HARD-GATE>

## Visual companion

A browser tab for mockups, diagrams and clickable throwaway prototypes. Offer it the first time the look itself is theirs to decide (a screen, a layout, a flow, options that look different), never upfront, in a message with nothing else: "This might be easier if I show you. Want me to open a browser tab with some mockups?" Declined: stay in text, and don't offer again unless they raise it. Accepted: per question, ask whether they'd understand it better by seeing it; scope and trade-offs stay in text. Read `references/visual-companion.md` before starting it.

## Connects to

- **Receives:** new work from `devorb:using-devorb`: an idea, feature or change, or a plan to question hard.
- **Uses:** fresh subagents for facts and for the reviewer; `devorb:domain-modeling` for terms and hard-to-reverse decisions; `references/` for the grilling round, sizing and red flags, the reviewer prompt and the companion.
- **Hands off to:** `devorb:planning`, with the approved `docs/devorb/specs/YYYY-MM-DD-<topic>-design.md`.
