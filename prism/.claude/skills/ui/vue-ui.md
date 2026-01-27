---
name: vue-ui
description: Implements Vue 3 components from design specifications. Supports Composition API, TypeScript, and common styling approaches.
version: 1.0.0
category: ui
chainable: true
invokes: []
invoked_by: [developer]
tools: [Read, Write, Edit, Bash, Glob]
inputs: [component_spec, design_tokens, accessibility_requirements]
outputs: [component_files, style_files, test_files]
---

# Skill: Vue UI

## Purpose

Implement Vue 3 components from design specifications using Composition API.

## When to Invoke

- Developer receives task to implement UI component
- Constitution specifies Vue as UI framework
- vite.config.ts or vue.config.js indicates Vue project

## Inputs

**Standard Contract:**
- `component_spec`: object
- `design_tokens`: object
- `accessibility_requirements`: object

**Optional:**
- `styling_approach`: string — "scoped" | "tailwind" | "css-modules"
- `test_framework`: string — "vitest" | "jest"

## Process

### Step 1: Detect Project Setup

```bash
# Check for Vue version
grep -E "\"vue\":" package.json

# Check for TypeScript
ls tsconfig.json

# Check styling approach
grep -l "tailwind" package.json tailwind.config.*

# Check test framework
grep -E "vitest|jest" package.json
```

### Step 2: Generate Component

```vue
<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md',
  disabled: false,
});

const emit = defineEmits<{
  click: [event: MouseEvent];
}>();

const classes = computed(() => [
  'btn',
  `btn--${props.variant}`,
  `btn--${props.size}`,
  { 'btn--disabled': props.disabled },
]);

function handleClick(event: MouseEvent) {
  if (!props.disabled) {
    emit('click', event);
  }
}

function handleKeyDown(event: KeyboardEvent) {
  if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault();
    if (!props.disabled) {
      emit('click', event as unknown as MouseEvent);
    }
  }
}
</script>

<template>
  <button
    :class="classes"
    :disabled="disabled"
    :aria-disabled="disabled"
    :tabindex="disabled ? -1 : 0"
    @click="handleClick"
    @keydown="handleKeyDown"
  >
    <slot />
  </button>
</template>

<style scoped>
.btn {
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  border: none;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.2s, opacity 0.2s;
}

.btn:focus-visible {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}

.btn--primary {
  background-color: #3b82f6;
  color: white;
}

.btn--primary:hover:not(.btn--disabled) {
  background-color: #2563eb;
}

.btn--secondary {
  background-color: #f3f4f6;
  color: #111827;
}

.btn--secondary:hover:not(.btn--disabled) {
  background-color: #e5e7eb;
}

.btn--sm {
  padding: 0.375rem 0.75rem;
  font-size: 0.875rem;
}

.btn--md {
  padding: 0.5rem 1rem;
  font-size: 1rem;
}

.btn--lg {
  padding: 0.75rem 1.5rem;
  font-size: 1.125rem;
}

.btn--disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
```

### Step 3: Generate Tests

```typescript
import { describe, it, expect, vi } from 'vitest';
import { mount } from '@vue/test-utils';
import CustomButton from './CustomButton.vue';

describe('CustomButton', () => {
  it('renders slot content', () => {
    const wrapper = mount(CustomButton, {
      slots: {
        default: 'Click me',
      },
    });
    expect(wrapper.text()).toContain('Click me');
  });

  it('applies variant class', () => {
    const wrapper = mount(CustomButton, {
      props: { variant: 'primary' },
    });
    expect(wrapper.classes()).toContain('btn--primary');
  });

  it('emits click event', async () => {
    const wrapper = mount(CustomButton);
    await wrapper.trigger('click');
    expect(wrapper.emitted('click')).toHaveLength(1);
  });

  it('does not emit click when disabled', async () => {
    const wrapper = mount(CustomButton, {
      props: { disabled: true },
    });
    await wrapper.trigger('click');
    expect(wrapper.emitted('click')).toBeUndefined();
  });

  it('handles keyboard activation', async () => {
    const wrapper = mount(CustomButton);
    await wrapper.trigger('keydown', { key: 'Enter' });
    expect(wrapper.emitted('click')).toHaveLength(1);
  });

  it('has correct aria attributes when disabled', () => {
    const wrapper = mount(CustomButton, {
      props: { disabled: true },
    });
    expect(wrapper.attributes('aria-disabled')).toBe('true');
    expect(wrapper.attributes('tabindex')).toBe('-1');
  });
});
```

## Output Format

### File Structure
```
src/components/CustomButton/
├── CustomButton.vue
├── CustomButton.test.ts
└── index.ts
```

**index.ts:**
```typescript
export { default as CustomButton } from './CustomButton.vue';
```

## Handoff Data

```json
{
  "files_created": [
    "src/components/CustomButton/CustomButton.vue",
    "src/components/CustomButton/CustomButton.test.ts",
    "src/components/CustomButton/index.ts"
  ],
  "styling_approach": "scoped",
  "test_framework": "vitest",
  "accessibility_implemented": true,
  "typescript": true
}
```

## Vue Patterns

### Composition API
- Use `<script setup>` syntax (preferred)
- Composables for shared logic
- Computed for derived state
- Watch for side effects

### Props & Events
- TypeScript interfaces for props
- defineEmits for type-safe events
- withDefaults for default values
- Prop validation when not using TS

### Slots
- Default slot for children
- Named slots for layout sections
- Scoped slots for render props pattern
- v-slot shorthand (#)

### State
- ref for primitives
- reactive for objects
- computed for derived values
- readonly for immutable exposure

### Styling
- Scoped styles by default
- :deep() for child component styles
- CSS modules for isolation
- Tailwind integration

## Human Checkpoint

**Tier:** Auto

## Error Handling

| Error | Resolution |
|-------|------------|
| Vue 2 detected | Suggest migration or use Options API |
| Missing TypeScript | Generate without types |
| Test framework not found | Default to vitest |
| Styling conflicts | Use scoped or CSS modules |
