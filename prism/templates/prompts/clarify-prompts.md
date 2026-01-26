# Guided Clarification

> Prompts for systematically resolving specification ambiguities with non-technical users.

---

## Opening

"I have a few questions to make sure I understand your feature correctly. These will help avoid building the wrong thing. Most are quick to answer."

---

## Question Categories

### Scope Questions

**Purpose:** Clarify what's included and excluded

**Templates:**

"**Should [X] be part of this feature, or is that separate?**
- A) Include it in this feature
- B) That's a separate feature
- C) Not sure—let's discuss"

"**Does this apply to [user type A], [user type B], or both?**"

"**When you say '[term]', do you mean [interpretation A] or [interpretation B]?"

**Example:**
> "Should password reset be part of the login feature, or is that separate?"
> - A) Include password reset
> - B) Separate feature (we'll do it later)
> - C) Not sure

---

### Behavior Questions

**Purpose:** Clarify how things should work

**Templates:**

"**What should happen when [condition]?**"

"**If [scenario], should the system [option A] or [option B]?"

"**After [action], where should the user end up?"

**Example:**
> "After a successful login, where should the user go?"
> - A) Back to where they were before logging in
> - B) Always to the home page
> - C) To their profile/dashboard
> - D) Other (please describe)

---

### Edge Case Questions

**Purpose:** Handle unusual situations

**Templates:**

"**What if [unusual situation]?**"

"**How should we handle [error condition]?"

"**What happens if a user [unexpected action]?"

**Example:**
> "What if a user tries to log in while already logged in?"
> - A) Show a message that they're already logged in
> - B) Silently redirect to home
> - C) Let them log in again (switch accounts)
> - D) Other

---

### Data Questions

**Purpose:** Clarify data formats and validation

**Templates:**

"**What format should [data field] use?"

"**What values are valid for [field]?"

"**Is [field] required or optional?"

**Example:**
> "What password rules should we enforce?"
> - A) Minimum 8 characters (simple)
> - B) 8+ characters with number and special character (moderate)
> - C) Complex rules with strength meter (strict)
> - D) Other (describe your requirements)

---

### Priority Questions

**Purpose:** Understand importance and ordering

**Templates:**

"**Is [capability] must-have or nice-to-have?"

"**Which is more important: [option A] or [option B]?"

"**Can we launch without [feature]?"

**Example:**
> "Is 'Remember me' (staying logged in) a must-have for launch?"
> - A) Yes, must have it
> - B) Nice to have, but can launch without
> - C) Can skip it entirely for now

---

### Integration Questions

**Purpose:** Understand external connections

**Templates:**

"**Does this need to work with [system]?"

"**What should happen if [external service] is unavailable?"

"**Who manages [external dependency]?"

**Example:**
> "If our email service is down and we can't send login emails, should we:"
> - A) Show an error and block the action
> - B) Let them proceed and retry sending later
> - C) Offer an alternative (like SMS)

---

### Accessibility Questions

**Purpose:** Ensure inclusive design

**Templates:**

"**How should [feature] work for users who [accessibility need]?"

"**Should [information] be available in [alternative format]?"

"**What happens when [assistive technology scenario]?"

**Example:**
> "How should login errors be announced to screen reader users?"
> - A) Just show the error text (they'll find it)
> - B) Immediately announce the error
> - C) Both—show it and announce it

---

## Presenting Questions

### Grouping
Present 3-5 questions at a time, grouped by category:

"I have [N] questions in [Category]. Let's start there:

**Question 1:** [Question]
Options: [A/B/C]

**Question 2:** [Question]
Options: [A/B/C]"

### Context
Always explain why we're asking:

"I'm asking because [reason]. The answer will affect [impact]."

### Defaults
Offer sensible defaults for uncertain users:

"If you're not sure, I'd suggest [option] because [reason]. We can always change it later."

---

## Handling Responses

### Clear Answer
"Got it. I'll update the spec to reflect [answer]."

### Uncertain Answer
"That's okay to be uncertain. Let me explain the trade-offs:
[Option A] means [implication]
[Option B] means [implication]
Which sounds closer to what you want?"

### New Information
"That's helpful context I didn't have before. Let me add that to the spec."

### Changed Mind
"No problem—it's better to change now than after we build it. I'll update the spec."

### Conflicting with Earlier
"I want to check—earlier you said [X], but this suggests [Y]. Which should we go with?"

---

## Escalation Triggers

### When to escalate:

"This question touches on [business policy / legal / security]. You might want to check with [stakeholder] before we decide."

"I've asked about this a few times and we're still unclear. Would it help to have a quick call to talk through it?"

"This decision has significant implications. Let me summarize the options and you can decide with your team."

---

## Closing

### All Resolved
"Great! All my questions are answered. Here's a summary of what we clarified:

[Clarification summary]

I'll update the spec and move on to planning."

### Some Remaining
"We've clarified most questions. There are [N] I've marked as 'to be determined':

[List]

We can proceed with planning and come back to these, or resolve them now. Which would you prefer?"

---

## Tips for Clarification

### Keep momentum
- Ask related questions together
- Don't belabor minor points
- "Let's move on and come back if needed"

### Validate understanding
- "So to confirm: [restate answer]"
- "That means [implication]—correct?"

### Encourage honesty
- "There's no wrong answer here"
- "It's okay to say 'I don't know'"
- "We can change this decision later if needed"

### Watch for signs of frustration
- Too many questions? "Just a couple more, then we're done."
- Feeling interrogated? "These questions help avoid building the wrong thing."
- Want to just start? "I understand. Let me note the unknowns and we'll figure them out as we go."
