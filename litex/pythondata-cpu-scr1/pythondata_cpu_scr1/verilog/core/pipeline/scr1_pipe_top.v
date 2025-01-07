/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_top (
	pipe_rst_n,
	pipe2hdu_rdc_qlfy_i,
	dbg_rst_n,
	clk,
	pipe2imem_req_o,
	pipe2imem_cmd_o,
	pipe2imem_addr_o,
	imem2pipe_req_ack_i,
	imem2pipe_rdata_i,
	imem2pipe_resp_i,
	pipe2dmem_req_o,
	pipe2dmem_cmd_o,
	pipe2dmem_width_o,
	pipe2dmem_addr_o,
	pipe2dmem_wdata_o,
	dmem2pipe_req_ack_i,
	dmem2pipe_rdata_i,
	dmem2pipe_resp_i,
	dbg_en,
	dm2pipe_active_i,
	dm2pipe_cmd_req_i,
	dm2pipe_cmd_i,
	pipe2dm_cmd_resp_o,
	pipe2dm_cmd_rcode_o,
	pipe2dm_hart_event_o,
	pipe2dm_hart_status_o,
	pipe2dm_pbuf_addr_o,
	dm2pipe_pbuf_instr_i,
	pipe2dm_dreg_req_o,
	pipe2dm_dreg_wr_o,
	pipe2dm_dreg_wdata_o,
	dm2pipe_dreg_resp_i,
	dm2pipe_dreg_fail_i,
	dm2pipe_dreg_rdata_i,
	pipe2dm_pc_sample_o,
	soc2pipe_irq_lines_i,
	soc2pipe_irq_soft_i,
	soc2pipe_irq_mtimer_i,
	soc2pipe_mtimer_val_i,
	soc2pipe_fuse_mhartid_i
);
	input wire pipe_rst_n;
	input wire pipe2hdu_rdc_qlfy_i;
	input wire dbg_rst_n;
	input wire clk;
	output wire pipe2imem_req_o;
	output wire pipe2imem_cmd_o;
	output wire [31:0] pipe2imem_addr_o;
	input wire imem2pipe_req_ack_i;
	input wire [31:0] imem2pipe_rdata_i;
	input wire [1:0] imem2pipe_resp_i;
	output wire pipe2dmem_req_o;
	output wire pipe2dmem_cmd_o;
	output wire [1:0] pipe2dmem_width_o;
	output wire [31:0] pipe2dmem_addr_o;
	output wire [31:0] pipe2dmem_wdata_o;
	input wire dmem2pipe_req_ack_i;
	input wire [31:0] dmem2pipe_rdata_i;
	input wire [1:0] dmem2pipe_resp_i;
	input wire dbg_en;
	input wire dm2pipe_active_i;
	input wire dm2pipe_cmd_req_i;
	input wire [1:0] dm2pipe_cmd_i;
	output wire pipe2dm_cmd_resp_o;
	output wire pipe2dm_cmd_rcode_o;
	output wire pipe2dm_hart_event_o;
	output wire [3:0] pipe2dm_hart_status_o;
	localparam [31:0] SCR1_HDU_PBUF_ADDR_SPAN = 8;
	localparam [31:0] SCR1_HDU_PBUF_ADDR_WIDTH = 3;
	output wire [2:0] pipe2dm_pbuf_addr_o;
	localparam [31:0] SCR1_HDU_CORE_INSTR_WIDTH = 32;
	input wire [31:0] dm2pipe_pbuf_instr_i;
	output wire pipe2dm_dreg_req_o;
	output wire pipe2dm_dreg_wr_o;
	output wire [31:0] pipe2dm_dreg_wdata_o;
	input wire dm2pipe_dreg_resp_i;
	input wire dm2pipe_dreg_fail_i;
	input wire [31:0] dm2pipe_dreg_rdata_i;
	output wire [31:0] pipe2dm_pc_sample_o;
	localparam SCR1_IRQ_VECT_NUM = 16;
	localparam SCR1_IRQ_LINES_NUM = SCR1_IRQ_VECT_NUM;
	input wire [15:0] soc2pipe_irq_lines_i;
	input wire soc2pipe_irq_soft_i;
	input wire soc2pipe_irq_mtimer_i;
	input wire [63:0] soc2pipe_mtimer_val_i;
	input wire [31:0] soc2pipe_fuse_mhartid_i;
	wire [31:0] curr_pc;
	wire [31:0] next_pc;
	wire new_pc_req;
	wire [31:0] new_pc;
	wire stop_fetch;
	wire exu_exc_req;
	wire brkpt;
	wire exu_init_pc;
	wire wfi_run2halt;
	wire instret;
	wire instret_nexc;
	wire ipic2csr_irq;
	wire brkpt_hw;
	wire ifu2idu_vd;
	wire [31:0] ifu2idu_instr;
	wire ifu2idu_imem_err;
	wire ifu2idu_err_rvi_hi;
	wire idu2ifu_rdy;
	wire idu2exu_req;
	localparam SCR1_GPR_FIELD_WIDTH = 5;
	localparam SCR1_CSR_CMD_ALL_NUM_E = 4;
	localparam SCR1_CSR_CMD_WIDTH_E = 2;
	localparam SCR1_CSR_OP_ALL_NUM_E = 2;
	localparam SCR1_CSR_OP_WIDTH_E = 1;
	localparam [31:0] SCR1_EXC_CODE_WIDTH_E = 4;
	localparam SCR1_IALU_CMD_ALL_NUM_E = 23;
	localparam SCR1_IALU_CMD_WIDTH_E = 5;
	localparam SCR1_IALU_OP_ALL_NUM_E = 2;
	localparam SCR1_IALU_OP_WIDTH_E = 1;
	localparam SCR1_SUM2_OP_ALL_NUM_E = 2;
	localparam SCR1_SUM2_OP_WIDTH_E = 1;
	localparam SCR1_LSU_CMD_ALL_NUM_E = 9;
	localparam SCR1_LSU_CMD_WIDTH_E = 4;
	localparam SCR1_RD_WB_ALL_NUM_E = 7;
	localparam SCR1_RD_WB_WIDTH_E = 3;
	wire [74:0] idu2exu_cmd;
	wire idu2exu_use_rs1;
	wire idu2exu_use_rs2;
	wire idu2exu_use_rd;
	wire idu2exu_use_imm;
	wire exu2idu_rdy;
	wire [4:0] exu2mprf_rs1_addr;
	wire [31:0] mprf2exu_rs1_data;
	wire [4:0] exu2mprf_rs2_addr;
	wire [31:0] mprf2exu_rs2_data;
	wire exu2mprf_w_req;
	wire [4:0] exu2mprf_rd_addr;
	wire [31:0] exu2mprf_rd_data;
	localparam [31:0] SCR1_CSR_ADDR_WIDTH = 12;
	wire [11:0] exu2csr_rw_addr;
	wire exu2csr_r_req;
	wire [31:0] csr2exu_r_data;
	wire exu2csr_w_req;
	wire [1:0] exu2csr_w_cmd;
	wire [31:0] exu2csr_w_data;
	wire csr2exu_rw_exc;
	wire exu2csr_take_irq;
	wire exu2csr_take_exc;
	wire exu2csr_mret_update;
	wire exu2csr_mret_instr;
	wire [3:0] exu2csr_exc_code;
	wire [31:0] exu2csr_trap_val;
	wire [31:0] csr2exu_new_pc;
	wire csr2exu_irq;
	wire csr2exu_ip_ie;
	wire csr2exu_mstatus_mie_up;
	wire csr2ipic_r_req;
	wire csr2ipic_w_req;
	wire [2:0] csr2ipic_addr;
	wire [31:0] csr2ipic_wdata;
	wire [31:0] ipic2csr_rdata;
	wire csr2tdu_req;
	wire [1:0] csr2tdu_cmd;
	localparam SCR1_CSR_ADDR_TDU_OFFS_W = 3;
	wire [2:0] csr2tdu_addr;
	wire [31:0] csr2tdu_wdata;
	wire [31:0] tdu2csr_rdata;
	wire tdu2csr_resp;
	wire csr2tdu_req_qlfy;
	wire [33:0] exu2tdu_i_mon;
	wire [34:0] lsu2tdu_d_mon;
	localparam [31:0] SCR1_TDU_TRIG_NUM = 4;
	localparam [31:0] SCR1_TDU_MTRIG_NUM = SCR1_TDU_TRIG_NUM;
	localparam [31:0] SCR1_TDU_ALLTRIG_NUM = SCR1_TDU_MTRIG_NUM + 1'b1;
	wire [SCR1_TDU_ALLTRIG_NUM - 1:0] tdu2exu_i_match;
	wire [3:0] tdu2lsu_d_match;
	wire tdu2exu_i_x_req;
	wire tdu2lsu_i_x_req;
	wire tdu2lsu_d_x_req;
	wire [SCR1_TDU_ALLTRIG_NUM - 1:0] exu2tdu_bp_retire;
	wire [33:0] exu2tdu_i_mon_qlfy;
	wire [34:0] lsu2tdu_d_mon_qlfy;
	wire [SCR1_TDU_ALLTRIG_NUM - 1:0] exu2tdu_bp_retire_qlfy;
	wire fetch_pbuf;
	wire csr2hdu_req;
	wire [1:0] csr2hdu_cmd;
	function automatic [11:0] sv2v_cast_C1AAB;
		input reg [11:0] inp;
		sv2v_cast_C1AAB = inp;
	endfunction
	localparam [11:0] SCR1_CSR_ADDR_HDU_MSPAN = sv2v_cast_C1AAB('h4);
	localparam [31:0] SCR1_HDU_DEBUGCSR_ADDR_SPAN = SCR1_CSR_ADDR_HDU_MSPAN;
	localparam [31:0] SCR1_HDU_DEBUGCSR_ADDR_WIDTH = $clog2(SCR1_HDU_DEBUGCSR_ADDR_SPAN);
	wire [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] csr2hdu_addr;
	wire [31:0] csr2hdu_wdata;
	wire [31:0] hdu2csr_rdata;
	wire hdu2csr_resp;
	wire csr2hdu_req_qlfy;
	wire hwbrk_dsbl;
	wire hdu_hwbrk_dsbl;
	wire tdu2hdu_dmode_req;
	wire exu_no_commit;
	wire exu_irq_dsbl;
	wire exu_pc_advmt_dsbl;
	wire exu_dmode_sstep_en;
	wire dbg_halted;
	wire dbg_run2halt;
	wire dbg_halt2run;
	wire dbg_run_start;
	wire [31:0] dbg_new_pc;
	wire ifu2hdu_pbuf_rdy;
	wire hdu2ifu_pbuf_vd;
	wire hdu2ifu_pbuf_err;
	wire [31:0] hdu2ifu_pbuf_instr;
	wire ifu2hdu_pbuf_rdy_qlfy;
	wire exu_busy_qlfy;
	wire instret_qlfy;
	wire exu_init_pc_qlfy;
	wire exu_exc_req_qlfy;
	wire brkpt_qlfy;
	wire exu_busy;
	wire pipe2clkctl_wake_req_o;
	assign stop_fetch = wfi_run2halt | fetch_pbuf;
	assign pipe2dm_pc_sample_o = curr_pc;
	scr1_pipe_ifu i_pipe_ifu(
		.rst_n(pipe_rst_n),
		.clk(clk),
		.imem2ifu_req_ack_i(imem2pipe_req_ack_i),
		.ifu2imem_req_o(pipe2imem_req_o),
		.ifu2imem_cmd_o(pipe2imem_cmd_o),
		.ifu2imem_addr_o(pipe2imem_addr_o),
		.imem2ifu_rdata_i(imem2pipe_rdata_i),
		.imem2ifu_resp_i(imem2pipe_resp_i),
		.exu2ifu_pc_new_req_i(new_pc_req),
		.exu2ifu_pc_new_i(new_pc),
		.pipe2ifu_stop_fetch_i(stop_fetch),
		.hdu2ifu_pbuf_fetch_i(fetch_pbuf),
		.ifu2hdu_pbuf_rdy_o(ifu2hdu_pbuf_rdy),
		.hdu2ifu_pbuf_vd_i(hdu2ifu_pbuf_vd),
		.hdu2ifu_pbuf_err_i(hdu2ifu_pbuf_err),
		.hdu2ifu_pbuf_instr_i(hdu2ifu_pbuf_instr),
		.idu2ifu_rdy_i(idu2ifu_rdy),
		.ifu2idu_instr_o(ifu2idu_instr),
		.ifu2idu_imem_err_o(ifu2idu_imem_err),
		.ifu2idu_err_rvi_hi_o(ifu2idu_err_rvi_hi),
		.ifu2idu_vd_o(ifu2idu_vd)
	);
	scr1_pipe_idu i_pipe_idu(
		.idu2ifu_rdy_o(idu2ifu_rdy),
		.ifu2idu_instr_i(ifu2idu_instr),
		.ifu2idu_imem_err_i(ifu2idu_imem_err),
		.ifu2idu_err_rvi_hi_i(ifu2idu_err_rvi_hi),
		.ifu2idu_vd_i(ifu2idu_vd),
		.idu2exu_req_o(idu2exu_req),
		.idu2exu_cmd_o(idu2exu_cmd),
		.idu2exu_use_rs1_o(idu2exu_use_rs1),
		.idu2exu_use_rs2_o(idu2exu_use_rs2),
		.idu2exu_use_rd_o(idu2exu_use_rd),
		.idu2exu_use_imm_o(idu2exu_use_imm),
		.exu2idu_rdy_i(exu2idu_rdy)
	);
	scr1_pipe_exu i_pipe_exu(
		.rst_n(pipe_rst_n),
		.clk(clk),
		.idu2exu_req_i(idu2exu_req),
		.exu2idu_rdy_o(exu2idu_rdy),
		.idu2exu_cmd_i(idu2exu_cmd),
		.idu2exu_use_rs1_i(idu2exu_use_rs1),
		.idu2exu_use_rs2_i(idu2exu_use_rs2),
		.idu2exu_use_rd_i(idu2exu_use_rd),
		.idu2exu_use_imm_i(idu2exu_use_imm),
		.exu2mprf_rs1_addr_o(exu2mprf_rs1_addr),
		.mprf2exu_rs1_data_i(mprf2exu_rs1_data),
		.exu2mprf_rs2_addr_o(exu2mprf_rs2_addr),
		.mprf2exu_rs2_data_i(mprf2exu_rs2_data),
		.exu2mprf_w_req_o(exu2mprf_w_req),
		.exu2mprf_rd_addr_o(exu2mprf_rd_addr),
		.exu2mprf_rd_data_o(exu2mprf_rd_data),
		.exu2csr_rw_addr_o(exu2csr_rw_addr),
		.exu2csr_r_req_o(exu2csr_r_req),
		.csr2exu_r_data_i(csr2exu_r_data),
		.exu2csr_w_req_o(exu2csr_w_req),
		.exu2csr_w_cmd_o(exu2csr_w_cmd),
		.exu2csr_w_data_o(exu2csr_w_data),
		.csr2exu_rw_exc_i(csr2exu_rw_exc),
		.exu2csr_take_irq_o(exu2csr_take_irq),
		.exu2csr_take_exc_o(exu2csr_take_exc),
		.exu2csr_mret_update_o(exu2csr_mret_update),
		.exu2csr_mret_instr_o(exu2csr_mret_instr),
		.exu2csr_exc_code_o(exu2csr_exc_code),
		.exu2csr_trap_val_o(exu2csr_trap_val),
		.csr2exu_new_pc_i(csr2exu_new_pc),
		.csr2exu_irq_i(csr2exu_irq),
		.csr2exu_ip_ie_i(csr2exu_ip_ie),
		.csr2exu_mstatus_mie_up_i(csr2exu_mstatus_mie_up),
		.exu2dmem_req_o(pipe2dmem_req_o),
		.exu2dmem_cmd_o(pipe2dmem_cmd_o),
		.exu2dmem_width_o(pipe2dmem_width_o),
		.exu2dmem_addr_o(pipe2dmem_addr_o),
		.exu2dmem_wdata_o(pipe2dmem_wdata_o),
		.dmem2exu_req_ack_i(dmem2pipe_req_ack_i),
		.dmem2exu_rdata_i(dmem2pipe_rdata_i),
		.dmem2exu_resp_i(dmem2pipe_resp_i),
		.hdu2exu_no_commit_i(exu_no_commit),
		.hdu2exu_irq_dsbl_i(exu_irq_dsbl),
		.hdu2exu_pc_advmt_dsbl_i(exu_pc_advmt_dsbl),
		.hdu2exu_dmode_sstep_en_i(exu_dmode_sstep_en),
		.hdu2exu_pbuf_fetch_i(fetch_pbuf),
		.hdu2exu_dbg_halted_i(dbg_halted),
		.hdu2exu_dbg_run2halt_i(dbg_run2halt),
		.hdu2exu_dbg_halt2run_i(dbg_halt2run),
		.hdu2exu_dbg_run_start_i(dbg_run_start),
		.hdu2exu_dbg_new_pc_i(dbg_new_pc),
		.exu2tdu_imon_o(exu2tdu_i_mon),
		.tdu2exu_ibrkpt_match_i(tdu2exu_i_match),
		.tdu2exu_ibrkpt_exc_req_i(tdu2exu_i_x_req),
		.lsu2tdu_dmon_o(lsu2tdu_d_mon),
		.tdu2lsu_ibrkpt_exc_req_i(tdu2lsu_i_x_req),
		.tdu2lsu_dbrkpt_match_i(tdu2lsu_d_match),
		.tdu2lsu_dbrkpt_exc_req_i(tdu2lsu_d_x_req),
		.exu2tdu_ibrkpt_ret_o(exu2tdu_bp_retire),
		.exu2hdu_ibrkpt_hw_o(brkpt_hw),
		.exu2pipe_exc_req_o(exu_exc_req),
		.exu2pipe_brkpt_o(brkpt),
		.exu2pipe_init_pc_o(exu_init_pc),
		.exu2pipe_wfi_run2halt_o(wfi_run2halt),
		.exu2pipe_instret_o(instret),
		.exu2csr_instret_no_exc_o(instret_nexc),
		.exu2pipe_exu_busy_o(exu_busy),
		.exu2pipe_pc_curr_o(curr_pc),
		.exu2csr_pc_next_o(next_pc),
		.exu2ifu_pc_new_req_o(new_pc_req),
		.exu2ifu_pc_new_o(new_pc)
	);
	scr1_pipe_mprf i_pipe_mprf(
		.rst_n(pipe_rst_n),
		.clk(clk),
		.exu2mprf_rs1_addr_i(exu2mprf_rs1_addr),
		.mprf2exu_rs1_data_o(mprf2exu_rs1_data),
		.exu2mprf_rs2_addr_i(exu2mprf_rs2_addr),
		.mprf2exu_rs2_data_o(mprf2exu_rs2_data),
		.exu2mprf_w_req_i(exu2mprf_w_req),
		.exu2mprf_rd_addr_i(exu2mprf_rd_addr),
		.exu2mprf_rd_data_i(exu2mprf_rd_data)
	);
	scr1_pipe_csr i_pipe_csr(
		.rst_n(pipe_rst_n),
		.clk(clk),
		.exu2csr_r_req_i(exu2csr_r_req),
		.exu2csr_rw_addr_i(exu2csr_rw_addr),
		.csr2exu_r_data_o(csr2exu_r_data),
		.exu2csr_w_req_i(exu2csr_w_req),
		.exu2csr_w_cmd_i(exu2csr_w_cmd),
		.exu2csr_w_data_i(exu2csr_w_data),
		.csr2exu_rw_exc_o(csr2exu_rw_exc),
		.exu2csr_take_irq_i(exu2csr_take_irq),
		.exu2csr_take_exc_i(exu2csr_take_exc),
		.exu2csr_mret_update_i(exu2csr_mret_update),
		.exu2csr_mret_instr_i(exu2csr_mret_instr),
		.exu2csr_exc_code_i(exu2csr_exc_code),
		.exu2csr_trap_val_i(exu2csr_trap_val),
		.csr2exu_new_pc_o(csr2exu_new_pc),
		.csr2exu_irq_o(csr2exu_irq),
		.csr2exu_ip_ie_o(csr2exu_ip_ie),
		.csr2exu_mstatus_mie_up_o(csr2exu_mstatus_mie_up),
		.csr2ipic_r_req_o(csr2ipic_r_req),
		.csr2ipic_w_req_o(csr2ipic_w_req),
		.csr2ipic_addr_o(csr2ipic_addr),
		.csr2ipic_wdata_o(csr2ipic_wdata),
		.ipic2csr_rdata_i(ipic2csr_rdata),
		.exu2csr_pc_curr_i(curr_pc),
		.exu2csr_pc_next_i(next_pc),
		.exu2csr_instret_no_exc_i(instret_nexc),
		.soc2csr_irq_ext_i(ipic2csr_irq),
		.soc2csr_irq_soft_i(soc2pipe_irq_soft_i),
		.soc2csr_irq_mtimer_i(soc2pipe_irq_mtimer_i),
		.soc2csr_mtimer_val_i(soc2pipe_mtimer_val_i),
		.csr2hdu_req_o(csr2hdu_req),
		.csr2hdu_cmd_o(csr2hdu_cmd),
		.csr2hdu_addr_o(csr2hdu_addr),
		.csr2hdu_wdata_o(csr2hdu_wdata),
		.hdu2csr_rdata_i(hdu2csr_rdata),
		.hdu2csr_resp_i(hdu2csr_resp),
		.hdu2csr_no_commit_i(exu_no_commit),
		.csr2tdu_req_o(csr2tdu_req),
		.csr2tdu_cmd_o(csr2tdu_cmd),
		.csr2tdu_addr_o(csr2tdu_addr),
		.csr2tdu_wdata_o(csr2tdu_wdata),
		.tdu2csr_rdata_i(tdu2csr_rdata),
		.tdu2csr_resp_i(tdu2csr_resp),
		.soc2csr_fuse_mhartid_i(soc2pipe_fuse_mhartid_i)
	);
	scr1_ipic i_pipe_ipic(
		.rst_n(pipe_rst_n),
		.clk(clk),
		.soc2ipic_irq_lines_i(soc2pipe_irq_lines_i),
		.csr2ipic_r_req_i(csr2ipic_r_req),
		.csr2ipic_w_req_i(csr2ipic_w_req),
		.csr2ipic_addr_i(csr2ipic_addr),
		.csr2ipic_wdata_i(csr2ipic_wdata),
		.ipic2csr_rdata_o(ipic2csr_rdata),
		.ipic2csr_irq_m_req_o(ipic2csr_irq)
	);
	scr1_pipe_tdu i_pipe_tdu(
		.rst_n(dbg_rst_n),
		.clk(clk),
		.clk_en(1'b1),
		.tdu_dsbl_i(hwbrk_dsbl),
		.csr2tdu_req_i(csr2tdu_req_qlfy),
		.csr2tdu_cmd_i(csr2tdu_cmd),
		.csr2tdu_addr_i(csr2tdu_addr),
		.csr2tdu_wdata_i(csr2tdu_wdata),
		.tdu2csr_rdata_o(tdu2csr_rdata),
		.tdu2csr_resp_o(tdu2csr_resp),
		.exu2tdu_imon_i(exu2tdu_i_mon_qlfy),
		.tdu2exu_ibrkpt_match_o(tdu2exu_i_match),
		.tdu2exu_ibrkpt_exc_req_o(tdu2exu_i_x_req),
		.exu2tdu_bp_retire_i(exu2tdu_bp_retire_qlfy),
		.tdu2lsu_ibrkpt_exc_req_o(tdu2lsu_i_x_req),
		.lsu2tdu_dmon_i(lsu2tdu_d_mon_qlfy),
		.tdu2lsu_dbrkpt_match_o(tdu2lsu_d_match),
		.tdu2lsu_dbrkpt_exc_req_o(tdu2lsu_d_x_req),
		.tdu2hdu_dmode_req_o(tdu2hdu_dmode_req)
	);
	assign hwbrk_dsbl = ~dbg_en | hdu_hwbrk_dsbl;
	assign csr2tdu_req_qlfy = (dbg_en & csr2tdu_req) & pipe2hdu_rdc_qlfy_i;
	assign exu2tdu_i_mon_qlfy[33] = exu2tdu_i_mon[33] & pipe2hdu_rdc_qlfy_i;
	assign exu2tdu_i_mon_qlfy[32] = exu2tdu_i_mon[32];
	assign exu2tdu_i_mon_qlfy[31-:32] = exu2tdu_i_mon[31-:32];
	assign lsu2tdu_d_mon_qlfy[34] = lsu2tdu_d_mon[34] & pipe2hdu_rdc_qlfy_i;
	assign lsu2tdu_d_mon_qlfy[33] = lsu2tdu_d_mon[33];
	assign lsu2tdu_d_mon_qlfy[32] = lsu2tdu_d_mon[32];
	assign lsu2tdu_d_mon_qlfy[31-:32] = lsu2tdu_d_mon[31-:32];
	assign exu2tdu_bp_retire_qlfy = exu2tdu_bp_retire & {SCR1_TDU_ALLTRIG_NUM {pipe2hdu_rdc_qlfy_i}};
	scr1_pipe_hdu i_pipe_hdu(
		.rst_n(dbg_rst_n),
		.clk_en(dm2pipe_active_i),
		.clk(clk),
		.csr2hdu_req_i(csr2hdu_req_qlfy),
		.csr2hdu_cmd_i(csr2hdu_cmd),
		.csr2hdu_addr_i(csr2hdu_addr),
		.csr2hdu_wdata_i(csr2hdu_wdata),
		.hdu2csr_resp_o(hdu2csr_resp),
		.hdu2csr_rdata_o(hdu2csr_rdata),
		.pipe2hdu_rdc_qlfy_i(pipe2hdu_rdc_qlfy_i),
		.dm2hdu_cmd_req_i(dm2pipe_cmd_req_i),
		.dm2hdu_cmd_i(dm2pipe_cmd_i),
		.hdu2dm_cmd_resp_o(pipe2dm_cmd_resp_o),
		.hdu2dm_cmd_rcode_o(pipe2dm_cmd_rcode_o),
		.hdu2dm_hart_event_o(pipe2dm_hart_event_o),
		.hdu2dm_hart_status_o(pipe2dm_hart_status_o),
		.hdu2dm_pbuf_addr_o(pipe2dm_pbuf_addr_o),
		.dm2hdu_pbuf_instr_i(dm2pipe_pbuf_instr_i),
		.hdu2dm_dreg_req_o(pipe2dm_dreg_req_o),
		.hdu2dm_dreg_wr_o(pipe2dm_dreg_wr_o),
		.hdu2dm_dreg_wdata_o(pipe2dm_dreg_wdata_o),
		.dm2hdu_dreg_resp_i(dm2pipe_dreg_resp_i),
		.dm2hdu_dreg_fail_i(dm2pipe_dreg_fail_i),
		.dm2hdu_dreg_rdata_i(dm2pipe_dreg_rdata_i),
		.hdu2tdu_hwbrk_dsbl_o(hdu_hwbrk_dsbl),
		.tdu2hdu_dmode_req_i(tdu2hdu_dmode_req),
		.exu2hdu_ibrkpt_hw_i(brkpt_hw),
		.pipe2hdu_exu_busy_i(exu_busy_qlfy),
		.pipe2hdu_instret_i(instret_qlfy),
		.pipe2hdu_init_pc_i(exu_init_pc_qlfy),
		.pipe2hdu_exu_exc_req_i(exu_exc_req_qlfy),
		.pipe2hdu_brkpt_i(brkpt_qlfy),
		.hdu2exu_pbuf_fetch_o(fetch_pbuf),
		.hdu2exu_no_commit_o(exu_no_commit),
		.hdu2exu_irq_dsbl_o(exu_irq_dsbl),
		.hdu2exu_pc_advmt_dsbl_o(exu_pc_advmt_dsbl),
		.hdu2exu_dmode_sstep_en_o(exu_dmode_sstep_en),
		.hdu2exu_dbg_halted_o(dbg_halted),
		.hdu2exu_dbg_run2halt_o(dbg_run2halt),
		.hdu2exu_dbg_halt2run_o(dbg_halt2run),
		.hdu2exu_dbg_run_start_o(dbg_run_start),
		.pipe2hdu_pc_curr_i(curr_pc),
		.hdu2exu_dbg_new_pc_o(dbg_new_pc),
		.ifu2hdu_pbuf_instr_rdy_i(ifu2hdu_pbuf_rdy_qlfy),
		.hdu2ifu_pbuf_instr_vd_o(hdu2ifu_pbuf_vd),
		.hdu2ifu_pbuf_instr_err_o(hdu2ifu_pbuf_err),
		.hdu2ifu_pbuf_instr_o(hdu2ifu_pbuf_instr)
	);
	assign csr2hdu_req_qlfy = (csr2hdu_req & dbg_en) & pipe2hdu_rdc_qlfy_i;
	assign exu_busy_qlfy = exu_busy & {pipe2hdu_rdc_qlfy_i};
	assign instret_qlfy = instret & {pipe2hdu_rdc_qlfy_i};
	assign exu_init_pc_qlfy = exu_init_pc & {pipe2hdu_rdc_qlfy_i};
	assign exu_exc_req_qlfy = exu_exc_req & {pipe2hdu_rdc_qlfy_i};
	assign brkpt_qlfy = brkpt & {pipe2hdu_rdc_qlfy_i};
	assign ifu2hdu_pbuf_rdy_qlfy = ifu2hdu_pbuf_rdy & {pipe2hdu_rdc_qlfy_i};
endmodule
