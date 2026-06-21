# Credits

This library curates and builds upon excellent open-source RTL work from the community.
Full credit and attribution to all original authors below.

---

## Alex Forencich

**Website:** https://alexelectronics.net  
**GitHub:** https://github.com/alexforencich  
**License:** MIT

IPs curated from his repositories:

| IP | Source Repository |
|---|---|
| `uart_tx`, `uart_rx` | https://github.com/alexforencich/verilog-uart |
| `i2c_master` | https://github.com/alexforencich/verilog-i2c |

Alex Forencich maintains a large collection of high-quality, production-grade Verilog IP cores covering UART, I2C, SPI, Ethernet, AXI, and more. His designs are widely used in the open-source FPGA community.

---

## Original Contributions

The following IPs were written specifically for this library by aazhi-ip-lib contributors:

- `spi_master` — SPI Master Controller
- `sync_fifo` — Synchronous FIFO
- `async_fifo` — Asynchronous FIFO (dual-clock, Gray-code CDC)
- `vga_controller` — VGA 640×480 @ 60 Hz Controller
- `pwm` — PWM Generator
- `debounce` — Button Debouncer
- `lfsr` — LFSR Pseudo-Random Number Generator
- `clock_divider` — Integer Clock Divider

These are released under the MIT License.  
Inspired by well-known textbook implementations and community examples; written from scratch.

---

## How to Credit This Library

If you use IPs from this library in your project, please include a note such as:

> RTL IP cores sourced from the [Aazhi IP Library](https://github.com/Veena-vk/aazhi-ip-lib), MIT License.

---

## Adding to This File

When contributing an IP curated from another project, add an entry here with:
- Author name and link
- Original repository URL
- Which IPs were curated from it
- The license under which it was taken
