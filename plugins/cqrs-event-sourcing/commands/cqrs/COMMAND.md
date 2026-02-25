# /cqrs

A quick-access command for cqrs-event-sourcing workflows in Claude Code.

## Trigger

`/cqrs [action] [options]`

## Input

### Actions
- `analyze` - Analyze existing cqrs-event-sourcing implementation
- `generate` - Generate new cqrs-event-sourcing artifacts
- `improve` - Suggest improvements to current implementation
- `validate` - Check implementation against best practices
- `document` - Generate documentation for cqrs-event-sourcing artifacts

### Options
- `--context <path>` - Specify the file or directory to operate on
- `--format <type>` - Output format (markdown, json, yaml)
- `--verbose` - Include detailed explanations
- `--dry-run` - Preview changes without applying them

## Process

### Step 1: Context Gathering
- Read relevant files and configuration
- Identify the current state of cqrs-event-sourcing artifacts
- Determine applicable standards and conventions

### Step 2: Analysis
- Evaluate against cqrs-patterns patterns
- Identify gaps, issues, and opportunities
- Prioritize findings by impact and effort

### Step 3: Execution
- Apply the requested action
- Generate or modify artifacts as needed
- Validate changes against requirements

### Step 4: Output
- Present results in the requested format
- Include actionable next steps
- Flag any items requiring human decision

## Output

### Success
```
## Cqrs Event Sourcing - [Action] Complete

### Changes Made
- [List of changes]

### Validation
- [Checks passed]

### Next Steps
- [Recommended follow-up actions]
```

### Error
```
## Cqrs Event Sourcing - [Action] Failed

### Issue
[Description of the problem]

### Suggested Fix
[How to resolve the issue]
```

## Examples

```bash
# Analyze current implementation
/cqrs analyze

# Generate new artifacts
/cqrs generate --context ./src

# Validate against best practices
/cqrs validate --verbose

# Generate documentation
/cqrs document --format markdown
```
