# NixOS Config — den aspect-oriented

Two hosts (Dell laptop `default`, AMD desktop `lan-pc`), one user (`sethb`).

## Structure

- `flake.nix` — Flake entry point. Uses `import-tree` + `den` to evaluate all modules and produce NixOS configurations.
- `modules/index.nix` — Den schema (common to all hosts).
- `modules/hosts/` — One `.nix` per host; each defines `den.hosts` and its `den.aspects-selection`.
- `modules/aspects/` — One aspect per feature. Aspects are context-aware functions that return NixOS + Home-Manager modules.
- `home.nix` — Home-Manager user config (shared by both hosts).
- `hardware-configuration.nix` / `lan-hardware-configuration.nix` — Auto-generated hardware scans.

## Running

```bash
# Rebuild default (laptop)
sudo nixos-rebuild --flake .#default

# Rebuild LAN PC
sudo nixos-rebuild --flake .#lan-pc

# Switch (nh)
nh switch
```

## Aspects

Each aspect in `modules/aspects/` is self-contained. Hosts select aspects via `den.aspects-selection`. To add a feature, create a new `.nix` file in `aspects/` and add its name to the selection list.
