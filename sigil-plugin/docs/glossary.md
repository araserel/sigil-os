# Glossary

Plain-English definitions for terms used in Sigil. If a word sounds technical, you'll find it here.

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
| **Phase** | One stage of the workflow: Assess, Specify, Clarify, Plan, Tasks, Implement, or Review. (Validation runs automatically within the Implement phase after each task.) |
| **Specification (Spec)** | A written plan that describes what a feature should do — the "what," not the "how" |
| **Track** | The workflow path Sigil picks based on size: Quick (small), Standard (medium), or Enterprise (large) |
| **User Scenario** | A short story: "As a [person], I want to [do something] so that [benefit]" |

---

## Priority and Status Terms

| Term | What It Means |
|------|---------------|
| **P1 / P2 / P3** | How important something is: P1 = must have, P2 = should have, P3 = nice to have |
| **Blocker** | A problem that stops all progress until someone fixes it |
| **Human Checkpoint** | A pause in the workflow where Sigil waits for your approval before continuing |

---

## Technical Terms

| Term | What It Means |
|------|---------------|
| **API Endpoint** | A web address where your app sends or receives data — like a mailbox for software |
| **CLI** | Command Line Interface — the text-based window where you type commands |
| **Lint / Format** | Tools that check and fix code style automatically — like spell-check for code |
| **Plugin** | An add-on that gives a program new features (Sigil is a plugin for Claude Code) |
| **QA Loop** | An automatic fix-and-check cycle that runs up to 5 times before asking for help |
| **Repository (Repo)** | A folder tracked by Git (version control software) that stores your project's history |
| **WCAG** | Web Content Accessibility Guidelines — the international standard for making websites usable by everyone, including people with disabilities. Sigil targets WCAG AA (the middle level) by default. |

---

## Configuration Terms

| Term | What It Means |
|------|---------------|
| **Personal Config** | Your personal settings stored in `.sigil/config.yaml`. This file is gitignored — each team member has their own. Contains user track and execution mode. |
| **User Track** | A personal setting that controls how Sigil communicates with you: `non-technical` (plain English, auto-decides technical details) or `technical` (shows implementation details, trade-offs, and specialist names) |
| **Execution Mode** | A personal setting that controls how specialists are selected: `automatic` (Sigil chooses) or `directed` (you choose, requires technical track) |
| **Specialist** | A domain-specific overlay that customizes a base agent's behavior for a particular type of work (e.g., an API Developer specialist makes the Developer agent focus on API contracts and backwards compatibility) |
| **Base Agent** | One of the 9 core agents (like Developer or QA Engineer) that a specialist extends with domain-specific behavior |
| **Specialist Selection** | The process of matching a task to the most appropriate specialist based on what files it touches and what it's about |

---

## Sigil-Specific Terms

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
| **Sentinel File** | The local connection file (`~/.sigil/registry.json`) that maps your projects to their shared repo |
| **Shared Standards** | Organizational rules stored in `shared-standards/` in the shared repo, referenced by projects via `@inherit` markers |
| **@inherit** | A marker in your constitution (e.g., `<!-- @inherit: shared-standards/security.md -->`) that pulls in standards from the shared repo |
| **Offline Queue** | When the shared repo is unreachable, learnings save locally and sync automatically on your next session start |
| **Project Profile** | A YAML file (`.sigil/project-profile.yaml`) that describes your project's tech stack, exposed APIs, consumed dependencies, and sibling relationships — used by agents for context and cross-repo impact warnings |

---

*Don't see a term? Check the [User Guide](user-guide.md) or [Command Reference](command-reference.md).*
