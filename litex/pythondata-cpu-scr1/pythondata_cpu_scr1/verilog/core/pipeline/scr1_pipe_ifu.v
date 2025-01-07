/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_ifu (
	rst_n,
	clk,
	pipe2ifu_stop_fetch_i,
	imem2ifu_req_ack_i,
	ifu2imem_req_o,
	ifu2imem_cmd_o,
	ifu2imem_addr_o,
	imem2ifu_rdata_i,
	imem2ifu_resp_i,
	exu2ifu_pc_new_req_i,
	exu2ifu_pc_new_i,
	hdu2ifu_pbuf_fetch_i,
	ifu2hdu_pbuf_rdy_o,
	hdu2ifu_pbuf_vd_i,
	hdu2ifu_pbuf_err_i,
	hdu2ifu_pbuf_instr_i,
	idu2ifu_rdy_i,
	ifu2idu_instr_o,
	ifu2idu_imem_err_o,
	ifu2idu_err_rvi_hi_o,
	ifu2idu_vd_o
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	input wire pipe2ifu_stop_fetch_i;
	input wire imem2ifu_req_ack_i;
	output wire ifu2imem_req_o;
	output wire ifu2imem_cmd_o;
	output wire [31:0] ifu2imem_addr_o;
	input wire [31:0] imem2ifu_rdata_i;
	input wire [1:0] imem2ifu_resp_i;
	input wire exu2ifu_pc_new_req_i;
	input wire [31:0] exu2ifu_pc_new_i;
	input wire hdu2ifu_pbuf_fetch_i;
	output wire ifu2hdu_pbuf_rdy_o;
	input wire hdu2ifu_pbuf_vd_i;
	input wire hdu2ifu_pbuf_err_i;
	localparam [31:0] SCR1_HDU_CORE_INSTR_WIDTH = 32;
	input wire [31:0] hdu2ifu_pbuf_instr_i;
	input wire idu2ifu_rdy_i;
	output reg [31:0] ifu2idu_instr_o;
	output reg ifu2idu_imem_err_o;
	output reg ifu2idu_err_rvi_hi_o;
	output reg ifu2idu_vd_o;
	localparam SCR1_IFU_Q_SIZE_WORD = 2;
	localparam SCR1_IFU_Q_SIZE_HALF = 4;
	localparam SCR1_TXN_CNT_W = 3;
	localparam SCR1_IFU_QUEUE_ADR_W = 2;
	localparam SCR1_IFU_QUEUE_PTR_W = 3;
	localparam SCR1_IFU_Q_FREE_H_W = 3;
	localparam SCR1_IFU_Q_FREE_W_W = 2;
	reg new_pc_unaligned_ff;
	wire new_pc_unaligned_next;
	wire new_pc_unaligned_upd;
	wire instr_hi_is_rvi;
	wire instr_lo_is_rvi;
	reg [2:0] instr_type;
	reg instr_hi_rvi_lo_ff;
	wire instr_hi_rvi_lo_next;
	wire [1:0] q_rd_size;
	wire q_rd_vd;
	wire q_rd_none;
	wire q_rd_hword;
	reg [1:0] q_wr_size;
	wire q_wr_none;
	wire q_wr_full;
	reg [2:0] q_rptr;
	wire [2:0] q_rptr_next;
	wire q_rptr_upd;
	reg [2:0] q_wptr;
	wire [2:0] q_wptr_next;
	wire q_wptr_upd;
	wire q_wr_en;
	wire q_flush_req;
	reg [63:0] q_data;
	wire [15:0] q_data_head;
	wire [15:0] q_data_next;
	reg [0:3] q_err;
	wire q_err_head;
	wire q_err_next;
	wire q_is_empty;
	wire q_has_free_slots;
	wire q_has_1_ocpd_hw;
	wire q_head_is_rvc;
	wire q_head_is_rvi;
	wire [2:0] q_ocpd_h;
	wire [2:0] q_free_h_next;
	wire [1:0] q_free_w_next;
	wire ifu_fetch_req;
	wire ifu_stop_req;
	reg ifu_fsm_curr;
	reg ifu_fsm_next;
	wire ifu_fsm_fetch;
	wire imem_resp_ok;
	wire imem_resp_er;
	wire imem_resp_er_discard_pnd;
	wire imem_resp_discard_req;
	wire imem_resp_received;
	wire imem_resp_vd;
	wire imem_handshake_done;
	wire [15:0] imem_rdata_lo;
	wire [31:16] imem_rdata_hi;
	wire imem_addr_upd;
	reg [31:2] imem_addr_ff;
	wire [31:2] imem_addr_next;
	wire imem_pnd_txns_cnt_upd;
	reg [2:0] imem_pnd_txns_cnt;
	wire [2:0] imem_pnd_txns_cnt_next;
	wire [2:0] imem_vd_pnd_txns_cnt;
	wire imem_pnd_txns_q_full;
	wire imem_resp_discard_cnt_upd;
	reg [2:0] imem_resp_discard_cnt;
	wire [2:0] imem_resp_discard_cnt_next;
	assign new_pc_unaligned_upd = exu2ifu_pc_new_req_i | imem_resp_vd;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			new_pc_unaligned_ff <= 1'b0;
		else if (new_pc_unaligned_upd)
			new_pc_unaligned_ff <= new_pc_unaligned_next;
	assign new_pc_unaligned_next = (exu2ifu_pc_new_req_i ? exu2ifu_pc_new_i[1] : (~imem_resp_vd ? new_pc_unaligned_ff : 1'b0));
	assign instr_hi_is_rvi = &imem2ifu_rdata_i[17:16];
	assign instr_lo_is_rvi = &imem2ifu_rdata_i[1:0];
	always @(*) begin
		if (_sv2v_0)
			;
		instr_type = 3'd0;
		if (imem_resp_ok & ~imem_resp_discard_req) begin
			if (new_pc_unaligned_ff)
				instr_type = (instr_hi_is_rvi ? 3'd7 : 3'd6);
			else if (instr_hi_rvi_lo_ff)
				instr_type = (instr_hi_is_rvi ? 3'd5 : 3'd4);
			else
				case ({instr_hi_is_rvi, instr_lo_is_rvi})
					2'b00: instr_type = 3'd2;
					2'b10: instr_type = 3'd3;
					default: instr_type = 3'd1;
				endcase
		end
	end
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			instr_hi_rvi_lo_ff <= 1'b0;
		else if (exu2ifu_pc_new_req_i)
			instr_hi_rvi_lo_ff <= 1'b0;
		else if (imem_resp_vd)
			instr_hi_rvi_lo_ff <= instr_hi_rvi_lo_next;
	assign instr_hi_rvi_lo_next = ((instr_type == 3'd7) | (instr_type == 3'd5)) | (instr_type == 3'd3);
	assign q_rd_vd = (~q_is_empty & ifu2idu_vd_o) & idu2ifu_rdy_i;
	assign q_rd_hword = q_head_is_rvc | q_err_head;
	assign q_rd_size = (~q_rd_vd ? 2'd0 : (q_rd_hword ? 2'd1 : 2'd2));
	assign q_rd_none = q_rd_size == 2'd0;
	always @(*) begin
		if (_sv2v_0)
			;
		q_wr_size = 2'd0;
		if (~imem_resp_discard_req) begin
			if (imem_resp_ok)
				case (instr_type)
					3'd0: q_wr_size = 2'd0;
					3'd6, 3'd7: q_wr_size = 2'd2;
					default: q_wr_size = 2'd1;
				endcase
			else if (imem_resp_er)
				q_wr_size = 2'd1;
		end
	end
	assign q_wr_none = q_wr_size == 2'd0;
	assign q_wr_full = q_wr_size == 2'd1;
	assign q_flush_req = exu2ifu_pc_new_req_i | pipe2ifu_stop_fetch_i;
	assign q_wptr_upd = q_flush_req | ~q_wr_none;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			q_wptr <= 1'sb0;
		else if (q_wptr_upd)
			q_wptr <= q_wptr_next;
	assign q_wptr_next = (q_flush_req ? {3 {1'sb0}} : (~q_wr_none ? q_wptr + (q_wr_full ? 3'b010 : 3'b001) : q_wptr));
	assign q_rptr_upd = q_flush_req | ~q_rd_none;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			q_rptr <= 1'sb0;
		else if (q_rptr_upd)
			q_rptr <= q_rptr_next;
	assign q_rptr_next = (q_flush_req ? {3 {1'sb0}} : (~q_rd_none ? q_rptr + (q_rd_hword ? 3'b001 : 3'b010) : q_rptr));
	assign imem_rdata_hi = imem2ifu_rdata_i[31:16];
	assign imem_rdata_lo = imem2ifu_rdata_i[15:0];
	assign q_wr_en = imem_resp_vd & ~q_flush_req;
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	always @(posedge clk or negedge rst_n)
		if (~rst_n) begin
			q_data <= {SCR1_IFU_Q_SIZE_HALF {1'sb0}};
			q_err <= {SCR1_IFU_Q_SIZE_HALF {1'b0}};
		end
		else if (q_wr_en)
			case (q_wr_size)
				2'd2: begin
					q_data[(3 - sv2v_cast_2(q_wptr)) * 16+:16] <= imem_rdata_hi;
					q_err[sv2v_cast_2(q_wptr)] <= imem_resp_er;
				end
				2'd1: begin
					q_data[(3 - sv2v_cast_2(q_wptr)) * 16+:16] <= imem_rdata_lo;
					q_err[sv2v_cast_2(q_wptr)] <= imem_resp_er;
					q_data[(3 - sv2v_cast_2(q_wptr + 1'b1)) * 16+:16] <= imem_rdata_hi;
					q_err[sv2v_cast_2(q_wptr + 1'b1)] <= imem_resp_er;
				end
			endcase
	assign q_data_head = q_data[(3 - sv2v_cast_2(q_rptr)) * 16+:16];
	assign q_data_next = q_data[(3 - sv2v_cast_2(q_rptr + 1'b1)) * 16+:16];
	assign q_err_head = q_err[sv2v_cast_2(q_rptr)];
	assign q_err_next = q_err[sv2v_cast_2(q_rptr + 1'b1)];
	assign q_ocpd_h = q_wptr - q_rptr;
	function automatic [2:0] sv2v_cast_3;
		input reg [2:0] inp;
		sv2v_cast_3 = inp;
	endfunction
	assign q_free_h_next = sv2v_cast_3(SCR1_IFU_Q_SIZE_HALF - (q_wptr - q_rptr_next));
	assign q_free_w_next = sv2v_cast_2(q_free_h_next >> 1'b1);
	assign q_is_empty = q_rptr == q_wptr;
	assign q_has_free_slots = sv2v_cast_3(q_free_w_next) > imem_vd_pnd_txns_cnt;
	assign q_has_1_ocpd_hw = q_ocpd_h == 3'sd1;
	assign q_head_is_rvi = &q_data_head[1:0];
	assign q_head_is_rvc = ~q_head_is_rvi;
	assign ifu_fetch_req = exu2ifu_pc_new_req_i & ~pipe2ifu_stop_fetch_i;
	assign ifu_stop_req = pipe2ifu_stop_fetch_i | (imem_resp_er_discard_pnd & ~exu2ifu_pc_new_req_i);
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			ifu_fsm_curr <= 1'd0;
		else
			ifu_fsm_curr <= ifu_fsm_next;
	always @(*) begin
		if (_sv2v_0)
			;
		case (ifu_fsm_curr)
			1'd0: ifu_fsm_next = (ifu_fetch_req ? 1'd1 : 1'd0);
			1'd1: ifu_fsm_next = (ifu_stop_req ? 1'd0 : 1'd1);
		endcase
	end
	assign ifu_fsm_fetch = ifu_fsm_curr == 1'd1;
	assign imem_resp_er = imem2ifu_resp_i == 2'b10;
	assign imem_resp_ok = imem2ifu_resp_i == 2'b01;
	assign imem_resp_received = imem_resp_ok | imem_resp_er;
	assign imem_resp_vd = imem_resp_received & ~imem_resp_discard_req;
	assign imem_resp_er_discard_pnd = imem_resp_er & ~imem_resp_discard_req;
	assign imem_handshake_done = ifu2imem_req_o & imem2ifu_req_ack_i;
	assign imem_addr_upd = imem_handshake_done | exu2ifu_pc_new_req_i;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			imem_addr_ff <= 1'sb0;
		else if (imem_addr_upd)
			imem_addr_ff <= imem_addr_next;
	assign imem_addr_next = (exu2ifu_pc_new_req_i ? exu2ifu_pc_new_i[31:2] + imem_handshake_done : (&imem_addr_ff[5:2] ? imem_addr_ff + imem_handshake_done : {imem_addr_ff[31:6], imem_addr_ff[5:2] + imem_handshake_done}));
	assign imem_pnd_txns_cnt_upd = imem_handshake_done ^ imem_resp_received;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			imem_pnd_txns_cnt <= 1'sb0;
		else if (imem_pnd_txns_cnt_upd)
			imem_pnd_txns_cnt <= imem_pnd_txns_cnt_next;
	assign imem_pnd_txns_cnt_next = imem_pnd_txns_cnt + (imem_handshake_done - imem_resp_received);
	assign imem_pnd_txns_q_full = &imem_pnd_txns_cnt;
	assign imem_resp_discard_cnt_upd = (exu2ifu_pc_new_req_i | imem_resp_er) | (imem_resp_ok & imem_resp_discard_req);
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			imem_resp_discard_cnt <= 1'sb0;
		else if (imem_resp_discard_cnt_upd)
			imem_resp_discard_cnt <= imem_resp_discard_cnt_next;
	assign imem_resp_discard_cnt_next = (exu2ifu_pc_new_req_i ? imem_pnd_txns_cnt_next - imem_handshake_done : (imem_resp_er_discard_pnd ? imem_pnd_txns_cnt_next : imem_resp_discard_cnt - 1'b1));
	assign imem_vd_pnd_txns_cnt = imem_pnd_txns_cnt - imem_resp_discard_cnt;
	assign imem_resp_discard_req = |imem_resp_discard_cnt;
	assign ifu2imem_req_o = ((exu2ifu_pc_new_req_i & ~imem_pnd_txns_q_full) & ~pipe2ifu_stop_fetch_i) | ((ifu_fsm_fetch & ~imem_pnd_txns_q_full) & q_has_free_slots);
	assign ifu2imem_addr_o = (exu2ifu_pc_new_req_i ? {exu2ifu_pc_new_i[31:2], 2'b00} : {imem_addr_ff, 2'b00});
	assign ifu2imem_cmd_o = 1'b0;
	always @(*) begin
		if (_sv2v_0)
			;
		ifu2idu_vd_o = 1'b0;
		ifu2idu_imem_err_o = 1'b0;
		ifu2idu_err_rvi_hi_o = 1'b0;
		if (~q_is_empty) begin
			if (q_has_1_ocpd_hw) begin
				ifu2idu_vd_o = q_head_is_rvc | q_err_head;
				ifu2idu_imem_err_o = q_err_head;
			end
			else begin
				ifu2idu_vd_o = 1'b1;
				ifu2idu_imem_err_o = (q_err_head ? 1'b1 : q_head_is_rvi & q_err_next);
				ifu2idu_err_rvi_hi_o = (~q_err_head & q_head_is_rvi) & q_err_next;
			end
		end
		if (hdu2ifu_pbuf_fetch_i) begin
			ifu2idu_vd_o = hdu2ifu_pbuf_vd_i;
			ifu2idu_imem_err_o = hdu2ifu_pbuf_err_i;
		end
	end
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		ifu2idu_instr_o = (q_head_is_rvc ? sv2v_cast_32(q_data_head) : {q_data_next, q_data_head});
		if (hdu2ifu_pbuf_fetch_i)
			ifu2idu_instr_o = sv2v_cast_32({1'sb0, hdu2ifu_pbuf_instr_i});
	end
	assign ifu2hdu_pbuf_rdy_o = idu2ifu_rdy_i;
	initial _sv2v_0 = 0;
endmodule
