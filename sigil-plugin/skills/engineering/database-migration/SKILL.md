---
name: database-migration
description: Generate and validate database migration files. Detects migration tooling from project and enforces safety checks for destructive changes.
version: 1.0.0
category: engineering
chainable: true
invokes: []
invoked_by: [developer, architect]
tools: Read, Write, Edit, Bash, Glob, Grep
---

# Skill: Database Migration

## Purpose

Generate, validate, and safety-check database migration files. Automatically detects the project's migration tooling, produces up and down migrations in the correct format, and flags destructive changes that could cause data loss.

## When to Invoke

- Schema change required by implementation plan
- New model or table needs to be created
- Column additions, removals, or type changes
- Index creation or modification
- Data migration between schema versions
- User requests "create migration for X"

## Inputs

**Required:**
- `change_description`: string — Plain-language description of the schema change

**Optional:**
- `migration_name`: string — Slug for the migration file (auto-generated if not provided)
- `target_models`: string[] — Paths to model/schema files for reference
- `dry_run`: boolean — Generate migration without writing files (default: false)
- `skip_rollback`: boolean — Skip rollback generation (default: false)

**Auto-loaded:**
- `project_context`: string — `/.sigil/project-context.md`
- `constitution`: string — `/.sigil/constitution.md` (for database conventions)

## Process

### Step 1: Detect Migration Tool

```
1. Scan project for migration tool indicators:

   JavaScript/TypeScript:
   - prisma/ directory, schema.prisma → Prisma
   - knexfile.js/ts → Knex
   - ormconfig.ts, data-source.ts → TypeORM
   - drizzle.config.ts → Drizzle
   - sequelize config → Sequelize

   Python:
   - alembic/ directory, alembic.ini → Alembic (SQLAlchemy)
   - django manage.py, INSTALLED_APPS → Django ORM
   - tortoise config → Tortoise ORM

   Go:
   - goose binary or config → Goose
   - golang-migrate config → golang-migrate
   - atlas.hcl → Atlas

   Java/Kotlin:
   - flyway config → Flyway
   - liquibase config → Liquibase

   Ruby:
   - db/migrate/ + Gemfile with rails/activerecord → ActiveRecord
   - Sequel config → Sequel

   PHP:
   - Laravel migrations directory → Laravel
   - doctrine config → Doctrine

2. Detect migration directory and naming convention:
   - Timestamp-prefixed: 20260311120000_create_users.sql
   - Sequential: 001_create_users.sql
   - Tool-specific: Prisma uses schema.prisma, not migration files

3. If no tool detected:
   - Check for raw SQL migration directories
   - Ask user which tool to use
   - Suggest tool based on project language and ORM
```

### Step 2: Analyze Schema Change Requirements

```
1. Parse change_description into structured operations:
   - CREATE TABLE / ADD MODEL
   - ADD COLUMN / ADD FIELD
   - ALTER COLUMN / CHANGE TYPE
   - DROP COLUMN / REMOVE FIELD
   - DROP TABLE / REMOVE MODEL
   - CREATE INDEX / ADD INDEX
   - ADD CONSTRAINT (foreign key, unique, check)
   - DATA MIGRATION (transform existing data)

2. If target_models provided, read current schema:
   - Extract current table/model structure
   - Identify the delta between current and desired state
   - Resolve foreign key dependencies

3. Determine operation order:
   - Tables before foreign keys
   - Columns before indexes
   - Data migrations after schema changes
   - Constraint additions after data is valid

4. Identify affected tables and their relationships
```

### Step 3: Safety Analysis

Classify each operation by risk level:

| Operation | Risk | Requires Confirmation |
|-----------|------|-----------------------|
| CREATE TABLE | Low | No |
| ADD COLUMN (nullable) | Low | No |
| ADD COLUMN (not null, with default) | Low | No |
| ADD INDEX | Low | No (but note lock impact) |
| ADD COLUMN (not null, no default) | Medium | Yes — existing rows will fail |
| ALTER COLUMN type | Medium | Yes — data conversion needed |
| RENAME COLUMN | Medium | Yes — application code must update |
| DROP INDEX | Medium | Yes — query performance impact |
| RENAME TABLE | High | Yes — all references must update |
| DROP COLUMN | High | Yes — data will be permanently lost |
| DROP TABLE | Critical | Yes — all data permanently lost |
| DATA MIGRATION | Variable | Yes — verify transform logic |

```
For each medium/high/critical operation:
1. Generate explicit warning with impact description
2. Suggest safer alternatives where possible:
   - DROP COLUMN → Mark deprecated, remove in future migration
   - ALTER TYPE → Add new column, migrate data, drop old column
   - DROP TABLE → Rename to _deprecated, drop in future migration
3. Require human confirmation before proceeding
```

### Step 4: Generate Migration File

Generate migration in the detected tool's format:

**Prisma:**
```
1. Update schema.prisma with model changes
2. Run: npx prisma migrate dev --name <migration_name> --create-only
3. Review generated SQL in prisma/migrations/
```

**Knex:**
```
1. Generate migration file: npx knex migrate:make <migration_name>
2. Write exports.up function with schema changes
3. Write exports.down function with rollback
```

**Alembic:**
```
1. Generate revision: alembic revision --autogenerate -m "<description>"
2. Review and adjust generated upgrade() function
3. Write corresponding downgrade() function
```

**Django:**
```
1. Update model files with changes
2. Run: python manage.py makemigrations --name <migration_name>
3. Review generated migration file
```

**Drizzle:**
```
1. Update schema file with changes
2. Run: npx drizzle-kit generate:pg --name <migration_name>
3. Review generated SQL
```

**Goose:**
```
1. Create migration file: goose create <migration_name> sql
2. Write -- +goose Up section with SQL
3. Write -- +goose Down section with rollback SQL
```

**Raw SQL (no ORM):**
```
1. Create timestamped .sql file in migrations directory
2. Write forward migration SQL
3. Create corresponding rollback .sql file
```

### Step 5: Generate Rollback Migration

```
1. For each operation in the up migration, generate the inverse:
   - CREATE TABLE → DROP TABLE
   - ADD COLUMN → DROP COLUMN (with data loss warning)
   - ALTER COLUMN → ALTER back to original type
   - CREATE INDEX → DROP INDEX
   - ADD CONSTRAINT → DROP CONSTRAINT
   - DATA MIGRATION → reverse transform (if possible)

2. For irreversible operations:
   - DROP COLUMN → Cannot restore data, document this
   - Data transforms → May not be perfectly reversible
   - Mark migration as partially irreversible in comments

3. Write rollback in tool-appropriate format:
   - Knex: exports.down
   - Alembic: downgrade()
   - Goose: -- +goose Down
   - Raw SQL: separate rollback file
```

### Step 6: Validate Migration

```
1. Syntax validation:
   - SQL syntax check (for SQL-based tools)
   - Schema file validation (for ORM-based tools)
   - Import/dependency resolution

2. Referential integrity:
   - Foreign keys reference existing tables/columns
   - Cascade rules are appropriate
   - No orphaned references after migration

3. Index assessment:
   - Large table index creation may require CONCURRENTLY
   - Duplicate index detection
   - Missing index suggestions for new foreign keys

4. If dev database available:
   - Run migration against dev database
   - Verify rollback executes cleanly
   - Check for lock conflicts or timeout risks

5. Generate validation report
```

### Step 7: Produce Safety Report

```
1. Compile all findings into safety report:
   - Operations summary (count by type)
   - Risk assessment for each operation
   - Warnings and required confirmations
   - Rollback completeness (fully/partially reversible)
   - Performance notes (lock duration, index build time)
   - Data integrity checks

2. If any Critical risk operations:
   - Block auto-execution
   - Require explicit human approval
   - Suggest phased migration approach

3. Attach report as comment in migration file header
```

## Outputs

**Artifacts:**
- Migration file in tool-specific format and location
- Rollback file (or down function within migration)
- Safety report (as migration file header comment)

**Handoff Data:**
```json
{
  "migration_path": "prisma/migrations/20260311_add_user_roles/migration.sql",
  "rollback_path": "prisma/migrations/20260311_add_user_roles/migration.sql",
  "tool": "prisma",
  "operations": [
    {
      "type": "CREATE_TABLE",
      "target": "roles",
      "risk": "low"
    },
    {
      "type": "ADD_COLUMN",
      "target": "users.role_id",
      "risk": "low"
    },
    {
      "type": "ADD_CONSTRAINT",
      "target": "users.role_id → roles.id",
      "risk": "low"
    }
  ],
  "risk_summary": {
    "low": 3,
    "medium": 0,
    "high": 0,
    "critical": 0
  },
  "rollback_complete": true,
  "validated": true,
  "requires_approval": false
}
```

## Human Checkpoints

| Risk Level | Tier | Behavior |
|------------|------|----------|
| Low (additive only) | Auto | Generate and validate without approval |
| Medium (type changes, renames) | Review | Present safety report, request review |
| High (column drops, data migration) | Approve | Require explicit approval before writing |
| Critical (table drops) | Approve | Require explicit approval, suggest alternatives first |

## Error Handling

| Error | Resolution |
|-------|------------|
| No migration tool detected | Ask user to specify tool or suggest one |
| Schema file not found | Search for alternative schema locations |
| Migration name conflict | Append timestamp or increment suffix |
| Foreign key to non-existent table | Flag error, check if table is created in same migration |
| Dev database unavailable | Skip live validation, note in safety report |
| Circular foreign key dependency | Suggest deferred constraints or restructuring |
| Tool CLI not installed | Provide install command, generate file manually |
| Incompatible type conversion | Flag as requiring data migration step |

## Example Invocations

**Simple table creation:**
```
change_description: "Add a roles table with id, name, and description columns.
                     Users should have a role_id foreign key."
tool: Prisma

→ Updates schema.prisma with Role model and User relation
→ Generates migration SQL
→ Risk: Low (all additive operations)
→ No approval needed
```

**Destructive change:**
```
change_description: "Remove the legacy_email column from users table"
tool: Knex

→ Generates migration with DROP COLUMN
→ Safety report: HIGH RISK — data loss
→ Warning: "Column users.legacy_email will be permanently deleted.
   Consider: rename to _deprecated_legacy_email first."
→ Requires explicit approval
```

**Type change with data migration:**
```
change_description: "Change users.phone from varchar to a structured phone object
                     with country_code and number fields"
tool: Alembic

→ Generates multi-step migration:
  1. Add phone_country_code and phone_number columns
  2. Migrate data from phone to new columns
  3. Drop original phone column (flagged for approval)
→ Risk: High (data transformation + column drop)
→ Requires approval at step 3
```

## Integration Points

- **Invoked by:** `developer` agent during implementation, `architect` during planning
- **Works with:** Model/schema files in the project
- **Outputs to:** Migration directory per tool conventions
- **References:** Project constitution for database naming conventions

## Best Practices

1. **One concern per migration** — Separate schema changes from data migrations
2. **Always generate rollbacks** — Even if you think you won't need them
3. **Test on dev first** — Never run untested migrations on production
4. **Additive over destructive** — Prefer adding columns over modifying existing ones
5. **Default values for new NOT NULL columns** — Prevent failures on existing rows
6. **Index concurrently on large tables** — Avoid locking production tables
7. **Phase destructive changes** — Deprecate first, remove in a later migration

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-03-11 | Initial release — full implementation |
