/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_hdu (
	rst_n,
	clk,
	clk_en,
	pipe2hdu_rdc_qlfy_i,
	csr2hdu_req_i,
	csr2hdu_cmd_i,
	csr2hdu_addr_i,
	csr2hdu_wdata_i,
	hdu2csr_resp_o,
	hdu2csr_rdata_o,
	dm2hdu_cmd_req_i,
	dm2hdu_cmd_i,
	hdu2dm_cmd_resp_o,
	hdu2dm_cmd_rcode_o,
	hdu2dm_hart_event_o,
	hdu2dm_hart_status_o,
	hdu2dm_pbuf_addr_o,
	dm2hdu_pbuf_instr_i,
	hdu2dm_dreg_req_o,
	hdu2dm_dreg_wr_o,
	hdu2dm_dreg_wdata_o,
	dm2hdu_dreg_resp_i,
	dm2hdu_dreg_fail_i,
	dm2hdu_dreg_rdata_i,
	hdu2tdu_hwbrk_dsbl_o,
	tdu2hdu_dmode_req_i,
	exu2hdu_ibrkpt_hw_i,
	pipe2hdu_exu_busy_i,
	pipe2hdu_instret_i,
	pipe2hdu_init_pc_i,
	pipe2hdu_exu_exc_req_i,
	pipe2hdu_brkpt_i,
	hdu2exu_pbuf_fetch_o,
	hdu2exu_no_commit_o,
	hdu2exu_irq_dsbl_o,
	hdu2exu_pc_advmt_dsbl_o,
	hdu2exu_dmode_sstep_en_o,
	hdu2exu_dbg_halted_o,
	hdu2exu_dbg_run2halt_o,
	hdu2exu_dbg_halt2run_o,
	hdu2exu_dbg_run_start_o,
	pipe2hdu_pc_curr_i,
	hdu2exu_dbg_new_pc_o,
	ifu2hdu_pbuf_instr_rdy_i,
	hdu2ifu_pbuf_instr_vd_o,
	hdu2ifu_pbuf_instr_err_o,
	hdu2ifu_pbuf_instr_o
);
	reg _sv2v_0;
	parameter HART_PBUF_INSTR_REGOUT_EN = 1'b1;
	input wire rst_n;
	input wire clk;
	input wire clk_en;
	input wire pipe2hdu_rdc_qlfy_i;
	input wire csr2hdu_req_i;
	localparam SCR1_CSR_CMD_ALL_NUM_E = 4;
	localparam SCR1_CSR_CMD_WIDTH_E = 2;
	input wire [1:0] csr2hdu_cmd_i;
	localparam [31:0] SCR1_CSR_ADDR_WIDTH = 12;
	function automatic [11:0] sv2v_cast_C1AAB;
		input reg [11:0] inp;
		sv2v_cast_C1AAB = inp;
	endfunction
	localparam [11:0] SCR1_CSR_ADDR_HDU_MSPAN = sv2v_cast_C1AAB('h4);
	localparam [31:0] SCR1_HDU_DEBUGCSR_ADDR_SPAN = SCR1_CSR_ADDR_HDU_MSPAN;
	localparam [31:0] SCR1_HDU_DEBUGCSR_ADDR_WIDTH = $clog2(SCR1_HDU_DEBUGCSR_ADDR_SPAN);
	input wire [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] csr2hdu_addr_i;
	input wire [31:0] csr2hdu_wdata_i;
	output wire hdu2csr_resp_o;
	output wire [31:0] hdu2csr_rdata_o;
	input wire dm2hdu_cmd_req_i;
	input wire [1:0] dm2hdu_cmd_i;
	output reg hdu2dm_cmd_resp_o;
	output wire hdu2dm_cmd_rcode_o;
	output wire hdu2dm_hart_event_o;
	output reg [3:0] hdu2dm_hart_status_o;
	localparam [31:0] SCR1_HDU_PBUF_ADDR_SPAN = 8;
	localparam [31:0] SCR1_HDU_PBUF_ADDR_WIDTH = 3;
	output wire [2:0] hdu2dm_pbuf_addr_o;
	localparam [31:0] SCR1_HDU_CORE_INSTR_WIDTH = 32;
	input wire [31:0] dm2hdu_pbuf_instr_i;
	output wire hdu2dm_dreg_req_o;
	output wire hdu2dm_dreg_wr_o;
	output wire [31:0] hdu2dm_dreg_wdata_o;
	input wire dm2hdu_dreg_resp_i;
	input wire dm2hdu_dreg_fail_i;
	input wire [31:0] dm2hdu_dreg_rdata_i;
	output wire hdu2tdu_hwbrk_dsbl_o;
	input wire tdu2hdu_dmode_req_i;
	input wire exu2hdu_ibrkpt_hw_i;
	input wire pipe2hdu_exu_busy_i;
	input wire pipe2hdu_instret_i;
	input wire pipe2hdu_init_pc_i;
	input wire pipe2hdu_exu_exc_req_i;
	input wire pipe2hdu_brkpt_i;
	output wire hdu2exu_pbuf_fetch_o;
	output wire hdu2exu_no_commit_o;
	output wire hdu2exu_irq_dsbl_o;
	output wire hdu2exu_pc_advmt_dsbl_o;
	output wire hdu2exu_dmode_sstep_en_o;
	output wire hdu2exu_dbg_halted_o;
	output wire hdu2exu_dbg_run2halt_o;
	output wire hdu2exu_dbg_halt2run_o;
	output wire hdu2exu_dbg_run_start_o;
	input wire [31:0] pipe2hdu_pc_curr_i;
	output wire [31:0] hdu2exu_dbg_new_pc_o;
	input wire ifu2hdu_pbuf_instr_rdy_i;
	output wire hdu2ifu_pbuf_instr_vd_o;
	output wire hdu2ifu_pbuf_instr_err_o;
	output reg [31:0] hdu2ifu_pbuf_instr_o;
	localparam [31:0] SCR1_HDU_TIMEOUT = 64;
	localparam [31:0] SCR1_HDU_TIMEOUT_WIDTH = 6;
	wire dm_dhalt_req;
	wire dm_run_req;
	wire dm_cmd_run;
	wire dm_cmd_dhalted;
	wire dm_cmd_drun;
	reg [1:0] dbg_state;
	reg [1:0] dbg_state_next;
	wire dbg_state_dhalted;
	wire dbg_state_drun;
	wire dbg_state_run;
	wire dbg_state_reset;
	reg dfsm_trans;
	reg dfsm_trans_next;
	reg dfsm_update;
	reg dfsm_update_next;
	reg dfsm_event;
	reg dfsm_event_next;
	wire hart_resume_req;
	wire hart_halt_req;
	reg hart_cmd_req;
	wire hart_runctrl_upd;
	wire hart_runctrl_clr;
	reg [5:0] hart_runctrl;
	reg [5:0] halt_req_timeout_cnt;
	wire [5:0] halt_req_timeout_cnt_next;
	wire halt_req_timeout_cnt_en;
	wire halt_req_timeout_flag;
	reg [3:0] hart_haltstatus;
	reg [2:0] hart_haltcause;
	wire hart_halt_pnd;
	wire hart_halt_ack;
	wire dmode_cause_sstep;
	wire dmode_cause_except;
	wire dmode_cause_ebreak;
	wire dmode_cause_any;
	wire dmode_cause_tmreq;
	wire ifu_handshake_done;
	wire pbuf_exc_inj_req;
	wire pbuf_exc_inj_end;
	wire pbuf_start_fetch;
	reg [1:0] pbuf_fsm_curr;
	reg [1:0] pbuf_fsm_next;
	wire pbuf_fsm_idle;
	wire pbuf_fsm_fetch;
	wire pbuf_fsm_excinj;
	reg [2:0] pbuf_addr_ff;
	wire [2:0] pbuf_addr_next;
	wire pbuf_addr_end;
	wire pbuf_addr_next_vd;
	reg pbuf_instr_wait_latching;
	wire csr_upd_on_halt;
	wire csr_wr;
	reg [31:0] csr_wr_data;
	wire [31:0] csr_rd_data;
	reg csr_dcsr_sel;
	reg csr_dcsr_wr;
	reg [(((((((((((32'sd31 - 32'sd28) >= 0 ? (32'sd31 - 32'sd28) + 1 : -2) + ((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10)) + 1) + ((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1)) + 1) + ((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0)) + ((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1)) + ((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1)) + 1) + ((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0)) - 1:0] csr_dcsr_in;
	reg [(((((((((((32'sd31 - 32'sd28) >= 0 ? (32'sd31 - 32'sd28) + 1 : -2) + ((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10)) + 1) + ((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1)) + 1) + ((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0)) + ((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1)) + ((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1)) + 1) + ((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0)) - 1:0] csr_dcsr_out;
	reg csr_dcsr_ebreakm;
	reg csr_dcsr_stepie;
	reg csr_dcsr_step;
	reg [32'sd8 - 32'sd6:0] csr_dcsr_cause;
	reg csr_dpc_sel;
	wire csr_dpc_wr;
	reg [31:0] csr_dpc_ff;
	wire [31:0] csr_dpc_next;
	wire [31:0] csr_dpc_out;
	wire csr_addr_dscratch0;
	reg csr_dscratch0_sel;
	wire csr_dscratch0_wr;
	wire [31:0] csr_dscratch0_out;
	wire csr_dscratch0_resp;
	assign dm_cmd_dhalted = dm2hdu_cmd_i == 2'b10;
	assign dm_cmd_run = dm2hdu_cmd_i == 2'b01;
	assign dm_cmd_drun = dm2hdu_cmd_i == 2'b11;
	assign dm_dhalt_req = dm2hdu_cmd_req_i & dm_cmd_dhalted;
	assign dm_run_req = dm2hdu_cmd_req_i & (dm_cmd_run | dm_cmd_drun);
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			dbg_state <= 2'b00;
		else
			dbg_state <= dbg_state_next;
	always @(*) begin
		if (_sv2v_0)
			;
		if (~pipe2hdu_rdc_qlfy_i)
			dbg_state_next = 2'b00;
		else
			case (dbg_state)
				2'b00: dbg_state_next = (~pipe2hdu_init_pc_i ? 2'b00 : (dm_dhalt_req ? 2'b10 : 2'b01));
				2'b01: dbg_state_next = (dfsm_update ? 2'b10 : 2'b01);
				2'b10: dbg_state_next = (~dfsm_update ? 2'b10 : (dm_cmd_drun ? 2'b11 : 2'b01));
				2'b11: dbg_state_next = (dfsm_update ? 2'b10 : 2'b11);
				default: dbg_state_next = dbg_state;
			endcase
	end
	assign dbg_state_dhalted = dbg_state == 2'b10;
	assign dbg_state_drun = dbg_state == 2'b11;
	assign dbg_state_run = dbg_state == 2'b01;
	assign dbg_state_reset = dbg_state == 2'b00;
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			dfsm_trans <= 1'b0;
			dfsm_update <= 1'b0;
			dfsm_event <= 1'b0;
		end
		else begin
			dfsm_trans <= dfsm_trans_next;
			dfsm_update <= dfsm_update_next;
			dfsm_event <= dfsm_event_next;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		dfsm_trans_next = 1'b0;
		dfsm_update_next = 1'b0;
		dfsm_event_next = 1'b0;
		if (~pipe2hdu_rdc_qlfy_i) begin
			dfsm_trans_next = 1'b0;
			dfsm_update_next = 1'b0;
			dfsm_event_next = 1'b1;
		end
		else
			case (dbg_state)
				2'b00: begin
					dfsm_trans_next = 1'b0;
					dfsm_update_next = 1'b0;
					dfsm_event_next = pipe2hdu_init_pc_i & ~dm2hdu_cmd_req_i;
				end
				2'b01, 2'b11: begin
					dfsm_trans_next = (~dfsm_update ? hart_halt_pnd : dfsm_trans);
					dfsm_update_next = ~dfsm_update & hart_halt_ack;
					dfsm_event_next = dfsm_update;
				end
				2'b10: begin
					dfsm_trans_next = (~dfsm_update ? ~dfsm_trans & dm_run_req : dfsm_trans);
					dfsm_update_next = ~dfsm_update & dfsm_trans;
					dfsm_event_next = dfsm_update;
				end
				default: begin
					dfsm_trans_next = 1'sbx;
					dfsm_update_next = 1'sbx;
					dfsm_event_next = 1'sbx;
				end
			endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		hart_cmd_req = 1'b0;
		if (~pipe2hdu_rdc_qlfy_i)
			hart_cmd_req = 1'b0;
		else
			case (dbg_state)
				2'b00: hart_cmd_req = dm2hdu_cmd_req_i;
				2'b10: hart_cmd_req = dfsm_update | dfsm_trans;
				2'b01, 2'b11: hart_cmd_req = ~dfsm_update & dfsm_trans;
				default: hart_cmd_req = 1'sbx;
			endcase
	end
	assign hart_halt_req = dm_cmd_dhalted & hart_cmd_req;
	assign hart_resume_req = (dm_cmd_run | dm_cmd_drun) & hart_cmd_req;
	assign hart_runctrl_clr = (dbg_state_run | dbg_state_drun) & (dbg_state_next == 2'b10);
	assign hart_runctrl_upd = dbg_state_dhalted & dfsm_trans_next;
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			hart_runctrl[5] <= 1'b0;
			hart_runctrl[4] <= 1'b0;
			hart_runctrl[3] <= 1'b0;
			hart_runctrl[2] <= 1'b0;
			hart_runctrl[1-:2] <= 1'sb0;
		end
		else if (clk_en) begin
			if (hart_runctrl_clr)
				hart_runctrl <= 1'sb0;
			else if (hart_runctrl_upd) begin
				if (~dm_cmd_drun) begin
					hart_runctrl[5] <= (csr_dcsr_step ? ~csr_dcsr_stepie : 1'b0);
					hart_runctrl[4] <= 1'b0;
					hart_runctrl[3] <= 1'b0;
					hart_runctrl[2] <= 1'b0;
					hart_runctrl[1] <= csr_dcsr_step;
					hart_runctrl[0] <= csr_dcsr_ebreakm;
				end
				else begin
					hart_runctrl[5] <= 1'b1;
					hart_runctrl[4] <= 1'b1;
					hart_runctrl[3] <= 1'b1;
					hart_runctrl[2] <= 1'b1;
					hart_runctrl[1] <= 1'b0;
					hart_runctrl[0] <= 1'b1;
				end
			end
		end
	assign halt_req_timeout_cnt_en = hdu2exu_dbg_halt2run_o | (hart_halt_req & ~hdu2exu_dbg_run2halt_o);
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			halt_req_timeout_cnt <= 1'sb1;
		else if (halt_req_timeout_cnt_en)
			halt_req_timeout_cnt <= halt_req_timeout_cnt_next;
	assign halt_req_timeout_cnt_next = (hdu2exu_dbg_halt2run_o ? {SCR1_HDU_TIMEOUT_WIDTH {1'sb1}} : (hart_halt_req & ~hdu2exu_dbg_run2halt_o ? halt_req_timeout_cnt - 1'b1 : halt_req_timeout_cnt));
	assign halt_req_timeout_flag = ~|halt_req_timeout_cnt;
	assign dmode_cause_sstep = hart_runctrl[1] & pipe2hdu_instret_i;
	assign dmode_cause_except = ((dbg_state_drun & pipe2hdu_exu_exc_req_i) & ~pipe2hdu_brkpt_i) & ~exu2hdu_ibrkpt_hw_i;
	assign dmode_cause_ebreak = hart_runctrl[0] & pipe2hdu_brkpt_i;
	assign dmode_cause_tmreq = tdu2hdu_dmode_req_i & exu2hdu_ibrkpt_hw_i;
	assign dmode_cause_any = (((dmode_cause_sstep | dmode_cause_ebreak) | dmode_cause_except) | hart_halt_req) | dmode_cause_tmreq;
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			dmode_cause_tmreq: hart_haltcause = 3'b010;
			dmode_cause_ebreak: hart_haltcause = 3'b001;
			hart_halt_req: hart_haltcause = 3'b011;
			dmode_cause_sstep: hart_haltcause = 3'b100;
			default: hart_haltcause = 3'b000;
		endcase
	end
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			hart_haltstatus <= 1'sb0;
		else if (hart_halt_ack) begin
			hart_haltstatus[3] <= dmode_cause_except;
			hart_haltstatus[2-:3] <= hart_haltcause;
		end
	assign hart_halt_pnd = (dfsm_trans | dm_dhalt_req) & ~hart_halt_ack;
	assign hart_halt_ack = ~hdu2exu_dbg_halted_o & (halt_req_timeout_flag | (~pipe2hdu_exu_busy_i & dmode_cause_any));
	assign ifu_handshake_done = hdu2ifu_pbuf_instr_vd_o & ifu2hdu_pbuf_instr_rdy_i;
	assign pbuf_addr_end = pbuf_addr_ff == 7;
	assign pbuf_start_fetch = dbg_state_dhalted & (dbg_state_next == 2'b11);
	assign pbuf_exc_inj_req = ifu_handshake_done & pbuf_addr_end;
	assign pbuf_exc_inj_end = pipe2hdu_exu_exc_req_i | ifu_handshake_done;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			pbuf_fsm_curr <= 2'b00;
		else if (clk_en)
			pbuf_fsm_curr <= pbuf_fsm_next;
	always @(*) begin
		if (_sv2v_0)
			;
		case (pbuf_fsm_curr)
			2'b00: pbuf_fsm_next = (pbuf_start_fetch ? 2'b01 : 2'b00);
			2'b01: pbuf_fsm_next = (pipe2hdu_exu_exc_req_i ? 2'b11 : (pbuf_exc_inj_req ? 2'b10 : 2'b01));
			2'b10: pbuf_fsm_next = (pbuf_exc_inj_end ? 2'b11 : 2'b10);
			2'b11: pbuf_fsm_next = (hdu2exu_dbg_halted_o ? 2'b00 : 2'b11);
		endcase
	end
	assign pbuf_fsm_idle = pbuf_fsm_curr == 2'b00;
	assign pbuf_fsm_fetch = pbuf_fsm_curr == 2'b01;
	assign pbuf_fsm_excinj = pbuf_fsm_curr == 2'b10;
	assign pbuf_addr_next_vd = ((pbuf_fsm_fetch & ifu_handshake_done) & ~pipe2hdu_exu_exc_req_i) & ~pbuf_addr_end;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			pbuf_addr_ff <= 1'sb0;
		else if (clk_en)
			pbuf_addr_ff <= pbuf_addr_next;
	assign pbuf_addr_next = (pbuf_fsm_idle ? {SCR1_HDU_PBUF_ADDR_WIDTH {1'sb0}} : (pbuf_addr_next_vd ? pbuf_addr_ff + 1'b1 : pbuf_addr_ff));
	generate
		if (HART_PBUF_INSTR_REGOUT_EN) begin : genblk1
			always @(posedge clk or negedge rst_n)
				if (~rst_n)
					pbuf_instr_wait_latching <= 1'b0;
				else
					pbuf_instr_wait_latching <= ifu_handshake_done;
		end
		else begin : genblk1
			wire [1:1] sv2v_tmp_8D5F6;
			assign sv2v_tmp_8D5F6 = 1'b0;
			always @(*) pbuf_instr_wait_latching = sv2v_tmp_8D5F6;
		end
	endgenerate
	assign csr_upd_on_halt = (dbg_state_reset | dbg_state_run) & (dbg_state_next == 2'b10);
	function automatic [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] sv2v_cast_68C55;
		input reg [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] inp;
		sv2v_cast_68C55 = inp;
	endfunction
	localparam SCR1_HDU_DBGCSR_OFFS_DCSR = sv2v_cast_68C55('d0);
	localparam SCR1_HDU_DBGCSR_OFFS_DPC = sv2v_cast_68C55('d1);
	localparam SCR1_HDU_DBGCSR_OFFS_DSCRATCH0 = sv2v_cast_68C55('d2);
	always @(*) begin : csr_if_regsel
		if (_sv2v_0)
			;
		csr_dcsr_sel = 1'b0;
		csr_dpc_sel = 1'b0;
		csr_dscratch0_sel = 1'b0;
		if (csr2hdu_req_i)
			case (csr2hdu_addr_i)
				SCR1_HDU_DBGCSR_OFFS_DCSR: csr_dcsr_sel = 1'b1;
				SCR1_HDU_DBGCSR_OFFS_DPC: csr_dpc_sel = 1'b1;
				SCR1_HDU_DBGCSR_OFFS_DSCRATCH0: csr_dscratch0_sel = 1'b1;
				default: begin
					csr_dcsr_sel = 1'bx;
					csr_dpc_sel = 1'bx;
					csr_dscratch0_sel = 1'bx;
				end
			endcase
	end
	assign csr_rd_data = (csr_dcsr_out | csr_dpc_out) | csr_dscratch0_out;
	assign csr_wr = csr2hdu_req_i;
	function automatic [1:0] sv2v_cast_999B9;
		input reg [1:0] inp;
		sv2v_cast_999B9 = inp;
	endfunction
	always @(*) begin : csr_if_write
		if (_sv2v_0)
			;
		csr_wr_data = 1'sb0;
		if (csr2hdu_req_i)
			case (csr2hdu_cmd_i)
				sv2v_cast_999B9({32 {1'sb0}} + 1): csr_wr_data = csr2hdu_wdata_i;
				sv2v_cast_999B9({32 {1'sb0}} + 2): csr_wr_data = csr_rd_data | csr2hdu_wdata_i;
				sv2v_cast_999B9({32 {1'sb0}} + 3): csr_wr_data = csr_rd_data & ~csr2hdu_wdata_i;
				default: csr_wr_data = 1'sbx;
			endcase
	end
	localparam [3:0] SCR1_HDU_DEBUGCSR_DCSR_XDEBUGVER = 4'h4;
	always @(*) begin
		if (_sv2v_0)
			;
		csr_dcsr_in = csr_wr_data;
		csr_dcsr_wr = csr_wr & csr_dcsr_sel;
		csr_dcsr_out = 1'sb0;
		if (csr_dcsr_sel) begin
			csr_dcsr_out[((32'sd31 - 32'sd28) >= 0 ? (32'sd31 - 32'sd28) + 1 : -2) + (((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10) + (1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))))))-:((((32'sd31 - 32'sd28) >= 0 ? (32'sd31 - 32'sd28) + 1 : -2) + (((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10) + (1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))))))) >= (((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10) + (1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (1 + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))))))) ? ((((32'sd31 - 32'sd28) >= 0 ? (32'sd31 - 32'sd28) + 1 : -2) + (((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10) + (1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))))))) - (((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10) + (1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (1 + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0)))))))))) + 1 : ((((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10) + (1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (1 + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))))))) - (((32'sd31 - 32'sd28) >= 0 ? (32'sd31 - 32'sd28) + 1 : -2) + (((32'sd27 - 32'sd16) >= 0 ? (32'sd27 - 32'sd16) + 1 : -10) + (1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0)))))))))) + 1)] = SCR1_HDU_DEBUGCSR_DCSR_XDEBUGVER;
			csr_dcsr_out[1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))))] = csr_dcsr_ebreakm;
			csr_dcsr_out[1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))] = csr_dcsr_stepie;
			csr_dcsr_out[((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0] = csr_dcsr_step;
			csr_dcsr_out[((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) - 1-:((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0)] = 2'b11;
			csr_dcsr_out[((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))-:((((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))) >= (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (1 + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))) ? ((((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))) - (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (1 + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0)))) + 1 : ((((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (1 + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))) - (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0)))) + 1)] = csr_dcsr_cause;
		end
	end
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			csr_dcsr_ebreakm <= 1'b0;
			csr_dcsr_stepie <= 1'b0;
			csr_dcsr_step <= 1'b0;
		end
		else if (clk_en) begin
			if (csr_dcsr_wr) begin
				csr_dcsr_ebreakm <= csr_dcsr_in[1 + (((32'sd14 - 32'sd12) >= 0 ? (32'sd14 - 32'sd12) + 1 : -1) + (1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))))];
				csr_dcsr_stepie <= csr_dcsr_in[1 + (((32'sd10 - 32'sd9) >= 0 ? (32'sd10 - 32'sd9) + 1 : 0) + (((32'sd8 - 32'sd6) >= 0 ? (32'sd8 - 32'sd6) + 1 : -1) + (((32'sd5 - 32'sd3) >= 0 ? (32'sd5 - 32'sd3) + 1 : -1) + (((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0))))];
				csr_dcsr_step <= csr_dcsr_in[((32'sd1 - 32'sd0) >= 0 ? (32'sd1 - 32'sd0) + 1 : 0) + 0];
			end
		end
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			csr_dcsr_cause <= 1'b0;
		else if (clk_en) begin
			if (csr_upd_on_halt)
				csr_dcsr_cause <= hart_haltstatus[2-:3];
		end
	assign csr_dpc_wr = csr_wr & csr_dpc_sel;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			csr_dpc_ff <= 1'sb0;
		else if (clk_en)
			csr_dpc_ff <= csr_dpc_next;
	assign csr_dpc_next = (csr_upd_on_halt ? pipe2hdu_pc_curr_i : (csr_dpc_wr ? csr_wr_data : csr_dpc_ff));
	assign csr_dpc_out = (csr_dpc_sel ? csr_dpc_ff : {32 {1'sb0}});
	assign csr_dscratch0_resp = (~dm2hdu_dreg_resp_i | dm2hdu_dreg_fail_i ? 1'd1 : 1'd0);
	assign csr_dscratch0_out = (csr_dscratch0_sel ? dm2hdu_dreg_rdata_i : {32 {1'sb0}});
	assign hdu2dm_hart_event_o = dfsm_event;
	always @(*) begin
		if (_sv2v_0)
			;
		hdu2dm_hart_status_o = 1'sb0;
		hdu2dm_hart_status_o[1-:2] = dbg_state;
		hdu2dm_hart_status_o[3] = dbg_state_dhalted & hart_haltstatus[3];
		hdu2dm_hart_status_o[2] = dbg_state_dhalted & (hart_haltstatus[2-:3] == 3'b001);
	end
	assign hdu2dm_cmd_rcode_o = (dbg_state_reset ? (~pipe2hdu_rdc_qlfy_i | ~pipe2hdu_init_pc_i) | ~dm2hdu_cmd_req_i : ~pipe2hdu_rdc_qlfy_i | ~dfsm_update);
	always @(*) begin
		if (_sv2v_0)
			;
		hdu2dm_cmd_resp_o = 1'b0;
		case (dbg_state)
			2'b00: hdu2dm_cmd_resp_o = (pipe2hdu_rdc_qlfy_i & pipe2hdu_init_pc_i) & dm2hdu_cmd_req_i;
			2'b01: hdu2dm_cmd_resp_o = (pipe2hdu_rdc_qlfy_i & dfsm_update) & dm2hdu_cmd_req_i;
			2'b10: hdu2dm_cmd_resp_o = (pipe2hdu_rdc_qlfy_i ? dfsm_update : dm2hdu_cmd_req_i);
			2'b11: hdu2dm_cmd_resp_o = (~pipe2hdu_rdc_qlfy_i | dfsm_update) & dm2hdu_cmd_req_i;
			default: hdu2dm_cmd_resp_o = 1'sbx;
		endcase
	end
	assign hdu2dm_pbuf_addr_o = pbuf_addr_ff;
	assign hdu2dm_dreg_req_o = csr_dscratch0_sel;
	assign hdu2dm_dreg_wr_o = csr_wr & csr_dscratch0_sel;
	assign hdu2dm_dreg_wdata_o = csr_wr_data;
	assign hdu2exu_dbg_halted_o = (dbg_state_next == 2'b10) | (~pipe2hdu_rdc_qlfy_i & ~dbg_state_run);
	assign hdu2exu_dbg_run_start_o = (dbg_state_dhalted & pipe2hdu_rdc_qlfy_i) & dfsm_update;
	assign hdu2exu_dbg_halt2run_o = hdu2exu_dbg_halted_o & hart_resume_req;
	assign hdu2exu_dbg_run2halt_o = hart_halt_ack;
	assign hdu2exu_pbuf_fetch_o = hart_runctrl[4];
	assign hdu2exu_irq_dsbl_o = hart_runctrl[5];
	assign hdu2exu_pc_advmt_dsbl_o = hart_runctrl[3];
	assign hdu2exu_no_commit_o = dmode_cause_ebreak | dmode_cause_tmreq;
	assign hdu2exu_dmode_sstep_en_o = hart_runctrl[1];
	assign hdu2exu_dbg_new_pc_o = csr_dpc_ff;
	assign hdu2ifu_pbuf_instr_vd_o = (pbuf_fsm_fetch | pbuf_fsm_excinj) & ~pbuf_instr_wait_latching;
	assign hdu2ifu_pbuf_instr_err_o = pbuf_fsm_excinj;
	generate
		if (HART_PBUF_INSTR_REGOUT_EN) begin : genblk2
			always @(posedge clk) hdu2ifu_pbuf_instr_o <= dm2hdu_pbuf_instr_i;
		end
		else begin : genblk2
			wire [32:1] sv2v_tmp_E72A7;
			assign sv2v_tmp_E72A7 = dm2hdu_pbuf_instr_i;
			always @(*) hdu2ifu_pbuf_instr_o = sv2v_tmp_E72A7;
		end
	endgenerate
	assign csr_addr_dscratch0 = csr2hdu_addr_i == SCR1_HDU_DBGCSR_OFFS_DSCRATCH0;
	assign hdu2csr_resp_o = (~dbg_state_drun ? 1'd1 : (csr_addr_dscratch0 ? csr_dscratch0_resp : (csr2hdu_req_i ? 1'd0 : 1'd1)));
	assign hdu2csr_rdata_o = csr_rd_data;
	assign hdu2tdu_hwbrk_dsbl_o = hart_runctrl[2];
	initial _sv2v_0 = 0;
endmodule
