# `type-performance-now-persisted` on a banked duration

Reported in [expo/exact#102](https://github.com/expo/exact/issues/102).

A stopwatch banks elapsed time across Stop and Start and has a Reset. `app.test.contract` shows the
banked value is a duration: runs of 3 s and 2 s, with 10 s between them, bank 5000 ms. The compiler
still warns that the value sent to `keep` is computed from `performanceNow()`, and `verify` counts
the warning, so the app never reaches `verify: clean`.

Grouping decides it: `let total = banked + performanceNow() - start` warns, and
`banked + (performanceNow() - start)` does not. Without the `reset` action, neither warns.

## Setup

Needs Bun 1.4.2 and an Exact checkout set up with `bun scripts/exact.mjs setup`. Clone this
repository beside the checkout, or set `EXACT2` to the checkout's absolute path:

```sh
git clone https://github.com/expo/exact
git clone REPO_URL exact-repro-perf-now-warning
cd exact-repro-perf-now-warning
```

## Run

```sh
./repro.sh
```

It exits 1 while the problem is present, 0 once it is fixed, and 2 when its setup fails.

Today:

```
BUG: type-performance-now-persisted fires on a duration; the control does not
```

The script runs the test, then compiles `app.contract` and a copy grouped as
`banked + (performanceNow() - start)`. It exits 1 while `app.contract` warns and the copy does not,
and 0 once neither warns.

Checked against Exact `c582b3b` on macOS 27.2.1, Xcode 27.2, Bun 1.4.2.
