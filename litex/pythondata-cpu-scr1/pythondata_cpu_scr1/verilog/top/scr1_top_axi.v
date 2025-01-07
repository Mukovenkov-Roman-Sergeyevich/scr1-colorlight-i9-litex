/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_top_axi (
	pwrup_rst_n,
	rst_n,
	cpu_rst_n,
	test_mode,
	test_rst_n,
	clk,
	rtc_clk,
	sys_rst_n_o,
	sys_rdc_qlfy_o,
	fuse_mhartid,
	fuse_idcode,
	irq_lines,
	soft_irq,
	trst_n,
	tck,
	tms,
	tdi,
	tdo,
	tdo_en,
	io_axi_imem_awid,
	io_axi_imem_awaddr,
	io_axi_imem_awlen,
	io_axi_imem_awsize,
	io_axi_imem_awburst,
	io_axi_imem_awlock,
	io_axi_imem_awcache,
	io_axi_imem_awprot,
	io_axi_imem_awregion,
	io_axi_imem_awuser,
	io_axi_imem_awqos,
	io_axi_imem_awvalid,
	io_axi_imem_awready,
	io_axi_imem_wdata,
	io_axi_imem_wstrb,
	io_axi_imem_wlast,
	io_axi_imem_wuser,
	io_axi_imem_wvalid,
	io_axi_imem_wready,
	io_axi_imem_bid,
	io_axi_imem_bresp,
	io_axi_imem_bvalid,
	io_axi_imem_buser,
	io_axi_imem_bready,
	io_axi_imem_arid,
	io_axi_imem_araddr,
	io_axi_imem_arlen,
	io_axi_imem_arsize,
	io_axi_imem_arburst,
	io_axi_imem_arlock,
	io_axi_imem_arcache,
	io_axi_imem_arprot,
	io_axi_imem_arregion,
	io_axi_imem_aruser,
	io_axi_imem_arqos,
	io_axi_imem_arvalid,
	io_axi_imem_arready,
	io_axi_imem_rid,
	io_axi_imem_rdata,
	io_axi_imem_rresp,
	io_axi_imem_rlast,
	io_axi_imem_ruser,
	io_axi_imem_rvalid,
	io_axi_imem_rready,
	io_axi_dmem_awid,
	io_axi_dmem_awaddr,
	io_axi_dmem_awlen,
	io_axi_dmem_awsize,
	io_axi_dmem_awburst,
	io_axi_dmem_awlock,
	io_axi_dmem_awcache,
	io_axi_dmem_awprot,
	io_axi_dmem_awregion,
	io_axi_dmem_awuser,
	io_axi_dmem_awqos,
	io_axi_dmem_awvalid,
	io_axi_dmem_awready,
	io_axi_dmem_wdata,
	io_axi_dmem_wstrb,
	io_axi_dmem_wlast,
	io_axi_dmem_wuser,
	io_axi_dmem_wvalid,
	io_axi_dmem_wready,
	io_axi_dmem_bid,
	io_axi_dmem_bresp,
	io_axi_dmem_bvalid,
	io_axi_dmem_buser,
	io_axi_dmem_bready,
	io_axi_dmem_arid,
	io_axi_dmem_araddr,
	io_axi_dmem_arlen,
	io_axi_dmem_arsize,
	io_axi_dmem_arburst,
	io_axi_dmem_arlock,
	io_axi_dmem_arcache,
	io_axi_dmem_arprot,
	io_axi_dmem_arregion,
	io_axi_dmem_aruser,
	io_axi_dmem_arqos,
	io_axi_dmem_arvalid,
	io_axi_dmem_arready,
	io_axi_dmem_rid,
	io_axi_dmem_rdata,
	io_axi_dmem_rresp,
	io_axi_dmem_rlast,
	io_axi_dmem_ruser,
	io_axi_dmem_rvalid,
	io_axi_dmem_rready
);
	input wire pwrup_rst_n;
	input wire rst_n;
	input wire cpu_rst_n;
	input wire test_mode;
	input wire test_rst_n;
	input wire clk;
	input wire rtc_clk;
	output wire sys_rst_n_o;
	output wire sys_rdc_qlfy_o;
	input wire [31:0] fuse_mhartid;
	input wire [31:0] fuse_idcode;
	localparam SCR1_IRQ_VECT_NUM = 16;
	localparam SCR1_IRQ_LINES_NUM = SCR1_IRQ_VECT_NUM;
	input wire [15:0] irq_lines;
	input wire soft_irq;
	input wire trst_n;
	input wire tck;
	input wire tms;
	input wire tdi;
	output wire tdo;
	output wire tdo_en;
	output wire [3:0] io_axi_imem_awid;
	output wire [31:0] io_axi_imem_awaddr;
	output wire [7:0] io_axi_imem_awlen;
	output wire [2:0] io_axi_imem_awsize;
	output wire [1:0] io_axi_imem_awburst;
	output wire io_axi_imem_awlock;
	output wire [3:0] io_axi_imem_awcache;
	output wire [2:0] io_axi_imem_awprot;
	output wire [3:0] io_axi_imem_awregion;
	output wire [3:0] io_axi_imem_awuser;
	output wire [3:0] io_axi_imem_awqos;
	output wire io_axi_imem_awvalid;
	input wire io_axi_imem_awready;
	output wire [31:0] io_axi_imem_wdata;
	output wire [3:0] io_axi_imem_wstrb;
	output wire io_axi_imem_wlast;
	output wire [3:0] io_axi_imem_wuser;
	output wire io_axi_imem_wvalid;
	input wire io_axi_imem_wready;
	input wire [3:0] io_axi_imem_bid;
	input wire [1:0] io_axi_imem_bresp;
	input wire io_axi_imem_bvalid;
	input wire [3:0] io_axi_imem_buser;
	output wire io_axi_imem_bready;
	output wire [3:0] io_axi_imem_arid;
	output wire [31:0] io_axi_imem_araddr;
	output wire [7:0] io_axi_imem_arlen;
	output wire [2:0] io_axi_imem_arsize;
	output wire [1:0] io_axi_imem_arburst;
	output wire io_axi_imem_arlock;
	output wire [3:0] io_axi_imem_arcache;
	output wire [2:0] io_axi_imem_arprot;
	output wire [3:0] io_axi_imem_arregion;
	output wire [3:0] io_axi_imem_aruser;
	output wire [3:0] io_axi_imem_arqos;
	output wire io_axi_imem_arvalid;
	input wire io_axi_imem_arready;
	input wire [3:0] io_axi_imem_rid;
	input wire [31:0] io_axi_imem_rdata;
	input wire [1:0] io_axi_imem_rresp;
	input wire io_axi_imem_rlast;
	input wire [3:0] io_axi_imem_ruser;
	input wire io_axi_imem_rvalid;
	output wire io_axi_imem_rready;
	output wire [3:0] io_axi_dmem_awid;
	output wire [31:0] io_axi_dmem_awaddr;
	output wire [7:0] io_axi_dmem_awlen;
	output wire [2:0] io_axi_dmem_awsize;
	output wire [1:0] io_axi_dmem_awburst;
	output wire io_axi_dmem_awlock;
	output wire [3:0] io_axi_dmem_awcache;
	output wire [2:0] io_axi_dmem_awprot;
	output wire [3:0] io_axi_dmem_awregion;
	output wire [3:0] io_axi_dmem_awuser;
	output wire [3:0] io_axi_dmem_awqos;
	output wire io_axi_dmem_awvalid;
	input wire io_axi_dmem_awready;
	output wire [31:0] io_axi_dmem_wdata;
	output wire [3:0] io_axi_dmem_wstrb;
	output wire io_axi_dmem_wlast;
	output wire [3:0] io_axi_dmem_wuser;
	output wire io_axi_dmem_wvalid;
	input wire io_axi_dmem_wready;
	input wire [3:0] io_axi_dmem_bid;
	input wire [1:0] io_axi_dmem_bresp;
	input wire io_axi_dmem_bvalid;
	input wire [3:0] io_axi_dmem_buser;
	output wire io_axi_dmem_bready;
	output wire [3:0] io_axi_dmem_arid;
	output wire [31:0] io_axi_dmem_araddr;
	output wire [7:0] io_axi_dmem_arlen;
	output wire [2:0] io_axi_dmem_arsize;
	output wire [1:0] io_axi_dmem_arburst;
	output wire io_axi_dmem_arlock;
	output wire [3:0] io_axi_dmem_arcache;
	output wire [2:0] io_axi_dmem_arprot;
	output wire [3:0] io_axi_dmem_arregion;
	output wire [3:0] io_axi_dmem_aruser;
	output wire [3:0] io_axi_dmem_arqos;
	output wire io_axi_dmem_arvalid;
	input wire io_axi_dmem_arready;
	input wire [3:0] io_axi_dmem_rid;
	input wire [31:0] io_axi_dmem_rdata;
	input wire [1:0] io_axi_dmem_rresp;
	input wire io_axi_dmem_rlast;
	input wire [3:0] io_axi_dmem_ruser;
	input wire io_axi_dmem_rvalid;
	output wire io_axi_dmem_rready;
	localparam [31:0] SCR1_CLUSTER_TOP_RST_SYNC_STAGES_NUM = 2;
	wire pwrup_rst_n_sync;
	wire rst_n_sync;
	wire cpu_rst_n_sync;
	wire core_rst_n_local;
	wire axi_rst_n;
	wire tapc_trst_n;
	wire core_imem_req_ack;
	wire core_imem_req;
	wire core_imem_cmd;
	wire [31:0] core_imem_addr;
	wire [31:0] core_imem_rdata;
	wire [1:0] core_imem_resp;
	wire core_dmem_req_ack;
	wire core_dmem_req;
	wire core_dmem_cmd;
	wire [1:0] core_dmem_width;
	wire [31:0] core_dmem_addr;
	wire [31:0] core_dmem_wdata;
	wire [31:0] core_dmem_rdata;
	wire [1:0] core_dmem_resp;
	wire axi_imem_req_ack;
	wire axi_imem_req;
	wire axi_imem_cmd;
	wire [31:0] axi_imem_addr;
	wire [31:0] axi_imem_rdata;
	wire [1:0] axi_imem_resp;
	wire axi_dmem_req_ack;
	wire axi_dmem_req;
	wire axi_dmem_cmd;
	wire [1:0] axi_dmem_width;
	wire [31:0] axi_dmem_addr;
	wire [31:0] axi_dmem_wdata;
	wire [31:0] axi_dmem_rdata;
	wire [1:0] axi_dmem_resp;
	wire tcm_imem_req_ack;
	wire tcm_imem_req;
	wire tcm_imem_cmd;
	wire [31:0] tcm_imem_addr;
	wire [31:0] tcm_imem_rdata;
	wire [1:0] tcm_imem_resp;
	wire tcm_dmem_req_ack;
	wire tcm_dmem_req;
	wire tcm_dmem_cmd;
	wire [1:0] tcm_dmem_width;
	wire [31:0] tcm_dmem_addr;
	wire [31:0] tcm_dmem_wdata;
	wire [31:0] tcm_dmem_rdata;
	wire [1:0] tcm_dmem_resp;
	wire timer_dmem_req_ack;
	wire timer_dmem_req;
	wire timer_dmem_cmd;
	wire [1:0] timer_dmem_width;
	wire [31:0] timer_dmem_addr;
	wire [31:0] timer_dmem_wdata;
	wire [31:0] timer_dmem_rdata;
	wire [1:0] timer_dmem_resp;
	wire timer_irq;
	wire [63:0] timer_val;
	reg axi_reinit;
	wire axi_imem_idle;
	wire axi_dmem_idle;
	scr1_reset_sync_cell #(.STAGES_AMOUNT(SCR1_CLUSTER_TOP_RST_SYNC_STAGES_NUM)) i_pwrup_rstn_reset_sync(
		.rst_n(pwrup_rst_n),
		.clk(clk),
		.test_rst_n(test_rst_n),
		.test_mode(test_mode),
		.rst_n_in(1'b1),
		.rst_n_out(pwrup_rst_n_sync)
	);
	scr1_reset_sync_cell #(.STAGES_AMOUNT(SCR1_CLUSTER_TOP_RST_SYNC_STAGES_NUM)) i_rstn_reset_sync(
		.rst_n(pwrup_rst_n),
		.clk(clk),
		.test_rst_n(test_rst_n),
		.test_mode(test_mode),
		.rst_n_in(rst_n),
		.rst_n_out(rst_n_sync)
	);
	scr1_reset_sync_cell #(.STAGES_AMOUNT(SCR1_CLUSTER_TOP_RST_SYNC_STAGES_NUM)) i_cpu_rstn_reset_sync(
		.rst_n(pwrup_rst_n),
		.clk(clk),
		.test_rst_n(test_rst_n),
		.test_mode(test_mode),
		.rst_n_in(cpu_rst_n),
		.rst_n_out(cpu_rst_n_sync)
	);
	scr1_reset_and2_cell i_tapc_rstn_and2_cell(
		.rst_n_in({trst_n, pwrup_rst_n}),
		.test_rst_n(test_rst_n),
		.test_mode(test_mode),
		.rst_n_out(tapc_trst_n)
	);
	assign axi_rst_n = sys_rst_n_o;
	scr1_core_top i_core_top(
		.pwrup_rst_n(pwrup_rst_n_sync),
		.rst_n(rst_n_sync),
		.cpu_rst_n(cpu_rst_n_sync),
		.test_mode(test_mode),
		.test_rst_n(test_rst_n),
		.clk(clk),
		.core_rst_n_o(core_rst_n_local),
		.core_rdc_qlfy_o(),
		.sys_rst_n_o(sys_rst_n_o),
		.sys_rdc_qlfy_o(sys_rdc_qlfy_o),
		.core_fuse_mhartid_i(fuse_mhartid),
		.tapc_fuse_idcode_i(fuse_idcode),
		.core_irq_lines_i(irq_lines),
		.core_irq_soft_i(soft_irq),
		.core_irq_mtimer_i(timer_irq),
		.core_mtimer_val_i(timer_val),
		.tapc_trst_n(tapc_trst_n),
		.tapc_tck(tck),
		.tapc_tms(tms),
		.tapc_tdi(tdi),
		.tapc_tdo(tdo),
		.tapc_tdo_en(tdo_en),
		.imem2core_req_ack_i(core_imem_req_ack),
		.core2imem_req_o(core_imem_req),
		.core2imem_cmd_o(core_imem_cmd),
		.core2imem_addr_o(core_imem_addr),
		.imem2core_rdata_i(core_imem_rdata),
		.imem2core_resp_i(core_imem_resp),
		.dmem2core_req_ack_i(core_dmem_req_ack),
		.core2dmem_req_o(core_dmem_req),
		.core2dmem_cmd_o(core_dmem_cmd),
		.core2dmem_width_o(core_dmem_width),
		.core2dmem_addr_o(core_dmem_addr),
		.core2dmem_wdata_o(core_dmem_wdata),
		.dmem2core_rdata_i(core_dmem_rdata),
		.dmem2core_resp_i(core_dmem_resp)
	);
	localparam [31:0] SCR1_TCM_ADDR_MASK = 'hffff0000;
	scr1_tcm #(.SCR1_TCM_SIZE(~SCR1_TCM_ADDR_MASK + 1'b1)) i_tcm(
		.clk(clk),
		.rst_n(core_rst_n_local),
		.imem_req_ack(tcm_imem_req_ack),
		.imem_req(tcm_imem_req),
		.imem_addr(tcm_imem_addr),
		.imem_rdata(tcm_imem_rdata),
		.imem_resp(tcm_imem_resp),
		.dmem_req_ack(tcm_dmem_req_ack),
		.dmem_req(tcm_dmem_req),
		.dmem_cmd(tcm_dmem_cmd),
		.dmem_width(tcm_dmem_width),
		.dmem_addr(tcm_dmem_addr),
		.dmem_wdata(tcm_dmem_wdata),
		.dmem_rdata(tcm_dmem_rdata),
		.dmem_resp(tcm_dmem_resp)
	);
	scr1_timer i_timer(
		.rst_n(core_rst_n_local),
		.clk(clk),
		.rtc_clk(rtc_clk),
		.dmem_req(timer_dmem_req),
		.dmem_cmd(timer_dmem_cmd),
		.dmem_width(timer_dmem_width),
		.dmem_addr(timer_dmem_addr),
		.dmem_wdata(timer_dmem_wdata),
		.dmem_req_ack(timer_dmem_req_ack),
		.dmem_rdata(timer_dmem_rdata),
		.dmem_resp(timer_dmem_resp),
		.timer_val(timer_val),
		.timer_irq(timer_irq)
	);
	localparam [31:0] SCR1_TCM_ADDR_PATTERN = 'hf0000000;
	scr1_imem_router #(
		.SCR1_ADDR_MASK(SCR1_TCM_ADDR_MASK),
		.SCR1_ADDR_PATTERN(SCR1_TCM_ADDR_PATTERN)
	) i_imem_router(
		.rst_n(core_rst_n_local),
		.clk(clk),
		.imem_req_ack(core_imem_req_ack),
		.imem_req(core_imem_req),
		.imem_cmd(core_imem_cmd),
		.imem_addr(core_imem_addr),
		.imem_rdata(core_imem_rdata),
		.imem_resp(core_imem_resp),
		.port0_req_ack(axi_imem_req_ack),
		.port0_req(axi_imem_req),
		.port0_cmd(axi_imem_cmd),
		.port0_addr(axi_imem_addr),
		.port0_rdata(axi_imem_rdata),
		.port0_resp(axi_imem_resp),
		.port1_req_ack(tcm_imem_req_ack),
		.port1_req(tcm_imem_req),
		.port1_cmd(tcm_imem_cmd),
		.port1_addr(tcm_imem_addr),
		.port1_rdata(tcm_imem_rdata),
		.port1_resp(tcm_imem_resp)
	);
	localparam [31:0] SCR1_TIMER_ADDR_MASK = 'hffffffe0;
	localparam [31:0] SCR1_TIMER_ADDR_PATTERN = 'hf0040000;
	scr1_dmem_router #(
		.SCR1_PORT1_ADDR_MASK(SCR1_TCM_ADDR_MASK),
		.SCR1_PORT1_ADDR_PATTERN(SCR1_TCM_ADDR_PATTERN),
		.SCR1_PORT2_ADDR_MASK(SCR1_TIMER_ADDR_MASK),
		.SCR1_PORT2_ADDR_PATTERN(SCR1_TIMER_ADDR_PATTERN)
	) i_dmem_router(
		.rst_n(core_rst_n_local),
		.clk(clk),
		.dmem_req_ack(core_dmem_req_ack),
		.dmem_req(core_dmem_req),
		.dmem_cmd(core_dmem_cmd),
		.dmem_width(core_dmem_width),
		.dmem_addr(core_dmem_addr),
		.dmem_wdata(core_dmem_wdata),
		.dmem_rdata(core_dmem_rdata),
		.dmem_resp(core_dmem_resp),
		.port1_req_ack(tcm_dmem_req_ack),
		.port1_req(tcm_dmem_req),
		.port1_cmd(tcm_dmem_cmd),
		.port1_width(tcm_dmem_width),
		.port1_addr(tcm_dmem_addr),
		.port1_wdata(tcm_dmem_wdata),
		.port1_rdata(tcm_dmem_rdata),
		.port1_resp(tcm_dmem_resp),
		.port2_req_ack(timer_dmem_req_ack),
		.port2_req(timer_dmem_req),
		.port2_cmd(timer_dmem_cmd),
		.port2_width(timer_dmem_width),
		.port2_addr(timer_dmem_addr),
		.port2_wdata(timer_dmem_wdata),
		.port2_rdata(timer_dmem_rdata),
		.port2_resp(timer_dmem_resp),
		.port0_req_ack(axi_dmem_req_ack),
		.port0_req(axi_dmem_req),
		.port0_cmd(axi_dmem_cmd),
		.port0_width(axi_dmem_width),
		.port0_addr(axi_dmem_addr),
		.port0_wdata(axi_dmem_wdata),
		.port0_rdata(axi_dmem_rdata),
		.port0_resp(axi_dmem_resp)
	);
	scr1_mem_axi #(
		.SCR1_AXI_REQ_BP(1),
		.SCR1_AXI_RESP_BP(1)
	) i_imem_axi(
		.clk(clk),
		.rst_n(axi_rst_n),
		.axi_reinit(axi_reinit),
		.core_idle(axi_imem_idle),
		.core_req_ack(axi_imem_req_ack),
		.core_req(axi_imem_req),
		.core_cmd(axi_imem_cmd),
		.core_width(2'b10),
		.core_addr(axi_imem_addr),
		.core_wdata(1'sb0),
		.core_rdata(axi_imem_rdata),
		.core_resp(axi_imem_resp),
		.awid(io_axi_imem_awid),
		.awaddr(io_axi_imem_awaddr),
		.awlen(io_axi_imem_awlen),
		.awsize(io_axi_imem_awsize),
		.awburst(io_axi_imem_awburst),
		.awlock(io_axi_imem_awlock),
		.awcache(io_axi_imem_awcache),
		.awprot(io_axi_imem_awprot),
		.awregion(io_axi_imem_awregion),
		.awuser(io_axi_imem_awuser),
		.awqos(io_axi_imem_awqos),
		.awvalid(io_axi_imem_awvalid),
		.awready(io_axi_imem_awready),
		.wdata(io_axi_imem_wdata),
		.wstrb(io_axi_imem_wstrb),
		.wlast(io_axi_imem_wlast),
		.wuser(io_axi_imem_wuser),
		.wvalid(io_axi_imem_wvalid),
		.wready(io_axi_imem_wready),
		.bid(io_axi_imem_bid),
		.bresp(io_axi_imem_bresp),
		.bvalid(io_axi_imem_bvalid),
		.buser(io_axi_imem_buser),
		.bready(io_axi_imem_bready),
		.arid(io_axi_imem_arid),
		.araddr(io_axi_imem_araddr),
		.arlen(io_axi_imem_arlen),
		.arsize(io_axi_imem_arsize),
		.arburst(io_axi_imem_arburst),
		.arlock(io_axi_imem_arlock),
		.arcache(io_axi_imem_arcache),
		.arprot(io_axi_imem_arprot),
		.arregion(io_axi_imem_arregion),
		.aruser(io_axi_imem_aruser),
		.arqos(io_axi_imem_arqos),
		.arvalid(io_axi_imem_arvalid),
		.arready(io_axi_imem_arready),
		.rid(io_axi_imem_rid),
		.rdata(io_axi_imem_rdata),
		.rresp(io_axi_imem_rresp),
		.rlast(io_axi_imem_rlast),
		.ruser(io_axi_imem_ruser),
		.rvalid(io_axi_imem_rvalid),
		.rready(io_axi_imem_rready)
	);
	scr1_mem_axi #(
		.SCR1_AXI_REQ_BP(1),
		.SCR1_AXI_RESP_BP(1)
	) i_dmem_axi(
		.clk(clk),
		.rst_n(axi_rst_n),
		.axi_reinit(axi_reinit),
		.core_idle(axi_dmem_idle),
		.core_req_ack(axi_dmem_req_ack),
		.core_req(axi_dmem_req),
		.core_cmd(axi_dmem_cmd),
		.core_width(axi_dmem_width),
		.core_addr(axi_dmem_addr),
		.core_wdata(axi_dmem_wdata),
		.core_rdata(axi_dmem_rdata),
		.core_resp(axi_dmem_resp),
		.awid(io_axi_dmem_awid),
		.awaddr(io_axi_dmem_awaddr),
		.awlen(io_axi_dmem_awlen),
		.awsize(io_axi_dmem_awsize),
		.awburst(io_axi_dmem_awburst),
		.awlock(io_axi_dmem_awlock),
		.awcache(io_axi_dmem_awcache),
		.awprot(io_axi_dmem_awprot),
		.awregion(io_axi_dmem_awregion),
		.awuser(io_axi_dmem_awuser),
		.awqos(io_axi_dmem_awqos),
		.awvalid(io_axi_dmem_awvalid),
		.awready(io_axi_dmem_awready),
		.wdata(io_axi_dmem_wdata),
		.wstrb(io_axi_dmem_wstrb),
		.wlast(io_axi_dmem_wlast),
		.wuser(io_axi_dmem_wuser),
		.wvalid(io_axi_dmem_wvalid),
		.wready(io_axi_dmem_wready),
		.bid(io_axi_dmem_bid),
		.bresp(io_axi_dmem_bresp),
		.bvalid(io_axi_dmem_bvalid),
		.buser(io_axi_dmem_buser),
		.bready(io_axi_dmem_bready),
		.arid(io_axi_dmem_arid),
		.araddr(io_axi_dmem_araddr),
		.arlen(io_axi_dmem_arlen),
		.arsize(io_axi_dmem_arsize),
		.arburst(io_axi_dmem_arburst),
		.arlock(io_axi_dmem_arlock),
		.arcache(io_axi_dmem_arcache),
		.arprot(io_axi_dmem_arprot),
		.arregion(io_axi_dmem_arregion),
		.aruser(io_axi_dmem_aruser),
		.arqos(io_axi_dmem_arqos),
		.arvalid(io_axi_dmem_arvalid),
		.arready(io_axi_dmem_arready),
		.rid(io_axi_dmem_rid),
		.rdata(io_axi_dmem_rdata),
		.rresp(io_axi_dmem_rresp),
		.rlast(io_axi_dmem_rlast),
		.ruser(io_axi_dmem_ruser),
		.rvalid(io_axi_dmem_rvalid),
		.rready(io_axi_dmem_rready)
	);
	always @(negedge core_rst_n_local or posedge clk)
		if (~core_rst_n_local)
			axi_reinit <= 1'b1;
		else if (axi_imem_idle & axi_dmem_idle)
			axi_reinit <= 1'b0;
endmodule
