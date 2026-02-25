# Contributing to LibreArch

Welcome to the architecture knowledge commons. This repository maps how to use Claude Code for software architecture, system design, and structural decision-making. Every contribution raises our shared understanding of AI-assisted architectural engineering.

---

## Philosophy

**We build architecture-aware, not textbook-grade.**

The gap between "understands the pattern" and "applies it correctly in context" is where systems rot. Contributions to LibreArch must close that gap -- trade-off analysis, evolutionary considerations, team coordination, and operational reality. If your contribution presents a pattern without stating when NOT to use it, it is incomplete.

**We teach the forces, not just the form.**

Every architectural pattern exists because of specific forces: performance requirements, team structure, domain complexity, deployment constraints. Document those forces. Why this decomposition? Why this boundary? Why this communication style? Architecture without reasoning becomes cargo cult design.

---

## Guiding Principles

1. **Context over dogma** -- Every pattern has trade-offs. Document when it applies AND when it does not.
2. **Forces before form** -- Explain the architectural forces that drive a decision before presenting the solution.
3. **Evolution-aware** -- Architecture changes over time. Document migration paths and decomposition readiness.
4. **Team-aware** -- Architecture must match team structure (Conway's Law). Note team size and skill assumptions.
5. **Testable** -- Architectural decisions should be verifiable through fitness functions, not just code review.

---

## Types of Contributions

### Architecture Patterns

Production-tested architectural patterns with full trade-off analysis.

**How to contribute:**
1. Define the architectural forces that make this pattern relevant
2. Show the pattern in at least one concrete implementation
3. Document trade-offs, failure modes, and operational considerations
4. State when this pattern is NOT the right choice

**Template:**
```markdown
## [Pattern Name]

### Forces
[What architectural pressures make this pattern relevant?]

### The Pattern
[Structure, components, relationships]

### Trade-offs
[What you gain vs what you pay]

### When NOT to Use
[Conditions where this pattern causes more harm than good]

### Evolution Path
[How to adopt incrementally, how to migrate away]
```

### Plugins, Agents & Commands

New Claude Code extensions for architecture workflows.

**Requirements:**
- Clear scope definition (what it does and does not do)
- Trade-off awareness in all recommendations
- Usage examples with expected output
- Related plugin references

### Documentation & Guides

Learning paths, pattern comparisons, decision frameworks, and reference material.

**Structure:**
- Clear problem statement and target audience
- Progressive difficulty (build understanding step by step)
- Practical exercises with real codebases
- Decision trees for choosing between alternatives

---

## Contribution Process

### 1. Check Existing Work

Search issues and existing content before starting. Duplicated architecture guidance creates confusion.

### 2. Open an Issue (for significant changes)

For new plugins or substantial content, open an issue first to discuss scope. Small fixes and documentation improvements can go directly to PR.

### 3. Fork & Branch

```bash
git clone https://github.com/YOUR-USERNAME/LibreArch-Claude-Code.git
cd LibreArch-Claude-Code
git checkout -b feature/your-contribution-name
```

**Branch naming:**
- `feature/` -- New content, plugins, or capabilities
- `fix/` -- Bug fixes or corrections
- `docs/` -- Documentation improvements
- `example/` -- New examples or exercises

### 4. Write & Validate

Follow the guidelines above. Validate patterns against real codebases.

### 5. Commit

```
feat(plugin): Add saga orchestration patterns with compensation strategies

Includes:
- Orchestrator and choreography approaches with trade-off analysis
- Compensation transaction patterns for failure recovery
- State machine implementation for long-running sagas
- Decision framework for choosing orchestration vs choreography
```

Use conventional commits: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`.

### 6. Submit PR

Open a pull request using the PR template. Include:
- Clear description of what this adds
- Which architectural forces it addresses
- How it was validated (real codebase, thought experiment, literature review)

### 7. Review

Maintainers review for:
- **Trade-off awareness** -- Are both sides of each decision documented?
- **Context sensitivity** -- Does it state when NOT to apply the pattern?
- **Completeness** -- Are forces, form, and evolution paths included?
- **Quality** -- Clear writing, accurate patterns, proper structure?

---

## Architecture Review Checklist

Before submitting, verify:

- [ ] Trade-offs documented for every pattern recommendation
- [ ] "When NOT to use" section included
- [ ] Architectural forces driving the decision are stated
- [ ] Team size and skill assumptions noted where relevant
- [ ] Evolution and migration paths considered
- [ ] Related patterns and alternatives referenced
- [ ] Concrete examples provided (not just abstract descriptions)
- [ ] Follows project structure and naming conventions
- [ ] Markdown renders correctly
- [ ] Links are valid

---

## What We Do Not Accept

- **Pattern dogma** -- "Always use microservices" or "Never use a monolith" without context
- **Textbook summaries** -- Rephrasing Wikipedia without adding practical insight
- **Technology-first thinking** -- Choosing tools before understanding the problem
- **Missing trade-offs** -- Presenting a pattern as universally good
- **Untested patterns** -- Theoretical architectures without real-world validation

---

## Recognition

Contributors are:
- Listed in commit history and release notes
- Part of the architecture knowledge commons
- Building collective design capability

Your contribution might be one architectural pattern, one decision framework, one migration strategy. But someone, somewhere, will avoid an architectural mistake because you documented what you learned.

---

**Share what you build. The architecture gets stronger when knowledge flows.**

Thank you for contributing to collective architectural excellence.
