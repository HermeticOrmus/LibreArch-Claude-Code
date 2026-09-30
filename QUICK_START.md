# Quick start

Inside Claude Code:

```
/plugin marketplace add HermeticOrmus/LibreArch-Claude-Code
/plugin install domain-driven-design@libre-arch
```

Or from a clone, installing every plugin through the Claude Code CLI:

```bash
git clone https://github.com/HermeticOrmus/LibreArch-Claude-Code.git ~/projects/LibreArch-Claude-Code
cd ~/projects/LibreArch-Claude-Code
./setup.sh
```

### Install in Grok Build

Grok Build reads the same plugin folders. Add the marketplace and install a plugin, or install one plugin straight from its folder:

```bash
grok plugin marketplace add HermeticOrmus/LibreArch-Claude-Code
grok plugin install domain-driven-design@LibreArch-Claude-Code --trust
# or, without the marketplace:
grok plugin install HermeticOrmus/LibreArch-Claude-Code#plugins/domain-driven-design --trust
```

From a clone, `./setup.sh --grok` installs every plugin through the `grok` CLI. Start a new Grok session to load them. The `libre-arch-hooks` plugin uses a hook format Grok supports, but it has not been verified in a live Grok session.

### First prompt

Restart Claude Code, then try:

```
/ddd identify bounded contexts for a marketplace: sellers list inventory, buyers browse + purchase, finance processes payouts, support handles disputes. Where are the seams?
```

Expected: 4-5 bounded contexts (catalog, order, payment, support, possibly identity) with the language differences explicit, a context map showing relationships (probably customer-supplier between catalog and order, anti-corruption layer if there's a legacy inventory system), and per-context aggregate sketches.

`/ddd` also has focused modes: `/ddd model` for one aggregate, `/ddd map-contexts` for an integration between two contexts, `/ddd validate` to audit existing code, and `/ddd generate` to scaffold an aggregate.

See learning paths for progression.
