# Jargon Audit: How Prism Works Across Teams and Projects

## Flagged Terms

| Term | Location | Replacement Used | On Blocklist? |
|------|----------|-----------------|---------------|
| Repository / Repo | Title area, multiple sections | "project folder" with inline definition: "(git repositories where your code lives)" | Yes |
| Constitution | Multiple sections | Defined on first use: "constitution (the set of rules and preferences that guide how Prism works in your project)" | Yes |
| Hook | Sync diagram, key details | "git hook" described as "a safety net, pushing anything that was missed" | Yes |
| Config | Not used | Avoided entirely | Yes |
| Deploy | Not used | Avoided entirely | Yes |
| Init | Not used | Avoided entirely | Yes |
| CLI | Not used | Avoided entirely | Yes |
| Plugin | Not used | Avoided entirely | Yes |
| Marketplace | Not used | Avoided entirely | Yes |
| Supabase | Stage 2 section | Defined inline: "a Supabase database (a cloud-hosted data store your team sets up once)" | No (not on blocklist, but technical) |
| Symlinks | Claude Code memory section | Used in technical context for engineering audience | No |
| Pull request | Stage 3 section | Used without definition; assumed known by engineering audience | No |
| Spec | Multiple sections | Established Prism term; context makes meaning clear | No |
| Onboarding | Putting it all together | Common business term, no definition needed | No |
| Prototype | Product person section | Common term, self-explanatory in context | No |

## Reading Level

- **Flesch-Kincaid Grade Level:** ~7.4
- **Average sentence length:** 14 words
- **Pass/Fail:** Pass

## Visual Coverage

- **Procedure sections:** 5 (Big Picture, Product/Engineer flow, Sync flow, Central repo pattern, full weekly example)
- **Sections with visuals:** 4 (Big Picture, Product/Engineer flow, Sync flow, Central repo pattern)
- **Coverage ratio:** 80% (weekly example is narrative, not procedural -- visual not required)
- **Pass/Fail:** Pass (narrative sections exempt from visual requirement)

## Accessibility Check

- [x] Valid heading hierarchy (H1 > H2 > H3, no skipped levels)
- [x] All images have alt text (all 4 Mermaid diagrams have HTML comment alt text)
- [x] No color-only indicators (diagrams use labels and text, not colors, to convey meaning)
- [x] All link text is descriptive (no "click here" patterns)
- [x] Navigable by headings alone (each heading is self-explanatory)

## Diagram Rendering Notes

- All labels use Mermaid markdown syntax (backtick strings) instead of `\n` for line breaks
- Commands are bolded in diagram labels to distinguish them from descriptions
- Node labels kept short to avoid truncation in narrow viewports
