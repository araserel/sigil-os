# Glossary

Plain-English definitions for terms used in Prism. If a word sounds technical, you'll find it here.

---

## Workflow Terms

| Term | What It Means |
|------|---------------|
| **Acceptance Criteria** | The checklist a feature must pass to be considered done |
| **Clarification** | A question-and-answer round that removes confusion from requirements |
| **Constitution** | Your project's rulebook — the standards that all features must follow |
| **Entity** | A type of data your app stores, like a User, Product, or Order |
| **Functional Requirement** | A specific thing the system must do (e.g., "show a login form") |
| **Handoff** | A package of documents passed to engineers so they can start building |
| **Non-Functional Requirement** | How well the system must work — speed, security, or accessibility |
| **Phase** | One stage of the workflow: Assess, Specify, Clarify, Plan, Tasks, Implement, Validate, or Review |
| **Specification (Spec)** | A written plan that describes what a feature should do — the "what," not the "how" |
| **Track** | The workflow path Prism picks based on size: Quick (small), Standard (medium), or Enterprise (large) |
| **User Scenario** | A short story: "As a [person], I want to [do something] so that [benefit]" |

---

## Priority and Status Terms

| Term | What It Means |
|------|---------------|
| **P1 / P2 / P3** | How important something is: P1 = must have, P2 = should have, P3 = nice to have |
| **Blocker** | A problem that stops all progress until someone fixes it |
| **Human Checkpoint** | A pause in the workflow where Prism waits for your approval before continuing |

---

## Technical Terms

| Term | What It Means |
|------|---------------|
| **API Endpoint** | A web address where your app sends or receives data — like a mailbox for software |
| **CLI** | Command Line Interface — the text-based window where you type commands |
| **Lint / Format** | Tools that check and fix code style automatically — like spell-check for code |
| **Plugin** | An add-on that gives a program new features (Prism is a plugin for Claude Code) |
| **QA Loop** | An automatic fix-and-check cycle that runs up to 5 times before asking for help |
| **Repository (Repo)** | A folder tracked by Git (version control software) that stores your project's history |

---

## Prism-Specific Terms

| Term | What It Means |
|------|---------------|
| **Agent** | An AI specialist that handles one type of work (e.g., Business Analyst, QA Engineer) |
| **Chain** | A sequence of skills that run together to complete a workflow |
| **Orchestrator** | The central agent that reads your request and sends it to the right specialist |
| **Skill** | A single, reusable ability an agent can use (e.g., "write a spec" or "check code quality") |

---

## Shared Context Terms

| Term | What It Means |
|------|---------------|
| **Shared Context** | A system that syncs learnings and standards across multiple code projects through a shared GitHub repository |
| **Shared Repo** | A GitHub repository that stores learnings and standards shared between projects (e.g., `my-org/platform-context`) |
| **Sentinel File** | The local connection file (`~/.prism/registry.json`) that maps your projects to their shared repo |
| **Shared Standards** | Organizational rules stored in `shared-standards/` in the shared repo, referenced by projects via `@inherit` markers |
| **@inherit** | A marker in your constitution (e.g., `<!-- @inherit: shared-standards/security.md -->`) that pulls in standards from the shared repo |
| **Offline Queue** | When the shared repo is unreachable, learnings save locally and sync automatically on your next `/prime` |

---

*Don't see a term? Check the [User Guide](user-guide.md) or [Command Reference](command-reference.md).*
