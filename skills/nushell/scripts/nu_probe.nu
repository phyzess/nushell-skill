#!/usr/bin/env nu

# Emits a small, non-secret JSON report for agents deciding whether Nushell is available.
let shell = ($env.SHELL? | default "")
let version_info = (try { version | select version commit_hash build_os build_target } catch { {} })
let path_has_nu = (
  try {
    which nu | is-not-empty
  } catch {
    false
  }
)

{
  nushell_available: true,
  shell_mentions_nu: ($shell | str contains "nu"),
  shell_path_present: ($shell | is-not-empty),
  path_has_nu: $path_has_nu,
  version: $version_info
} | to json
