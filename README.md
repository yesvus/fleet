# fleet — Beszel status CLI

Check your Beszel-monitored hosts from the terminal. Reads the Beszel hub SQLite DB over SSH, no dashboard password needed.

Requires `ssh` access to the hub host, `sqlite3` on the hub, `python3` locally.

## Install

```sh
git clone https://github.com/yesvus/fleet.git
ln -s "$PWD/fleet/fleet" ~/.local/bin/fleet
```

## Usage

```sh
fleet [OPTIONS] [FILTER]
```

`FILTER` shows only systems whose name contains it. Options:

- `--json` — machine-readable JSON
- `--host HOST` — ssh target of the hub (default: `jelly`)
- `--db PATH` — hub SQLite path (default: `/opt/beszel/beszel_data/data.db`)
- `-h, --help` / `-v, --version`

`BESZEL_SSH_HOST` and `BESZEL_DB` env vars override the defaults.

```sh
fleet            # table of all systems
fleet zom        # only matching names
fleet --json     # JSON array, pipe to jq
```

## Sample

Random fake data (`sample/input.json`, IPs are TEST-NET-1), rendered by fleet itself — regenerate with `sample/generate.sh`:

```
db-01    up   cpu=35.8% mem=62.75% (7.52G) disk=21.62% (57.97G) load=[2.93, 1.74, 0.06] updated=11:58:01Z
laptop-02 up   cpu=6.51% mem=7.74% (2.48G) disk=47.51% (23.68G) load=[3.19, 3.64, 2.45] updated=11:58:52Z
nas-02   up   cpu=27.06% mem=22.68% (8.32G) disk=45.14% (178.56G) load=[2.15, 0.79, 2.61] updated=11:59:48Z
pi-04    up   cpu=54.64% mem=39.11% (9.83G) disk=52.44% (155.68G) load=[2.98, 0.16, 2.82] updated=11:58:06Z
pi-05    paused cpu=- mem=- (-) disk=- (-) load=- updated=-
web-01   up   cpu=6.34% mem=17.03% (15.68G) disk=51.14% (95.05G) load=[1.16, 2.82, 0.95] updated=11:58:07Z
```

JSON form: [sample/output.json](sample/output.json).

## License

MIT.
