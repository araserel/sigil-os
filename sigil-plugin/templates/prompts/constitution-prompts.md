# Guided Constitution Setup

> Plain-language prompts for a 3-round constitution setup accessible to non-technical users.

---

## Opening

"Let's set up your project's constitution — a short document that tells AI agents the rules for your project. Think of it as writing down 'how we do things here' so every tool respects your standards automatically.

This takes about 3 questions. I'll handle the technical details and just ask you the decisions that matter."

---

## Round 1: Stack Validation

### When Stack Detected

"I scanned your project and found:

- **Language:** [detected]
- **Framework:** [detected]
- **Database:** [detected]

Is this correct? Anything to add or change?"

### When Stack Detected from Foundation

"I have your technology choices from the Discovery phase:

- **Language:** [language] [version]
- **Framework:** [framework] [version]
- **Database:** [database] [version]

Does this look right?"

### When Stack NOT Detected

"I couldn't detect your tech stack automatically. No worries — a few quick questions:

- What programming language? (e.g., TypeScript, Python, Go)
- Using a framework? (e.g., Next.js, Django, Express)
- Using a database? (e.g., PostgreSQL, MongoDB, or none yet)

If you're not sure about any of these, just say so and I'll suggest something."

### When Detection Partially Succeeds

"I found some of your setup:

- **Language:** [detected]
- **Framework:** [detected or 'Not detected']
- **Database:** [detected or 'Not detected']

[For each undetected item:]
I couldn't detect your [item]. Are you using one? If so, which?"

### User Says "I Don't Know"

"No problem! Based on [what I can see / common choices], I'd suggest:
- [Suggested stack with one-line rationale each]

Want to go with this? You can always change it later."

---

## Round 2: Project Type

"What kind of project is this?

Why this matters: This shapes how much testing, security, and documentation I set up. You can always adjust later.

**1. MVP / Prototype**
Ship fast, add polish later. Minimal testing, flexible structure. Good for validating ideas quickly.

**2. Production App**
Balance speed with stability. Standard testing, proven patterns. Good for apps real users depend on.

**3. Enterprise**
Maximum rigor. Comprehensive testing, full documentation, strict reviews. Good for regulated industries or large teams."

### If User Says "Suggest" or "I Don't Know"

"Here's a quick way to decide:

- **Building something to test an idea?** → MVP
- **Building something people will use daily?** → Production App
- **Building for a large company or regulated industry?** → Enterprise

If you're not sure, **Production App** is a safe middle ground."

### After Selection — Confirmation

"Got it — **[Selected Type]**. Here's what I'll configure:

- **Testing:** [plain description]
- **Security:** [plain description]
- **Code reviews:** [plain description]
- **Documentation:** [plain description]

These are sensible defaults for [type]. Want to change anything, or move on?"

#### MVP Confirmation Details

- **Testing:** Essential paths tested before shipping
- **Security:** Standard protections — no secrets in code, user data stays private
- **Code reviews:** Major changes flagged for your approval
- **Documentation:** Light — just enough to stay organized

#### Production Confirmation Details

- **Testing:** Key features tested thoroughly, critical user journeys verified end-to-end
- **Security:** Login required by default, all user input validated, dependencies reviewed
- **Code reviews:** New packages, database changes, and security changes require your sign-off
- **Documentation:** Standard — clear enough for someone new to understand the project

#### Enterprise Confirmation Details

- **Testing:** Comprehensive coverage required, all features tested before shipping, performance verified
- **Security:** Maximum protection — audit trail, security review for all changes, vulnerability response plan
- **Code reviews:** All code changes reviewed, architecture decisions require explicit approval
- **Documentation:** Full documentation for every significant feature

---

## Round 3: Optional Preferences

"A few optional preferences. Say 'skip' to use smart defaults for all of these:

**1. External service approval**

Should I ask before adding features that need external services (like payment processors, email senders, or cloud storage)?

Why this matters: External services may have costs or require accounts to set up.

- **Yes (Recommended):** I'll flag these for your approval first
- **No:** I'll add them as needed

**2. Offline support**

Should the app work when users have no internet?

Why this matters: Offline mode means users can still access their data with poor signal, but it adds complexity.

- **Yes:** Works offline, syncs when connected
- **No (Default):** Requires internet connection

**3. Accessibility level**

How accessible should this be?

Why this matters: Accessibility ensures people with disabilities can use your app. It's also required by law in many countries.

- **Works for everyone (Recommended):** Follows international accessibility standards so all users can participate
- **Standard:** Basic accessibility included (keyboard navigation, readable text)"

### If User Says "Skip"

"Using smart defaults:
- I'll ask before adding external services
- Internet required (no offline mode)
- Full accessibility standards

Moving on to generate your constitution."

### If User Says "I Don't Understand" to Any Question

For external services:
"No worries. Basically: if building a feature requires signing up for another company's service (like Stripe for payments), should I check with you first? Most people say yes."

For offline:
"This means: can people use your app in airplane mode or with bad wifi? If you're not sure, 'No' is the simpler choice."

For accessibility:
"This means: will the app work for people who use screen readers, keyboard-only navigation, or have vision impairments? 'Works for everyone' is recommended and ensures you're covered."

---

## Gitignore Prompt

"One more thing — should your team share the project constitution via git?

Why this matters: If you work with a team, sharing the constitution means everyone (and all AI tools) follow the same rules. If you're working solo, it can stay local.

- **Yes (Recommended for teams):** Constitution is version controlled — everyone sees the same rules
- **No (Solo projects):** Constitution stays on your machine only"

---

## Summary and Confirmation

"Your constitution is ready! Here's what I set up:

**Tech Stack:** [Language] + [Framework] + [Database]

**Quality Level:** [Project Type]
- Testing: [plain description]
- Security: [plain description]
- Reviews: [plain description]

**Accessibility:** [plain description]

This is saved at `/.sigil/constitution.md`. All AI agents will follow these rules automatically.

Does this look right? Say 'yes' to confirm, or tell me what to change."

### After Confirmation

"Constitution saved. All future work on this project will follow these rules.

To view it later: `/sigil-constitution`
To update it: `/sigil-constitution edit`"

---

## Handling "Suggest" and "Accept Defaults"

When a user says "suggest", "default", "whatever you think", or similar at any point:

**DO:** Provide a clear explanation of what was configured.

"I've set up [specific choice]. This means [one-sentence impact explanation]. You can change this anytime by running `/sigil-constitution edit`."

**DON'T:** Silently accept without explanation.

---

## Handling Existing Constitution

"This project already has a constitution set up.

- **View it:** I'll show you what's configured
- **Start fresh:** I'll guide you through creating a new one (the old one will be replaced)
- **Cancel:** Keep everything as-is"

---

## Tips for the AI Agent

### For decisive users
Move quickly through rounds. Confirm at the end.

### For uncertain users
Offer defaults at every step. "If you're not sure, [X] is a safe choice."

### For "suggest" / "accept" responses
Always explain what was configured and why. Never silently accept.

### For technical users who want details
Respect their knowledge but don't assume everyone is technical. If they ask for specifics, provide them. But keep the default flow plain-language.

### For non-English speakers
Keep sentences short and clear. Avoid idioms and cultural references.
