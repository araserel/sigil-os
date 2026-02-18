---
name: shared-context-sync
description: Orchestrates shared context operations — sentinel detection, repo identity, push/pull sync, cache management, and offline queue via GitHub MCP.
version: 1.2.0
category: shared-context
chainable: false
invokes: []
invoked_by: [learning-capture, learning-reader, sigil, connect-wizard, profile-generator]
tools: Read, Write, Edit, Bash, ToolSearch, mcp__github__get_file_contents, mcp__github__create_or_update_file, mcp__github__push_files
model: haiku
---

# Skill: Shared Context Sync

## Purpose

Provide shared context infrastructure for all Sigil skills. This skill handles:
- Sentinel file detection and validation
- Repository identity detection from git remote
- GitHub MCP availability checking
- Local cache management
- Offline queue management
- Push (on learning capture) and pull (on prime) sync operations

Other skills call into this skill's procedures rather than implementing sync logic themselves.

## Sentinel Detection

### Check if Shared Context is Active

Read `~/.sigil/registry.json`. If the file exists and is valid JSON, shared context may be active for the current project.

**Lookup procedure:**

1. Read `~/.sigil/registry.json`
2. If file missing or invalid JSON → return `{ active: false }`
3. Detect current project identity (see Repo Identity Detection below)
4. Look up current project in `projects` map
5. If found → return `{ active: true, shared_repo: projects[project].shared_repo }`
6. If not found → check `default_repo`
7. If `default_repo` is non-empty → return `{ active: true, shared_repo: default_repo }`
8. Otherwise → return `{ active: false }`

**Sentinel schema:**

```json
{
  "version": 1,
  "default_repo": "my-org/platform-context",
  "connected_at": "2026-02-09T14:30:00Z",
  "projects": {
    "my-org/web-app": {
      "shared_repo": "my-org/platform-context",
      "connected_at": "2026-02-09T14:30:00Z"
    }
  }
}
```

### Write Sentinel Entry

When `sigil connect` completes for a project:

1. Read existing `~/.sigil/registry.json` (or start with empty object if missing)
2. Set `version` to `1` if not present
3. Add/update entry in `projects` map keyed by current project identity
4. If this is the first project, also set `default_repo`
5. Set top-level `connected_at` to current timestamp
6. Write atomically: write to `~/.sigil/registry.tmp.json`, then rename to `~/.sigil/registry.json`

---

## Repo Identity Detection

Determine the current project's `owner/repo` identity from git remote.

**Procedure:**

1. Run `git remote get-url origin`
2. Parse the result:
   - SSH format: `git@github.com:owner/repo.git` → `owner/repo`
   - HTTPS format: `https://github.com/owner/repo.git` → `owner/repo`
   - HTTPS without .git: `https://github.com/owner/repo` → `owner/repo`
3. Strip trailing `.git` if present
4. Return `owner/repo` string

**Error cases:**

| Condition | Behavior |
|-----------|----------|
| No git repo | Return error: "Shared context requires a git repository. Run `git init` first." |
| No remote configured | Return error: "Shared context needs a git remote. Add one with `git remote add origin <url>`." |
| Remote is not GitHub | Return error: "Shared context currently requires a GitHub remote." |
| Parse failure | Return error: "Could not determine project identity from git remote." |

---

## GitHub MCP Detection

Check whether GitHub MCP tools are available in the current session.

**Procedure:**

1. Use `ToolSearch` with query `"+github get file"` to find GitHub MCP file tools
2. If `mcp__github__get_file_contents` is found → MCP is available
3. If no tools found → MCP is not available

**Key MCP tools used by shared context:**

| Tool | Purpose |
|------|---------|
| `mcp__github__get_file_contents` | Read files/directories from shared repo |
| `mcp__github__create_or_update_file` | Create or update a single file (with SHA for safe updates) |
| `mcp__github__push_files` | Push multiple files in a single commit (used for scaffolding) |

**When MCP is not available:**

Return a structured result indicating MCP is missing, with guidance text:

```
GitHub MCP is not configured. Shared context requires a GitHub connection.

To set it up, run this in your terminal:

  claude mcp add-json -s user github '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer YOUR_GITHUB_PAT"}}'

Replace YOUR_GITHUB_PAT with a GitHub personal access token
(Settings → Developer settings → Personal access tokens → Fine-grained tokens).

Then restart your Claude Code session.
```

---

## Local Cache Structure

The local cache mirrors the shared repo state and stores the offline queue.

**Directory layout:**

```
~/.sigil/
├── registry.json                    # Sentinel file
└── cache/
    └── shared/
        ├── last-sync.json           # Timestamp + hashes of last successful pull
        ├── learnings/               # Cached copy of shared learnings
        │   ├── web-app/
        │   │   ├── patterns.md
        │   │   ├── gotchas.md
        │   │   └── decisions.md
        │   └── api-server/
        │       └── ...
        ├── profiles/                # Cached sibling profiles (S2-102)
        │   └── api-server.yaml
        └── queue/                   # Pending offline writes
            └── 1707234600000.json
```

### `last-sync.json` Schema

Tracks when the last successful pull occurred and content hashes for "what's new" detection.

```json
{
  "last_pull": "2026-02-09T14:30:00Z",
  "content_hashes": {
    "learnings/web-app/patterns.md": "sha256:abc123...",
    "learnings/web-app/gotchas.md": "sha256:def456...",
    "learnings/api-server/patterns.md": "sha256:789ghi..."
  }
}
```

### Cache Initialization

When shared context activates for the first time (no cache directory exists):

1. Create `~/.sigil/cache/shared/` directory tree
2. Create empty `last-sync.json` with `{ "last_pull": null, "content_hashes": {} }`
3. Create empty `learnings/`, `profiles/`, and `queue/` directories

---

## Offline Queue

When an MCP write fails, persist the operation for later retry.

### Queue Item Schema

File: `~/.sigil/cache/shared/queue/{timestamp_ms}.json`

```json
{
  "operation": "append",
  "target": "learnings/web-app/patterns.md",
  "content": "## [2026-02-09] Use AbortController for fetch cancellation\n- **Contributor:** adam@example.com\n- **Context:** When making API calls that may be cancelled\n- **Solution:** Wrap fetch in AbortController, abort in cleanup\n- **Tags:** react, api, performance\n",
  "queued_at": "2026-02-09T14:30:00Z",
  "attempts": 0,
  "last_attempt": null,
  "error": null
}
```

### Queue Operations

**Enqueue (on MCP write failure):**

1. Create queue item JSON with `attempts: 0`
2. Use current timestamp in milliseconds as filename
3. Write to `~/.sigil/cache/shared/queue/`

**Drain (at session start or next successful MCP write):**

1. List all `.json` files in `~/.sigil/cache/shared/queue/`
2. Sort by filename (chronological order)
3. For each item:
   a. Read queue item JSON to get `target` path and `content`
   b. Determine shared repo from sentinel
   c. Attempt MCP write:
      ```
      mcp__github__get_file_contents(owner, repo, path=item.target)
      ```
      Then append content and write:
      ```
      mcp__github__create_or_update_file(
        owner, repo, path=item.target,
        content=existing + item.content,
        message="learning: sync queued entry",
        branch="main", sha=existing_sha
      )
      ```
   d. On success: delete the queue file, update local cache
   e. On failure: increment `attempts`, update `last_attempt` and `error`
   f. If `attempts >= 3`: log permanent failure, move to `~/.sigil/cache/shared/queue/failed/`
4. Report: "Synced X queued learnings. Y failed (see ~/.sigil/cache/shared/queue/failed/)."

**Queue Status:**

Return count of pending and failed items for display in `/sigil-learn` and `/sigil` status.

---

## Push Protocol

Called by `learning-capture` after writing a learning locally.

**Inputs:**
- `category`: "patterns" | "gotchas" | "decisions"
- `content`: The formatted learning entry (shared format with metadata)
- `repo_name`: Current project's repo name (from identity detection)

**Procedure:**

1. Check sentinel → if not active, return silently
2. Determine shared repo from sentinel lookup (e.g., `araserel/platform-context`)
3. Split shared repo into `owner` and `repo` parts
4. Determine target file path: `learnings/{repo_name}/{category}.md`
5. Get contributor email via `git config user.email`
6. **Read existing file via MCP:**
   ```
   mcp__github__get_file_contents(owner, repo, path=target_file_path)
   ```
   - If file exists: extract content and SHA from response
   - If file doesn't exist (404): start with category header (e.g., `# Patterns — {repo_name}\n\n`)
7. **Run duplicate detection** (see Duplicate Detection section below)
   - If duplicate found: skip push, return silently
8. Append new entry to existing content
9. **Write updated file via MCP:**
   ```
   mcp__github__create_or_update_file(
     owner, repo,
     path=target_file_path,
     content=updated_content,
     message="learning: add {category} entry for {repo_name}",
     branch="main",
     sha=existing_file_sha  # Required for updates, omit for new files
   )
   ```
   - **SHA safety (FR-019):** Always pass the SHA from step 6 when updating. If SHA mismatch occurs (concurrent write), re-read the file and retry once.
10. On success: update local cache copy at `~/.sigil/cache/shared/learnings/{repo_name}/{category}.md`
11. On failure: enqueue to offline queue (see Queue Operations)

**Shared learning entry format:**

```markdown
## [YYYY-MM-DD] Short title
- **Contributor:** {git config user.email}
- **Context:** When/why this applies
- **Solution:** The learning content
- **Related files:** path/to/file.ts (optional)
- **Tags:** tag1, tag2 (optional)
```

The contributor email is obtained from `git config user.email`.

**Graceful failure (FR-011):** If any MCP call fails, log a warning ("Shared sync unavailable, learning saved locally") and enqueue to the offline queue. Never block the user's workflow on sync failure.

---

## Pull Protocol

Called by `prime` at session start.

**Procedure:**

1. Check sentinel → if not active, return silently
2. Determine shared repo from sentinel lookup (e.g., `araserel/platform-context`)
3. Split shared repo into `owner` and `repo` parts
4. Read `~/.sigil/cache/shared/last-sync.json` for previous content hashes
5. **Read learnings directory via MCP:**
   ```
   mcp__github__get_file_contents(owner, repo, path="learnings/")
   ```
   This returns an array of directory entries. For each subdirectory (repo name):
   ```
   mcp__github__get_file_contents(owner, repo, path="learnings/{sub_repo}/")
   ```
   Then for each file (patterns.md, gotchas.md, decisions.md):
   ```
   mcp__github__get_file_contents(owner, repo, path="learnings/{sub_repo}/{file}")
   ```
6. For each file found:
   a. Compare SHA from response with cached SHA in `last-sync.json`
   b. If changed: decode content (base64) and update local cache at `~/.sigil/cache/shared/learnings/{sub_repo}/{file}`
   c. If unchanged: skip (cache is current)
7. **Read profiles directory via MCP** (for S2-102):
   ```
   mcp__github__get_file_contents(owner, repo, path="profiles/")
   ```
   Cache any profile files to `~/.sigil/cache/shared/profiles/`
8. Update `~/.sigil/cache/shared/last-sync.json` with new SHAs and timestamp
9. **Compute "what's new" diff:**
   - Compare new content with previous cache content
   - Count new `## [date]` heading entries that didn't exist in previous cache
   - Build list of new entry titles for display
10. Drain offline queue (see Queue Operations)
11. Return:
    - List of new learning entries (for "what's new" display)
    - Count of queued items synced
    - Any errors encountered

**On MCP failure during pull (FR-011):**

1. Log warning: "Shared context unavailable, using cached data."
2. Return cached data from `~/.sigil/cache/shared/`
3. Do NOT delete cache or sentinel
4. Still attempt queue drain (will also fail, items stay queued)
5. Continue session normally — MCP failure must never block session start

---

## Duplicate Detection (Rule-Based V1)

Before appending a learning to the shared repo (step 7 of Push Protocol), check for duplicates.

**Procedure:**

1. Parse existing entries from the target file (each `## [date] Title` block is one entry)
2. Extract keywords from the new entry's title and solution text
3. For each existing entry in the same category file:
   a. **Title similarity:** Compare normalized titles (lowercase, stripped of dates). If >70% word overlap → potential duplicate
   b. **Tag overlap:** If both entries have tags, check for ≥50% tag overlap
   c. **Recency:** If a potential duplicate was added within the last 7 days → strong duplicate signal
4. If all three signals match → **flag as duplicate**, skip the push
5. If only title matches but tags/recency differ → **allow** (may be a refinement)

**On duplicate detected:**

- Do NOT push to shared repo
- Do NOT queue locally
- Log: "Duplicate learning detected — skipping shared sync. Run `/sigil-learn --review` to manage."
- Still write locally (local capture is unaffected)

**Limitations (V1):**

- Keyword-based only, no semantic matching
- May miss paraphrased duplicates
- Errs on the side of allowing writes (better to have near-duplicates than miss entries)

---

## Profile Protocol

### Profile Push

Called by `profile-generator` after writing or updating `.sigil/project-profile.yaml`.

**Inputs:**
- `repo_name`: Current project's repo name (from identity detection)

**Procedure:**

1. Check sentinel → if not active, return silently
2. Determine shared repo from sentinel lookup (e.g., `araserel/platform-context`)
3. Split shared repo into `owner` and `repo` parts
4. Determine target file path: `profiles/{repo_name}.yaml`
5. Read local `.sigil/project-profile.yaml`
6. **Read existing file via MCP:**
   ```
   mcp__github__get_file_contents(owner, repo, path="profiles/{repo_name}.yaml")
   ```
   - If file exists: extract SHA from response
   - If file doesn't exist (404): SHA is null (new file)
7. **Write profile via MCP:**
   ```
   mcp__github__create_or_update_file(
     owner, repo,
     path="profiles/{repo_name}.yaml",
     content=local_profile_content,
     message="profile: update {repo_name} project profile",
     branch="main",
     sha=existing_file_sha  # Required for updates, omit for new files
   )
   ```
   - **SHA safety:** Always pass the SHA from step 6 when updating. If SHA mismatch occurs (concurrent write), re-read the file and retry once.
8. On success: update local hash cache at `~/.sigil/cache/shared/profile-hashes.json`
9. On failure: enqueue to offline queue with `operation: "overwrite"` and `target: "profiles/{repo_name}.yaml"`

**Graceful failure:** If any MCP call fails, log a warning ("Profile sync unavailable, profile saved locally") and enqueue to the offline queue. Never block the user's workflow on sync failure.

### Profile Pull

Called by `prime` at session start (as part of pull protocol).

**Procedure:**

1. Check sentinel → if not active, return silently
2. Determine shared repo from sentinel lookup
3. Split shared repo into `owner` and `repo` parts
4. **Read profiles directory via MCP:**
   ```
   mcp__github__get_file_contents(owner, repo, path="profiles/")
   ```
   This returns an array of directory entries. For each `.yaml` file:
   ```
   mcp__github__get_file_contents(owner, repo, path="profiles/{filename}")
   ```
5. For each profile file found:
   a. Compare SHA from response with cached SHA in `~/.sigil/cache/shared/profile-hashes.json`
   b. If changed: decode content (base64) and update local cache at `~/.sigil/cache/shared/profiles/{filename}`
   c. If unchanged: skip (cache is current)
6. Update `~/.sigil/cache/shared/profile-hashes.json` with new SHAs
7. Return sibling profile list (excluding current project's profile)

**On MCP failure during pull:**

1. Log warning: "Profile sync unavailable, using cached profiles."
2. Return cached profiles from `~/.sigil/cache/shared/profiles/`
3. Continue session normally — MCP failure must never block session start

### Profile Change Detection

Called by `prime` to determine if the local profile needs republishing.

**Procedure:**

1. Read `.sigil/project-profile.yaml` — if missing, return (no profile to sync)
2. Compute SHA256 hash of file contents
3. Read `~/.sigil/cache/shared/profile-hashes.json`
4. Compare local hash with cached `local_hash` entry
5. If different → trigger Profile Push, then update `local_hash` in cache
6. If same → skip (no changes since last sync)

**Cache schema (`~/.sigil/cache/shared/profile-hashes.json`):**

```json
{
  "local_hash": "sha256:abc123...",
  "remote_profiles": {
    "api-server.yaml": "github_sha_from_api",
    "web-app.yaml": "github_sha_from_api"
  }
}
```

---

## Scaffolding Protocol

Called by `connect-wizard` when a shared repo is empty or missing the expected structure.

**Procedure:**

1. Check repo contents via MCP:
   ```
   mcp__github__get_file_contents(owner, repo, path="/")
   ```
2. If repo only has README.md or is empty, scaffold using a single commit:
   ```
   mcp__github__push_files(
     owner, repo, branch="main",
     message="chore: initialize shared context structure",
     files=[
       { path: "README.md", content: <README content from connect-wizard> },
       { path: "shared-standards/.gitkeep", content: "" },
       { path: "profiles/.gitkeep", content: "" },
       { path: "learnings/.gitkeep", content: "" }
     ]
   )
   ```
3. On success: return `{ scaffolded: true }`
4. On failure: return error with message for connect-wizard to display

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Sentinel missing | Return `{ active: false }`. No error, no message. |
| Sentinel invalid JSON | Return `{ active: false }`. Log warning. |
| Git not available | Error: "Shared context requires a git repository. Run `git init` first." |
| No git remote | Error: "Shared context needs a git remote. Add one with `git remote add origin <url>`." |
| Remote is not GitHub | Error: "Shared context currently requires a GitHub remote." |
| MCP not available | Log warning on push/pull. Queue writes. Use cache for reads. |
| MCP read fails (network) | Use cached version. Log: "Shared context unavailable, using cached data." |
| MCP read fails (404) | File doesn't exist yet — start with empty content (for push) or skip (for pull). |
| MCP write fails (permissions) | "Could not write to shared repo. Ask your admin for write access to `{owner}/{repo}`." Queue locally. |
| MCP write fails (network) | Queue locally. Warn on next prime: "N learnings pending sync." |
| MCP write fails (SHA mismatch) | Re-read file, retry once. If still fails, queue locally. |
| Shared repo not accessible | "Could not reach `{owner}/{repo}`. Check that the repository exists and you have access." |
| Cache directory missing | Create it (first-time initialization). |
| Queue item exceeds 3 retries | Move to `failed/` directory. Log. |
| Registry exists but repo unreachable | Use cache. Warn user. Do not delete sentinel. |
| Profile file missing locally | Skip profile push/change detection. No error. |
| Profile push fails (MCP) | Queue locally. Warn: "Profile sync unavailable, saved locally." |
| Profile pull fails (MCP) | Use cached profiles. Log warning. |
| Profile hash cache missing | Create it (first-time initialization). |

---

## Integration Points

| Caller | Operation | When |
|--------|-----------|------|
| `learning-capture` | Push | After writing a learning locally |
| `learning-reader` | Read cache | Before loading local learnings |
| `prime` (session start) | Pull + queue drain | At session start |
| `sigil` | Sentinel check | During state detection |
| `connect-wizard` | Write sentinel, scaffold repo | During `sigil connect` |
| `learn` | Queue status | When displaying learning summary |
| `profile-generator` | Profile Push | After writing/updating `.sigil/project-profile.yaml` |
| `prime` (session start) | Profile Pull + change detection | At session start (alongside learning pull) |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-09 | Initial release — sentinel detection, repo identity, cache structure, queue management, push/pull protocols |
| 1.2.0 | 2026-02-09 | S2-102: Added Profile Protocol — profile push, pull, change detection, profile hash cache |
| 1.1.0 | 2026-02-09 | Added specific MCP tool references, scaffolding protocol, duplicate detection V1, expanded error paths, graceful fallback details |
