import os
from migen import *
from litex.gen import *
from litex import get_data_mod
from litex.soc.interconnect.csr import *
from litex.soc.interconnect import axi
from litex.soc.cores.cpu import CPU
from litex.soc.cores.cpu import CPU_GCC_TRIPLE_RISCV32

CPU_VARIANTS = {
    "full": "SCR1_Full"
}
GCC_FLAGS = {
    "full": "-march=rv32imc_zicsr -mabi=ilp32",
}

class SCR1(CPU):
    family = "riscv"
    category = "softcore"
    name = "scr1"
    human_name = "SCR1"
    variants = CPU_VARIANTS
    endianness = "little"
    gcc_triple = CPU_GCC_TRIPLE_RISCV32
    data_width = 32
    linker_output_format = "elf32-littleriscv"
    io_regions = {0xff00_0000: 0x00f0_0000}
    nop = "nop"
    @property
    def gcc_flags(self):
        flags = GCC_FLAGS[self.variant]
        flags += " -D__scr1__"
        return flags
    def __init__(self, platform, variant="full"):
        self.platform = platform
        self.variant = variant
        self.human_name  = CPU_VARIANTS.get(variant, "SCR1")
        self.external_variant = None
        self.reset = Signal()
        self.interrupt = Signal(16)
        ibus = axi.AXIInterface(data_width=32, address_width=32)
        dbus = axi.AXIInterface(data_width=32, address_width=32)
        self.periph_buses = [ibus, dbus]
        self.memory_buses = []
        self.cpu_params = dict(
            i_pwrup_rst_n = ~(ResetSignal("sys") | self.reset),
            i_clk         = ClockSignal("sys"),
            i_rst_n       = ~(ResetSignal("sys") | self.reset),
            i_cpu_rst_n   = ~(ResetSignal("sys") | self.reset),
            i_test_mode  = 0,
            i_test_rst_n = 1,
            i_rtc_clk = 0,
            i_irq_lines = self.interrupt,
            i_soft_irq  = 0,
            i_fuse_mhartid = 0,
            i_fuse_idcode = 0xDEB11001,
            o_io_axi_imem_awid      = ibus.aw.id,
            o_io_axi_imem_awaddr    = ibus.aw.addr,
            o_io_axi_imem_awlen     = ibus.aw.len,
            o_io_axi_imem_awsize    = ibus.aw.size,
            o_io_axi_imem_awburst   = ibus.aw.burst,
            o_io_axi_imem_awlock    = ibus.aw.lock,
            o_io_axi_imem_awcache   = ibus.aw.cache,
            o_io_axi_imem_awprot    = ibus.aw.prot,
            o_io_axi_imem_awregion  = Open(),
            o_io_axi_imem_awuser    = Open(),
            o_io_axi_imem_awqos     = ibus.aw.qos,
            o_io_axi_imem_awvalid   = ibus.aw.valid,
            i_io_axi_imem_awready   = ibus.aw.ready,
            o_io_axi_imem_wdata     = ibus.w.data,
            o_io_axi_imem_wstrb     = ibus.w.strb,
            o_io_axi_imem_wlast     = ibus.w.last,
            o_io_axi_imem_wuser     = Open(),
            o_io_axi_imem_wvalid    = ibus.w.valid,
            i_io_axi_imem_wready    = ibus.w.ready,
            i_io_axi_imem_bid       = ibus.b.id,
            i_io_axi_imem_bresp     = ibus.b.resp,
            i_io_axi_imem_bvalid    = ibus.b.valid,
            i_io_axi_imem_buser     = 0,
            o_io_axi_imem_bready    = ibus.b.ready,
            o_io_axi_imem_arid      = ibus.ar.id,
            o_io_axi_imem_araddr    = ibus.ar.addr,
            o_io_axi_imem_arlen     = ibus.ar.len,
            o_io_axi_imem_arsize    = ibus.ar.size,
            o_io_axi_imem_arburst   = ibus.ar.burst,
            o_io_axi_imem_arlock    = ibus.ar.lock,
            o_io_axi_imem_arcache   = ibus.ar.cache,
            o_io_axi_imem_arprot    = ibus.ar.prot,
            o_io_axi_imem_arregion  = Open(),
            o_io_axi_imem_aruser    = Open(),
            o_io_axi_imem_arqos     = ibus.ar.qos,
            o_io_axi_imem_arvalid   = ibus.ar.valid,
            i_io_axi_imem_arready   = ibus.ar.ready,
            i_io_axi_imem_rid       = ibus.r.id,
            i_io_axi_imem_rdata     = ibus.r.data,
            i_io_axi_imem_rresp     = ibus.r.resp,
            i_io_axi_imem_rlast     = ibus.r.last,
            i_io_axi_imem_ruser     = 0,
            i_io_axi_imem_rvalid    = ibus.r.valid,
            o_io_axi_imem_rready    = ibus.r.ready,
            o_io_axi_dmem_awid      = dbus.aw.id,
            o_io_axi_dmem_awaddr    = dbus.aw.addr,
            o_io_axi_dmem_awlen     = dbus.aw.len,
            o_io_axi_dmem_awsize    = dbus.aw.size,
            o_io_axi_dmem_awburst   = dbus.aw.burst,
            o_io_axi_dmem_awlock    = dbus.aw.lock,
            o_io_axi_dmem_awcache   = dbus.aw.cache,
            o_io_axi_dmem_awprot    = dbus.aw.prot,
            o_io_axi_dmem_awregion  = Open(),
            o_io_axi_dmem_awuser    = Open(),
            o_io_axi_dmem_awqos     = dbus.aw.qos,
            o_io_axi_dmem_awvalid   = dbus.aw.valid,
            i_io_axi_dmem_awready   = dbus.aw.ready,
            o_io_axi_dmem_wdata     = dbus.w.data,
            o_io_axi_dmem_wstrb     = dbus.w.strb,
            o_io_axi_dmem_wlast     = dbus.w.last,
            o_io_axi_dmem_wuser     = Open(),
            o_io_axi_dmem_wvalid    = dbus.w.valid,
            i_io_axi_dmem_wready    = dbus.w.ready,
            i_io_axi_dmem_bid       = dbus.b.id,
            i_io_axi_dmem_bresp     = dbus.b.resp,
            i_io_axi_dmem_bvalid    = dbus.b.valid,
            i_io_axi_dmem_buser     = 0,
            o_io_axi_dmem_bready    = dbus.b.ready,
            o_io_axi_dmem_arid      = dbus.ar.id,
            o_io_axi_dmem_araddr    = dbus.ar.addr,
            o_io_axi_dmem_arlen     = dbus.ar.len,
            o_io_axi_dmem_arsize    = dbus.ar.size,
            o_io_axi_dmem_arburst   = dbus.ar.burst,
            o_io_axi_dmem_arlock    = dbus.ar.lock,
            o_io_axi_dmem_arcache   = dbus.ar.cache,
            o_io_axi_dmem_arprot    = dbus.ar.prot,
            o_io_axi_dmem_arregion  = Open(),
            o_io_axi_dmem_aruser    = Open(),
            o_io_axi_dmem_arqos     = dbus.ar.qos,
            o_io_axi_dmem_arvalid   = dbus.ar.valid,
            i_io_axi_dmem_arready   = dbus.ar.ready,
            i_io_axi_dmem_rid       = dbus.r.id,
            i_io_axi_dmem_rdata     = dbus.r.data,
            i_io_axi_dmem_rresp     = dbus.r.resp,
            i_io_axi_dmem_rlast     = dbus.r.last,
            i_io_axi_dmem_ruser     = 0,
            i_io_axi_dmem_rvalid    = dbus.r.valid,
            o_io_axi_dmem_rready    = dbus.r.ready,
        )
        self.add_sources(platform)
    @property
    def mem_map(self):
        return {
            "main_ram": 0x1000_0000,
            "csr": 0xff00_0000,
            "rom": 0xfffc_0000,
            "sram": 0xffff_e000,
            "tcm": 0xf0000_0000
        }
    @staticmethod
    def add_sources(platform):
        vdir = get_data_mod("cpu", "scr1").data_location
        top_files = os.path.join(vdir, "top")
        core_files = os.path.join(vdir, "core")
        pipeline_files = os.path.join(core_files, "pipeline")
        primitives_files = os.path.join(core_files, "primitives")
        platform.add_source_dir(top_files)
        platform.add_source_dir(core_files)
        platform.add_source_dir(pipeline_files)
        platform.add_source_dir(primitives_files)
    def set_reset_address(self, reset_address):
        self.reset_address = reset_address
        assert reset_address == 0xfffc_0000, "reset address hardcoded to 0xfffc_0000!"
    def do_finalize(self):
        assert hasattr(self, "reset_address")
        self.specials += Instance("scr1_top_axi", **self.cpu_params)
