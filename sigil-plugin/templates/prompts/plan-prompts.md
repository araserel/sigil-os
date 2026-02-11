# Guided Plan Review

> Prompts to help non-technical users understand and approve implementation plans.

---

## Opening

"I've created a technical plan for [Feature Name]. Let me walk you through it in plain terms. You don't need to understand all the technical details—I'll highlight the decisions that need your input."

---

## Section 1: Plain-Language Summary

### What We're Building
"Here's what we're going to build, in simple terms:

[Plain-language description of approach]

**Think of it like:** [Analogy to everyday concept]"

### Example:
> "We're building a login system. Think of it like a security desk at a building—users show their credentials (email/password), we check if they're valid, and if so, we give them a visitor badge (a token) they can show to access different areas without checking in again."

---

## Section 2: Key Decisions

### Presenting Technical Choices

For each significant decision, present as:

"**Decision: [Topic]**

We need to decide [what]. Here are the options:

**Option A: [Name]**
- What it means: [Plain explanation]
- Good because: [Benefits]
- Trade-off: [Downsides]
- Best for: [When to choose]

**Option B: [Name]**
- What it means: [Plain explanation]
- Good because: [Benefits]
- Trade-off: [Downsides]
- Best for: [When to choose]

**My recommendation:** Option [X] because [reason in user terms].

Which would you prefer?"

### Example Decision:
> **Decision: How should users stay logged in?**
>
> **Option A: Session Cookies**
> - What it means: The browser remembers the login, like a website remembering your shopping cart
> - Good because: Simple, works everywhere, users are familiar with it
> - Trade-off: Doesn't work well if users share devices
> - Best for: Standard web apps where users have their own devices
>
> **Option B: Token-Based Auth**
> - What it means: Users get a digital "key" that expires and renews automatically
> - Good because: More secure, works across devices, better for mobile
> - Trade-off: Slightly more complex, users might notice brief re-logins
> - Best for: Apps where security is critical or users switch devices
>
> **My recommendation:** Option B because you mentioned security is important and some users will use mobile.

---

## Section 3: What Will Change

### Files and Code
"Here's what will be added or changed in the codebase. You don't need to understand the technical details—this is mostly for the record:

- **New:** [Count] new files will be created
- **Changed:** [Count] existing files will be modified
- **Removed:** [Count] files (if any)

Nothing about the parts users see will break. Existing features will keep working."

### Data Changes (if applicable)
"The database needs some changes:

**What's changing:** [Plain description]
**Why:** [Reason]
**Risk:** [Low/Medium/High] — [What this means for users]
**Rollback:** If something goes wrong, we can [undo strategy]"

---

## Section 4: Dependencies

### New Tools/Libraries
"We'll need to add [N] new tools to make this work:

**[Library Name]**
- What it does: [Plain description]
- Why we need it: [Reason]
- Is it safe?: [Security status]
- Who maintains it?: [Reputation]"

### Prompt if user concerned:
"Would you like me to explain any of these in more detail, or research alternatives?"

---

## Section 5: Risks

### Presenting Risks
"Every plan has some risks. Here's what could go wrong and how we'll handle it:

**Risk: [Description]**
- How likely: [Low/Medium/High]
- Impact if it happens: [What would go wrong]
- How we'll prevent it: [Mitigation]
- Backup plan: [What we'd do if it happens anyway]"

### Prompt for risk tolerance:
"Are any of these risks concerning to you? We can adjust the approach to reduce specific risks."

---

## Section 6: What Happens Next

### Timeline (without dates)
"Here's the sequence of work:

1. **Setup:** [What happens first]
2. **Core work:** [Main implementation]
3. **Testing:** [Quality checks]
4. **Review:** [Final verification]

At each stage, you'll see progress and can provide feedback."

### Human Touchpoints
"Here's when I'll check in with you:

- **After planning:** Now (you're approving the approach)
- **During implementation:** [When significant milestones occur]
- **Before completion:** Final review before we're done"

---

## Section 7: Approval

### Summary Prompt
"To summarize the plan:

**Approach:** [One-line description]
**Key decision:** [Main choice made]
**New tools:** [Count] ([names])
**Risk level:** [Low/Medium/High]
**Main risk:** [Biggest risk and mitigation]

Do you approve this plan? Or would you like to:
- Change a decision
- Reduce risk in a specific area
- Get more detail on something
- Research alternatives"

---

## Handling Questions

### If user doesn't understand:
"Let me explain that differently. [Simpler analogy]"

"Think of it this way: [Everyday comparison]"

### If user is concerned about a choice:
"I hear your concern about [X]. Let me explain why I recommended this, and we can explore alternatives."

"What specifically worries you? Knowing that helps me address it."

### If user wants to change something:
"Absolutely, we can change that. Here's what that would mean: [Implications]"

"That's a valid preference. Let me update the plan."

### If user is overwhelmed:
"There's a lot here. The key things you need to decide are:
1. [Decision 1]
2. [Decision 2]

Everything else I can handle. Want to focus on just those?"

---

## Tips for Plan Reviews

### Keep it simple
- Lead with plain language, technical details at the end
- Use analogies to everyday concepts
- Focus on decisions, not implementation details

### Highlight what matters
- Users care about: Will it work? Is it safe? What could go wrong?
- Users don't need: File names, code patterns, technical architecture

### Respect user expertise
- They know their business and users better than we do
- Their concerns often reveal requirements we missed
- "That's a good point" is always appropriate
