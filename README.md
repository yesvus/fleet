# fleet - Beszel status CLI

Check your Beszel-monitored hosts from the terminal. Reads the Beszel hub SQLite DB over SSH, no dashboard password needed.

## Requirements

- Local: `ssh` (OpenSSH client), `python3` (>= 3.7)
- Hub: `sqlite3` installed, Beszel hub **0.19.0** (uses the `systems` / `system_stats` schema)

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

- `--json` - machine-readable JSON (never colored)
- `--host HOST` - ssh target of the hub (default: `jelly`)
- `--db PATH` - hub SQLite path (default: `/opt/beszel/beszel_data/data.db`)
- `--color=WHEN` - table colors: `auto` (default, tty only), `always`, `never`
- `-h, --help` / `-v, --version`

`BESZEL_SSH_HOST` and `BESZEL_DB` env vars override the defaults. `NO_COLOR` disables color.

Colors: status (`up` green, `down` red, other yellow) and usage >= 75% yellow, >= 90% red.

Unrooted Android agents can't read `/proc`, so their CPU 0% / load are bogus. Their real storage shows up as `Internal`/`Shared` extra disks (`EXTRA_FILESYSTEMS`), and with `FILESYSTEM=/data` on the agent the root disk reports the real storage too (the agent de-duplicates `Internal` away). Fleet hides CPU/load for those hosts and prefers `Internal` when present, else the root values.

```sh
fleet            # table of all systems
fleet toa        # only matching names
fleet --json     # JSON array, pipe to jq
```

## Sample output

```
fridge        down cpu=10.15% mem=8.36% (2.48G) disk=52.02% (23.68G) load=[6.37, 7.28, 4.9] updated=06:58:52Z
hamster-wheel up   cpu=90.1% mem=46.84% (9.83G) disk=57.47% (155.68G) load=[5.96, 0.32, 5.64] updated=11:58:06Z
nokia-3310    paused cpu=- mem=- (-) disk=- (-) load=- updated=-
potato        up   cpu=58.81% mem=75.84% (7.52G) disk=23.38% (57.97G) load=[5.86, 3.48, 0.12] updated=11:58:01Z
skynet        up   cpu=44.29% mem=26.69% (8.32G) disk=49.39% (178.56G) load=[4.3, 1.59, 5.21] updated=11:59:48Z
toaster       up   cpu=9.88% mem=19.76% (15.68G) disk=56.03% (95.05G) load=[2.32, 5.64, 1.9] updated=11:58:07Z
```

JSON form: [sample/output.json](sample/output.json).

## License

MIT.
