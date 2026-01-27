# ADR-019: Adding UI/UX Designer as 9th Core Agent

## Status
Accepted

## Context

Prism OS's 8-agent architecture (D002) maps to engineering team roles but lacks a dedicated design function. Currently:
- UI component design decisions fall awkwardly between Architect (technical design) and Developer (implementation)
- Accessibility validation (D010) has no clear owner
- Framework selection for UI is ad-hoc
- There's no systematic way to integrate with design tools like Figma

The community has fragmented approaches: some create subagents per framework, others create skills, others combine both. This creates inconsistency and cognitive overhead.

## Decision

Add `uiux-designer` as the 9th core agent with responsibility for:
1. Component architecture and hierarchy
2. UX patterns and user flows
3. Accessibility requirements (WCAG compliance)
4. UI framework selection based on target platforms
5. Design system analysis and consistency
6. Figma integration (when available)

The agent operates in the **Plan phase** before the Architect, establishing UI/component design as a constraint that technical architecture must accommodate.

## Options Considered

### Option 1: Add design responsibilities to Architect
- **Pro:** Keeps 8 agents
- **Con:** Architect scope is technical systems, not visual/interaction design; cognitive overload

### Option 2: Add design responsibilities to Developer
- **Pro:** Keeps 8 agents
- **Con:** Conflates design thinking with implementation; Developer becomes catch-all

### Option 3: Add UI/UX Designer as 9th agent (Selected)
- **Pro:** Clear separation of concerns; maps to real team roles; owns accessibility
- **Con:** Breaks D002's "8 agents" but not its rationale (avoiding 137-agent explosion)

### Option 4: Separate UI and UX agents (10 agents)
- **Pro:** Maximum specialization
- **Con:** Too much friction for target non-technical users; UX research rarely needed in isolation

## Consequences

### Positive
- Clear ownership of UI design decisions
- Accessibility (D010) has a dedicated owner
- Framework selection becomes systematic
- Figma integration has a natural home
- Workflow mirrors real design → development handoff

### Negative
- Users must learn one additional agent (mitigated by trigger-word routing)
- Plan phase now has sub-ordering (UI/UX Designer → Architect)
- 9 agent definitions to maintain instead of 8

### Neutral
- New skills required to support the agent
- Chain definitions need updating

## Implementation

- Add agent definition: `.claude/agents/uiux-designer.md`
- Add design layer skills: `ux-patterns`, `ui-designer`, `accessibility`, `design-system-reader`, `figma-review`, `framework-selector`
- Add implementation layer skills: `react-ui`, `react-native-ui`, `flutter-ui`, `vue-ui`, `swift-ui`, `design-skill-creator`
- Update `full-pipeline.md` chain to include UI/UX Designer before Architect
- Update `CLAUDE.md` with new agent and routing

## References
- D002: 8 Core Agents decision (rationale preserved, number updated)
- D010: WCAG 2.1 AA Accessibility Default (now has owner)
- D007: Skill-Based Architecture (skills support the agent)
