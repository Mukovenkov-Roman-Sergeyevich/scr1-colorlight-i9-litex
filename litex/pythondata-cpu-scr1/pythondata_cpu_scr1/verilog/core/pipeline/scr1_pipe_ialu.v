/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_ialu (
	clk,
	rst_n,
	exu2ialu_rvm_cmd_vd_i,
	ialu2exu_rvm_res_rdy_o,
	exu2ialu_main_op1_i,
	exu2ialu_main_op2_i,
	exu2ialu_cmd_i,
	ialu2exu_main_res_o,
	ialu2exu_cmp_res_o,
	exu2ialu_addr_op1_i,
	exu2ialu_addr_op2_i,
	ialu2exu_addr_res_o
);
	reg _sv2v_0;
	input wire clk;
	input wire rst_n;
	input wire exu2ialu_rvm_cmd_vd_i;
	output reg ialu2exu_rvm_res_rdy_o;
	input wire [31:0] exu2ialu_main_op1_i;
	input wire [31:0] exu2ialu_main_op2_i;
	localparam SCR1_IALU_CMD_ALL_NUM_E = 23;
	localparam SCR1_IALU_CMD_WIDTH_E = 5;
	input wire [4:0] exu2ialu_cmd_i;
	output reg [31:0] ialu2exu_main_res_o;
	output reg ialu2exu_cmp_res_o;
	input wire [31:0] exu2ialu_addr_op1_i;
	input wire [31:0] exu2ialu_addr_op2_i;
	output wire [31:0] ialu2exu_addr_res_o;
	localparam SCR1_MUL_WIDTH = 32;
	localparam SCR1_MUL_RES_WIDTH = 64;
	localparam SCR1_MDU_SUM_WIDTH = 33;
	localparam SCR1_DIV_WIDTH = 1;
	localparam SCR1_DIV_CNT_INIT = 32'b00000000000000000000000000000001 << 30;
	reg [32:0] main_sum_res;
	reg [3:0] main_sum_flags;
	reg main_sum_pos_ovflw;
	reg main_sum_neg_ovflw;
	wire main_ops_diff_sgn;
	wire main_ops_non_zero;
	wire ialu_cmd_shft;
	reg signed [31:0] shft_op1;
	reg [4:0] shft_op2;
	wire [1:0] shft_cmd;
	reg [31:0] shft_res;
	wire mdu_cmd_is_iter;
	wire mdu_iter_req;
	wire mdu_iter_rdy;
	wire mdu_corr_req;
	wire div_corr_req;
	wire rem_corr_req;
	reg [1:0] mdu_fsm_ff;
	reg [1:0] mdu_fsm_next;
	wire mdu_fsm_idle;
	wire mdu_fsm_corr;
	wire [1:0] mdu_cmd;
	wire mdu_cmd_mul;
	wire mdu_cmd_div;
	wire [1:0] mul_cmd;
	wire mul_cmd_hi;
	wire [1:0] div_cmd;
	wire div_cmd_div;
	wire div_cmd_rem;
	wire mul_op1_is_sgn;
	wire mul_op2_is_sgn;
	wire mul_op1_sgn;
	wire mul_op2_sgn;
	wire signed [32:0] mul_op1;
	wire signed [SCR1_MUL_WIDTH:0] mul_op2;
	wire signed [63:0] mul_res;
	wire div_ops_are_sgn;
	wire div_op1_is_neg;
	wire div_op2_is_neg;
	reg div_res_rem_c;
	reg [31:0] div_res_rem;
	reg [31:0] div_res_quo;
	reg div_quo_bit;
	wire div_dvdnd_lo_upd;
	reg [31:0] div_dvdnd_lo_ff;
	wire [31:0] div_dvdnd_lo_next;
	reg mdu_sum_sub;
	reg signed [32:0] mdu_sum_op1;
	reg signed [32:0] mdu_sum_op2;
	reg signed [32:0] mdu_sum_res;
	wire mdu_iter_cnt_en;
	reg [31:0] mdu_iter_cnt;
	wire [31:0] mdu_iter_cnt_next;
	wire mdu_res_upd;
	reg mdu_res_c_ff;
	wire mdu_res_c_next;
	reg [31:0] mdu_res_hi_ff;
	wire [31:0] mdu_res_hi_next;
	reg [31:0] mdu_res_lo_ff;
	wire [31:0] mdu_res_lo_next;
	function automatic [4:0] sv2v_cast_9DDEB;
		input reg [4:0] inp;
		sv2v_cast_9DDEB = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		main_sum_res = (exu2ialu_cmd_i != sv2v_cast_9DDEB({32 {1'sb0}} + 4) ? {1'b0, exu2ialu_main_op1_i} - {1'b0, exu2ialu_main_op2_i} : {1'b0, exu2ialu_main_op1_i} + {1'b0, exu2ialu_main_op2_i});
		main_sum_pos_ovflw = (~exu2ialu_main_op1_i[31] & exu2ialu_main_op2_i[31]) & main_sum_res[31];
		main_sum_neg_ovflw = (exu2ialu_main_op1_i[31] & ~exu2ialu_main_op2_i[31]) & ~main_sum_res[31];
		main_sum_flags[0] = main_sum_res[32];
		main_sum_flags[3] = ~|main_sum_res[31:0];
		main_sum_flags[2] = main_sum_res[31];
		main_sum_flags[1] = main_sum_pos_ovflw | main_sum_neg_ovflw;
	end
	assign ialu2exu_addr_res_o = exu2ialu_addr_op1_i + exu2ialu_addr_op2_i;
	assign ialu_cmd_shft = ((exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 12)) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 13))) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 14));
	assign shft_cmd = (ialu_cmd_shft ? {exu2ialu_cmd_i != sv2v_cast_9DDEB({32 {1'sb0}} + 12), exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 14)} : 2'b00);
	always @(*) begin
		if (_sv2v_0)
			;
		shft_op1 = exu2ialu_main_op1_i;
		shft_op2 = exu2ialu_main_op2_i[4:0];
		case (shft_cmd)
			2'b10: shft_res = shft_op1 >> shft_op2;
			2'b11: shft_res = shft_op1 >>> shft_op2;
			default: shft_res = shft_op1 << shft_op2;
		endcase
	end
	assign mdu_cmd_div = (((exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 19)) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 20))) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 21))) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 22));
	assign mdu_cmd_mul = (((exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 15)) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 18))) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 16))) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 17));
	assign mdu_cmd = (mdu_cmd_div ? 2'd2 : (mdu_cmd_mul ? 2'd1 : 2'd0));
	assign main_ops_non_zero = |exu2ialu_main_op1_i & |exu2ialu_main_op2_i;
	assign main_ops_diff_sgn = exu2ialu_main_op1_i[31] ^ exu2ialu_main_op2_i[31];
	assign mdu_cmd_is_iter = mdu_cmd_div;
	assign mdu_iter_req = (mdu_cmd_is_iter ? main_ops_non_zero & mdu_fsm_idle : 1'b0);
	assign mdu_iter_rdy = mdu_iter_cnt[0];
	assign div_cmd_div = div_cmd == 2'b00;
	assign div_cmd_rem = div_cmd[1];
	assign div_corr_req = div_cmd_div & main_ops_diff_sgn;
	assign rem_corr_req = (div_cmd_rem & |div_res_rem) & (div_op1_is_neg ^ div_res_rem_c);
	assign mdu_corr_req = mdu_cmd_div & (div_corr_req | rem_corr_req);
	assign mdu_iter_cnt_en = exu2ialu_rvm_cmd_vd_i & ~ialu2exu_rvm_res_rdy_o;
	always @(posedge clk)
		if (mdu_iter_cnt_en)
			mdu_iter_cnt <= mdu_iter_cnt_next;
	assign mdu_iter_cnt_next = (~mdu_fsm_idle ? mdu_iter_cnt >> 1 : (mdu_cmd_div ? SCR1_DIV_CNT_INIT : mdu_iter_cnt));
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			mdu_fsm_ff <= 2'd0;
		else
			mdu_fsm_ff <= mdu_fsm_next;
	always @(*) begin
		if (_sv2v_0)
			;
		mdu_fsm_next = 2'd0;
		if (exu2ialu_rvm_cmd_vd_i)
			case (mdu_fsm_ff)
				2'd0: mdu_fsm_next = (mdu_iter_req ? 2'd1 : 2'd0);
				2'd1: mdu_fsm_next = (~mdu_iter_rdy ? 2'd1 : (mdu_corr_req ? 2'd2 : 2'd0));
				2'd2: mdu_fsm_next = 2'd0;
			endcase
	end
	assign mdu_fsm_idle = mdu_fsm_ff == 2'd0;
	assign mdu_fsm_corr = mdu_fsm_ff == 2'd2;
	assign mul_cmd = {(exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 16)) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 17)), (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 16)) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 18))};
	assign mul_cmd_hi = |mul_cmd;
	assign mul_op1_is_sgn = ~&mul_cmd;
	assign mul_op2_is_sgn = ~mul_cmd[1];
	assign mul_op1_sgn = mul_op1_is_sgn & exu2ialu_main_op1_i[31];
	assign mul_op2_sgn = mul_op2_is_sgn & exu2ialu_main_op2_i[31];
	assign mul_op1 = (mdu_cmd_mul ? $signed({mul_op1_sgn, exu2ialu_main_op1_i}) : {33 {1'sb0}});
	assign mul_op2 = (mdu_cmd_mul ? $signed({mul_op2_sgn, exu2ialu_main_op2_i}) : {33 {1'sb0}});
	assign mul_res = (mdu_cmd_mul ? mul_op1 * mul_op2 : $signed(1'sb0));
	assign div_cmd = {(exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 21)) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 22)), (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 22)) | (exu2ialu_cmd_i == sv2v_cast_9DDEB({32 {1'sb0}} + 20))};
	assign div_ops_are_sgn = ~div_cmd[0];
	assign div_op1_is_neg = div_ops_are_sgn & exu2ialu_main_op1_i[31];
	assign div_op2_is_neg = div_ops_are_sgn & exu2ialu_main_op2_i[31];
	always @(*) begin
		if (_sv2v_0)
			;
		div_res_rem_c = 1'sb0;
		div_res_rem = 1'sb0;
		div_res_quo = 1'sb0;
		div_quo_bit = 1'b0;
		if (mdu_cmd_div & ~mdu_fsm_corr) begin
			div_res_rem_c = mdu_sum_res[32];
			div_res_rem = mdu_sum_res[31:0];
			div_quo_bit = ~(div_op1_is_neg ^ div_res_rem_c) | (div_op1_is_neg & ({mdu_sum_res, div_dvdnd_lo_next} == {65 {1'sb0}}));
			div_res_quo = (mdu_fsm_idle ? {1'sb0, div_quo_bit} : {mdu_res_lo_ff[30:0], div_quo_bit});
		end
	end
	assign div_dvdnd_lo_upd = exu2ialu_rvm_cmd_vd_i & ~ialu2exu_rvm_res_rdy_o;
	always @(posedge clk)
		if (div_dvdnd_lo_upd)
			div_dvdnd_lo_ff <= div_dvdnd_lo_next;
	assign div_dvdnd_lo_next = (~mdu_cmd_div | mdu_fsm_corr ? {32 {1'sb0}} : (mdu_fsm_idle ? exu2ialu_main_op1_i << 1 : div_dvdnd_lo_ff << 1));
	always @(*) begin
		if (_sv2v_0)
			;
		mdu_sum_sub = 1'b0;
		mdu_sum_op1 = 1'sb0;
		mdu_sum_op2 = 1'sb0;
		case (mdu_cmd)
			2'd2: begin : sv2v_autoblock_1
				reg sgn;
				reg inv;
				sgn = (mdu_fsm_corr ? div_op1_is_neg ^ mdu_res_c_ff : (mdu_fsm_idle ? 1'b0 : ~mdu_res_lo_ff[0]));
				inv = div_ops_are_sgn & main_ops_diff_sgn;
				mdu_sum_sub = ~inv ^ sgn;
				mdu_sum_op1 = (mdu_fsm_corr ? $signed({1'b0, mdu_res_hi_ff}) : (mdu_fsm_idle ? $signed({div_op1_is_neg, exu2ialu_main_op1_i[31]}) : $signed({mdu_res_hi_ff, div_dvdnd_lo_ff[31]})));
				mdu_sum_op2 = $signed({div_op2_is_neg, exu2ialu_main_op2_i});
			end
			default:
				;
		endcase
		mdu_sum_res = (mdu_sum_sub ? mdu_sum_op1 - mdu_sum_op2 : mdu_sum_op1 + mdu_sum_op2);
	end
	assign mdu_res_upd = exu2ialu_rvm_cmd_vd_i & ~ialu2exu_rvm_res_rdy_o;
	always @(posedge clk)
		if (mdu_res_upd) begin
			mdu_res_c_ff <= mdu_res_c_next;
			mdu_res_hi_ff <= mdu_res_hi_next;
			mdu_res_lo_ff <= mdu_res_lo_next;
		end
	assign mdu_res_c_next = (mdu_cmd_div ? div_res_rem_c : mdu_res_c_ff);
	assign mdu_res_hi_next = (mdu_cmd_div ? div_res_rem : mdu_res_hi_ff);
	assign mdu_res_lo_next = (mdu_cmd_div ? div_res_quo : mdu_res_lo_ff);
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		ialu2exu_main_res_o = 1'sb0;
		ialu2exu_cmp_res_o = 1'b0;
		ialu2exu_rvm_res_rdy_o = 1'b1;
		case (exu2ialu_cmd_i)
			sv2v_cast_9DDEB({32 {1'sb0}} + 1): ialu2exu_main_res_o = exu2ialu_main_op1_i & exu2ialu_main_op2_i;
			sv2v_cast_9DDEB({32 {1'sb0}} + 2): ialu2exu_main_res_o = exu2ialu_main_op1_i | exu2ialu_main_op2_i;
			sv2v_cast_9DDEB({32 {1'sb0}} + 3): ialu2exu_main_res_o = exu2ialu_main_op1_i ^ exu2ialu_main_op2_i;
			sv2v_cast_9DDEB({32 {1'sb0}} + 4): ialu2exu_main_res_o = main_sum_res[31:0];
			sv2v_cast_9DDEB({32 {1'sb0}} + 5): ialu2exu_main_res_o = main_sum_res[31:0];
			sv2v_cast_9DDEB({32 {1'sb0}} + 6): begin
				ialu2exu_main_res_o = sv2v_cast_32(main_sum_flags[2] ^ main_sum_flags[1]);
				ialu2exu_cmp_res_o = main_sum_flags[2] ^ main_sum_flags[1];
			end
			sv2v_cast_9DDEB({32 {1'sb0}} + 7): begin
				ialu2exu_main_res_o = sv2v_cast_32(main_sum_flags[0]);
				ialu2exu_cmp_res_o = main_sum_flags[0];
			end
			sv2v_cast_9DDEB({32 {1'sb0}} + 8): begin
				ialu2exu_main_res_o = sv2v_cast_32(main_sum_flags[3]);
				ialu2exu_cmp_res_o = main_sum_flags[3];
			end
			sv2v_cast_9DDEB({32 {1'sb0}} + 9): begin
				ialu2exu_main_res_o = sv2v_cast_32(~main_sum_flags[3]);
				ialu2exu_cmp_res_o = ~main_sum_flags[3];
			end
			sv2v_cast_9DDEB({32 {1'sb0}} + 10): begin
				ialu2exu_main_res_o = sv2v_cast_32(~(main_sum_flags[2] ^ main_sum_flags[1]));
				ialu2exu_cmp_res_o = ~(main_sum_flags[2] ^ main_sum_flags[1]);
			end
			sv2v_cast_9DDEB({32 {1'sb0}} + 11): begin
				ialu2exu_main_res_o = sv2v_cast_32(~main_sum_flags[0]);
				ialu2exu_cmp_res_o = ~main_sum_flags[0];
			end
			sv2v_cast_9DDEB({32 {1'sb0}} + 12), sv2v_cast_9DDEB({32 {1'sb0}} + 13), sv2v_cast_9DDEB({32 {1'sb0}} + 14): ialu2exu_main_res_o = shft_res;
			sv2v_cast_9DDEB({32 {1'sb0}} + 15), sv2v_cast_9DDEB({32 {1'sb0}} + 16), sv2v_cast_9DDEB({32 {1'sb0}} + 17), sv2v_cast_9DDEB({32 {1'sb0}} + 18): ialu2exu_main_res_o = (mul_cmd_hi ? mul_res[63:32] : mul_res[31:0]);
			sv2v_cast_9DDEB({32 {1'sb0}} + 19), sv2v_cast_9DDEB({32 {1'sb0}} + 20), sv2v_cast_9DDEB({32 {1'sb0}} + 21), sv2v_cast_9DDEB({32 {1'sb0}} + 22):
				case (mdu_fsm_ff)
					2'd0: begin
						ialu2exu_main_res_o = (|exu2ialu_main_op2_i | div_cmd_rem ? exu2ialu_main_op1_i : {32 {1'sb1}});
						ialu2exu_rvm_res_rdy_o = ~mdu_iter_req;
					end
					2'd1: begin
						ialu2exu_main_res_o = (div_cmd_rem ? div_res_rem : div_res_quo);
						ialu2exu_rvm_res_rdy_o = mdu_iter_rdy & ~mdu_corr_req;
					end
					2'd2: begin
						ialu2exu_main_res_o = (div_cmd_rem ? mdu_sum_res[31:0] : -mdu_res_lo_ff[31:0]);
						ialu2exu_rvm_res_rdy_o = 1'b1;
					end
				endcase
			default:
				;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
