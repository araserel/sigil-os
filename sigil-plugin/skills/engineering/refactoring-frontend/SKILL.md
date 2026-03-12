---
name: refactoring-frontend
description: Structured frontend refactoring with safety guarantees. Applies component extraction, state management restructuring, and accessibility preservation with bundle size monitoring.
version: 1.0.0
category: engineering
chainable: true
invokes: [test-generator]
invoked_by: [developer, architect]
tools: Read, Write, Edit, Bash, Glob, Grep
---

# Skill: Refactoring Frontend

## Purpose

Perform structured frontend code refactoring with safety guarantees. Ensures test and snapshot coverage exists before changes, applies refactoring in incremental steps, preserves accessibility attributes, and monitors bundle size impact throughout.

## When to Invoke

- Components have grown too large or complex
- State management needs restructuring (prop drilling, global state cleanup)
- Code review identifies UI architecture issues
- Accessibility audit requires component restructuring
- Bundle size optimization requires code splitting
- User requests "refactor component X" or "extract Y from Z"
- Design system migration or component library adoption

## Inputs

**Required:**
- `target_path`: string — Path to component file or directory to refactor
- `pattern`: string — Refactoring pattern to apply (see Patterns section)

**Optional:**
- `description`: string — Plain-language description of desired outcome
- `preserve_api`: boolean — Ensure component props/interface unchanged (default: true)
- `check_a11y`: boolean — Verify accessibility preservation (default: true)
- `check_bundle`: boolean — Monitor bundle size impact (default: true)
- `max_steps`: number — Maximum incremental steps before checkpoint (default: 10)

**Auto-loaded:**
- `project_context`: string — `/.sigil/project-context.md`
- `constitution`: string — `/.sigil/constitution.md` (for UI/UX standards)

## Patterns

### Component Extraction

Extract a section of a large component into a standalone, reusable component.

**When to use:** Component exceeds ~200 lines, renders distinct UI sections, or contains reusable UI patterns.

```
1. Identify the self-contained UI section to extract
2. Map all props, state, and callbacks used by the section
3. Create new component file with appropriate props interface
4. Move JSX/template and related logic to new component
5. Replace inline section with new component usage
6. Pass required props from parent
7. Verify rendering identical
8. Verify accessibility attributes preserved
```

### State Management Refactoring

Restructure how state flows through a component tree.

**When to use:** Prop drilling exceeds 3 levels, state logic is scattered, or performance issues from unnecessary re-renders.

```
1. Map current state flow (which components read/write which state)
2. Identify state that should be lifted, colocated, or extracted
3. Based on project patterns, apply appropriate strategy:
   - Context API extraction (React)
   - Composables extraction (Vue)
   - Store module creation (Redux, Zustand, Pinia, Vuex)
   - Signal/observable extraction (Solid, Svelte, Angular)
4. Migrate state consumers to new source
5. Remove prop drilling chains
6. Verify all consumers receive correct data
```

### Prop Drilling Elimination

Remove deeply passed props by introducing appropriate state sharing.

**When to use:** Same prop is passed through 3+ levels of components without being used by intermediate components.

```
1. Trace the prop from origin to final consumer(s)
2. List all intermediate components that just pass it through
3. Choose elimination strategy:
   - Context/Provider (React): for widely shared, infrequently changing data
   - Composition (Vue slots, React children): for template-level sharing
   - Store (any framework): for frequently changing or complex data
   - Component composition: restructure tree to remove intermediaries
4. Implement chosen strategy
5. Remove prop from intermediate component interfaces
6. Verify final consumers still receive correct values
```

### Bundle Impact Optimization

Restructure imports and components to reduce bundle size.

**When to use:** Bundle analysis shows large modules, unused imports, or opportunities for code splitting.

```
1. Analyze current bundle contribution of target
2. Identify optimization opportunities:
   - Dynamic imports for route-level code splitting
   - Lazy loading for below-fold components
   - Tree-shaking blockers (barrel file re-exports, side effects)
   - Heavy dependency replacement (moment → date-fns, lodash → individual imports)
3. Apply optimizations incrementally
4. Measure bundle delta after each change
5. Verify no runtime errors from lazy loading
```

### Accessibility Preservation Refactoring

Restructure components while ensuring all accessibility features are maintained.

**When to use:** Any refactoring that modifies DOM structure, event handlers, or ARIA attributes.

```
1. Audit current accessibility attributes:
   - ARIA roles, labels, descriptions
   - Keyboard event handlers (onKeyDown, onKeyUp)
   - Focus management (tabIndex, autoFocus, focus traps)
   - Screen reader text (sr-only, visually-hidden)
   - Color contrast and visual indicators
2. Create accessibility snapshot before refactoring
3. After each refactoring step, verify:
   - All ARIA attributes present in new structure
   - Keyboard navigation paths preserved
   - Focus order maintained
   - Screen reader announcements unchanged
4. Flag any accessibility regressions immediately
```

### Hook/Composable Extraction

Extract reusable logic from components into custom hooks or composables.

**When to use:** Same stateful logic appears in multiple components, or component has complex logic obscuring its rendering purpose.

```
1. Identify reusable stateful logic in the component
2. Map state, effects, and callbacks that form a cohesive unit
3. Create custom hook/composable:
   - React: useCustomHook()
   - Vue: useCustomComposable()
   - Svelte: custom store or action
   - Angular: injectable service
4. Move logic to hook, expose necessary return values
5. Replace inline logic with hook call
6. If same pattern exists elsewhere, replace those too
7. Verify behavior identical
```

## Process

### Step 1: Analyze Current Component Structure

```
1. Read the target component(s) and map:
   - Component tree (parent → children)
   - Props interface (received props and their types)
   - Internal state (useState, reactive, signals)
   - Side effects (useEffect, onMounted, lifecycle hooks)
   - Event handlers and callbacks
   - Rendered DOM structure

2. Identify framework and patterns:
   - React (class or functional), Vue (Options or Composition API),
     Svelte, Angular, Solid, etc.
   - CSS approach: CSS modules, styled-components, Tailwind, CSS-in-JS
   - State management: Redux, Zustand, Pinia, Vuex, MobX, Jotai, signals

3. Identify component consumers:
   - Search for imports of the target component
   - Map which props each consumer passes
   - Note any ref forwarding or imperative handle usage

4. Measure baseline:
   - Component line count
   - Number of props
   - State variables count
   - Render complexity
```

### Step 2: Verify Test and Snapshot Coverage

```
1. Search for existing tests:
   - Component tests (render, interaction, snapshot)
   - Integration tests involving the component
   - E2E tests covering the component's page/route

2. Check snapshot coverage:
   - Existing snapshot tests
   - Visual regression tests (if configured)

3. Assess coverage:
   - If adequate: proceed to Step 3
   - If insufficient:
     a. Invoke test-generator skill for the component
     b. Generate at minimum:
        - Render test (component mounts without error)
        - Props test (renders correctly with various props)
        - Interaction test (click/input handlers work)
        - Snapshot test (DOM structure captured)
     c. Verify tests pass against current code

4. Accessibility baseline:
   - Run any configured a11y tests (jest-axe, cypress-axe)
   - Document current ARIA attributes and keyboard behavior
```

### Step 3: Plan Refactoring Steps

```
1. Based on the selected pattern, decompose into atomic steps
2. Each step must be:
   - Small enough to verify independently
   - Reversible if tests fail
   - Focused on one concern (move OR modify, not both)

3. Order steps to minimize risk:
   - Create new files before modifying existing
   - Move code before changing interfaces
   - Update parent components last
   - CSS/style changes separate from logic changes

4. For each step, note:
   - Files to create or modify
   - Expected test behavior (pass/update snapshot)
   - Accessibility attributes to preserve
   - Bundle impact expectation

5. If steps exceed max_steps, checkpoint with user
```

### Step 4: Execute Incremental Steps

For each step in the plan:

```
1. Make the code change (single concern per step)

2. Run tests:
   - Component tests pass or snapshots update expectedly
   - No render errors or warnings
   - No type errors

3. Verify accessibility (if check_a11y):
   - ARIA attributes present in rendered output
   - Keyboard handlers still attached
   - Focus management unchanged
   - Run a11y linting if available (eslint-plugin-jsx-a11y, etc.)

4. Check bundle impact (if check_bundle):
   - Run build or bundle analysis
   - Compare chunk sizes to baseline
   - Flag if any chunk grows >5% unexpectedly

5. If tests pass and checks clear:
   - Record step as complete
   - Proceed to next step

6. If anything fails:
   - Revert the step
   - Analyze failure
   - Adjust approach and retry
```

### Step 5: Update Imports and Re-exports

```
1. Update all import paths for moved components
2. Create or update barrel files (index.ts) to preserve import paths
3. Update CSS/style imports if files moved
4. Update any dynamic imports or lazy loading references
5. Update Storybook stories if they exist
6. Update any path aliases in build configuration
7. Run full build to catch missed references
```

### Step 6: Verify Accessibility Preservation

```
1. Compare final accessibility state against baseline:
   - All ARIA roles still present
   - All ARIA labels and descriptions unchanged
   - Keyboard navigation paths functional
   - Focus order maintained
   - Screen reader experience unchanged

2. If a11y testing tools configured:
   - Run full accessibility test suite
   - Verify no new violations introduced

3. Manual checklist:
   - [ ] All interactive elements keyboard-accessible
   - [ ] All images/icons have alt text or aria-label
   - [ ] Form inputs have associated labels
   - [ ] Error states announced to screen readers
   - [ ] Focus visible on all interactive elements
   - [ ] Color is not the sole indicator of state
```

### Step 7: Validate and Report

```
1. Run full test suite
2. Run full build (verify no compilation errors)
3. Measure improvements:
   - Component sizes (before/after line counts)
   - Props complexity (before/after prop counts)
   - State distribution (before/after)
   - Bundle size delta
   - Reusability (new shared components/hooks)
4. Produce refactoring report
```

## Outputs

**Artifacts:**
- Refactored component files
- New extracted components or hooks
- Updated imports across the project
- Updated or new snapshot files
- New or updated tests (if test-generator was invoked)

**Handoff Data:**
```json
{
  "target": "src/components/UserDashboard.tsx",
  "pattern": "component-extraction",
  "steps_completed": 5,
  "steps_total": 5,
  "files_modified": [
    "src/components/UserDashboard.tsx",
    "src/components/index.ts"
  ],
  "files_created": [
    "src/components/UserStats.tsx",
    "src/components/UserActivity.tsx",
    "src/components/__tests__/UserStats.test.tsx",
    "src/components/__tests__/UserActivity.test.tsx"
  ],
  "tests_run": 28,
  "tests_passing": 28,
  "snapshots_updated": 2,
  "a11y_preserved": true,
  "a11y_attributes_verified": 14,
  "bundle_impact": {
    "before_kb": 45.2,
    "after_kb": 45.8,
    "delta": "+0.6 KB (+1.3%)",
    "acceptable": true
  },
  "metrics": {
    "before": {
      "target_lines": 340,
      "props_count": 8,
      "state_variables": 6,
      "child_components": 0
    },
    "after": {
      "target_lines": 120,
      "props_count": 3,
      "state_variables": 2,
      "extracted_components": 2,
      "child_components": 2
    }
  }
}
```

## Human Checkpoints

| Scenario | Tier | Behavior |
|----------|------|----------|
| Single component extraction | Auto | Execute with test verification |
| State management restructuring | Review | Present plan, may affect multiple components |
| Steps exceed max_steps | Review | Checkpoint with user before continuing |
| Bundle size increases >5% | Review | Present analysis, user decides to proceed or optimize |
| Accessibility regression detected | Approve | User must approve any a11y changes |
| Props interface changes (preserve_api: false) | Review | Document breaking changes for consumers |
| CSS/design changes as side effect | Review | Verify visual appearance acceptable |

## Error Handling

| Error | Resolution |
|-------|------------|
| No test coverage for component | Invoke test-generator before proceeding |
| Snapshot tests fail after extraction | Update snapshots if DOM change is intentional |
| Accessibility attribute lost during move | Immediately restore, investigate root cause |
| Bundle size significantly increases | Analyze cause — may need dynamic import or tree-shaking fix |
| Framework-specific pattern not recognized | Fall back to generic component analysis, ask user |
| CSS modules break after file move | Update CSS import paths, check for hardcoded paths |
| Circular component dependency created | Restructure extraction boundary |
| Type errors from changed prop interfaces | Update consumer components, add type exports |
| Storybook stories break | Update story imports and args |

## Example Invocations

**Extract components from a large dashboard:**
```
target_path: src/components/UserDashboard.tsx
pattern: component-extraction
description: "Dashboard is 340 lines. Extract stats panel and activity feed."

→ Step 1: Analyze — 340 lines, 8 props, 6 state vars
→ Step 2: Generate snapshot + interaction tests
→ Step 3: Plan 5 steps (create UserStats, create UserActivity,
          move logic, update parent, update imports)
→ Step 4: Execute — all tests pass after each step
→ Step 6: 14 ARIA attributes verified preserved
→ Result: Dashboard 120 lines, 2 new focused components
```

**Eliminate prop drilling:**
```
target_path: src/components/Settings/
pattern: prop-drilling-elimination
description: "Theme preference is drilled through 4 levels"

→ Step 1: Trace theme prop: App → Layout → Sidebar → Settings → ThemeToggle
→ Step 2: Tests exist for ThemeToggle and Settings
→ Step 3: Plan: create ThemeContext, wrap provider, consume in ThemeToggle
→ Step 4: Execute — remove theme prop from Layout and Sidebar
→ Result: 3 intermediate components simplified
```

**Extract custom hook:**
```
target_path: src/components/SearchBar.tsx
pattern: hook-extraction
description: "Search logic (debounce, API call, result caching) used in 3 components"

→ Step 1: Identify search state, debounce effect, API call, cache
→ Step 2: Tests exist for SearchBar
→ Step 3: Create useSearch() hook with same interface
→ Step 4: Replace logic in SearchBar, ProductFilter, UserSearch
→ Result: 3 components simplified, shared useSearch hook created
```

**Bundle optimization:**
```
target_path: src/pages/Dashboard.tsx
pattern: bundle-impact-optimization
description: "Dashboard page loads charting library even when charts tab not visible"

→ Step 1: Analyze — chart component contributes 180KB to main bundle
→ Step 2: Tests cover chart rendering
→ Step 3: Plan: lazy load chart component, add loading state
→ Step 4: Wrap with React.lazy + Suspense
→ Result: Main bundle reduced by 180KB, charts load on tab click
```

## Integration Points

- **Invoked by:** `developer` agent, `architect` during technical planning
- **Invokes:** `test-generator` skill (to ensure coverage before refactoring)
- **Works with:** Code review skill (validates refactoring quality), UI/UX design skills (for visual verification)
- **Outputs to:** Modified and new component files in the project
- **References:** Component library documentation, design system tokens

## Best Practices

1. **Tests and snapshots first** — Never refactor a component without test coverage
2. **One pattern at a time** — Don't extract components while also restructuring state
3. **Preserve accessibility always** — a11y regression is never an acceptable trade-off
4. **Monitor bundle size** — Refactoring should not bloat the bundle
5. **Small components over clever components** — Favor readability and composability
6. **Colocate related files** — Keep component, styles, tests, and stories together
7. **Revert early** — If a step breaks tests, revert rather than debugging forward
8. **Update stories** — Storybook stories are documentation; keep them current

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-03-11 | Initial release — full implementation |
