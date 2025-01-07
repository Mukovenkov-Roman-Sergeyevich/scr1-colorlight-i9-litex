/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_exu (
	rst_n,
	clk,
	idu2exu_req_i,
	exu2idu_rdy_o,
	idu2exu_cmd_i,
	idu2exu_use_rs1_i,
	idu2exu_use_rs2_i,
	idu2exu_use_rd_i,
	idu2exu_use_imm_i,
	exu2mprf_rs1_addr_o,
	mprf2exu_rs1_data_i,
	exu2mprf_rs2_addr_o,
	mprf2exu_rs2_data_i,
	exu2mprf_w_req_o,
	exu2mprf_rd_addr_o,
	exu2mprf_rd_data_o,
	exu2csr_rw_addr_o,
	exu2csr_r_req_o,
	csr2exu_r_data_i,
	exu2csr_w_req_o,
	exu2csr_w_cmd_o,
	exu2csr_w_data_o,
	csr2exu_rw_exc_i,
	exu2csr_take_irq_o,
	exu2csr_take_exc_o,
	exu2csr_mret_update_o,
	exu2csr_mret_instr_o,
	exu2csr_exc_code_o,
	exu2csr_trap_val_o,
	csr2exu_new_pc_i,
	csr2exu_irq_i,
	csr2exu_ip_ie_i,
	csr2exu_mstatus_mie_up_i,
	exu2dmem_req_o,
	exu2dmem_cmd_o,
	exu2dmem_width_o,
	exu2dmem_addr_o,
	exu2dmem_wdata_o,
	dmem2exu_req_ack_i,
	dmem2exu_rdata_i,
	dmem2exu_resp_i,
	exu2pipe_exc_req_o,
	exu2pipe_brkpt_o,
	exu2pipe_init_pc_o,
	exu2pipe_wfi_run2halt_o,
	exu2pipe_instret_o,
	exu2csr_instret_no_exc_o,
	exu2pipe_exu_busy_o,
	hdu2exu_no_commit_i,
	hdu2exu_irq_dsbl_i,
	hdu2exu_pc_advmt_dsbl_i,
	hdu2exu_dmode_sstep_en_i,
	hdu2exu_pbuf_fetch_i,
	hdu2exu_dbg_halted_i,
	hdu2exu_dbg_run2halt_i,
	hdu2exu_dbg_halt2run_i,
	hdu2exu_dbg_run_start_i,
	hdu2exu_dbg_new_pc_i,
	exu2tdu_imon_o,
	tdu2exu_ibrkpt_match_i,
	tdu2exu_ibrkpt_exc_req_i,
	lsu2tdu_dmon_o,
	tdu2lsu_ibrkpt_exc_req_i,
	tdu2lsu_dbrkpt_match_i,
	tdu2lsu_dbrkpt_exc_req_i,
	exu2tdu_ibrkpt_ret_o,
	exu2hdu_ibrkpt_hw_o,
	exu2pipe_pc_curr_o,
	exu2csr_pc_next_o,
	exu2ifu_pc_new_req_o,
	exu2ifu_pc_new_o
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	input wire idu2exu_req_i;
	output wire exu2idu_rdy_o;
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
	input wire [74:0] idu2exu_cmd_i;
	input wire idu2exu_use_rs1_i;
	input wire idu2exu_use_rs2_i;
	input wire idu2exu_use_rd_i;
	input wire idu2exu_use_imm_i;
	output wire [4:0] exu2mprf_rs1_addr_o;
	input wire [31:0] mprf2exu_rs1_data_i;
	output wire [4:0] exu2mprf_rs2_addr_o;
	input wire [31:0] mprf2exu_rs2_data_i;
	output wire exu2mprf_w_req_o;
	output wire [4:0] exu2mprf_rd_addr_o;
	output reg [31:0] exu2mprf_rd_data_o;
	localparam [31:0] SCR1_CSR_ADDR_WIDTH = 12;
	output wire [11:0] exu2csr_rw_addr_o;
	output reg exu2csr_r_req_o;
	input wire [31:0] csr2exu_r_data_i;
	output reg exu2csr_w_req_o;
	output wire [1:0] exu2csr_w_cmd_o;
	output wire [31:0] exu2csr_w_data_o;
	input wire csr2exu_rw_exc_i;
	output wire exu2csr_take_irq_o;
	output wire exu2csr_take_exc_o;
	output wire exu2csr_mret_update_o;
	output wire exu2csr_mret_instr_o;
	output wire [3:0] exu2csr_exc_code_o;
	output wire [31:0] exu2csr_trap_val_o;
	input wire [31:0] csr2exu_new_pc_i;
	input wire csr2exu_irq_i;
	input wire csr2exu_ip_ie_i;
	input wire csr2exu_mstatus_mie_up_i;
	output wire exu2dmem_req_o;
	output wire exu2dmem_cmd_o;
	output wire [1:0] exu2dmem_width_o;
	output wire [31:0] exu2dmem_addr_o;
	output wire [31:0] exu2dmem_wdata_o;
	input wire dmem2exu_req_ack_i;
	input wire [31:0] dmem2exu_rdata_i;
	input wire [1:0] dmem2exu_resp_i;
	output wire exu2pipe_exc_req_o;
	output wire exu2pipe_brkpt_o;
	output wire exu2pipe_init_pc_o;
	output wire exu2pipe_wfi_run2halt_o;
	output wire exu2pipe_instret_o;
	output wire exu2csr_instret_no_exc_o;
	output wire exu2pipe_exu_busy_o;
	input wire hdu2exu_no_commit_i;
	input wire hdu2exu_irq_dsbl_i;
	input wire hdu2exu_pc_advmt_dsbl_i;
	input wire hdu2exu_dmode_sstep_en_i;
	input wire hdu2exu_pbuf_fetch_i;
	input wire hdu2exu_dbg_halted_i;
	input wire hdu2exu_dbg_run2halt_i;
	input wire hdu2exu_dbg_halt2run_i;
	input wire hdu2exu_dbg_run_start_i;
	input wire [31:0] hdu2exu_dbg_new_pc_i;
	output wire [33:0] exu2tdu_imon_o;
	localparam [31:0] SCR1_TDU_TRIG_NUM = 4;
	localparam [31:0] SCR1_TDU_MTRIG_NUM = SCR1_TDU_TRIG_NUM;
	localparam [31:0] SCR1_TDU_ALLTRIG_NUM = SCR1_TDU_MTRIG_NUM + 1'b1;
	input wire [SCR1_TDU_ALLTRIG_NUM - 1:0] tdu2exu_ibrkpt_match_i;
	input wire tdu2exu_ibrkpt_exc_req_i;
	output wire [34:0] lsu2tdu_dmon_o;
	input wire tdu2lsu_ibrkpt_exc_req_i;
	input wire [3:0] tdu2lsu_dbrkpt_match_i;
	input wire tdu2lsu_dbrkpt_exc_req_i;
	output reg [SCR1_TDU_ALLTRIG_NUM - 1:0] exu2tdu_ibrkpt_ret_o;
	output wire exu2hdu_ibrkpt_hw_o;
	output wire [31:0] exu2pipe_pc_curr_o;
	output wire [31:0] exu2csr_pc_next_o;
	output wire exu2ifu_pc_new_req_o;
	output reg [31:0] exu2ifu_pc_new_o;
	localparam SCR1_JUMP_MASK = 32'hfffffffe;
	wire exu_queue_vd;
	reg [74:0] exu_queue;
	wire exu_queue_barrier;
	wire dbg_run_start_npbuf;
	wire exu_queue_en;
	wire [31:0] exu_illegal_instr;
	reg idu2exu_use_rs1_ff;
	reg idu2exu_use_rs2_ff;
	wire exu_queue_vd_upd;
	reg exu_queue_vd_ff;
	wire exu_queue_vd_next;
	wire ialu_rdy;
	wire ialu_vd;
	reg [31:0] ialu_main_op1;
	reg [31:0] ialu_main_op2;
	wire [31:0] ialu_main_res;
	reg [31:0] ialu_addr_op1;
	reg [31:0] ialu_addr_op2;
	wire [31:0] ialu_addr_res;
	wire ialu_cmp;
	wire exu_exc_req;
	reg exu_exc_req_ff;
	wire exu_exc_req_next;
	reg [3:0] exc_code;
	reg [31:0] exc_trap_val;
	wire instr_fault_rvi_hi;
	wire wfi_halt_cond;
	wire wfi_run_req;
	wire wfi_halt_req;
	reg wfi_run_start_ff;
	wire wfi_run_start_next;
	wire wfi_halted_upd;
	reg wfi_halted_ff;
	wire wfi_halted_next;
	reg [3:0] init_pc_v;
	wire init_pc;
	wire [31:0] inc_pc;
	wire branch_taken;
	wire jb_taken;
	wire [31:0] jb_new_pc;
	wire pc_curr_upd;
	reg [31:0] pc_curr_ff;
	wire [31:0] pc_curr_next;
	wire lsu_req;
	wire lsu_rdy;
	wire [31:0] lsu_l_data;
	wire lsu_exc_req;
	wire [3:0] lsu_exc_code;
	reg exu_rdy;
	wire mprf_rs1_req;
	wire mprf_rs2_req;
	wire [4:0] mprf_rs1_addr;
	wire [4:0] mprf_rs2_addr;
	reg csr_access_ff;
	wire csr_access_next;
	wire csr_access_init;
	assign dbg_run_start_npbuf = hdu2exu_dbg_run_start_i & ~hdu2exu_pbuf_fetch_i;
	assign exu_queue_barrier = ((((wfi_halted_ff | wfi_halt_req) | wfi_run_start_ff) | hdu2exu_dbg_halted_i) | hdu2exu_dbg_run2halt_i) | dbg_run_start_npbuf;
	assign exu_queue_en = exu2idu_rdy_o & idu2exu_req_i;
	assign exu_queue_vd_upd = exu_queue_barrier | exu_rdy;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			exu_queue_vd_ff <= 1'b0;
		else if (exu_queue_vd_upd)
			exu_queue_vd_ff <= exu_queue_vd_next;
	assign exu_queue_vd_next = (~exu_queue_barrier & idu2exu_req_i) & ~exu2ifu_pc_new_req_o;
	assign exu_queue_vd = exu_queue_vd_ff;
	always @(posedge clk)
		if (exu_queue_en) begin
			exu_queue[74] <= idu2exu_cmd_i[74];
			exu_queue[73-:1] <= idu2exu_cmd_i[73-:1];
			exu_queue[72-:5] <= idu2exu_cmd_i[72-:5];
			exu_queue[67-:1] <= idu2exu_cmd_i[67-:1];
			exu_queue[66-:4] <= idu2exu_cmd_i[66-:4];
			exu_queue[62-:1] <= idu2exu_cmd_i[62-:1];
			exu_queue[61-:2] <= idu2exu_cmd_i[61-:2];
			exu_queue[59-:3] <= idu2exu_cmd_i[59-:3];
			exu_queue[56] <= idu2exu_cmd_i[56];
			exu_queue[55] <= idu2exu_cmd_i[55];
			exu_queue[54] <= idu2exu_cmd_i[54];
			exu_queue[53] <= idu2exu_cmd_i[53];
			exu_queue[52] <= idu2exu_cmd_i[52];
			exu_queue[4] <= idu2exu_cmd_i[4];
			exu_queue[3-:SCR1_EXC_CODE_WIDTH_E] <= idu2exu_cmd_i[3-:SCR1_EXC_CODE_WIDTH_E];
			idu2exu_use_rs1_ff <= idu2exu_use_rs1_i;
			idu2exu_use_rs2_ff <= idu2exu_use_rs2_i;
			if (idu2exu_use_rs1_i)
				exu_queue[51-:5] <= idu2exu_cmd_i[51-:5];
			if (idu2exu_use_rs2_i)
				exu_queue[46-:5] <= idu2exu_cmd_i[46-:5];
			if (idu2exu_use_rd_i)
				exu_queue[41-:5] <= idu2exu_cmd_i[41-:5];
			if (idu2exu_use_imm_i)
				exu_queue[36-:32] <= idu2exu_cmd_i[36-:32];
		end
	function automatic [4:0] sv2v_cast_8B244;
		input reg [4:0] inp;
		sv2v_cast_8B244 = inp;
	endfunction
	assign ialu_vd = (exu_queue_vd & (exu_queue[72-:5] != sv2v_cast_8B244(1'sb0))) & ~tdu2exu_ibrkpt_exc_req_i;
	function automatic [0:0] sv2v_cast_EFCFF;
		input reg [0:0] inp;
		sv2v_cast_EFCFF = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		if (~ialu_vd) begin
			ialu_main_op1 = 1'sb0;
			ialu_main_op2 = 1'sb0;
		end
		else if (exu_queue[73-:1] == sv2v_cast_EFCFF(1)) begin
			ialu_main_op1 = mprf2exu_rs1_data_i;
			ialu_main_op2 = mprf2exu_rs2_data_i;
		end
		else begin
			ialu_main_op1 = mprf2exu_rs1_data_i;
			ialu_main_op2 = exu_queue[36-:32];
		end
	end
	function automatic [0:0] sv2v_cast_64327;
		input reg [0:0] inp;
		sv2v_cast_64327 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		if (exu_queue[67-:1] == sv2v_cast_64327(1)) begin
			ialu_addr_op1 = mprf2exu_rs1_data_i;
			ialu_addr_op2 = exu_queue[36-:32];
		end
		else begin
			ialu_addr_op1 = pc_curr_ff;
			ialu_addr_op2 = exu_queue[36-:32];
		end
	end
	scr1_pipe_ialu i_ialu(
		.clk(clk),
		.rst_n(rst_n),
		.exu2ialu_rvm_cmd_vd_i(ialu_vd),
		.ialu2exu_rvm_res_rdy_o(ialu_rdy),
		.exu2ialu_main_op1_i(ialu_main_op1),
		.exu2ialu_main_op2_i(ialu_main_op2),
		.exu2ialu_cmd_i(exu_queue[72-:5]),
		.ialu2exu_main_res_o(ialu_main_res),
		.ialu2exu_cmp_res_o(ialu_cmp),
		.exu2ialu_addr_op1_i(ialu_addr_op1),
		.exu2ialu_addr_op2_i(ialu_addr_op2),
		.ialu2exu_addr_res_o(ialu_addr_res)
	);
	assign exu_exc_req = exu_queue_vd & (((exu_queue[4] | lsu_exc_req) | csr2exu_rw_exc_i) | exu2hdu_ibrkpt_hw_o);
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			exu_exc_req_ff <= 1'b0;
		else
			exu_exc_req_ff <= exu_exc_req_next;
	assign exu_exc_req_next = (hdu2exu_dbg_halt2run_i ? 1'b0 : exu_exc_req);
	function automatic [3:0] sv2v_cast_92043;
		input reg [3:0] inp;
		sv2v_cast_92043 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			exu2hdu_ibrkpt_hw_o: exc_code = sv2v_cast_92043(4'd3);
			exu_queue[4]: exc_code = exu_queue[3-:SCR1_EXC_CODE_WIDTH_E];
			lsu_exc_req: exc_code = lsu_exc_code;
			csr2exu_rw_exc_i: exc_code = sv2v_cast_92043(4'd2);
			default: exc_code = sv2v_cast_92043(4'd11);
		endcase
	end
	assign instr_fault_rvi_hi = exu_queue[74];
	function automatic [4:0] sv2v_cast_5;
		input reg [4:0] inp;
		sv2v_cast_5 = inp;
	endfunction
	assign exu_illegal_instr = {exu2csr_rw_addr_o, sv2v_cast_5(exu_queue[51-:5]), exu_queue[19:17], sv2v_cast_5(exu_queue[41-:5]), 7'b1110011};
	always @(*) begin
		if (_sv2v_0)
			;
		case (exc_code)
			sv2v_cast_92043(4'd1): exc_trap_val = (instr_fault_rvi_hi ? inc_pc : pc_curr_ff);
			sv2v_cast_92043(4'd2): exc_trap_val = (exu_queue[4] ? exu_queue[36-:32] : exu_illegal_instr);
			sv2v_cast_92043(4'd3):
				case (1'b1)
					tdu2exu_ibrkpt_exc_req_i: exc_trap_val = pc_curr_ff;
					tdu2lsu_dbrkpt_exc_req_i: exc_trap_val = ialu_addr_res;
					default: exc_trap_val = 1'sb0;
				endcase
			sv2v_cast_92043(4'd4), sv2v_cast_92043(4'd5), sv2v_cast_92043(4'd6), sv2v_cast_92043(4'd7): exc_trap_val = ialu_addr_res;
			default: exc_trap_val = 1'sb0;
		endcase
	end
	assign wfi_halt_cond = (((~csr2exu_ip_ie_i & ((exu_queue_vd & exu_queue[52]) | wfi_run_start_ff)) & ~hdu2exu_no_commit_i) & ~hdu2exu_dmode_sstep_en_i) & ~hdu2exu_dbg_run2halt_i;
	assign wfi_halt_req = ~wfi_halted_ff & wfi_halt_cond;
	assign wfi_run_req = wfi_halted_ff & (csr2exu_ip_ie_i | hdu2exu_dbg_halt2run_i);
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			wfi_run_start_ff <= 1'b0;
		else
			wfi_run_start_ff <= wfi_run_start_next;
	assign wfi_run_start_next = (wfi_halted_ff & csr2exu_ip_ie_i) & ~exu2csr_take_irq_o;
	assign wfi_halted_upd = wfi_halt_req | wfi_run_req;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			wfi_halted_ff <= 1'b0;
		else if (wfi_halted_upd)
			wfi_halted_ff <= wfi_halted_next;
	assign wfi_halted_next = wfi_halt_req | ~wfi_run_req;
	assign exu2pipe_wfi_run2halt_o = wfi_halt_req;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			init_pc_v <= 1'sb0;
		else if (~&init_pc_v)
			init_pc_v <= {init_pc_v[2:0], 1'b1};
	assign init_pc = ~init_pc_v[3] & init_pc_v[2];
	assign pc_curr_upd = ((exu2pipe_instret_o | exu2csr_take_irq_o) | dbg_run_start_npbuf) & (~hdu2exu_pc_advmt_dsbl_i & ~hdu2exu_no_commit_i);
	localparam [31:0] SCR1_ARCH_RST_VECTOR = 'hfffc0000;
	localparam [31:0] SCR1_RST_VECTOR = SCR1_ARCH_RST_VECTOR;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			pc_curr_ff <= SCR1_RST_VECTOR;
		else if (pc_curr_upd)
			pc_curr_ff <= pc_curr_next;
	assign inc_pc = pc_curr_ff + (exu_queue[74] ? 32'd2 : 32'd4);
	assign pc_curr_next = (exu2ifu_pc_new_req_o ? exu2ifu_pc_new_o : (inc_pc[6] ^ pc_curr_ff[6] ? inc_pc : {pc_curr_ff[31:6], inc_pc[5:0]}));
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			init_pc: exu2ifu_pc_new_o = SCR1_RST_VECTOR;
			exu2csr_take_exc_o, exu2csr_take_irq_o, exu2csr_mret_instr_o: exu2ifu_pc_new_o = csr2exu_new_pc_i;
			dbg_run_start_npbuf: exu2ifu_pc_new_o = hdu2exu_dbg_new_pc_i;
			wfi_run_start_ff: exu2ifu_pc_new_o = pc_curr_ff;
			exu_queue[53]: exu2ifu_pc_new_o = inc_pc;
			default: exu2ifu_pc_new_o = ialu_addr_res & SCR1_JUMP_MASK;
		endcase
	end
	assign exu2ifu_pc_new_req_o = ((((((init_pc | exu2csr_take_irq_o) | exu2csr_take_exc_o) | (exu2csr_mret_instr_o & ~csr2exu_mstatus_mie_up_i)) | (exu_queue_vd & exu_queue[53])) | wfi_run_start_ff) | dbg_run_start_npbuf) | (exu_queue_vd & jb_taken);
	assign branch_taken = exu_queue[55] & ialu_cmp;
	assign jb_taken = exu_queue[56] | branch_taken;
	assign jb_new_pc = ialu_addr_res & SCR1_JUMP_MASK;
	assign exu2csr_pc_next_o = (~exu_queue_vd ? pc_curr_ff : (jb_taken ? jb_new_pc : inc_pc));
	assign exu2pipe_pc_curr_o = pc_curr_ff;
	function automatic [3:0] sv2v_cast_5290E;
		input reg [3:0] inp;
		sv2v_cast_5290E = inp;
	endfunction
	assign lsu_req = (exu_queue[66-:4] != sv2v_cast_5290E(1'sb0)) & exu_queue_vd;
	scr1_pipe_lsu i_lsu(
		.rst_n(rst_n),
		.clk(clk),
		.exu2lsu_req_i(lsu_req),
		.exu2lsu_cmd_i(exu_queue[66-:4]),
		.exu2lsu_addr_i(ialu_addr_res),
		.exu2lsu_sdata_i(mprf2exu_rs2_data_i),
		.lsu2exu_rdy_o(lsu_rdy),
		.lsu2exu_ldata_o(lsu_l_data),
		.lsu2exu_exc_o(lsu_exc_req),
		.lsu2exu_exc_code_o(lsu_exc_code),
		.lsu2tdu_dmon_o(lsu2tdu_dmon_o),
		.tdu2lsu_ibrkpt_exc_req_i(tdu2lsu_ibrkpt_exc_req_i),
		.tdu2lsu_dbrkpt_exc_req_i(tdu2lsu_dbrkpt_exc_req_i),
		.lsu2dmem_req_o(exu2dmem_req_o),
		.lsu2dmem_cmd_o(exu2dmem_cmd_o),
		.lsu2dmem_width_o(exu2dmem_width_o),
		.lsu2dmem_addr_o(exu2dmem_addr_o),
		.lsu2dmem_wdata_o(exu2dmem_wdata_o),
		.dmem2lsu_req_ack_i(dmem2exu_req_ack_i),
		.dmem2lsu_rdata_i(dmem2exu_rdata_i),
		.dmem2lsu_resp_i(dmem2exu_resp_i)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			lsu_req: exu_rdy = lsu_rdy | lsu_exc_req;
			ialu_vd: exu_rdy = ialu_rdy;
			csr2exu_mstatus_mie_up_i: exu_rdy = 1'b0;
			default: exu_rdy = 1'b1;
		endcase
	end
	assign exu2pipe_init_pc_o = init_pc;
	assign exu2idu_rdy_o = exu_rdy & ~exu_queue_barrier;
	assign exu2pipe_exu_busy_o = exu_queue_vd & ~exu_rdy;
	assign exu2pipe_instret_o = exu_queue_vd & exu_rdy;
	assign exu2csr_instret_no_exc_o = exu2pipe_instret_o & ~exu_exc_req;
	assign exu2pipe_exc_req_o = (exu_queue_vd ? exu_exc_req : exu_exc_req_ff);
	assign exu2pipe_brkpt_o = exu_queue_vd & (exu_queue[3-:SCR1_EXC_CODE_WIDTH_E] == sv2v_cast_92043(4'd3));
	assign exu2hdu_ibrkpt_hw_o = tdu2exu_ibrkpt_exc_req_i | tdu2lsu_dbrkpt_exc_req_i;
	assign mprf_rs1_req = exu_queue_vd & idu2exu_use_rs1_ff;
	assign mprf_rs2_req = exu_queue_vd & idu2exu_use_rs2_ff;
	assign mprf_rs1_addr = exu_queue[51:47];
	assign mprf_rs2_addr = exu_queue[46:42];
	assign exu2mprf_rs1_addr_o = (mprf_rs1_req ? mprf_rs1_addr[4:0] : {5 {1'sb0}});
	assign exu2mprf_rs2_addr_o = (mprf_rs2_req ? mprf_rs2_addr[4:0] : {5 {1'sb0}});
	function automatic [2:0] sv2v_cast_2C11F;
		input reg [2:0] inp;
		sv2v_cast_2C11F = inp;
	endfunction
	function automatic [2:0] sv2v_cast_4D524;
		input reg [2:0] inp;
		sv2v_cast_4D524 = inp;
	endfunction
	assign exu2mprf_w_req_o = ((((exu_queue[59-:3] != sv2v_cast_2C11F(1'sb0)) & exu_queue_vd) & ~exu_exc_req) & ~hdu2exu_no_commit_i) & (exu_queue[59-:3] == sv2v_cast_4D524({32 {1'sb0}} + 6) ? csr_access_init : exu_rdy);
	assign exu2mprf_rd_addr_o = sv2v_cast_5(exu_queue[41-:5]);
	always @(*) begin
		if (_sv2v_0)
			;
		case (exu_queue[59-:3])
			sv2v_cast_4D524({32 {1'sb0}} + 2): exu2mprf_rd_data_o = ialu_addr_res;
			sv2v_cast_4D524({32 {1'sb0}} + 3): exu2mprf_rd_data_o = exu_queue[36-:32];
			sv2v_cast_4D524({32 {1'sb0}} + 4): exu2mprf_rd_data_o = inc_pc;
			sv2v_cast_4D524({32 {1'sb0}} + 5): exu2mprf_rd_data_o = lsu_l_data;
			sv2v_cast_4D524({32 {1'sb0}} + 6): exu2mprf_rd_data_o = csr2exu_r_data_i;
			default: exu2mprf_rd_data_o = ialu_main_res;
		endcase
	end
	function automatic [1:0] sv2v_cast_999B9;
		input reg [1:0] inp;
		sv2v_cast_999B9 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		if (~exu_queue_vd | tdu2exu_ibrkpt_exc_req_i) begin
			exu2csr_r_req_o = 1'b0;
			exu2csr_w_req_o = 1'b0;
		end
		else
			case (exu_queue[61-:2])
				sv2v_cast_999B9({32 {1'sb0}} + 1): begin
					exu2csr_r_req_o = |exu_queue[41-:5];
					exu2csr_w_req_o = csr_access_init;
				end
				sv2v_cast_999B9({32 {1'sb0}} + 2), sv2v_cast_999B9({32 {1'sb0}} + 3): begin
					exu2csr_r_req_o = 1'b1;
					exu2csr_w_req_o = |exu_queue[51-:5] & csr_access_init;
				end
				default: begin
					exu2csr_r_req_o = 1'b0;
					exu2csr_w_req_o = 1'b0;
				end
			endcase
	end
	assign exu2csr_w_cmd_o = exu_queue[61-:2];
	assign exu2csr_rw_addr_o = exu_queue[16:5];
	function automatic [0:0] sv2v_cast_E449B;
		input reg [0:0] inp;
		sv2v_cast_E449B = inp;
	endfunction
	assign exu2csr_w_data_o = (exu_queue[62-:1] == sv2v_cast_E449B(1) ? mprf2exu_rs1_data_i : {1'sb0, exu_queue[51-:5]});
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			csr_access_ff <= 1'd0;
		else
			csr_access_ff <= csr_access_next;
	assign csr_access_next = (csr_access_init & csr2exu_mstatus_mie_up_i ? 1'd1 : 1'd0);
	assign csr_access_init = csr_access_ff == 1'd0;
	assign exu2csr_take_exc_o = exu_exc_req & ~hdu2exu_dbg_halted_i;
	assign exu2csr_exc_code_o = exc_code;
	assign exu2csr_trap_val_o = exc_trap_val;
	assign exu2csr_take_irq_o = ((csr2exu_irq_i & ~exu2pipe_exu_busy_o) & ~hdu2exu_irq_dsbl_i) & ~hdu2exu_dbg_halted_i;
	assign exu2csr_mret_instr_o = ((exu_queue_vd & exu_queue[54]) & ~tdu2exu_ibrkpt_exc_req_i) & ~hdu2exu_dbg_halted_i;
	assign exu2csr_mret_update_o = exu2csr_mret_instr_o & csr_access_init;
	assign exu2tdu_imon_o[33] = exu_queue_vd;
	assign exu2tdu_imon_o[32] = exu2pipe_instret_o;
	assign exu2tdu_imon_o[31-:32] = pc_curr_ff;
	always @(*) begin
		if (_sv2v_0)
			;
		exu2tdu_ibrkpt_ret_o = 1'sb0;
		if (exu_queue_vd) begin
			exu2tdu_ibrkpt_ret_o = tdu2exu_ibrkpt_match_i;
			if (lsu_req)
				exu2tdu_ibrkpt_ret_o[3:0] = exu2tdu_ibrkpt_ret_o[3:0] | tdu2lsu_dbrkpt_match_i;
		end
	end
	initial _sv2v_0 = 0;
endmodule
