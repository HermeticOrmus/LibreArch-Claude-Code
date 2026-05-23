# Quick start

```bash
git clone https://github.com/HermeticOrmus/LibreArch-Claude-Code.git ~/projects/LibreArch-Claude-Code
cd ~/projects/LibreArch-Claude-Code
./setup.sh
```

```
/ddd identify bounded contexts for a marketplace: sellers list inventory, buyers browse + purchase, finance processes payouts, support handles disputes. Where are the seams?
```

Expected: 4-5 bounded contexts (catalog, order, payment, support, possibly identity) with the language differences explicit, a context map showing relationships (probably customer-supplier between catalog and order, anti-corruption layer if there's a legacy inventory system), and per-context aggregate sketches.

See learning paths for progression.
