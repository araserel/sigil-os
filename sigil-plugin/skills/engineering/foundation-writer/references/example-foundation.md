# Foundation Writer: Example Foundation Document

> **Referenced by:** `foundation-writer` SKILL.md — complete worked example for reference.

## Example: TaskFlow Project

```markdown
# Project Foundation: TaskFlow

> **Created:** 2026-01-20
> **Status:** Approved
> **Discovery Track:** Greenfield

---

## Problem Statement

### What We're Building

A personal task management application that helps individuals track their daily tasks, set priorities, and maintain focus on what matters most.

### Target Users

- **Primary:** Individual professionals who want simple task tracking
- **Secondary:** Students managing coursework and deadlines

### Core Value Proposition

Simple, distraction-free task management without the complexity of enterprise tools.

### Success Metrics

- Users can create and complete tasks in under 10 seconds
- 80% of users return within a week
- Task completion rate above 60%

---

## Constraints

### Critical Constraints

| Constraint | Value | Impact |
|------------|-------|--------|
| **Platform** | Web | Browser-based SPA |
| **Budget** | Free tier | Vercel, Supabase free tiers |
| **Timeline** | Standard | 2-4 weeks MVP |
| **Team Size** | Solo | Single developer |

### Expanded Constraints

#### Technical
- **Offline:** No (always online)
- **Real-time:** No (standard refresh)
- **Performance:** Standard web app expectations
- **Integrations:** None required for MVP

#### Business
- **Compliance:** None required
- **Data residency:** No restrictions

#### Team
- **Known Skills:** React, JavaScript
- **Learning Budget:** Moderate (willing to learn TypeScript)

---

## Technology Stack

### Selected Stack

> **Pattern:** fullstack-nextjs

| Layer | Technology | Version | Rationale |
|-------|------------|---------|-----------|
| **Language** | TypeScript | 5.x | Type safety, builds on JS knowledge |
| **Framework** | Next.js | 14.x | React-based, excellent DX, free hosting |
| **Database** | PostgreSQL | 15+ | Reliable, Supabase free tier |
| **ORM** | Prisma | Latest | Type-safe queries, great DX |
| **Hosting** | Vercel | — | Free tier, Next.js optimized |
| **Auth** | Supabase Auth | — | Built into Supabase, free tier |

### Alternatives Considered

| Stack | Why Not Selected |
|-------|------------------|
| React SPA + Express | More setup complexity for solo project |
| Django | Would require learning Python, separate frontend |
| SvelteKit | Smaller ecosystem, less hiring pool if project grows |

---

## Preferences Captured

### Explicit
- "I want to use React" → Selected Next.js (React-based)
- "No paid services" → Chose free tier stack
- "Keep it simple" → MVP project type

### Inferred
- JavaScript experience → TypeScript recommended (gentle upgrade)
- Solo project → Chose simpler architecture (no microservices)
- Free budget → Vercel + Supabase free tiers

### Not Asked
- Framework (React preference captured early)
- Budget (stated "no paid services")
- Deployment (Vercel auto-selected with Next.js)

---

## Decisions Log

| # | Decision | Rationale | Alternatives |
|---|----------|-----------|--------------|
| 1 | Next.js for fullstack | React-based, free Vercel hosting, SSR/SSG flexibility | Create React App, Remix |
| 2 | PostgreSQL over SQLite | Supabase free tier, scales if needed | SQLite (simpler but limited) |
| 3 | TypeScript over JavaScript | Type safety worth the learning curve | JavaScript (already known) |
| 4 | Prisma for ORM | Type-safe, great DX, Next.js integration | Drizzle (newer, less docs) |
```

## Notes

This example demonstrates:
- All required sections populated
- Decisions linked to constraints
- Alternatives documented with trade-offs
- Preferences tracked (explicit vs inferred)
- Metadata complete with status and track
