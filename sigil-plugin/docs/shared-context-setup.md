# Shared Context Setup Guide

Share learnings and standards across your code projects through a shared GitHub repository.

## What You Need

Before you start, make sure you have:

1. **A GitHub account** with access to create repositories.
2. **GitHub MCP** connected to Claude Code. If you are not sure, `/connect` will check for you and guide you through setup.
3. **A git repository** with a remote set for each project you want to connect.

## Step 1: Create a Shared Repository

Create a new repository on GitHub to hold your shared context.

1. Go to [github.com/new](https://github.com/new).
2. Name it something like `platform-context` or `shared-context`.
3. Make it **private** (recommended).
4. Add a short description (optional).
5. Click **Create repository**.

You should now see an empty repository on GitHub.

> **Tip:** If you are a solo developer with multiple projects, you can use the same shared repo for all of them. Teams can also share one repo across all their projects.

## Step 2: Connect Your Project

Open your project in Claude Code and run:

```
/connect your-username/platform-context
```

Replace `your-username/platform-context` with the path to your shared repo.

Sigil will:
- Check that GitHub MCP is available
- Verify access to the shared repo
- Set up the directory structure (if the repo is empty)
- Create a local connection file at `~/.sigil/registry.json`

You should now see a confirmation message with your shared repo and project details.

> **Note:** If GitHub MCP is not configured, Sigil will walk you through setting it up. Follow the on-screen instructions, then restart Claude Code and run `/connect` again.

## Step 3: Verify the Connection

Run `/sigil` to see the status dashboard. It should show:

```
Shared Context: Connected
  Repo: your-username/platform-context
  Queued: 0 pending syncs
```

Run `/prime` to pull the latest shared context. If the repo is new, there won't be any shared learnings yet.

You should now see shared context status in your session output.

## Step 4: Connect Additional Projects

Repeat Step 2 for each project you want to share context between.

1. Open the next project in Claude Code.
2. Run `/connect your-username/platform-context`.

Each project gets its own entry in `~/.sigil/registry.json`. All projects connected to the same shared repo share learnings.

## How It Works After Setup

### Learnings sync automatically

- When you capture a learning (via `/learn` or during task completion), it writes locally **and** pushes to the shared repo.
- When you start a session (via `/prime`), the latest shared learnings load automatically.
- A "what's new" summary shows any new entries since your last session.

### Project profiles sync too

Run `/profile` to create a project profile. It describes your tech stack, what your project exposes (APIs, events, packages), and what it consumes from other projects.

- When you create or update a profile, it publishes to the shared repo's `profiles/` directory.
- When you run `/prime`, profiles from connected projects load automatically.
- If your plan changes something another project depends on, Sigil warns you during planning.

> **Tip:** Profiles work even without shared context. In solo mode, `/profile` still generates a local profile that gives Sigil better understanding of your project.

### Offline support

If GitHub MCP is unreachable (network down, MCP not running):
- Learnings and profiles save locally and queue for later sync.
- Cached shared learnings and sibling profiles load from your last successful pull.
- Queued items sync automatically on your next `/prime`.

### Shared standards (optional)

If your shared repo has files in `shared-standards/`, you can reference them in your project's constitution:

```markdown
## Article 4: Security Mandates
<!-- @inherit: shared-standards/security-standards.md -->
```

During `/prime`, these markers expand with the referenced content from the shared repo.

## Disconnecting

To disconnect a project from shared context:

1. Open `~/.sigil/registry.json` in a text editor.
2. Remove the project's entry from the `projects` map.
3. If no projects remain, delete the file.

There is no `/disconnect` command. The connection file contains no secrets — just a repo path.

## Troubleshooting

### "GitHub MCP not found"

GitHub MCP is not configured in your Claude Code session.

**Fix:** Run this in your terminal:
```
claude mcp add-json -s user github '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer YOUR_GITHUB_PAT"}}'
```
Replace `YOUR_GITHUB_PAT` with a GitHub personal access token. Then restart Claude Code.

### "Could not reach the shared repo"

The repository doesn't exist or you don't have access.

**Fix:** Check that the repo path is correct (`owner/repo`) and that your GitHub token has access to the repository.

### "Could not write to shared repo"

You have read access but not write access.

**Fix:** Ask the repository owner to grant you write access, or use a GitHub token with the `repo` scope.

### Learnings not appearing in other projects

Learnings may not have synced yet.

**Fix:** Run `/prime` in the other project to pull the latest shared learnings. Check `/learn` to see if any items are queued.

### "Shared context unavailable, using cached data"

GitHub MCP failed during the pull. Sigil is using the last cached copy.

**Fix:** This is expected during network issues. Sigil continues working normally. The cache updates on your next successful `/prime`.
