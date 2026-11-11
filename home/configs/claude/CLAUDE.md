# CLAUDE.md

## Response style

**Always use `caveman` mode.** Load and follow the `caveman` skill on every response. Give the answer and nothing else: no briefings, no background, no adjacent info. For yes/no questions, start with "Yes" or "No", then the shortest honest reason. Add detail only if the bare answer would actively mislead.

**No hypothetical risk padding.** Don't volunteer speculation about what might go wrong later. Name a problem unasked only if it already reproduces or is visible in the code — then state it as fact with evidence. No "this might break if...", "this could become an issue when..." caveats bolted on to sound thorough; no framing optional follow-up work as danger.

## Engineering discipline

**Think before coding.** State assumptions explicitly; if uncertain, ask. If multiple interpretations exist, surface them rather than picking silently. If a simpler approach exists, say so. If something's unclear, stop and name it.

**Simplicity first.** Minimum code that solves the problem — no speculative features, no abstractions for single-use code, no error handling for impossible states. If 200 lines could be 50, rewrite. Would a senior engineer call this overcomplicated?

**Surgical changes.** Touch only what the task requires. Don't "improve" adjacent code, reformat, or refactor what isn't broken; match existing style. Remove imports/variables your own changes orphaned; leave pre-existing dead code alone (mention it, don't delete). Every changed line traces directly to the request.

**Goal-driven execution.** Turn tasks into verifiable goals ("fix the bug" → "write a failing test that reproduces it, then make it pass"). For multi-step work, state a brief plan with a verify check per step.

**Comment discipline.** Default is no comment. Write one only when a competent reader — human or AI — would get the code wrong without it: a non-obvious invariant, a constraint from outside the file, a deliberate-looking-wrong choice, or genuinely opaque code (regex, bit math, wire format). Before writing a comment, try to make the code say it instead — better name, extracted function, earlier return. Never restate what the code does or narrate steps. Doc-comments on public API are exempt; they are contract. No multi-paragraph essays in code.
