# Specs Directory

Contains feature specifications organized by feature number.

## Structure

Each feature gets its own numbered directory:

```
specs/
├── 001-user-authentication/
│   ├── spec.md              # Feature specification
│   ├── clarifications.md    # Q&A for ambiguity resolution
│   ├── plan.md              # Implementation plan
│   ├── tasks.md             # Task breakdown
│   ├── research.md          # Research findings (if applicable)
│   ├── data-model.md        # Data changes (if applicable)
│   ├── adr/                  # Architecture decisions
│   │   └── ADR-001-auth-approach.md
│   └── qa/                   # Validation reports
│       ├── task-T001-validation.md
│       └── task-T002-validation.md
├── 002-payment-processing/
│   └── ...
└── 003-dashboard/
    └── ...
```

## Naming Convention

- Directories: `###-feature-name` (zero-padded, kebab-case)
- Spec files: `spec.md`, `plan.md`, `tasks.md` (consistent names)
- ADRs: `ADR-###-topic.md`
- QA reports: `task-T###-validation.md`

## Creating New Features

New feature directories are created automatically by the `spec-writer` skill when you start specifying a new feature. The next available number is assigned automatically.

## Accessing Specs

Agents reference specs by path. The current feature is tracked in `/memory/project-context.md` so agents know which spec directory to work with.
