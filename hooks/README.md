# Original hook scripts

These are the original LibreArch hook scripts, kept for reference. Claude Code never ran them: the old `setup.sh` copied plugin folders but did not register hooks anywhere.

The installable, working versions live in the optional [`libre-arch-hooks`](../plugins/libre-arch-hooks) plugin. They read the hook JSON from stdin with `jq`, return output in the format Claude Code expects, and write no log files. Install them with:

```
/plugin install libre-arch-hooks@libre-arch
```
