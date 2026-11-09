# Git clean filter for home/.claude/settings.json. Directory marketplaces point
# at local paths (work plugins) that do not exist on other machines and must not
# reach this public repo, so drop them and every plugin setting that uses them.
# The live file keeps them; only the committed copy is stripped.
([.extraKnownMarketplaces // {} | to_entries[] | select(.value.source.source == "directory") | .key]) as $local
| def keep: with_entries(select(.key | split("@") | last | IN($local[]) | not));
  if .extraKnownMarketplaces then .extraKnownMarketplaces |= with_entries(select(.key | IN($local[]) | not)) else . end
| if .enabledPlugins then .enabledPlugins |= keep else . end
| if .pluginConfigs then .pluginConfigs |= keep else . end
| with_entries(select(.value != {}))
