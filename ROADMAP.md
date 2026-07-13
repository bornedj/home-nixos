# desktop-rs: A Rust Learning Roadmap Through Desktop-Environment Components

## Purpose of this document

This is a learning-oriented build plan. The goal is not primarily to produce a desktop
environment; it is to **re-establish and deepen Rust skills after a ~2 year break**, with
a deliberate bias toward skills that transfer to **systems and embedded engineering**. The
desktop components are the vehicle: each one is chosen because it forces you to practise a
distinct, transferable skill on a real target you use every day.

Every project below is documented with:

- **What it is** and how it fits your Hyprland + quickshell setup.
- **Rust skills honed** (language and ecosystem).
- **Systems / embedded skills honed** (the transferable payoff).
- **Why do this one** (what makes it worth your time versus alternatives).
- **Crates / protocols** you will touch.
- **Effort** (S / M / L) and **prerequisites**.

A [skills coverage matrix](#skills-coverage-matrix) at the end shows which project builds
which skill, so you can pick projects by the skill you want rather than by feature.

---

## Constraints and shape of the work (decided)

- **Augment Hyprland only.** No new compositor. Every component is a standalone process.
- **Greenfield-leaning, with some OSS contribution** landing organically.
- **Both embedded and general-systems emphasis**, weighted equally.

### Why standalone processes, not "Hyprland/quickshell plugins"

Hyprland's plugin API is C++ (no stable Rust ABI) and quickshell is QML/Qt. You therefore
do **not** embed Rust inside them. The idiomatic and more instructive pattern is
standalone Rust processes that:

1. **Produce state** over a Unix socket or D-Bus, which quickshell subscribes to and
   renders (quickshell stays your UI layer); or
2. **Draw their own surface** via the `wlr-layer-shell` protocol (pure-Rust UI, the
   graphics/embedded track); and
3. **Talk to Hyprland** over its IPC socket via the `hyprland` crate, the same IPC surface
   quickshell already consumes through `Quickshell.Hyprland`.

This decoupling is itself a systems-design lesson (process boundaries, IPC contracts,
failure isolation) and keeps your desktop working throughout.

### How quickshell consumes a Rust daemon

- **Producer daemons:** expose newline-delimited JSON on a Unix socket at
  `$XDG_RUNTIME_DIR/<name>.sock`; quickshell reads it with `Quickshell.Io.Socket` +
  `SplitParser`. This mirrors the `FileView` + `colors.json` pattern already in your
  quickshell config.
- **Event-rich services:** expose **D-Bus** (`zbus`); quickshell's D-Bus support
  subscribes.
- **Theming:** every component reads the matugen output
  `~/.local/state/quickshell/generated/colors.json` (md3 + base16 + tonal ramps) and can
  hook matugen `post_hook` for live reload, so Rust-drawn surfaces match the rest of the
  desktop.

---

## Cross-cutting Rust skills you will rebuild first

These recur across projects; the early tiers are sequenced so you meet them in a sensible
order.

| Skill area | What changed / what to relearn |
| --- | --- |
| Edition and tooling | Rust 2024 edition, `cargo` workspaces, feature flags, `clippy` lint groups, `cargo` profiles. |
| Error handling | `anyhow` for binaries, `thiserror` for libraries, the `?` operator, error context, `Result` ergonomics. |
| Async model | `async`/`await` maturity, `tokio` (tasks, `select!`, `mpsc`/`broadcast`/`watch` channels) versus the callback-based `calloop` event loop. Meeting both is deliberate. |
| Concurrency | `Arc`, `Mutex`/`RwLock`, message-passing versus shared state, fan-out with `broadcast`. |
| Traits and generics | Trait objects versus generics, `From`/`Into`, the delegate/dispatch pattern used by `wayland-rs`. |
| Serialization | `serde` derive, custom (de)serialization, `serde_json`. |
| FFI and `-sys` crates | Binding C libraries (NVML, PAM, PipeWire, libpulse), what a `-sys` crate is, `bindgen` at a conceptual level. |
| I/O and framing | Buffered reads, Unix sockets (`tokio::net::UnixListener`), line framing (`tokio_util` codecs). |
| Observability | Structured logging with `tracing`, `tracing-subscriber`. |
| CLI/config | `clap` for arguments, config file loading. |
| Nix + Rust packaging | Reproducible builds with `crane`, `devShell` composition, linking system libraries. |

---

## Foundational step: Rust build infrastructure (do this first)

Establish how Rust is built and shipped in your flake, following the existing per-program
`home/programs/<name>/default.nix` module pattern. Lay out a cargo **workspace** at
`~/gitlab_linux/desktop-rs/` with members `common/`, `sysmond/`, and future components.

- **Rust skills honed:** cargo **workspace** layout; a shared library crate (`common`)
  consumed by multiple binaries; `rust-toolchain.toml` pinning; `clippy`/`rustfmt`
  configuration; dependency and feature-flag hygiene across a workspace.
- **Systems / embedded skills honed:** **reproducible builds** and the Nix+Rust
  integration story (`crane`), pinning a toolchain, and linking against system libraries
  via `pkg-config` (the same discipline you need when cross-building for a target board).
- **Why do this one:** it is the smallest possible end-to-end loop -- one binary, built by
  Nix, installed as a systemd user service -- and it removes friction for every later
  tier. You only solve the packaging problem once.
- **What it touches:** `flake.nix` (add `rust-overlay` or `fenix`, and `crane`; add a
  `devShell` with `pkg-config`, `wayland`, `libxkbcommon`, `pipewire`, and NVML libs); new
  `home/programs/desktop-rs/default.nix`; new `~/gitlab_linux/desktop-rs/` workspace.
- **Effort:** M (mostly Nix, not Rust).

The `common` crate is where you will put the matugen color loader, the socket-serving
helper, and the shared `hyprland` IPC wiring. Building it teaches you to design a small,
reusable library API -- a distinct skill from writing a binary.

---

## Component roadmap

Ordered to build momentum and to introduce skills in a sensible sequence. Each tier is
independently useful; you can reorder after Tier 1.

### Tier 1 -- `sysmond`: system metrics daemon (START HERE)

Replaces the CPU/GPU/Mem polling currently done in
`home/programs/quickshell/services/{Cpu,Gpu,Mem}.qml` (which spawn processes and parse
`/proc` and `nvidia-smi` on a 2-second `Timer`). Instead, one long-lived daemon samples on
its own cadence and streams JSON to quickshell over a socket.

- **What it is:** a daemon that reads system telemetry and publishes it; quickshell
  subscribes with a single `Socket` instead of three polling widgets.
- **Rust skills honed:**
  - Efficient, allocation-conscious parsing of text interfaces (`/proc/stat`,
    `/proc/meminfo`) in a hot loop.
  - `serde` modelling of a typed snapshot struct.
  - `tokio` fundamentals: a sampling task, a `broadcast` channel to fan out to multiple
    socket clients, `UnixListener` accept loop, graceful client disconnect handling.
  - Your first `-sys`/FFI dependency via `nvml-wrapper` (typed NVIDIA telemetry instead of
    scraping `nvidia-smi` text).
  - `anyhow`/`thiserror`, `tracing`, and `clap` in a real binary.
- **Systems / embedded skills honed:**
  - Reading **procfs and sysfs** -- the fundamental telemetry mechanism on embedded Linux.
    CPU utilisation via **jiffy deltas** from `/proc/stat` teaches you the stateful,
    sample-over-time model sensors actually use.
  - **hwmon** sensor reading (`/sys/class/hwmon/*` for temperatures, fan RPM, throttling)
    -- identical to how you read board sensors on embedded targets.
  - The **vendor-library** pattern (NVML) -- binding a C telemetry library, exactly the
    situation you hit with SoC vendor SDKs.
  - Writing a **long-lived, low-overhead** process (bounded memory, no per-tick process
    spawn, no allocation in the sampling path) -- resource discipline that transfers
    directly to constrained targets.
- **Why do this one:** it is the ideal re-onboarding project. It replaces something you
  already run, the scope is small, and it exercises the exact procfs/sysfs/FFI skills that
  define embedded Linux telemetry. You get a visible win (your bar keeps working, better)
  within the first project.
- **Crates / protocols:** `tokio`, `serde`/`serde_json`, `nvml-wrapper`,
  `anyhow`/`thiserror`, `tracing`, `clap`.
- **Effort:** S-M. **Prerequisites:** foundational step.

### Tier 2 -- `idled`: idle and power daemon

Replaces the missing idle daemon (hypridle-style): dim, blank (DPMS), lock, or suspend
after inactivity, and respect inhibitors.

- **What it is:** a daemon that watches for user inactivity via a Wayland protocol and runs
  configured actions, while honouring inhibition requests (for example during video
  playback).
- **Rust skills honed:**
  - Your **first Wayland client protocol** work with `wayland-client`: the
    generated-bindings model, the `Dispatch` trait, and the **`calloop`** event loop --
    a callback/token-driven model that contrasts instructively with `tokio`.
  - Async D-Bus with `zbus`: generating a **proxy** for a remote interface and calling
    methods, plus optionally **serving** an inhibitor interface.
  - State machines for idle levels and action debouncing.
- **Systems / embedded skills honed:**
  - **Power management**: DPMS/backlight control and orchestrating **suspend** through
    `systemd-logind` -- core to any battery- or thermally-constrained device.
  - Talking to **logind** over D-Bus, the standard Linux session/power broker.
  - Event-loop-driven design (`calloop`) rather than thread-per-task -- the model used
    inside compositors and many embedded daemons.
- **Why do this one:** it is the gentlest on-ramp to Wayland protocols (idle-notify is a
  small, well-defined protocol) while adding genuine power-management systems experience.
  It also unlocks Tier 3 and the deferred lockscreen.
- **Crates / protocols:** `wayland-client`, `wayland-protocols` (`ext-idle-notify-v1`),
  `calloop`, `zbus`, `org.freedesktop.login1`.
- **Effort:** M. **Prerequisites:** Tier 1 (for the daemon/systemd pattern).

### Tier 3 -- `osd`: volume/brightness on-screen display (first self-drawn surface)

An on-screen popup that appears when you change volume or brightness. This is your first
component that **draws its own pixels** rather than handing data to quickshell.

- **What it is:** a layer-shell surface that renders a themed volume/brightness indicator
  and auto-dismisses.
- **Rust skills honed:**
  - The **`wlr-layer-shell`** protocol via `smithay-client-toolkit` (layer surfaces,
    anchors, exclusive zones, per-output placement).
  - **Buffer management** with `wl_shm`: allocating shared-memory buffers, double
    buffering, and submitting damage.
  - **2D rendering** in Rust with a software rasteriser (`tiny-skia`) or GPU
    (`femtovg`/`wgpu`), and colour handling from your matugen palette.
  - Integrating input/event sources into `calloop`.
- **Systems / embedded skills honed:**
  - **sysfs backlight** control (`/sys/class/backlight/*/brightness`) -- the canonical
    embedded display-control interface.
  - **Shared-memory buffers** and the producer/consumer model that sits directly adjacent
    to **DMA-BUF** and zero-copy graphics on constrained GPUs.
  - Reacting to **hardware input events** (volume/brightness keys) and audio state via
    **PipeWire** (`pipewire-rs`) or, pragmatically to start, `wpctl`.
- **Why do this one:** it is the milestone where you cross from "move JSON around" to
  "own a rendered surface." Buffer management and layer-shell are the foundation for every
  later graphical component and the closest client-side analogue to compositor/embedded
  graphics work.
- **Crates / protocols:** `smithay-client-toolkit`, `wayland-protocols`
  (`zwlr-layer-shell-v1`), `calloop`, `tiny-skia` or `femtovg`, `pipewire-rs`.
- **Effort:** M. **Prerequisites:** Tier 2 (Wayland client + `calloop`).

### Tier 4 -- `notifd`: notification daemon

Implements the freedesktop notification specification -- currently missing entirely from
your setup.

- **What it is:** a D-Bus service implementing `org.freedesktop.Notifications`. Start with
  the daemon owning the D-Bus server and publishing state for quickshell to render; later,
  optionally, draw notifications yourself via layer-shell for more graphics practice.
- **Rust skills honed:**
  - **Serving** a D-Bus interface to a published specification with `zbus` (methods,
    signals, properties, introspection) -- more involved than the Tier 2 proxy work.
  - Timeout, expiry, and replacement **state management**; action callbacks and their
    lifetimes; optional persistence.
  - Modelling an externally-specified contract faithfully in the type system.
- **Systems / embedded skills honed:**
  - Implementing an **IPC server to a public spec** and reasoning about compatibility --
    the same discipline as implementing a device/service protocol on a gateway or SoC.
  - Robust handling of concurrent clients and lifecycle edge cases.
- **Why do this one:** it is the deepest D-Bus exercise of the roadmap and produces a piece
  of the desktop you currently lack. It also teaches spec-compliance rigour, which is
  broadly valuable in systems work.
- **Crates / protocols:** `zbus`, `tokio`, `serde`;
  `org.freedesktop.Notifications`. Optional UI: `smithay-client-toolkit`.
- **Effort:** M. **Prerequisites:** Tier 2 (`zbus`); Tier 3 if drawing your own UI.

### Tier 5 -- `clipd`: clipboard manager

A clipboard-history daemon plus a picker (cliphist-style).

- **What it is:** a daemon that records clipboard history via a Wayland protocol and serves
  a searchable history to a picker UI (quickshell or a launcher).
- **Rust skills honed:**
  - A read/watch Wayland protocol (`wlr-data-control`) and **MIME/offer** handling.
  - **Embedded persistence** with `redb` (pure-Rust embedded key-value store) or
    `rusqlite`, including schema/versioning and pruning.
  - Handling binary and text payloads, deduplication, and bounded history.
- **Systems / embedded skills honed:**
  - Working with **binary buffers and MIME negotiation** over a protocol.
  - An **embedded database** engine and on-disk data lifecycle -- directly relevant to
    on-device storage on embedded systems.
- **Why do this one:** it introduces durable local storage (a gap in the other projects)
  and a different Wayland protocol shape (data offers), broadening your protocol
  experience.
- **Crates / protocols:** `wayland-client`, `wayland-protocols`
  (`wlr-data-control-unstable-v1`), `redb` or `rusqlite`.
- **Effort:** M. **Prerequisites:** Tier 2/3 (Wayland client).

### Tier 6 -- `launcherd`: application launcher backend

`hyprlauncher` is bound to `SUPER+R` in your Hyprland config but is not installed. Build a
Rust backend that indexes applications and serves fuzzy-search results.

- **What it is:** a backend that indexes `.desktop` entries and answers fuzzy queries over
  a socket; the list renders in quickshell (or you draw a pure-Rust launcher via
  layer-shell).
- **Rust skills honed:**
  - Parsing the **XDG Desktop Entry** specification and building an index.
  - **Fuzzy matching** with `nucleo` (the high-performance matcher used by Helix),
    including scoring and ranking.
  - A **request/response IPC** protocol (versus the Tier 1 fire-hose stream) and
    low-latency query handling; process spawning with correct environment/detachment.
- **Systems / embedded skills honed:**
  - Designing a **query protocol** with latency budgets.
  - Correct **process launching** semantics (double-fork/detachment, environment, cgroup
    considerations) -- relevant wherever you spawn workloads on a device.
- **Why do this one:** it rounds out your IPC vocabulary (request/response and streaming),
  adds algorithmic work (ranking), and fills a real gap in your desktop.
- **Crates / protocols:** `freedesktop-desktop-entry`, `nucleo`; socket IPC.
- **Effort:** M. **Prerequisites:** Tier 1 (socket IPC).

### Deferred / caution

- **Lockscreen (`ext-session-lock-v1`):** HIGH effort and **security-critical**. A bug
  means either lockout or an unlocked machine. Skills are excellent (session-lock protocol
  robustness, **PAM** authentication via FFI, careful failure handling), but keep
  `hyprlock` until you are fluent. Revisit after Tier 4, treating protocol robustness and
  PAM as first-class concerns.
- **Wallpaper daemon (swww-style):** good graphics/DMA-BUF and transition-animation
  practice, but `hyprpaper` already works, so this is optional and lower priority.
- **Do not** rebuild quickshell in Rust. Let quickshell remain the QML UI layer; Rust owns
  the daemons, protocols, and logic.

---

## OSS contribution track (parallel)

Contributions that fall out of the greenfield work rather than requiring separate effort:

- **`hyprland-rs`** (`hyprland-community/hyprland-rs`, at `0.4.0-beta`): you depend on it
  from Tier 1 onward. Filing issues and small fixes (event coverage, docs, ergonomics) is
  the lowest-friction way to get **code review from maintainers** and practise
  **contributing within an existing architecture** -- a distinct skill from greenfield.
- **`smithay-client-toolkit`** / **`layer-shika`**: as you build layer-shell components
  (Tier 3+) you will find rough edges worth upstreaming; this exposes you to a
  larger, more idiomatic codebase.
- **`niri`** (`niri-wm/niri`): aspirational. A Rust, Smithay-based **scrollable-tiling**
  compositor that matches your `layout = "scrolling"` taste, with a welcoming
  `CONTRIBUTING`. This is your on-ramp to **compositor internals** (DRM/KMS, libinput) if
  you later decide to go deeper than "augment Hyprland." Consider a "good first issue"
  after Tier 3, once Wayland client protocols feel natural.
- **`Smithay` / `cosmic-comp`**: the deepest systems/embedded targets (DRM/KMS, GBM, EGL)
  for when you want maximum graphics-stack depth.

**Skill honed across this track:** reading and navigating a large unfamiliar Rust
codebase, matching existing conventions, writing review-ready patches, and engaging with
maintainers -- the skills that distinguish a contributor from a solo builder.

---

## Suggested sequencing

1. Foundational step (flake Rust infra + workspace + `devShell`).
2. **Tier 1 `sysmond`** -- ship it, rewire the quickshell widgets, retire the polling.
3. Tier 2 `idled` (first Wayland protocol) plus a first small `hyprland-rs` contribution.
4. Tier 3 `osd` (first self-drawn layer-shell surface -- the graphics/embedded milestone).
5. Tier 4 `notifd`, then Tiers 5-6 as appetite dictates.
6. Revisit the lockscreen and/or a `niri` contribution once comfortable.

---

## Skills coverage matrix

Language/ecosystem and systems/embedded skills mapped to the project where you first (and
most) build them. Use this to pick a project by the skill you want to practise.

| Skill | Foundation | sysmond | idled | osd | notifd | clipd | launcherd |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Cargo workspace / library crate design | X | | | | | | |
| Nix + Rust reproducible builds (`crane`) | X | | | | | | |
| `serde` modelling | | X | | | X | X | |
| `tokio` async (tasks, channels) | | X | | | X | | X |
| `calloop` event loop | | | X | X | | | |
| Wayland client protocols (`wayland-rs`) | | | X | X | | X | |
| Layer-shell + `wl_shm` buffers | | | | X | (opt) | | (opt) |
| 2D rendering (`tiny-skia`/`femtovg`) | | | | X | (opt) | | (opt) |
| D-Bus proxy (client) `zbus` | | | X | | | | |
| D-Bus service (server) `zbus` | | | | | X | | |
| FFI / `-sys` crates | | X (NVML) | | X (PipeWire) | | | |
| procfs / sysfs reading | | X | | X (backlight) | | | |
| hwmon sensors | | X | | | | | |
| Power management (DPMS/logind/suspend) | | | X | | | | |
| Embedded persistence (`redb`/sqlite) | | | | | | X | |
| Fuzzy matching / ranking | | | | | | | X |
| Streaming IPC (fan-out) | | X | | | | | |
| Request/response IPC | | | | | | | X |
| Spec-compliant protocol implementation | | | | | X | X | X |
| Process spawning semantics | | | | | | | X |
| Resource discipline (long-lived, bounded) | | X | X | X | X | X | X |

(opt) = optional, if you choose the self-drawn UI variant.

---

## Notes on the existing setup (context for implementation)

- Hyprland uses the new **Lua** config API; dispatch strings run via
  `Hyprland.dispatch(...)` from quickshell, and IPC lives on the Hyprland socket.
- quickshell currently provides a top bar only (clock, workspaces, CPU/GPU/Mem, power
  menu). Widgets to rewire for Tier 1:
  `home/programs/quickshell/services/{Cpu,Gpu,Mem}.qml`.
- Theming source of truth: `~/.local/state/quickshell/generated/colors.json` (matugen).
- Present utilities: `hyprpaper`, `grim`, `matugen`. Rust toolchain present via `rustup`;
  no cargo `devShell` or Rust packaging in the flake yet (addressed by the foundational
  step).

---
---

# Addendum (2026-07-13): Reorienting toward a systems-engineering career

Everything above is preserved as the original desktop-environment plan. This addendum
records a follow-up conversation that reassessed that plan against a clearer goal:
**Daniel leans toward systems engineering over embedded engineering**, and wants the
project portfolio to point at that career path. The desktop material is kept because it
remains the best "fluency and motivation" track; this section adds the "career-signal"
track and re-weights the two.

## Honest assessment of the original DE plan for a systems career

The DE plan is an excellent way to rebuild Rust fluency and stay motivated (you use these
tools daily, so you will actually finish them). Measured strictly against a
**systems-engineering** hiring signal, however, it rates roughly a B+, not an A, because
much of its surface is domain-specific to the Linux desktop.

**What transfers strongly to systems roles (keep and emphasize):**

- `tokio` async: tasks, channels (`broadcast`/`mpsc`/`watch`), `select!`.
- IPC and wire-protocol design: sockets, framing, backpressure, versioning.
- FFI / `-sys` crates.
- The long-lived, robust, bounded-resource daemon discipline.
- `serde`, error modelling, `tracing`.

**What is desktop-specific and transfers weakly to mainstream systems hiring:**

- Wayland protocol plumbing, `wlr-layer-shell`, `wl_shm` buffer management.
- 2D rendering (`tiny-skia`/`femtovg`).
- D-Bus servicing.
- sysfs / hwmon / backlight -- this is the embedded side, which is the lower priority.

Conclusion: the graphics-heavy tiers (`osd` rendering, wallpaper) and the D-Bus tiers do
the least for a systems (non-embedded) career. The transferable core of the DE plan is the
async / IPC / FFI / daemon spine, which `sysmond` already exercises.

## Decision

Focus areas chosen, in priority order: **networking / protocols, storage / databases, and
distributed systems.** (Observability / eBPF was considered and set aside.) These three are
not separate tracks -- they compose into a single canonical arc: **a distributed
key-value store** (a "mini-TiKV"). Networking is the front end, storage is the single-node
engine, distributed is the replication layer. It is built in stages, and each stage is a
complete, standalone-credible project.

## The systems arc (staged; each stage ships something complete)

### Stage 0 -- Async / networking warmup

- **Build:** work through Tokio's official **`mini-redis`** tutorial.
- **Why:** the canonical async + sockets + framing primer, and the on-ramp to Stage 1. The
  DE `sysmond` daemon exercises the same muscles (socket server, `broadcast`, framing), so
  the two reinforce each other. This is where the actual "shake the rust off" happens.
- **Effort:** S.

### Stage 1 -- Networking / protocols

- **Build:** a real wire protocol from raw sockets. Recommended: **RESP (the Redis
  protocol)** server, because it becomes the front end of the Stage 2 storage engine (no
  wasted work). Alternatives for variety: a DNS server or an HTTP/1.1 server.
- **Skills honed:** protocol parsing and framing, pipelining, connection lifecycle,
  backpressure, graceful shutdown, `tokio` networking.
- **References:** **Codecrafters** has guided Rust tracks for Redis, DNS, HTTP, and SQLite
  if a scaffold is wanted.
- **Effort:** M.

### Stage 2 -- Storage / databases

Build a single-node storage engine behind the Stage 1 front end, in two steps:

- **Step A -- log-structured / Bitcask-style KV:** append-only log + in-memory hash index
  + compaction. PingCAP's **Talent Plan** course "Practical Networked Applications in
  Rust" builds exactly this and also covers the networking layer, overlapping Stage 1.
- **Step B -- LSM-tree:** graduate to a log-structured merge tree. **`skyzh/mini-lsm`**
  ("Build a mini LSM storage engine in Rust") is an excellent guided tutorial.
- **Skills honed:** write-ahead log, memtables, SSTables, compaction, crash recovery,
  on-disk formats, bloom filters, `mmap`, durability and `fsync` semantics.
- **Effort:** M-L.

### Stage 3 -- Distributed systems (capstone; only if energy holds)

- **Build:** add **Raft**-based replication to make the KV store multi-node.
- **Paths:** PingCAP Talent Plan's "Distributed Systems in Rust" labs; the **MIT 6.5840**
  labs implemented in Rust; or building against / contributing to TiKV's **`raft-rs`**.
- **Skills honed:** leader election, log replication, snapshots, linearizability,
  membership changes, partition handling.
- **Effort:** L (the largest by far).

**End state:** RESP front end + LSM engine + Raft = a coherent distributed database, built
incrementally, that can be stopped at any stage with something real.

## Scope guidance (important)

Do **not** front-load Raft. Stages 0-2 (warmup -> protocol server -> single-node storage
engine) hold most of the durable learning and already make a strong portfolio. Reach
Stage 3 only after storage feels comfortable. Understanding storage and networking cold
matters more than shipping a from-scratch Raft.

## How the two tracks now relate

- **Desktop track = fluency and motivation spine.** Keep `sysmond` (its async / socket /
  IPC code is a direct warmup for Stage 1) and keep it minimal. Do `osd` only if one
  graphics/protocol experience is wanted for breadth. **Drop the wallpaper tier.** Treat
  `notifd` / `clipd` / `launcherd` as optional "nicer desktop" side quests, not career
  work.
- **Systems arc = the career signal.** This is where the deliberate hours go.

## OSS contribution targets for the systems track

Real systems-Rust codebases where small PRs signal "works in real systems code":

- Networking: `tokio`, `hyper`, `tonic`.
- Storage: `sled`, `redb`, `datafusion`.
- Distributed: `raft-rs`, `tikv`.

## Reference reading

- Martin Kleppmann, *Designing Data-Intensive Applications* -- the map of the whole
  territory.
- Alex Petrov, *Database Internals* -- storage and replication mechanics.

## Revised focus order

1. Stage 0 warmup (`mini-redis`) in parallel with DE `sysmond` (shared skills).
2. Stage 1 RESP server.
3. Stage 2 storage engine (Bitcask-style, then LSM).
4. Stage 3 Raft / distributed KV, only if appetite remains.
5. Desktop components beyond `sysmond` remain optional, motivation-driven side quests.
