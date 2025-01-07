/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_lsu (
	rst_n,
	clk,
	exu2lsu_req_i,
	exu2lsu_cmd_i,
	exu2lsu_addr_i,
	exu2lsu_sdata_i,
	lsu2exu_rdy_o,
	lsu2exu_ldata_o,
	lsu2exu_exc_o,
	lsu2exu_exc_code_o,
	lsu2tdu_dmon_o,
	tdu2lsu_ibrkpt_exc_req_i,
	tdu2lsu_dbrkpt_exc_req_i,
	lsu2dmem_req_o,
	lsu2dmem_cmd_o,
	lsu2dmem_width_o,
	lsu2dmem_addr_o,
	lsu2dmem_wdata_o,
	dmem2lsu_req_ack_i,
	dmem2lsu_rdata_i,
	dmem2lsu_resp_i
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	input wire exu2lsu_req_i;
	localparam SCR1_LSU_CMD_ALL_NUM_E = 9;
	localparam SCR1_LSU_CMD_WIDTH_E = 4;
	input wire [3:0] exu2lsu_cmd_i;
	input wire [31:0] exu2lsu_addr_i;
	input wire [31:0] exu2lsu_sdata_i;
	output wire lsu2exu_rdy_o;
	output reg [31:0] lsu2exu_ldata_o;
	output wire lsu2exu_exc_o;
	localparam [31:0] SCR1_EXC_CODE_WIDTH_E = 4;
	output reg [3:0] lsu2exu_exc_code_o;
	output wire [34:0] lsu2tdu_dmon_o;
	input wire tdu2lsu_ibrkpt_exc_req_i;
	input wire tdu2lsu_dbrkpt_exc_req_i;
	output wire lsu2dmem_req_o;
	output wire lsu2dmem_cmd_o;
	output wire [1:0] lsu2dmem_width_o;
	output wire [31:0] lsu2dmem_addr_o;
	output wire [31:0] lsu2dmem_wdata_o;
	input wire dmem2lsu_req_ack_i;
	input wire [31:0] dmem2lsu_rdata_i;
	input wire [1:0] dmem2lsu_resp_i;
	reg lsu_fsm_curr;
	reg lsu_fsm_next;
	wire lsu_fsm_idle;
	wire lsu_cmd_upd;
	reg [3:0] lsu_cmd_ff;
	wire lsu_cmd_ff_load;
	wire lsu_cmd_ff_store;
	wire dmem_cmd_load;
	wire dmem_cmd_store;
	wire dmem_wdth_word;
	wire dmem_wdth_hword;
	wire dmem_wdth_byte;
	wire dmem_resp_ok;
	wire dmem_resp_er;
	wire dmem_resp_received;
	wire dmem_req_vd;
	wire lsu_exc_req;
	wire dmem_addr_mslgn;
	wire dmem_addr_mslgn_l;
	wire dmem_addr_mslgn_s;
	wire lsu_exc_hwbrk;
	assign dmem_resp_ok = dmem2lsu_resp_i == 2'b01;
	assign dmem_resp_er = dmem2lsu_resp_i == 2'b10;
	assign dmem_resp_received = dmem_resp_ok | dmem_resp_er;
	assign dmem_req_vd = (exu2lsu_req_i & dmem2lsu_req_ack_i) & ~lsu_exc_req;
	function automatic [3:0] sv2v_cast_4A511;
		input reg [3:0] inp;
		sv2v_cast_4A511 = inp;
	endfunction
	assign dmem_cmd_load = ((((exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 1)) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 4))) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 2))) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 5))) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 3));
	assign dmem_cmd_store = ((exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 6)) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 7))) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 8));
	assign dmem_wdth_word = (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 3)) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 8));
	assign dmem_wdth_hword = ((exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 2)) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 5))) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 7));
	assign dmem_wdth_byte = ((exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 1)) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 4))) | (exu2lsu_cmd_i == sv2v_cast_4A511({32 {1'sb0}} + 6));
	assign lsu_cmd_upd = lsu_fsm_idle & dmem_req_vd;
	function automatic [3:0] sv2v_cast_9707C;
		input reg [3:0] inp;
		sv2v_cast_9707C = inp;
	endfunction
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			lsu_cmd_ff <= sv2v_cast_9707C(1'sb0);
		else if (lsu_cmd_upd)
			lsu_cmd_ff <= exu2lsu_cmd_i;
	assign lsu_cmd_ff_load = ((((lsu_cmd_ff == sv2v_cast_4A511({32 {1'sb0}} + 1)) | (lsu_cmd_ff == sv2v_cast_4A511({32 {1'sb0}} + 4))) | (lsu_cmd_ff == sv2v_cast_4A511({32 {1'sb0}} + 2))) | (lsu_cmd_ff == sv2v_cast_4A511({32 {1'sb0}} + 5))) | (lsu_cmd_ff == sv2v_cast_4A511({32 {1'sb0}} + 3));
	assign lsu_cmd_ff_store = ((lsu_cmd_ff == sv2v_cast_4A511({32 {1'sb0}} + 6)) | (lsu_cmd_ff == sv2v_cast_4A511({32 {1'sb0}} + 7))) | (lsu_cmd_ff == sv2v_cast_4A511({32 {1'sb0}} + 8));
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			lsu_fsm_curr <= 1'd0;
		else
			lsu_fsm_curr <= lsu_fsm_next;
	always @(*) begin
		if (_sv2v_0)
			;
		case (lsu_fsm_curr)
			1'd0: lsu_fsm_next = (dmem_req_vd ? 1'd1 : 1'd0);
			1'd1: lsu_fsm_next = (dmem_resp_received ? 1'd0 : 1'd1);
		endcase
	end
	assign lsu_fsm_idle = lsu_fsm_curr == 1'd0;
	assign dmem_addr_mslgn = exu2lsu_req_i & ((dmem_wdth_hword & exu2lsu_addr_i[0]) | (dmem_wdth_word & |exu2lsu_addr_i[1:0]));
	assign dmem_addr_mslgn_l = dmem_addr_mslgn & dmem_cmd_load;
	assign dmem_addr_mslgn_s = dmem_addr_mslgn & dmem_cmd_store;
	function automatic [3:0] sv2v_cast_92043;
		input reg [3:0] inp;
		sv2v_cast_92043 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			dmem_resp_er: lsu2exu_exc_code_o = (lsu_cmd_ff_load ? sv2v_cast_92043(4'd5) : (lsu_cmd_ff_store ? sv2v_cast_92043(4'd7) : sv2v_cast_92043(4'd0)));
			lsu_exc_hwbrk: lsu2exu_exc_code_o = sv2v_cast_92043(4'd3);
			dmem_addr_mslgn_l: lsu2exu_exc_code_o = sv2v_cast_92043(4'd4);
			dmem_addr_mslgn_s: lsu2exu_exc_code_o = sv2v_cast_92043(4'd6);
			default: lsu2exu_exc_code_o = sv2v_cast_92043(4'd0);
		endcase
	end
	assign lsu_exc_req = (dmem_addr_mslgn_l | dmem_addr_mslgn_s) | lsu_exc_hwbrk;
	assign lsu2exu_rdy_o = dmem_resp_received;
	assign lsu2exu_exc_o = dmem_resp_er | lsu_exc_req;
	always @(*) begin
		if (_sv2v_0)
			;
		case (lsu_cmd_ff)
			sv2v_cast_4A511({32 {1'sb0}} + 2): lsu2exu_ldata_o = {{16 {dmem2lsu_rdata_i[15]}}, dmem2lsu_rdata_i[15:0]};
			sv2v_cast_4A511({32 {1'sb0}} + 5): lsu2exu_ldata_o = {16'b0000000000000000, dmem2lsu_rdata_i[15:0]};
			sv2v_cast_4A511({32 {1'sb0}} + 1): lsu2exu_ldata_o = {{24 {dmem2lsu_rdata_i[7]}}, dmem2lsu_rdata_i[7:0]};
			sv2v_cast_4A511({32 {1'sb0}} + 4): lsu2exu_ldata_o = {24'b000000000000000000000000, dmem2lsu_rdata_i[7:0]};
			default: lsu2exu_ldata_o = dmem2lsu_rdata_i;
		endcase
	end
	assign lsu2dmem_req_o = (exu2lsu_req_i & ~lsu_exc_req) & lsu_fsm_idle;
	assign lsu2dmem_addr_o = exu2lsu_addr_i;
	assign lsu2dmem_wdata_o = exu2lsu_sdata_i;
	assign lsu2dmem_cmd_o = (dmem_cmd_store ? 1'b1 : 1'b0);
	assign lsu2dmem_width_o = (dmem_wdth_byte ? 2'b00 : (dmem_wdth_hword ? 2'b01 : 2'b10));
	assign lsu2tdu_dmon_o[34] = (exu2lsu_req_i & lsu_fsm_idle) & ~tdu2lsu_ibrkpt_exc_req_i;
	assign lsu2tdu_dmon_o[31-:32] = exu2lsu_addr_i;
	assign lsu2tdu_dmon_o[33] = dmem_cmd_load;
	assign lsu2tdu_dmon_o[32] = dmem_cmd_store;
	assign lsu_exc_hwbrk = (exu2lsu_req_i & tdu2lsu_ibrkpt_exc_req_i) | tdu2lsu_dbrkpt_exc_req_i;
	initial _sv2v_0 = 0;
endmodule
