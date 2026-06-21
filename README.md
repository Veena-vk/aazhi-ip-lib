# Aazhi IP Library

> Curated open-source RTL IP cores for FPGA and ASIC design — built for students and learners using open-source EDA flows (Yosys, OpenROAD, Sky130).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## What is this?

A structured, metadata-rich library of commonly needed RTL building blocks. Every IP has:
- Clean, well-commented Verilog source
- `ip.json` with ports, parameters, usage notes, and license info
- Attribution to original authors where the design is curated from an upstream project

Designed to integrate directly into **Sangamam IDE** — an open-source Vivado-like GUI for the Yosys + OpenROAD ASIC flow.

---

## IP Catalog

### 🔌 Communication Protocols

| IP | Module | Description |
|---|---|---|
| [UART](protocols/uart/) | `uart_tx`, `uart_rx` | AXI4-Stream UART, configurable baud rate |
| [SPI Master](protocols/spi/) | `spi_master` | SPI modes 0–3, configurable word width |
| [I2C Master](protocols/i2c/) | `i2c_master` | Full I2C master with repeated start, multi-byte transfer |

### 💾 Memory & Buffers

| IP | Module | Description |
|---|---|---|
| [Sync FIFO](memory/sync_fifo/) | `sync_fifo` | Single-clock FIFO, parameterized width/depth |
| [Async FIFO](memory/async_fifo/) | `async_fifo` | Dual-clock FIFO with Gray-code CDC |

### 🎥 Image & Video

| IP | Module | Description |
|---|---|---|
| [VGA Controller](image_video/vga_controller/) | `vga_controller` | 640×480 @ 60 Hz VGA sync generator |

### ⏰ Clocking

| IP | Module | Description |
|---|---|---|
| [Clock Divider](clocking/clock_divider/) | `clock_divider` | Integer clock divider, even divisors, 50% duty |

### 🔧 Utility / Misc

| IP | Module | Description |
|---|---|---|
| [PWM Generator](misc/pwm/) | `pwm` | Pulse-width modulator, parameterizable resolution |
| [Button Debouncer](misc/debounce/) | `debounce` | Mechanical button / noisy signal debouncer |
| [LFSR PRNG](misc/lfsr/) | `lfsr` | Maximal-length Galois LFSR, 8/16/32-bit |

---

## Repository Structure

```
aazhi-ip-lib/
  index.json            ← Master catalog (machine-readable, used by Sangamam IDE)
  README.md
  CREDITS.md
  <category>/
    <ip-name>/
      ip.json           ← IP metadata (ports, parameters, license, author, tags)
      rtl/              ← Synthesizable Verilog source files
        *.v
      tb/               ← Testbenches (where available)
        *_tb.v
```

### `ip.json` schema

Each IP carries a rich metadata file:

```json
{
  "id":           "uart",
  "name":         "UART (Universal Asynchronous Receiver/Transmitter)",
  "version":      "1.0.0",
  "category":     "protocols",
  "description":  "...",
  "author":       "Alex Forencich",
  "source_url":   "https://github.com/alexforencich/verilog-uart",
  "license":      "MIT",
  "rtl_files":    ["rtl/uart_tx.v", "rtl/uart_rx.v"],
  "top_modules":  ["uart_tx", "uart_rx"],
  "parameters":   [{ "name": "DATA_WIDTH", "default": 8 }],
  "ports_summary": { "uart_tx": ["clk", "rst", "txd", ...] },
  "usage_note":   "Set prescale = clk_freq / baud_rate",
  "tags":         ["uart", "serial", "communication"],
  "verified":     true
}
```

---

## Contributing

We welcome additions! To add an IP:

1. Create a folder under the appropriate category: `<category>/<ip-name>/`
2. Add RTL source to `rtl/`
3. Write an `ip.json` following the schema above
4. Update `index.json` with the new entry
5. Add attribution to `CREDITS.md` if the design comes from an upstream project
6. Open a pull request

**Quality guidelines:**
- Verilog 2001 compatible (no SystemVerilog constructs in RTL)
- Parameterized where sensible
- At least a usage note in `ip.json`
- Properly credit all original authors

---

## Integration with Sangamam IDE

This library is the backend for the **IP Catalog** feature in [Sangamam IDE](https://github.com/Veena-vk/hdl-ide).  
The IDE fetches `index.json` at startup to populate the catalog, then downloads individual IP files on demand.

---

## License

All original contributions in this repository are licensed under the **MIT License**.  
Third-party IPs retain their original licenses — see `ip.json` and `CREDITS.md` for details.
