# /clean-arch

A quick-access command for clean-architecture workflows in Claude Code.

## Trigger

`/clean-arch [action] [options]`

## Input

### Actions
- `analyze` - Analyze existing clean-architecture implementation
- `generate` - Generate new clean-architecture artifacts
- `improve` - Suggest improvements to current implementation
- `validate` - Check implementation against best practices
- `document` - Generate documentation for clean-architecture artifacts

### Options
- `--context <path>` - Specify the file or directory to operate on
- `--format <type>` - Output format (markdown, json, yaml)
- `--verbose` - Include detailed explanations
- `--dry-run` - Preview changes without applying them

## Process

### Step 1: Context Gathering
- Read relevant files and configuration
- Identify the current state of clean-architecture artifacts
- Determine applicable standards and conventions

### Step 2: Analysis
- Evaluate against clean-arch-patterns patterns
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
## Clean Architecture - [Action] Complete

### Changes Made
- [List of changes]

### Validation
- [Checks passed]

### Next Steps
- [Recommended follow-up actions]
```

### Error
```
## Clean Architecture - [Action] Failed

### Issue
[Description of the problem]

### Suggested Fix
[How to resolve the issue]
```

## Examples

```bash
# Analyze current implementation
/clean-arch analyze

# Generate new artifacts
/clean-arch generate --context ./src

# Validate against best practices
/clean-arch validate --verbose

# Generate documentation
/clean-arch document --format markdown
```
