# SCR1 Core Integration into LiteX

## Overview

This repository has the code of the integration project of the Syntacore SCR1 RISC-V CPU soft core into the LiteX System-on-Chip builder framework.  The objective of this project was to run the SCR1 core on the Colorlight i9 FPGA board, which has Lattice ECP5. 

Presentation and text documenting the process (in Russian only) can be found in the /docs folder.

Other FPGAs are untested, but LiteX abstraction should make it work on yours as well. Be mindful that TCM uses block RAM and could require vendor-specific code.

The integration was tested with open-source FPGA synthesis and place-and-route tools (Yosys, nextpnr) available in LiteX.

## Key Features & Achievements

*   **SCR1 Core Integration:** Successfully integrated the AXI4 variant of the SCR1 core.
*   **Conversion into Verilog:** Implemented preprocessing using `sv2v` to translate the SCR1 SystemVerilog source code to Verilog, enabling problem-free synthesis with Yosys.
*   **IPIC Interrupt Handling:** Integrated basic support for the SCR1's Integrated Programmable Interrupt Controller (IPIC) within the LiteX firmware environment (`crt0.S`, `isr.c`), enabling handling of external interrupts (e.g., from UART). Courtesy of Syntacore for the IPIC interface found within Zephyr RTOS repo of SCR1. Note that the timer interrupt is not implemented and is untested.
*   **Hardware Verification:** Built and successfully loaded the resulting SoC onto the Colorlight i9 hardware. Basic functionality was verified using the LiteX BIOS via UART communication, including loading firmware through UART.
*   **Evaluation:** Performed quick and shallow resource utilization and performance measurements, comparing the integrated SCR1 core against other RISC-V cores available within LiteX on the same target hardware. It is found in /docs, only in Russian.

## Getting Started

### Prerequisites

*   **LiteX:** A working LiteX installation.
*   **RISC-V Toolchain:** A compatible RISC-V GCC toolchain
*   **FPGA Toolchain:**
    *   Yosys
    *   nextpnr-ecp5 (Project Trellis)
*   **Verilog Preprocessor:**
    *   `sv2v` (Required for converting SCR1 SystemVerilog sources)
*   **FPGA Programmer:**
    *   `ecpdap` (For flashing the ECP5 via JTAG/USB)

### Building and Loading

0.  **Drag'n'Drop all the files onto your LiteX directory:**
    Make sure that the directories align

1.  **Install the translated (.v) source files as a pip package:**
    Navigate to pythondata-cpu-scr1 and type,
    ```bash
    pip install .
    ```

3.  **Build and load the SoC Bitstream (UART connection needed):**
    ```bash
    python3 colorlight_i9.py --cpu-type=scr1 --cpu-variant=full --build --load
    ```
    Optimized options on colorlight_i9.py: --bus-interconnect=crossbar --bus-standard=axi-lite

5.  **Connect via Terminal:**
    Identify the correct serial port (e.g., `/dev/ttyUSB0`).
    ```bash
    litex_term /dev/ttyUSBX # Replace X with the correct number
    ```
    Pressing the reset button on the board should transfer the LiteX BIOS prompt to your PC via UART.

6.  **Load Firmware (Optional):**
    To load and run custom firmware (e.g., `firmware.bin`):
    ```bash
    litex_term /dev/ttyUSB0 --kernel=./firmware.bin --kernel-adr=0x10000000
    ```
    0x10000000 is the placement of SRAM, defined in core.py. Press the reset button while connected via UART. You can utilize litex_bare_metal_demo for the automatic linker script creation, UART communication and command line interface.

## Technical Notes

*   **SystemVerilog Handling:** The SCR1 core is written in SystemVerilog. The `sv2v` tool was used to translate the sources to Verilog before installing as a package.
*   **Interrupt Controller (IPIC):** Basic support for IPIC was implemented by modifying the interrupt service routine entry (`crt0.S`) and handler (`isr.c`) in the LiteX firmware. It utilizes the `soi` (Start Of Interrupt) and `eoi` (End Of Interrupt) mechanisms specific to IPIC for vector retrieval and acknowledgement. Courtesy of Syntacore. Timer interrupt support is currently not implemented in this basic handler.
*   **Bus Interface:** The AXI4 interfaces of the SCR1 core (instruction and data) were connected to the LiteX SoC interconnect. As LiteX primarily uses Wishbone internally, `AXI2Wishbone` bridges were automatically instantiated by LiteX, degrading performance.
*   **Pins Changed:** Due to physical problems with my own individual Colorlight-i9, a pin of mine did not work (fried or else). Refer to platforms/colorlight_i9.py to change it or keep it. You can also use LiteX's colorlight_i5.py which implements the same thing without the changed pin.

## Performance

*   The integrated SCR1 core (full configuration) is functional on the Colorlight i9 board using the setup. Fast multiplication works and in demos shows significant edge over CPUs which do not implement it.
*   Yosys and nextpnr show a maximum operating frequency of 23 MHz for this configuration, which is significantly lower than the target (60 MHz) and lower than simpler cores like VexRiscv on the same Colorlight i9.
*   Resource utilization is significantly higher than smaller RISC-V cores, consistent with the SCR1's extended features.
*   The performance is influenced by the complexity of the SCR1 config, Yosys' optimization capabilities, and overhead by the AXI-to-Wishbone bus bridges required for integration within LiteX.
*   If someone were to make a full AXI4 interface realization for all of the components of LiteX, the performance would rise significantly, potentially surpassing VexRiscv.

## Potential Work To Be Done

*   Optimize the SCR1 configuration (explore different variants/options) to find better trade-offs between performance and resource usage within LiteX.
*   Perform timing analysis to identify specific critical paths.
*   Investigate using LiteX's native AXI interconnect support to potentially mitigate bridge overhead.
*   Implement support for timer interrupts and other system features.
*   Refine and potentially upstream the IPIC handler support within LiteX.
*   **Implement support for JTAG debugger** <---- Requested Feature
  
## Licensing

*   The Syntacore SCR1 core is licensed under the Solderpad Hardware License v2.0.
*   LiteX framework components are typically licensed under the BSD 2-Clause license.
*   Other licensed work used.
*   Code specific to this integration project within this repository is licensed under the MIT license.

## Acknowledgements

*   Syntacore for providing the open-source SCR1 core, SDKs and interfaces.
*   The LiteX developers and community.
*   The developers of Yosys, nextpnr, Project Trellis, and sv2v.