# Prism OS Development Workflows

> Standard patterns for developing and extending Prism OS, for use as Claude.ai project knowledge.

**Last Updated:** 2026-01-28

---

## Repository Context

This guide is for **contributors developing Prism OS itself**, not end users of Prism. The repository has two distinct areas:

```
prism-os/                     # Development repository
├── CLAUDE.md                 # THIS file - dev instructions
├── PROJECT_PLAN.md           # Development roadmap
├── STATUS.md                 # Implementation status
│
└── prism/                    # THE PRODUCT (what users install)
    ├── .claude/              # Agents, skills, chains, commands
    ├── docs/                 # User documentation
    └── ...
```

**Key Rule:** Product code lives entirely in `prism/`. All paths inside product files are relative to `prism/` as the root.

---

## Adding a New Skill

### Step 1: Identify the Need

Before creating a skill, answer:

1. **What problem does this solve?**
2. **Is this reusable?** (If one-time operation, don't create a skill)
3. **Does a similar skill exist?** (Check `prism/.claude/skills/`)
4. **Where does it fit in the workflow?**

### Step 2: Choose the Category

| Category | Use When |
|----------|----------|
| `workflow` | Core workflow operations (spec, plan, tasks, preflight) |
| `qa` | Validation and fixing operations |
| `review` | Code, security, or deployment review |
| `research` | Information gathering and analysis |
| `learning` | Institutional memory operations |
| `engineering` | Technical documentation (ADRs, etc.) |
| `design` | UI/UX design, accessibility, framework selection |
| `ui` | Framework-specific component generation |

### Step 3: Create the Skill File

1. Copy the template:
   ```bash
   cp prism/templates/skill-template.md prism/.claude/skills/[category]/[skill-name].md
   ```

2. Fill in the YAML frontmatter:
   ```yaml
   ---
   name: skill-name          # Kebab-case identifier
   description: Brief desc   # < 100 characters
   version: 1.0.0           # Start at 1.0.0
   category: workflow        # One of the categories above
   chainable: true          # Can output feed into another skill?
   invokes: []              # Skills this skill calls
   invoked_by: []           # Skills that call this
   tools: Read, Write       # Claude Code tools used
   inputs: [required_input]
   outputs: [output_file]
   ---
   ```

3. Write required sections:
   - **Purpose** - What this skill accomplishes
   - **When Invoked** - Trigger phrases and context
   - **Workflow** - Step-by-step execution
   - **Input Schema** - Required/optional/auto-loaded inputs
   - **Output Schema** - What gets produced
   - **Error Handling** - How to handle failures
   - **Human Tier** - Auto/Review/Approve

### Step 4: Register the Skill

1. Update `prism/.claude/skills/README.md`:
   - Add to appropriate category table
   - Include skill name, purpose, version

2. If skill is invoked by an agent, update agent file:
   - Add to `invokes` list in agent definition
   - Update agent's skills documentation section

3. If skill is part of a chain, update chain file:
   - Add to skill sequence in `prism/.claude/chains/[chain-name].md`

### Step 5: Test the Skill

1. **Test in isolation:**
   ```
   [Manually invoke skill with known inputs]
   [Verify outputs match schema]
   ```

2. **Test in chain:**
   ```
   [Run through full workflow that includes skill]
   [Verify handoffs work correctly]
   ```

3. **Test error handling:**
   ```
   [Provide invalid inputs]
   [Verify graceful failure]
   ```

### Step 6: Update Status

1. Update `STATUS.md` if new skill added
2. Add to version history if modifying existing skill

---

## Adding a New Agent

### Step 1: Define the Role

Agents should have:
- **Clear responsibility** - Single domain of expertise
- **Phase ownership** - Which workflow phases it handles
- **Distinct triggers** - Keywords that route to it

### Step 2: Create the Agent File

Location: `prism/.claude/agents/[agent-name].md`

```yaml
---
name: agent-name
description: Role summary and when to invoke
version: 1.0.0
tools: [Read, Write, Edit, Bash, Glob, Grep]  # Permitted tools
active_phases: [Phase1, Phase2]
human_tier: Auto|Review|Approve
---

# Agent: [Agent Name]

## Role

[2-3 sentences describing primary responsibility]

## System Prompt

[Detailed behavior instructions for the agent]

## Trigger Words

**Primary:** "keyword1", "keyword2", "keyword3"
**Secondary:** "phrase1", "phrase2"

## Skills Invoked

| Skill | When |
|-------|------|
| `skill-name` | [Condition for invocation] |

## Handoff Protocol

### Receives From
- **[Agent]** when [condition]

### Hands Off To
- **[Agent]** when [condition]

## Human Tier

**Default Tier:** [Auto|Review|Approve]

[Description of when human intervention is needed]
```

### Step 3: Register the Agent

1. Update `prism/.claude/agents/README.md`:
   - Add to core team table
   - Document trigger words

2. Update Orchestrator routing logic in `prism/.claude/agents/orchestrator.md`:
   - Add to trigger word matrix
   - Update routing precedence if needed

### Step 4: Test Agent Routing

1. Test trigger word routing:
   ```
   "I need [trigger word]..."
   [Verify correct agent handles request]
   ```

2. Test phase-based routing:
   ```
   [In agent's active phase]
   [Verify agent takes ownership]
   ```

3. Test handoffs:
   ```
   [Complete agent's work]
   [Verify correct handoff to next agent]
   ```

---

## Running Validation/Linting

### Workflow Linter

The repository includes a Python linter for validating workflow structure:

```bash
# Run with verbose output
python3 tools/workflow-linter.py --verbose

# Run quietly (errors only)
python3 tools/workflow-linter.py
```

The linter checks:
- Skill file format validity
- Cross-reference integrity (invokes/invoked_by)
- Chain skill sequences
- Agent tool permissions
- Template completeness

### Manual Validation Checklist

Before committing changes:

- [ ] All paths in product files are relative to `prism/`
- [ ] Skill cross-references are valid (invokes/invoked_by)
- [ ] Agent trigger words don't overlap with existing agents
- [ ] Chain sequences include all required skills
- [ ] STATUS.md updated if implementation changed
- [ ] Version numbers incremented appropriately

---

## Testing Installation

### Local Installation Test

```bash
# Copy product to temp location
cp -r prism/ /tmp/test-project/

# Navigate to test location
cd /tmp/test-project/

# Verify structure
ls -la
ls -la .claude/

# Start Claude Code and test
claude

# Test commands
/prism help
/prism status
```

### Global Installation Test

```bash
# Run global install
./install-global.sh

# Navigate to a different project
cd /tmp/some-other-project/

# Verify global access
claude

# Test that Prism is available
/prism status
```

### Validation Points

1. **CLAUDE.md loads correctly** - Product brain recognized
2. **Paths resolve** - All referenced files exist
3. **Commands work** - /prism routes correctly
4. **Templates accessible** - Can use templates for new specs
5. **Preflight check passes** - No missing files or outdated enforcement

---

## Standard Claude Code Handoff Patterns

### Agent-to-Agent Handoff Format

When work transitions between agents, use this structure:

```markdown
## Handoff: [Source Agent] → [Target Agent]

**Feature:** [Feature Name]
**Phase Transition:** [From Phase] → [To Phase]

### Completed
- [Summary of work done]
- [Files created/modified]

### Artifacts
- `/specs/###-feature/spec.md` - Feature specification
- `/specs/###-feature/clarifications.md` - Q&A record

### For Your Action
- [Specific next steps for receiving agent]
- [Decisions needed]

### Context
- [Relevant constraints or concerns]
- [Constitution rules that apply]

### State Transfer
{
  "chain_id": "abc123",
  "spec_path": "/specs/001-feature/spec.md",
  "track": "Standard",
  "phase": "Plan"
}
```

### Skill Chain Handoff

Skills pass data through standardized output:

```json
{
  "status": "complete | partial | failed",
  "artifact_path": "/path/to/output.md",
  "summary": "Brief description of what was produced",
  "next_skill": "skill-name or null",
  "metadata": {
    "complexity_score": 5,
    "track": "Standard"
  }
}
```

### Human Escalation Format

When escalating to human:

```markdown
## Escalation Required

**Reason:** [Why human needed]
**Blocker:** [What's preventing progress]

### Context
[Background information]

### Options
A) [Option 1] - [Implications]
B) [Option 2] - [Implications]
C) [Escalate further]

### Recommended Action
[Suggestion with rationale]
```

---

## Version Management

### Semantic Versioning Rules

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| Breaking change to input/output | MAJOR | 1.0.0 → 2.0.0 |
| New feature, backward compatible | MINOR | 1.0.0 → 1.1.0 |
| Bug fix | PATCH | 1.0.0 → 1.0.1 |

### Where to Update Versions

1. **Individual skill:** Update `version` in frontmatter + version history
2. **Individual agent:** Update `version` in frontmatter
3. **System release:** Update `STATUS.md` and `VERSION` file
4. **Chain changes:** Update chain file version if sequence changes

---

## Common Development Tasks

### Adding a New Command

1. Create file: `prism/.claude/commands/[command-name].md`
2. Follow command format with YAML frontmatter
3. Update command reference in `prism/docs/command-reference.md`
4. Update quick reference in `prism/docs/command-reference.md`

### Adding a New Template

1. Create file: `prism/templates/[template-name].md`
2. Follow existing template structure
3. If guided prompts needed, add to `prism/templates/prompts/`
4. Update `prism/templates/README.md`

### Adding a New Chain

1. Create file: `prism/.claude/chains/[chain-name].md`
2. Define skill sequence with conditions
3. Include state transitions and human checkpoints
4. Update `prism/.claude/chains/README.md`
5. Update complexity-assessor if chain selection logic changes

### Updating Documentation

1. User docs go in `prism/docs/`
2. Keep quick-start.md under 5-minute read
3. Update command-reference.md for any command changes
4. Example walkthroughs go in `prism/docs/examples/`

### Adding a New UI Framework Skill

For new UI implementation skills (e.g., Angular, Svelte):

1. Use `design-skill-creator` as a guide
2. Create file: `prism/.claude/skills/ui/[framework]-ui.md`
3. Follow existing pattern from `react-ui.md`
4. Update UI/UX Designer agent's skill list
5. Add to design-chain.md framework options

---

## Debugging Tips

### Skill Not Found
- Verify file is in correct category directory
- Check filename matches `name` in frontmatter
- Ensure README.md is updated

### Chain Breaks
- Verify output schema matches next skill's input
- Check for version compatibility
- Ensure required fields are populated

### Agent Routing Wrong
- Check trigger word overlap with other agents
- Verify phase context
- Test with explicit agent name to isolate

### Handoff Data Missing
- Verify source skill populates all required fields
- Check state transfer JSON is valid
- Ensure artifact paths are correct

### Preflight Check Fails
- Run `./install-global.sh` to reinstall
- Check `~/.claude/` directory exists and has correct structure
- Verify CLAUDE.md enforcement section is present

---

## Quality Gates

### Before Pull Request

- [ ] Workflow linter passes
- [ ] Installation simulation works (local and global)
- [ ] Manual testing of changed components
- [ ] STATUS.md updated (if implementation changed)
- [ ] Version numbers incremented
- [ ] No hardcoded paths (use relative to prism/)

### Before Release

- [ ] All skills implemented (no stubs)
- [ ] E2E test scenarios pass
- [ ] Documentation complete
- [ ] Version history updated
- [ ] Known limitations documented
- [ ] Global installation tested
- [ ] Preflight check works correctly
