# Guided Spec Creation

> Conversational prompts to help non-technical users create feature specifications.

---

## Opening

"Let's create a specification for your feature. I'll ask you some questions to understand what you need. You don't need any technical knowledge—just describe what you want in your own words."

---

## Section 1: The Basics

### Feature Name
"First, let's give this feature a name. In a few words, what would you call this?"

**Examples:**
- "User Authentication"
- "Payment Processing"
- "Dashboard Analytics"

### Summary
"Now, in 2-3 sentences, describe what this feature does and why it matters. Think: if someone asked 'what does this do?', what would you say?"

**Example Response:**
> "This feature lets users log into the app with their email and password. They should stay logged in even if they close the browser. It's important because right now users have to log in every time they visit."

### Target Users
"Who will use this feature? What type of user are they?"

**Prompt if stuck:**
- "Is this for all users, or a specific group like admins?"
- "Are these existing users or new users?"
- "Any users who should NOT have access?"

---

## Section 2: User Scenarios

### P1 — Must Have
"What are the absolute must-haves? If any of these don't work, the feature is broken."

**Prompt:**
"Complete this sentence: 'A user must be able to...'"

**Example Responses:**
- "A user must be able to log in with email and password"
- "A user must be able to log out from any page"
- "A user must see an error if their password is wrong"

### P2 — Should Have
"What's important but not critical? If we had to launch without it, we could—but we really want it."

**Prompt:**
"Complete this: 'It would be a problem if users couldn't...'"

**Example Responses:**
- "It would be a problem if users couldn't reset their password"
- "It would be a problem if users couldn't stay logged in"

### P3 — Nice to Have
"What would be a nice bonus? If we don't have time, it's okay to skip."

**Prompt:**
"Complete this: 'It would be nice if users could...'"

**Example Responses:**
- "It would be nice if users could use Google to sign in"
- "It would be nice if users could see their login history"

---

## Section 3: Success Criteria

### Defining Done
"How will we know this feature is complete and working? What should we be able to do or see?"

**Prompt:**
"Imagine testing this feature. What would you check?"

**Example Responses:**
- "I can log in with correct credentials"
- "I see an error with wrong credentials"
- "I'm still logged in when I come back tomorrow"

### Measuring Success
"After launch, how will you know if it's successful? Any numbers or outcomes you're looking for?"

**Prompt if stuck:**
- "Are there any metrics you track today?"
- "What does success look like in a month?"

---

## Section 4: Boundaries

### Out of Scope
"What should this feature NOT do? This helps prevent scope creep."

**Prompt:**
"Is there anything that sounds related but isn't part of this?"

**Example Responses:**
- "Password reset is a separate feature"
- "Admin user management is not included"
- "We're not doing social login in this phase"

### Limitations
"Any constraints we should know about? Things we can't change or must work with?"

**Prompt if stuck:**
- "Are there existing systems this must integrate with?"
- "Any deadlines or dependencies?"
- "Budget or technology constraints?"

---

## Section 5: Details (Optional)

### Visual References
"Do you have any mockups, wireframes, or sketches? Even rough drawings help."

**Prompt:**
"If you have design files or screenshots of similar features, share them."

### Similar Features
"Is there a feature elsewhere (in this app or another) that does something similar?"

**Prompt:**
"Is there anything you can point to and say 'like that, but...'?"

### Security Considerations
"Does this feature handle sensitive information? Login credentials, personal data, payments?"

**Prompt:**
"Anything here that would be bad if it got into the wrong hands?"

---

## Closing

"Great! I have enough to create your specification. Let me summarize what I heard:

**Feature:** [Name]
**Summary:** [What it does]
**Must Have:** [P1 list]
**Should Have:** [P2 list]
**Out of Scope:** [Exclusions]

Does this sound right? Anything you'd change or add?"

---

## Tips for Better Specs

### If the user is vague:
- "Can you give me an example?"
- "What would that look like to a user?"
- "Walk me through how someone would use this."

### If the user is too technical:
- "Let's step back—what problem does this solve for users?"
- "Forget the how for now—what should users be able to do?"

### If the user wants everything:
- "If you had to pick the three most important things, what would they be?"
- "What's the minimum we need for this to be useful?"

### If the user isn't sure:
- "That's okay—let's mark it as a question to answer later."
- "What would help you decide?"
