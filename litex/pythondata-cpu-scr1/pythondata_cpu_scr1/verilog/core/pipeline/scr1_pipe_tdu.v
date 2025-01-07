/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_tdu (
	rst_n,
	clk,
	clk_en,
	tdu_dsbl_i,
	csr2tdu_req_i,
	csr2tdu_cmd_i,
	csr2tdu_addr_i,
	csr2tdu_wdata_i,
	tdu2csr_rdata_o,
	tdu2csr_resp_o,
	exu2tdu_imon_i,
	tdu2exu_ibrkpt_match_o,
	tdu2exu_ibrkpt_exc_req_o,
	exu2tdu_bp_retire_i,
	tdu2lsu_ibrkpt_exc_req_o,
	lsu2tdu_dmon_i,
	tdu2lsu_dbrkpt_match_o,
	tdu2lsu_dbrkpt_exc_req_o,
	tdu2hdu_dmode_req_o
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	input wire clk_en;
	input wire tdu_dsbl_i;
	input wire csr2tdu_req_i;
	localparam SCR1_CSR_CMD_ALL_NUM_E = 4;
	localparam SCR1_CSR_CMD_WIDTH_E = 2;
	input wire [1:0] csr2tdu_cmd_i;
	localparam SCR1_CSR_ADDR_TDU_OFFS_W = 3;
	input wire [2:0] csr2tdu_addr_i;
	localparam [31:0] SCR1_TDU_DATA_W = 32;
	input wire [31:0] csr2tdu_wdata_i;
	output reg [31:0] tdu2csr_rdata_o;
	output wire tdu2csr_resp_o;
	input wire [33:0] exu2tdu_imon_i;
	localparam [31:0] SCR1_TDU_TRIG_NUM = 4;
	localparam [31:0] SCR1_TDU_MTRIG_NUM = SCR1_TDU_TRIG_NUM;
	localparam [31:0] SCR1_TDU_ALLTRIG_NUM = SCR1_TDU_MTRIG_NUM + 1'b1;
	output wire [SCR1_TDU_ALLTRIG_NUM - 1:0] tdu2exu_ibrkpt_match_o;
	output wire tdu2exu_ibrkpt_exc_req_o;
	input wire [SCR1_TDU_ALLTRIG_NUM - 1:0] exu2tdu_bp_retire_i;
	output wire tdu2lsu_ibrkpt_exc_req_o;
	input wire [34:0] lsu2tdu_dmon_i;
	output wire [3:0] tdu2lsu_dbrkpt_match_o;
	output wire tdu2lsu_dbrkpt_exc_req_o;
	output reg tdu2hdu_dmode_req_o;
	localparam [31:0] MTRIG_NUM = SCR1_TDU_MTRIG_NUM;
	localparam [31:0] ALLTRIG_NUM = SCR1_TDU_ALLTRIG_NUM;
	localparam [31:0] ALLTRIG_W = $clog2(ALLTRIG_NUM + 1);
	reg csr_wr_req;
	reg [31:0] csr_wr_data;
	reg csr_addr_tselect;
	reg [3:0] csr_addr_mcontrol;
	reg [3:0] csr_addr_tdata2;
	reg csr_addr_icount;
	wire csr_tselect_upd;
	reg [ALLTRIG_W - 1:0] csr_tselect_ff;
	wire [3:0] csr_mcontrol_wr_req;
	wire [3:0] csr_mcontrol_clk_en;
	wire [3:0] csr_mcontrol_upd;
	reg [3:0] csr_mcontrol_dmode_ff;
	reg [3:0] csr_mcontrol_dmode_next;
	reg [3:0] csr_mcontrol_m_ff;
	reg [3:0] csr_mcontrol_m_next;
	reg [3:0] csr_mcontrol_exec_ff;
	reg [3:0] csr_mcontrol_exec_next;
	reg [3:0] csr_mcontrol_load_ff;
	reg [3:0] csr_mcontrol_load_next;
	reg [3:0] csr_mcontrol_store_ff;
	reg [3:0] csr_mcontrol_store_next;
	reg [3:0] csr_mcontrol_action_ff;
	reg [3:0] csr_mcontrol_action_next;
	reg [3:0] csr_mcontrol_hit_ff;
	reg [3:0] csr_mcontrol_hit_next;
	wire [3:0] csr_mcontrol_exec_hit;
	wire [3:0] csr_mcontrol_ldst_hit;
	wire csr_icount_wr_req;
	wire csr_icount_clk_en;
	wire csr_icount_upd;
	reg csr_icount_dmode_ff;
	reg csr_icount_dmode_next;
	reg csr_icount_m_ff;
	reg csr_icount_m_next;
	reg csr_icount_action_ff;
	reg csr_icount_action_next;
	reg csr_icount_hit_ff;
	reg csr_icount_hit_next;
	localparam [31:0] SCR1_TDU_ICOUNT_COUNT_HI = 23;
	localparam [31:0] SCR1_TDU_ICOUNT_COUNT_LO = 10;
	reg [SCR1_TDU_ICOUNT_COUNT_HI - SCR1_TDU_ICOUNT_COUNT_LO:0] csr_icount_count_ff;
	reg [SCR1_TDU_ICOUNT_COUNT_HI - SCR1_TDU_ICOUNT_COUNT_LO:0] csr_icount_count_next;
	reg csr_icount_skip_ff;
	wire csr_icount_skip_next;
	wire csr_icount_decr_en;
	wire csr_icount_count_decr;
	wire csr_icount_skip_dsbl;
	wire csr_icount_hit;
	wire [3:0] csr_tdata2_upd;
	reg [(MTRIG_NUM * SCR1_TDU_DATA_W) - 1:0] csr_tdata2_ff;
	assign tdu2csr_resp_o = (csr2tdu_req_i ? 1'd0 : 1'd1);
	localparam [2:0] SCR1_CSR_ADDR_TDU_OFFS_TDATA1 = 3'sd1;
	localparam [2:0] SCR1_CSR_ADDR_TDU_OFFS_TDATA2 = 3'sd2;
	localparam [2:0] SCR1_CSR_ADDR_TDU_OFFS_TINFO = 3'sd4;
	localparam [2:0] SCR1_CSR_ADDR_TDU_OFFS_TSELECT = 3'sd0;
	localparam [31:0] SCR1_TDU_ICOUNT_ACTION_HI = 5;
	localparam [31:0] SCR1_TDU_ICOUNT_ACTION_LO = 0;
	localparam [31:0] SCR1_TDU_ICOUNT_HIT = 24;
	localparam [31:0] SCR1_TDU_ICOUNT_M = 9;
	localparam [31:0] SCR1_TDU_ICOUNT_S = 7;
	localparam [31:0] SCR1_TDU_TDATA1_TYPE_HI = 31;
	localparam [31:0] SCR1_TDU_TDATA1_TYPE_LO = 28;
	localparam [SCR1_TDU_TDATA1_TYPE_HI - SCR1_TDU_TDATA1_TYPE_LO:0] SCR1_TDU_ICOUNT_TYPE_VAL = 2'd3;
	localparam [31:0] SCR1_TDU_ICOUNT_U = 6;
	localparam [31:0] SCR1_TDU_MCONTROL_ACTION_HI = 17;
	localparam [31:0] SCR1_TDU_MCONTROL_ACTION_LO = 12;
	localparam [31:0] SCR1_TDU_MCONTROL_CHAIN = 11;
	localparam [31:0] SCR1_TDU_MCONTROL_EXECUTE = 2;
	localparam [31:0] SCR1_TDU_MCONTROL_HIT = 20;
	localparam [31:0] SCR1_TDU_MCONTROL_LOAD = 0;
	localparam [31:0] SCR1_TDU_MCONTROL_M = 6;
	localparam [31:0] SCR1_TDU_MCONTROL_MASKMAX_HI = 26;
	localparam [31:0] SCR1_TDU_MCONTROL_MASKMAX_LO = 21;
	localparam [SCR1_TDU_MCONTROL_MASKMAX_HI - SCR1_TDU_MCONTROL_MASKMAX_LO:0] SCR1_TDU_MCONTROL_MASKMAX_VAL = 1'b0;
	localparam [31:0] SCR1_TDU_MCONTROL_MATCH_HI = 10;
	localparam [31:0] SCR1_TDU_MCONTROL_MATCH_LO = 7;
	localparam [31:0] SCR1_TDU_MCONTROL_RESERVEDA = 5;
	localparam [0:0] SCR1_TDU_MCONTROL_RESERVEDA_VAL = 1'b0;
	localparam [31:0] SCR1_TDU_MCONTROL_S = 4;
	localparam [31:0] SCR1_TDU_MCONTROL_SELECT = 19;
	localparam [0:0] SCR1_TDU_MCONTROL_SELECT_VAL = 1'b0;
	localparam [31:0] SCR1_TDU_MCONTROL_STORE = 1;
	localparam [31:0] SCR1_TDU_MCONTROL_TIMING = 18;
	localparam [0:0] SCR1_TDU_MCONTROL_TIMING_VAL = 1'b0;
	localparam [SCR1_TDU_TDATA1_TYPE_HI - SCR1_TDU_TDATA1_TYPE_LO:0] SCR1_TDU_MCONTROL_TYPE_VAL = 2'd2;
	localparam [31:0] SCR1_TDU_MCONTROL_U = 3;
	localparam [31:0] SCR1_TDU_TDATA1_DMODE = 27;
	function automatic [ALLTRIG_W - 1:0] sv2v_cast_646DD;
		input reg [ALLTRIG_W - 1:0] inp;
		sv2v_cast_646DD = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		tdu2csr_rdata_o = 1'sb0;
		if (csr2tdu_req_i)
			case (csr2tdu_addr_i)
				SCR1_CSR_ADDR_TDU_OFFS_TSELECT: tdu2csr_rdata_o = {1'sb0, csr_tselect_ff};
				SCR1_CSR_ADDR_TDU_OFFS_TDATA2: begin : sv2v_autoblock_1
					reg [31:0] i;
					for (i = 0; i < MTRIG_NUM; i = i + 1)
						if (csr_tselect_ff == sv2v_cast_646DD(i))
							tdu2csr_rdata_o = csr_tdata2_ff[i * SCR1_TDU_DATA_W+:SCR1_TDU_DATA_W];
				end
				SCR1_CSR_ADDR_TDU_OFFS_TDATA1: begin
					begin : sv2v_autoblock_2
						reg [31:0] i;
						for (i = 0; i < MTRIG_NUM; i = i + 1)
							if (csr_tselect_ff == sv2v_cast_646DD(i)) begin
								tdu2csr_rdata_o[SCR1_TDU_TDATA1_TYPE_HI:SCR1_TDU_TDATA1_TYPE_LO] = SCR1_TDU_MCONTROL_TYPE_VAL;
								tdu2csr_rdata_o[SCR1_TDU_TDATA1_DMODE] = csr_mcontrol_dmode_ff[i];
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_MASKMAX_HI:SCR1_TDU_MCONTROL_MASKMAX_LO] = SCR1_TDU_MCONTROL_MASKMAX_VAL;
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_HIT] = csr_mcontrol_hit_ff[i];
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_SELECT] = SCR1_TDU_MCONTROL_SELECT_VAL;
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_TIMING] = SCR1_TDU_MCONTROL_TIMING_VAL;
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_ACTION_HI:SCR1_TDU_MCONTROL_ACTION_LO] = {5'b00000, csr_mcontrol_action_ff[i]};
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_CHAIN] = 1'b0;
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_MATCH_HI:SCR1_TDU_MCONTROL_MATCH_LO] = 4'b0000;
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_M] = csr_mcontrol_m_ff[i];
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_RESERVEDA] = SCR1_TDU_MCONTROL_RESERVEDA_VAL;
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_S] = 1'b0;
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_U] = 1'b0;
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_EXECUTE] = csr_mcontrol_exec_ff[i];
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_STORE] = csr_mcontrol_store_ff[i];
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_LOAD] = csr_mcontrol_load_ff[i];
							end
					end
					if (csr_tselect_ff == sv2v_cast_646DD(SCR1_TDU_ALLTRIG_NUM - 1'b1)) begin
						tdu2csr_rdata_o[SCR1_TDU_TDATA1_TYPE_HI:SCR1_TDU_TDATA1_TYPE_LO] = SCR1_TDU_ICOUNT_TYPE_VAL;
						tdu2csr_rdata_o[SCR1_TDU_TDATA1_DMODE] = csr_icount_dmode_ff;
						tdu2csr_rdata_o[SCR1_TDU_ICOUNT_HIT] = csr_icount_hit_ff;
						tdu2csr_rdata_o[SCR1_TDU_ICOUNT_COUNT_HI:SCR1_TDU_ICOUNT_COUNT_LO] = csr_icount_count_ff;
						tdu2csr_rdata_o[SCR1_TDU_ICOUNT_U] = 1'b0;
						tdu2csr_rdata_o[SCR1_TDU_ICOUNT_S] = 1'b0;
						tdu2csr_rdata_o[SCR1_TDU_ICOUNT_M] = csr_icount_m_ff;
						tdu2csr_rdata_o[SCR1_TDU_ICOUNT_ACTION_HI:SCR1_TDU_ICOUNT_ACTION_LO] = {5'b00000, csr_icount_action_ff};
					end
				end
				SCR1_CSR_ADDR_TDU_OFFS_TINFO: begin
					begin : sv2v_autoblock_3
						reg [31:0] i;
						for (i = 0; i < MTRIG_NUM; i = i + 1)
							if (csr_tselect_ff == sv2v_cast_646DD(i))
								tdu2csr_rdata_o[SCR1_TDU_MCONTROL_TYPE_VAL] = 1'b1;
					end
					if (csr_tselect_ff == sv2v_cast_646DD(SCR1_TDU_ALLTRIG_NUM - 1'b1))
						tdu2csr_rdata_o[SCR1_TDU_ICOUNT_TYPE_VAL] = 1'b1;
				end
				default:
					;
			endcase
	end
	function automatic [1:0] sv2v_cast_999B9;
		input reg [1:0] inp;
		sv2v_cast_999B9 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		csr_wr_req = 1'b0;
		csr_wr_data = 1'sb0;
		case (csr2tdu_cmd_i)
			sv2v_cast_999B9({32 {1'sb0}} + 1): begin
				csr_wr_req = 1'b1;
				csr_wr_data = csr2tdu_wdata_i;
			end
			sv2v_cast_999B9({32 {1'sb0}} + 2): begin
				csr_wr_req = |csr2tdu_wdata_i;
				csr_wr_data = tdu2csr_rdata_o | csr2tdu_wdata_i;
			end
			sv2v_cast_999B9({32 {1'sb0}} + 3): begin
				csr_wr_req = |csr2tdu_wdata_i;
				csr_wr_data = tdu2csr_rdata_o & ~csr2tdu_wdata_i;
			end
			default:
				;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		csr_addr_tselect = 1'b0;
		csr_addr_tdata2 = 1'sb0;
		csr_addr_mcontrol = 1'sb0;
		csr_addr_icount = 1'sb0;
		if (csr2tdu_req_i)
			case (csr2tdu_addr_i)
				SCR1_CSR_ADDR_TDU_OFFS_TSELECT: csr_addr_tselect = 1'b1;
				SCR1_CSR_ADDR_TDU_OFFS_TDATA1: begin
					begin : sv2v_autoblock_4
						reg [31:0] i;
						for (i = 0; i < MTRIG_NUM; i = i + 1)
							if (csr_tselect_ff == sv2v_cast_646DD(i))
								csr_addr_mcontrol[i] = 1'b1;
					end
					if (csr_tselect_ff == sv2v_cast_646DD(SCR1_TDU_ALLTRIG_NUM - 1'b1))
						csr_addr_icount = 1'b1;
				end
				SCR1_CSR_ADDR_TDU_OFFS_TDATA2: begin : sv2v_autoblock_5
					reg [31:0] i;
					for (i = 0; i < MTRIG_NUM; i = i + 1)
						if (csr_tselect_ff == sv2v_cast_646DD(i))
							csr_addr_tdata2[i] = 1'b1;
				end
				default:
					;
			endcase
	end
	assign csr_tselect_upd = ((clk_en & csr_addr_tselect) & csr_wr_req) & (csr_wr_data[ALLTRIG_W - 1:0] < sv2v_cast_646DD(ALLTRIG_NUM));
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			csr_tselect_ff <= 1'sb0;
		else if (csr_tselect_upd)
			csr_tselect_ff <= csr_wr_data[ALLTRIG_W - 1:0];
	assign csr_icount_wr_req = csr_addr_icount & csr_wr_req;
	assign csr_icount_clk_en = clk_en & (csr_icount_wr_req | csr_icount_m_ff);
	assign csr_icount_upd = (~csr_icount_dmode_ff ? csr_icount_wr_req : tdu_dsbl_i & csr_icount_wr_req);
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			csr_icount_dmode_ff <= 1'b0;
			csr_icount_m_ff <= 1'b0;
			csr_icount_action_ff <= 1'b0;
			csr_icount_hit_ff <= 1'b0;
			csr_icount_count_ff <= 1'sb0;
			csr_icount_skip_ff <= 1'b0;
		end
		else if (csr_icount_clk_en) begin
			csr_icount_dmode_ff <= csr_icount_dmode_next;
			csr_icount_m_ff <= csr_icount_m_next;
			csr_icount_action_ff <= csr_icount_action_next;
			csr_icount_hit_ff <= csr_icount_hit_next;
			csr_icount_count_ff <= csr_icount_count_next;
			csr_icount_skip_ff <= csr_icount_skip_next;
		end
	assign csr_icount_decr_en = (~tdu_dsbl_i & csr_icount_m_ff ? exu2tdu_imon_i[33] & (csr_icount_count_ff != 14'b00000000000000) : 1'b0);
	assign csr_icount_count_decr = (exu2tdu_imon_i[32] & csr_icount_decr_en) & ~csr_icount_skip_ff;
	assign csr_icount_skip_dsbl = (exu2tdu_imon_i[32] & csr_icount_decr_en) & csr_icount_skip_ff;
	always @(*) begin
		if (_sv2v_0)
			;
		if (csr_icount_upd) begin
			csr_icount_dmode_next = csr_wr_data[SCR1_TDU_TDATA1_DMODE];
			csr_icount_m_next = csr_wr_data[SCR1_TDU_ICOUNT_M];
			csr_icount_action_next = csr_wr_data[SCR1_TDU_ICOUNT_ACTION_HI:SCR1_TDU_ICOUNT_ACTION_LO] == 'b1;
			csr_icount_hit_next = csr_wr_data[SCR1_TDU_ICOUNT_HIT];
			csr_icount_count_next = csr_wr_data[SCR1_TDU_ICOUNT_COUNT_HI:SCR1_TDU_ICOUNT_COUNT_LO];
		end
		else begin
			csr_icount_dmode_next = csr_icount_dmode_ff;
			csr_icount_m_next = csr_icount_m_ff;
			csr_icount_action_next = csr_icount_action_ff;
			csr_icount_hit_next = (exu2tdu_bp_retire_i[ALLTRIG_NUM - 1'b1] ? 1'b1 : csr_icount_hit_ff);
			csr_icount_count_next = (csr_icount_count_decr ? csr_icount_count_ff - 1'b1 : csr_icount_count_ff);
		end
	end
	assign csr_icount_skip_next = (csr_icount_wr_req ? csr_wr_data[SCR1_TDU_ICOUNT_M] : (csr_icount_skip_dsbl ? 1'b0 : csr_icount_skip_ff));
	genvar _gv_trig_1;
	generate
		for (_gv_trig_1 = 0; $unsigned(_gv_trig_1) < MTRIG_NUM; _gv_trig_1 = _gv_trig_1 + 1) begin : gblock_mtrig
			localparam trig = _gv_trig_1;
			assign csr_mcontrol_wr_req[trig] = csr_addr_mcontrol[trig] & csr_wr_req;
			assign csr_mcontrol_clk_en[trig] = clk_en & (csr_mcontrol_wr_req[trig] | csr_mcontrol_m_ff[trig]);
			assign csr_mcontrol_upd[trig] = (~csr_mcontrol_dmode_ff[trig] ? csr_mcontrol_wr_req[trig] : tdu_dsbl_i & csr_mcontrol_wr_req[trig]);
			always @(negedge rst_n or posedge clk)
				if (~rst_n) begin
					csr_mcontrol_dmode_ff[trig] <= 1'b0;
					csr_mcontrol_m_ff[trig] <= 1'b0;
					csr_mcontrol_exec_ff[trig] <= 1'b0;
					csr_mcontrol_load_ff[trig] <= 1'b0;
					csr_mcontrol_store_ff[trig] <= 1'b0;
					csr_mcontrol_action_ff[trig] <= 1'b0;
					csr_mcontrol_hit_ff[trig] <= 1'b0;
				end
				else if (csr_mcontrol_clk_en[trig]) begin
					csr_mcontrol_dmode_ff[trig] <= csr_mcontrol_dmode_next[trig];
					csr_mcontrol_m_ff[trig] <= csr_mcontrol_m_next[trig];
					csr_mcontrol_exec_ff[trig] <= csr_mcontrol_exec_next[trig];
					csr_mcontrol_load_ff[trig] <= csr_mcontrol_load_next[trig];
					csr_mcontrol_store_ff[trig] <= csr_mcontrol_store_next[trig];
					csr_mcontrol_action_ff[trig] <= csr_mcontrol_action_next[trig];
					csr_mcontrol_hit_ff[trig] <= csr_mcontrol_hit_next[trig];
				end
			always @(*) begin
				if (_sv2v_0)
					;
				if (csr_mcontrol_upd[trig]) begin
					csr_mcontrol_dmode_next[trig] = csr_wr_data[SCR1_TDU_TDATA1_DMODE];
					csr_mcontrol_m_next[trig] = csr_wr_data[SCR1_TDU_MCONTROL_M];
					csr_mcontrol_exec_next[trig] = csr_wr_data[SCR1_TDU_MCONTROL_EXECUTE];
					csr_mcontrol_load_next[trig] = csr_wr_data[SCR1_TDU_MCONTROL_LOAD];
					csr_mcontrol_store_next[trig] = csr_wr_data[SCR1_TDU_MCONTROL_STORE];
					csr_mcontrol_action_next[trig] = csr_wr_data[SCR1_TDU_MCONTROL_ACTION_HI:SCR1_TDU_MCONTROL_ACTION_LO] == 'b1;
					csr_mcontrol_hit_next[trig] = csr_wr_data[SCR1_TDU_MCONTROL_HIT];
				end
				else begin
					csr_mcontrol_dmode_next[trig] = csr_mcontrol_dmode_ff[trig];
					csr_mcontrol_m_next[trig] = csr_mcontrol_m_ff[trig];
					csr_mcontrol_exec_next[trig] = csr_mcontrol_exec_ff[trig];
					csr_mcontrol_load_next[trig] = csr_mcontrol_load_ff[trig];
					csr_mcontrol_store_next[trig] = csr_mcontrol_store_ff[trig];
					csr_mcontrol_action_next[trig] = csr_mcontrol_action_ff[trig];
					csr_mcontrol_hit_next[trig] = (exu2tdu_bp_retire_i[trig] ? 1'b1 : csr_mcontrol_hit_ff[trig]);
				end
			end
			assign csr_tdata2_upd[trig] = (~csr_mcontrol_dmode_ff[trig] ? (clk_en & csr_addr_tdata2[trig]) & csr_wr_req : ((clk_en & csr_addr_tdata2[trig]) & csr_wr_req) & tdu_dsbl_i);
			always @(posedge clk)
				if (csr_tdata2_upd[trig])
					csr_tdata2_ff[trig * SCR1_TDU_DATA_W+:SCR1_TDU_DATA_W] <= csr_wr_data;
		end
	endgenerate
	assign csr_icount_hit = (~tdu_dsbl_i & csr_icount_m_ff ? (exu2tdu_imon_i[33] & (csr_icount_count_ff == 14'b00000000000001)) & ~csr_icount_skip_ff : 1'b0);
	assign tdu2exu_ibrkpt_match_o = {csr_icount_hit, csr_mcontrol_exec_hit};
	assign tdu2exu_ibrkpt_exc_req_o = |csr_mcontrol_exec_hit | csr_icount_hit;
	generate
		for (_gv_trig_1 = 0; $unsigned(_gv_trig_1) < MTRIG_NUM; _gv_trig_1 = _gv_trig_1 + 1) begin : gblock_break_trig
			localparam trig = _gv_trig_1;
			assign csr_mcontrol_exec_hit[trig] = (((~tdu_dsbl_i & csr_mcontrol_m_ff[trig]) & csr_mcontrol_exec_ff[trig]) & exu2tdu_imon_i[33]) & (exu2tdu_imon_i[31-:32] == csr_tdata2_ff[trig * SCR1_TDU_DATA_W+:SCR1_TDU_DATA_W]);
		end
	endgenerate
	assign tdu2lsu_ibrkpt_exc_req_o = |csr_mcontrol_exec_hit | csr_icount_hit;
	generate
		for (_gv_trig_1 = 0; $unsigned(_gv_trig_1) < MTRIG_NUM; _gv_trig_1 = _gv_trig_1 + 1) begin : gblock_watch_trig
			localparam trig = _gv_trig_1;
			assign csr_mcontrol_ldst_hit[trig] = (((~tdu_dsbl_i & csr_mcontrol_m_ff[trig]) & lsu2tdu_dmon_i[34]) & ((csr_mcontrol_load_ff[trig] & lsu2tdu_dmon_i[33]) | (csr_mcontrol_store_ff[trig] & lsu2tdu_dmon_i[32]))) & (lsu2tdu_dmon_i[31-:32] == csr_tdata2_ff[trig * SCR1_TDU_DATA_W+:SCR1_TDU_DATA_W]);
		end
	endgenerate
	assign tdu2lsu_dbrkpt_match_o = csr_mcontrol_ldst_hit;
	assign tdu2lsu_dbrkpt_exc_req_o = |csr_mcontrol_ldst_hit;
	always @(*) begin
		if (_sv2v_0)
			;
		tdu2hdu_dmode_req_o = 1'b0;
		begin : sv2v_autoblock_6
			reg [31:0] i;
			for (i = 0; i < MTRIG_NUM; i = i + 1)
				tdu2hdu_dmode_req_o = tdu2hdu_dmode_req_o | (csr_mcontrol_action_ff[i] & exu2tdu_bp_retire_i[i]);
		end
		tdu2hdu_dmode_req_o = tdu2hdu_dmode_req_o | (csr_icount_action_ff & exu2tdu_bp_retire_i[ALLTRIG_NUM - 1]);
	end
	initial _sv2v_0 = 0;
endmodule
