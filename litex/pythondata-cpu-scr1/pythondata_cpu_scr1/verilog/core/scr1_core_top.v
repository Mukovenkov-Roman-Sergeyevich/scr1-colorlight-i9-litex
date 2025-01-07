/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_core_top (
	pwrup_rst_n,
	rst_n,
	cpu_rst_n,
	test_mode,
	test_rst_n,
	clk,
	core_rst_n_o,
	core_rdc_qlfy_o,
	sys_rst_n_o,
	sys_rdc_qlfy_o,
	core_fuse_mhartid_i,
	tapc_fuse_idcode_i,
	core_irq_lines_i,
	core_irq_soft_i,
	core_irq_mtimer_i,
	core_mtimer_val_i,
	tapc_trst_n,
	tapc_tck,
	tapc_tms,
	tapc_tdi,
	tapc_tdo,
	tapc_tdo_en,
	imem2core_req_ack_i,
	core2imem_req_o,
	core2imem_cmd_o,
	core2imem_addr_o,
	imem2core_rdata_i,
	imem2core_resp_i,
	dmem2core_req_ack_i,
	core2dmem_req_o,
	core2dmem_cmd_o,
	core2dmem_width_o,
	core2dmem_addr_o,
	core2dmem_wdata_o,
	dmem2core_rdata_i,
	dmem2core_resp_i
);
	input wire pwrup_rst_n;
	input wire rst_n;
	input wire cpu_rst_n;
	input wire test_mode;
	input wire test_rst_n;
	input wire clk;
	output wire core_rst_n_o;
	output wire core_rdc_qlfy_o;
	output wire sys_rst_n_o;
	output wire sys_rdc_qlfy_o;
	input wire [31:0] core_fuse_mhartid_i;
	input wire [31:0] tapc_fuse_idcode_i;
	localparam SCR1_IRQ_VECT_NUM = 16;
	localparam SCR1_IRQ_LINES_NUM = SCR1_IRQ_VECT_NUM;
	input wire [15:0] core_irq_lines_i;
	input wire core_irq_soft_i;
	input wire core_irq_mtimer_i;
	input wire [63:0] core_mtimer_val_i;
	input wire tapc_trst_n;
	input wire tapc_tck;
	input wire tapc_tms;
	input wire tapc_tdi;
	output wire tapc_tdo;
	output wire tapc_tdo_en;
	input wire imem2core_req_ack_i;
	output wire core2imem_req_o;
	output wire core2imem_cmd_o;
	output wire [31:0] core2imem_addr_o;
	input wire [31:0] imem2core_rdata_i;
	input wire [1:0] imem2core_resp_i;
	input wire dmem2core_req_ack_i;
	output wire core2dmem_req_o;
	output wire core2dmem_cmd_o;
	output wire [1:0] core2dmem_width_o;
	output wire [31:0] core2dmem_addr_o;
	output wire [31:0] core2dmem_wdata_o;
	input wire [31:0] dmem2core_rdata_i;
	input wire [1:0] dmem2core_resp_i;
	localparam [31:0] SCR1_CORE_TOP_RST_SYNC_STAGES_NUM = 2;
	wire core_rst_n;
	wire core_rst_n_status_sync;
	wire core_rst_status;
	wire core2hdu_rdc_qlfy;
	wire core2dm_rdc_qlfy;
	wire pwrup_rst_n_sync;
	wire rst_n_sync;
	wire cpu_rst_n_sync;
	wire tapc_dmi_ch_sel;
	localparam SCR1_DBG_DMI_CH_ID_WIDTH = 2'd2;
	wire [SCR1_DBG_DMI_CH_ID_WIDTH - 1:0] tapc_dmi_ch_id;
	wire tapc_dmi_ch_capture;
	wire tapc_dmi_ch_shift;
	wire tapc_dmi_ch_update;
	wire tapc_dmi_ch_tdi;
	wire tapc_dmi_ch_tdo;
	wire tapc_dmi_ch_sel_tapout;
	wire [SCR1_DBG_DMI_CH_ID_WIDTH - 1:0] tapc_dmi_ch_id_tapout;
	wire tapc_dmi_ch_capture_tapout;
	wire tapc_dmi_ch_shift_tapout;
	wire tapc_dmi_ch_update_tapout;
	wire tapc_dmi_ch_tdi_tapout;
	wire tapc_dmi_ch_tdo_tapin;
	wire dmi_req;
	wire dmi_wr;
	localparam SCR1_DBG_DMI_ADDR_WIDTH = 6'd7;
	wire [SCR1_DBG_DMI_ADDR_WIDTH - 1:0] dmi_addr;
	localparam SCR1_DBG_DMI_DATA_WIDTH = 6'd32;
	wire [SCR1_DBG_DMI_DATA_WIDTH - 1:0] dmi_wdata;
	wire dmi_resp;
	wire [SCR1_DBG_DMI_DATA_WIDTH - 1:0] dmi_rdata;
	wire tapc_scu_ch_sel;
	wire tapc_scu_ch_sel_tapout;
	wire tapc_scu_ch_tdo;
	wire tapc_ch_tdo;
	wire sys_rst_n;
	wire sys_rst_status;
	wire hdu_rst_n;
	wire hdu2dm_rdc_qlfy;
	wire ndm_rst_n;
	wire dm_rst_n;
	wire hart_rst_n;
	wire dm_active;
	wire dm_cmd_req;
	wire [1:0] dm_cmd;
	wire dm_cmd_resp;
	wire dm_cmd_resp_qlfy;
	wire dm_cmd_rcode;
	wire dm_hart_event;
	wire dm_hart_event_qlfy;
	wire [3:0] dm_hart_status;
	wire [3:0] dm_hart_status_qlfy;
	localparam [31:0] SCR1_HDU_PBUF_ADDR_SPAN = 8;
	localparam [31:0] SCR1_HDU_PBUF_ADDR_WIDTH = 3;
	wire [2:0] dm_pbuf_addr;
	wire [2:0] dm_pbuf_addr_qlfy;
	localparam [31:0] SCR1_HDU_CORE_INSTR_WIDTH = 32;
	wire [31:0] dm_pbuf_instr;
	wire dm_dreg_req;
	wire dm_dreg_req_qlfy;
	wire dm_dreg_wr;
	localparam [31:0] SCR1_HDU_DATA_REG_WIDTH = 32;
	wire [31:0] dm_dreg_wdata;
	wire dm_dreg_resp;
	wire dm_dreg_fail;
	wire [31:0] dm_dreg_rdata;
	wire [31:0] dm_pc_sample;
	wire [31:0] dm_pc_sample_qlfy;
	scr1_scu i_scu(
		.pwrup_rst_n(pwrup_rst_n),
		.rst_n(rst_n),
		.cpu_rst_n(cpu_rst_n),
		.test_mode(test_mode),
		.test_rst_n(test_rst_n),
		.clk(clk),
		.tapcsync2scu_ch_sel_i(tapc_scu_ch_sel),
		.tapcsync2scu_ch_id_i(1'sb0),
		.tapcsync2scu_ch_capture_i(tapc_dmi_ch_capture),
		.tapcsync2scu_ch_shift_i(tapc_dmi_ch_shift),
		.tapcsync2scu_ch_update_i(tapc_dmi_ch_update),
		.tapcsync2scu_ch_tdi_i(tapc_dmi_ch_tdi),
		.scu2tapcsync_ch_tdo_o(tapc_scu_ch_tdo),
		.ndm_rst_n_i(ndm_rst_n),
		.hart_rst_n_i(hart_rst_n),
		.sys_rst_n_o(sys_rst_n),
		.core_rst_n_o(core_rst_n),
		.dm_rst_n_o(dm_rst_n),
		.hdu_rst_n_o(hdu_rst_n),
		.sys_rst_status_o(sys_rst_status),
		.core_rst_status_o(core_rst_status),
		.sys_rdc_qlfy_o(sys_rdc_qlfy_o),
		.core_rdc_qlfy_o(core_rdc_qlfy_o),
		.core2hdu_rdc_qlfy_o(core2hdu_rdc_qlfy),
		.core2dm_rdc_qlfy_o(core2dm_rdc_qlfy),
		.hdu2dm_rdc_qlfy_o(hdu2dm_rdc_qlfy)
	);
	assign sys_rst_n_o = sys_rst_n;
	assign pwrup_rst_n_sync = pwrup_rst_n;
	assign core_rst_n_o = core_rst_n;
	scr1_pipe_top i_pipe_top(
		.pipe_rst_n(core_rst_n),
		.pipe2hdu_rdc_qlfy_i(core2hdu_rdc_qlfy),
		.dbg_rst_n(hdu_rst_n),
		.clk(clk),
		.pipe2imem_req_o(core2imem_req_o),
		.pipe2imem_cmd_o(core2imem_cmd_o),
		.pipe2imem_addr_o(core2imem_addr_o),
		.imem2pipe_req_ack_i(imem2core_req_ack_i),
		.imem2pipe_rdata_i(imem2core_rdata_i),
		.imem2pipe_resp_i(imem2core_resp_i),
		.pipe2dmem_req_o(core2dmem_req_o),
		.pipe2dmem_cmd_o(core2dmem_cmd_o),
		.pipe2dmem_width_o(core2dmem_width_o),
		.pipe2dmem_addr_o(core2dmem_addr_o),
		.pipe2dmem_wdata_o(core2dmem_wdata_o),
		.dmem2pipe_req_ack_i(dmem2core_req_ack_i),
		.dmem2pipe_rdata_i(dmem2core_rdata_i),
		.dmem2pipe_resp_i(dmem2core_resp_i),
		.dbg_en(1'b1),
		.dm2pipe_active_i(dm_active),
		.dm2pipe_cmd_req_i(dm_cmd_req),
		.dm2pipe_cmd_i(dm_cmd),
		.pipe2dm_cmd_resp_o(dm_cmd_resp),
		.pipe2dm_cmd_rcode_o(dm_cmd_rcode),
		.pipe2dm_hart_event_o(dm_hart_event),
		.pipe2dm_hart_status_o(dm_hart_status),
		.pipe2dm_pbuf_addr_o(dm_pbuf_addr),
		.dm2pipe_pbuf_instr_i(dm_pbuf_instr),
		.pipe2dm_dreg_req_o(dm_dreg_req),
		.pipe2dm_dreg_wr_o(dm_dreg_wr),
		.pipe2dm_dreg_wdata_o(dm_dreg_wdata),
		.dm2pipe_dreg_resp_i(dm_dreg_resp),
		.dm2pipe_dreg_fail_i(dm_dreg_fail),
		.dm2pipe_dreg_rdata_i(dm_dreg_rdata),
		.pipe2dm_pc_sample_o(dm_pc_sample),
		.soc2pipe_irq_lines_i(core_irq_lines_i),
		.soc2pipe_irq_soft_i(core_irq_soft_i),
		.soc2pipe_irq_mtimer_i(core_irq_mtimer_i),
		.soc2pipe_mtimer_val_i(core_mtimer_val_i),
		.soc2pipe_fuse_mhartid_i(core_fuse_mhartid_i)
	);
	scr1_tapc i_tapc(
		.tapc_trst_n(tapc_trst_n),
		.tapc_tck(tapc_tck),
		.tapc_tms(tapc_tms),
		.tapc_tdi(tapc_tdi),
		.tapc_tdo(tapc_tdo),
		.tapc_tdo_en(tapc_tdo_en),
		.soc2tapc_fuse_idcode_i(tapc_fuse_idcode_i),
		.tapc2tapcsync_scu_ch_sel_o(tapc_scu_ch_sel_tapout),
		.tapc2tapcsync_dmi_ch_sel_o(tapc_dmi_ch_sel_tapout),
		.tapc2tapcsync_ch_id_o(tapc_dmi_ch_id_tapout),
		.tapc2tapcsync_ch_capture_o(tapc_dmi_ch_capture_tapout),
		.tapc2tapcsync_ch_shift_o(tapc_dmi_ch_shift_tapout),
		.tapc2tapcsync_ch_update_o(tapc_dmi_ch_update_tapout),
		.tapc2tapcsync_ch_tdi_o(tapc_dmi_ch_tdi_tapout),
		.tapcsync2tapc_ch_tdo_i(tapc_dmi_ch_tdo_tapin)
	);
	scr1_tapc_synchronizer i_tapc_synchronizer(
		.pwrup_rst_n(pwrup_rst_n_sync),
		.dm_rst_n(dm_rst_n),
		.clk(clk),
		.tapc_trst_n(tapc_trst_n),
		.tapc_tck(tapc_tck),
		.tapc2tapcsync_scu_ch_sel_i(tapc_scu_ch_sel_tapout),
		.tapcsync2scu_ch_sel_o(tapc_scu_ch_sel),
		.tapc2tapcsync_dmi_ch_sel_i(tapc_dmi_ch_sel_tapout),
		.tapcsync2dmi_ch_sel_o(tapc_dmi_ch_sel),
		.tapc2tapcsync_ch_id_i(tapc_dmi_ch_id_tapout),
		.tapcsync2core_ch_id_o(tapc_dmi_ch_id),
		.tapc2tapcsync_ch_capture_i(tapc_dmi_ch_capture_tapout),
		.tapcsync2core_ch_capture_o(tapc_dmi_ch_capture),
		.tapc2tapcsync_ch_shift_i(tapc_dmi_ch_shift_tapout),
		.tapcsync2core_ch_shift_o(tapc_dmi_ch_shift),
		.tapc2tapcsync_ch_update_i(tapc_dmi_ch_update_tapout),
		.tapcsync2core_ch_update_o(tapc_dmi_ch_update),
		.tapc2tapcsync_ch_tdi_i(tapc_dmi_ch_tdi_tapout),
		.tapcsync2core_ch_tdi_o(tapc_dmi_ch_tdi),
		.tapc2tapcsync_ch_tdo_i(tapc_dmi_ch_tdo_tapin),
		.tapcsync2core_ch_tdo_o(tapc_ch_tdo)
	);
	assign tapc_ch_tdo = (tapc_scu_ch_tdo & tapc_scu_ch_sel) | (tapc_dmi_ch_tdo & tapc_dmi_ch_sel);
	scr1_dmi i_dmi(
		.rst_n(dm_rst_n),
		.clk(clk),
		.tapcsync2dmi_ch_sel_i(tapc_dmi_ch_sel),
		.tapcsync2dmi_ch_id_i(tapc_dmi_ch_id),
		.tapcsync2dmi_ch_capture_i(tapc_dmi_ch_capture),
		.tapcsync2dmi_ch_shift_i(tapc_dmi_ch_shift),
		.tapcsync2dmi_ch_update_i(tapc_dmi_ch_update),
		.tapcsync2dmi_ch_tdi_i(tapc_dmi_ch_tdi),
		.dmi2tapcsync_ch_tdo_o(tapc_dmi_ch_tdo),
		.dm2dmi_resp_i(dmi_resp),
		.dm2dmi_rdata_i(dmi_rdata),
		.dmi2dm_req_o(dmi_req),
		.dmi2dm_wr_o(dmi_wr),
		.dmi2dm_addr_o(dmi_addr),
		.dmi2dm_wdata_o(dmi_wdata)
	);
	assign dm_cmd_resp_qlfy = dm_cmd_resp & {hdu2dm_rdc_qlfy};
	assign dm_hart_event_qlfy = dm_hart_event & {hdu2dm_rdc_qlfy};
	assign dm_hart_status_qlfy[1-:2] = (hdu2dm_rdc_qlfy ? dm_hart_status[1-:2] : 2'b00);
	assign dm_hart_status_qlfy[3] = dm_hart_status[3];
	assign dm_hart_status_qlfy[2] = dm_hart_status[2];
	assign dm_pbuf_addr_qlfy = dm_pbuf_addr & {SCR1_HDU_PBUF_ADDR_WIDTH {hdu2dm_rdc_qlfy}};
	assign dm_dreg_req_qlfy = dm_dreg_req & {hdu2dm_rdc_qlfy};
	assign dm_pc_sample_qlfy = dm_pc_sample & {32 {core2dm_rdc_qlfy}};
	scr1_dm i_dm(
		.rst_n(dm_rst_n),
		.clk(clk),
		.dmi2dm_req_i(dmi_req),
		.dmi2dm_wr_i(dmi_wr),
		.dmi2dm_addr_i(dmi_addr),
		.dmi2dm_wdata_i(dmi_wdata),
		.dm2dmi_resp_o(dmi_resp),
		.dm2dmi_rdata_o(dmi_rdata),
		.ndm_rst_n_o(ndm_rst_n),
		.hart_rst_n_o(hart_rst_n),
		.dm2pipe_active_o(dm_active),
		.dm2pipe_cmd_req_o(dm_cmd_req),
		.dm2pipe_cmd_o(dm_cmd),
		.pipe2dm_cmd_resp_i(dm_cmd_resp_qlfy),
		.pipe2dm_cmd_rcode_i(dm_cmd_rcode),
		.pipe2dm_hart_event_i(dm_hart_event_qlfy),
		.pipe2dm_hart_status_i(dm_hart_status_qlfy),
		.soc2dm_fuse_mhartid_i(core_fuse_mhartid_i),
		.pipe2dm_pc_sample_i(dm_pc_sample_qlfy),
		.pipe2dm_pbuf_addr_i(dm_pbuf_addr_qlfy),
		.dm2pipe_pbuf_instr_o(dm_pbuf_instr),
		.pipe2dm_dreg_req_i(dm_dreg_req_qlfy),
		.pipe2dm_dreg_wr_i(dm_dreg_wr),
		.pipe2dm_dreg_wdata_i(dm_dreg_wdata),
		.dm2pipe_dreg_resp_o(dm_dreg_resp),
		.dm2pipe_dreg_fail_o(dm_dreg_fail),
		.dm2pipe_dreg_rdata_o(dm_dreg_rdata)
	);
endmodule
