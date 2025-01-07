/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_ipic (
	rst_n,
	clk,
	soc2ipic_irq_lines_i,
	csr2ipic_r_req_i,
	csr2ipic_w_req_i,
	csr2ipic_addr_i,
	csr2ipic_wdata_i,
	ipic2csr_rdata_o,
	ipic2csr_irq_m_req_o
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	localparam SCR1_IRQ_VECT_NUM = 16;
	localparam SCR1_IRQ_LINES_NUM = SCR1_IRQ_VECT_NUM;
	input wire [15:0] soc2ipic_irq_lines_i;
	input wire csr2ipic_r_req_i;
	input wire csr2ipic_w_req_i;
	input wire [2:0] csr2ipic_addr_i;
	input wire [31:0] csr2ipic_wdata_i;
	output reg [31:0] ipic2csr_rdata_o;
	output wire ipic2csr_irq_m_req_o;
	localparam SCR1_IRQ_IDX_WIDTH = 4;
	localparam SCR1_IRQ_LINES_WIDTH = 4;
	function automatic [1:0] scr1_search_one_2;
		input reg [1:0] din;
		reg [1:0] tmp;
		begin
			tmp[1] = |din;
			tmp[0] = ~din[0];
			scr1_search_one_2 = tmp;
		end
	endfunction
	function automatic [4:0] scr1_search_one_16;
		input reg [15:0] din;
		reg [7:0] stage1_vd;
		reg [3:0] stage2_vd;
		reg [1:0] stage3_vd;
		reg stage1_idx [7:0];
		reg [1:0] stage2_idx [3:0];
		reg [2:0] stage3_idx [1:0];
		reg [4:0] result;
		begin
			begin : sv2v_autoblock_1
				reg [31:0] i;
				for (i = 0; i < 8; i = i + 1)
					begin : sv2v_autoblock_2
						reg [1:0] tmp;
						tmp = scr1_search_one_2(din[((i + 1) * 2) - 1-:2]);
						stage1_vd[i] = tmp[1];
						stage1_idx[i] = tmp[0];
					end
			end
			begin : sv2v_autoblock_3
				reg [31:0] i;
				for (i = 0; i < 4; i = i + 1)
					begin : sv2v_autoblock_4
						reg [1:0] tmp;
						tmp = scr1_search_one_2(stage1_vd[((i + 1) * 2) - 1-:2]);
						stage2_vd[i] = tmp[1];
						stage2_idx[i] = (~tmp[0] ? {tmp[0], stage1_idx[2 * i]} : {tmp[0], stage1_idx[(2 * i) + 1]});
					end
			end
			begin : sv2v_autoblock_5
				reg [31:0] i;
				for (i = 0; i < 2; i = i + 1)
					begin : sv2v_autoblock_6
						reg [1:0] tmp;
						tmp = scr1_search_one_2(stage2_vd[((i + 1) * 2) - 1-:2]);
						stage3_vd[i] = tmp[1];
						stage3_idx[i] = (~tmp[0] ? {tmp[0], stage2_idx[2 * i]} : {tmp[0], stage2_idx[(2 * i) + 1]});
					end
			end
			result[4] = |stage3_vd;
			result[3-:SCR1_IRQ_IDX_WIDTH] = (stage3_vd[0] ? {1'b0, stage3_idx[0]} : {1'b1, stage3_idx[1]});
			scr1_search_one_16 = result;
		end
	endfunction
	reg [15:0] irq_lines;
	reg [15:0] irq_lines_sync;
	reg [15:0] irq_lines_dly;
	wire [15:0] irq_edge_detected;
	wire [15:0] irq_lvl;
	wire ipic_cisv_upd;
	localparam SCR1_IRQ_VECT_WIDTH = 5;
	reg [4:0] ipic_cisv_ff;
	wire [4:0] ipic_cisv_next;
	reg cicsr_wr_req;
	wire [1:0] ipic_cicsr;
	reg eoi_wr_req;
	wire ipic_eoi_req;
	reg soi_wr_req;
	wire ipic_soi_req;
	reg idxr_wr_req;
	reg [3:0] ipic_idxr_ff;
	wire ipic_ipr_upd;
	reg [15:0] ipic_ipr_ff;
	reg [15:0] ipic_ipr_next;
	wire [15:0] ipic_ipr_clr_cond;
	reg [15:0] ipic_ipr_clr_req;
	wire [15:0] ipic_ipr_clr;
	wire ipic_isvr_upd;
	reg [15:0] ipic_isvr_ff;
	reg [15:0] ipic_isvr_next;
	wire ipic_ier_upd;
	reg [15:0] ipic_ier_ff;
	reg [15:0] ipic_ier_next;
	reg [15:0] ipic_imr_ff;
	reg [15:0] ipic_imr_next;
	reg [15:0] ipic_iinvr_ff;
	reg [15:0] ipic_iinvr_next;
	reg icsr_wr_req;
	wire [8:0] ipic_icsr;
	wire irq_serv_vd;
	wire [3:0] irq_serv_idx;
	wire irq_req_vd;
	wire [3:0] irq_req_idx;
	wire irq_eoi_req_vd;
	wire [3:0] irq_eoi_req_idx;
	wire [15:0] irq_req_v;
	wire irq_start_vd;
	wire irq_hi_prior_pnd;
	wire [4:0] irr_priority;
	wire [4:0] isvr_priority_eoi;
	reg [15:0] ipic_isvr_eoi;
	always @(posedge clk or negedge rst_n)
		if (~rst_n) begin
			irq_lines_sync <= 1'sb0;
			irq_lines <= 1'sb0;
		end
		else begin
			irq_lines_sync <= soc2ipic_irq_lines_i;
			irq_lines <= irq_lines_sync;
		end
	assign irq_lvl = irq_lines ^ ipic_iinvr_next;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			irq_lines_dly <= 1'sb0;
		else
			irq_lines_dly <= irq_lines;
	assign irq_edge_detected = (irq_lines_dly ^ irq_lines) & irq_lvl;
	localparam [2:0] SCR1_IPIC_CICSR = 3'h1;
	localparam [2:0] SCR1_IPIC_CISV = 3'h0;
	localparam [2:0] SCR1_IPIC_EOI = 3'h4;
	localparam [2:0] SCR1_IPIC_ICSR = 3'h7;
	localparam SCR1_IPIC_ICSR_IE = 1;
	localparam SCR1_IPIC_ICSR_IM = 2;
	localparam SCR1_IPIC_ICSR_INV = 3;
	localparam SCR1_IPIC_ICSR_IP = 0;
	localparam SCR1_IPIC_ICSR_IS = 4;
	localparam SCR1_IPIC_ICSR_LN_LSB = 12;
	localparam SCR1_IPIC_ICSR_LN_MSB = 16;
	localparam SCR1_IPIC_ICSR_PRV_LSB = 8;
	localparam SCR1_IPIC_ICSR_PRV_MSB = 9;
	localparam [2:0] SCR1_IPIC_IDX = 3'h6;
	localparam [2:0] SCR1_IPIC_IPR = 3'h2;
	localparam [2:0] SCR1_IPIC_ISVR = 3'h3;
	localparam [1:0] SCR1_IPIC_PRV_M = 2'b11;
	localparam [2:0] SCR1_IPIC_SOI = 3'h5;
	function automatic signed [4:0] sv2v_cast_5_signed;
		input reg signed [4:0] inp;
		sv2v_cast_5_signed = inp;
	endfunction
	localparam [4:0] SCR1_IRQ_VOID_VECT_NUM = sv2v_cast_5_signed(SCR1_IRQ_VECT_NUM);
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		ipic2csr_rdata_o = 1'sb0;
		if (csr2ipic_r_req_i)
			case (csr2ipic_addr_i)
				SCR1_IPIC_CISV: ipic2csr_rdata_o[4:0] = (irq_serv_vd ? ipic_cisv_ff : SCR1_IRQ_VOID_VECT_NUM);
				SCR1_IPIC_CICSR: begin
					ipic2csr_rdata_o[SCR1_IPIC_ICSR_IP] = ipic_cicsr[1];
					ipic2csr_rdata_o[SCR1_IPIC_ICSR_IE] = ipic_cicsr[0];
				end
				SCR1_IPIC_IPR: ipic2csr_rdata_o = sv2v_cast_32(ipic_ipr_ff);
				SCR1_IPIC_ISVR: ipic2csr_rdata_o = sv2v_cast_32(ipic_isvr_ff);
				SCR1_IPIC_EOI, SCR1_IPIC_SOI: ipic2csr_rdata_o = 1'sb0;
				SCR1_IPIC_IDX: ipic2csr_rdata_o = sv2v_cast_32(ipic_idxr_ff);
				SCR1_IPIC_ICSR: begin
					ipic2csr_rdata_o[SCR1_IPIC_ICSR_IP] = ipic_icsr[8];
					ipic2csr_rdata_o[SCR1_IPIC_ICSR_IE] = ipic_icsr[7];
					ipic2csr_rdata_o[SCR1_IPIC_ICSR_IM] = ipic_icsr[6];
					ipic2csr_rdata_o[SCR1_IPIC_ICSR_INV] = ipic_icsr[5];
					ipic2csr_rdata_o[SCR1_IPIC_ICSR_PRV_MSB:SCR1_IPIC_ICSR_PRV_LSB] = SCR1_IPIC_PRV_M;
					ipic2csr_rdata_o[SCR1_IPIC_ICSR_IS] = ipic_icsr[4];
					ipic2csr_rdata_o[15:SCR1_IPIC_ICSR_LN_LSB] = ipic_icsr[3-:SCR1_IRQ_LINES_WIDTH];
				end
				default: ipic2csr_rdata_o = 1'sbx;
			endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		cicsr_wr_req = 1'b0;
		eoi_wr_req = 1'b0;
		soi_wr_req = 1'b0;
		idxr_wr_req = 1'b0;
		icsr_wr_req = 1'b0;
		if (csr2ipic_w_req_i)
			case (csr2ipic_addr_i)
				SCR1_IPIC_CISV:
					;
				SCR1_IPIC_CICSR: cicsr_wr_req = 1'b1;
				SCR1_IPIC_IPR:
					;
				SCR1_IPIC_ISVR:
					;
				SCR1_IPIC_EOI: eoi_wr_req = 1'b1;
				SCR1_IPIC_SOI: soi_wr_req = 1'b1;
				SCR1_IPIC_IDX: idxr_wr_req = 1'b1;
				SCR1_IPIC_ICSR: icsr_wr_req = 1'b1;
				default: begin
					cicsr_wr_req = 1'sbx;
					eoi_wr_req = 1'sbx;
					soi_wr_req = 1'sbx;
					idxr_wr_req = 1'sbx;
					icsr_wr_req = 1'sbx;
				end
			endcase
	end
	assign ipic_cisv_upd = irq_start_vd | ipic_eoi_req;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			ipic_cisv_ff <= SCR1_IRQ_VOID_VECT_NUM;
		else if (ipic_cisv_upd)
			ipic_cisv_ff <= ipic_cisv_next;
	assign ipic_cisv_next = (irq_start_vd ? {1'b0, irq_req_idx} : (ipic_eoi_req ? (irq_eoi_req_vd ? {1'b0, irq_eoi_req_idx} : SCR1_IRQ_VOID_VECT_NUM) : 1'b0));
	assign irq_serv_idx = ipic_cisv_ff[3:0];
	assign irq_serv_vd = ~ipic_cisv_ff[4];
	assign ipic_cicsr[1] = ipic_ipr_ff[irq_serv_idx] & irq_serv_vd;
	assign ipic_cicsr[0] = ipic_ier_ff[irq_serv_idx] & irq_serv_vd;
	assign ipic_eoi_req = eoi_wr_req & irq_serv_vd;
	assign ipic_soi_req = soi_wr_req & irq_req_vd;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			ipic_idxr_ff <= 1'sb0;
		else if (idxr_wr_req)
			ipic_idxr_ff <= csr2ipic_wdata_i[3:0];
	assign ipic_ipr_upd = ipic_ipr_next != ipic_ipr_ff;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			ipic_ipr_ff <= 1'sb0;
		else if (ipic_ipr_upd)
			ipic_ipr_ff <= ipic_ipr_next;
	always @(*) begin
		if (_sv2v_0)
			;
		ipic_ipr_clr_req = 1'sb0;
		if (csr2ipic_w_req_i)
			case (csr2ipic_addr_i)
				SCR1_IPIC_CICSR: ipic_ipr_clr_req[irq_serv_idx] = csr2ipic_wdata_i[SCR1_IPIC_ICSR_IP] & irq_serv_vd;
				SCR1_IPIC_IPR: ipic_ipr_clr_req = csr2ipic_wdata_i[15:0];
				SCR1_IPIC_SOI: ipic_ipr_clr_req[irq_req_idx] = irq_req_vd;
				SCR1_IPIC_ICSR: ipic_ipr_clr_req[ipic_idxr_ff] = csr2ipic_wdata_i[SCR1_IPIC_ICSR_IP];
				default:
					;
			endcase
	end
	assign ipic_ipr_clr_cond = ~irq_lvl | ipic_imr_next;
	assign ipic_ipr_clr = ipic_ipr_clr_req & ipic_ipr_clr_cond;
	always @(*) begin
		if (_sv2v_0)
			;
		ipic_ipr_next = 1'sb0;
		begin : sv2v_autoblock_7
			reg [31:0] i;
			for (i = 0; i < SCR1_IRQ_VECT_NUM; i = i + 1)
				ipic_ipr_next[i] = (ipic_ipr_clr[i] ? 1'b0 : (~ipic_imr_ff[i] ? irq_lvl[i] : ipic_ipr_ff[i] | irq_edge_detected[i]));
		end
	end
	assign ipic_isvr_upd = irq_start_vd | ipic_eoi_req;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			ipic_isvr_ff <= 1'sb0;
		else if (ipic_isvr_upd)
			ipic_isvr_ff <= ipic_isvr_next;
	always @(*) begin
		if (_sv2v_0)
			;
		ipic_isvr_eoi = ipic_isvr_ff;
		if (irq_serv_vd)
			ipic_isvr_eoi[irq_serv_idx] = 1'b0;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		ipic_isvr_next = ipic_isvr_ff;
		if (irq_start_vd)
			ipic_isvr_next[irq_req_idx] = 1'b1;
		else if (ipic_eoi_req)
			ipic_isvr_next = ipic_isvr_eoi;
	end
	assign ipic_ier_upd = cicsr_wr_req | icsr_wr_req;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			ipic_ier_ff <= 1'sb0;
		else if (ipic_ier_upd)
			ipic_ier_ff <= ipic_ier_next;
	always @(*) begin
		if (_sv2v_0)
			;
		ipic_ier_next = ipic_ier_ff;
		if (cicsr_wr_req)
			ipic_ier_next[irq_serv_idx] = (irq_serv_vd ? csr2ipic_wdata_i[SCR1_IPIC_ICSR_IE] : ipic_ier_ff[irq_serv_idx]);
		else if (icsr_wr_req)
			ipic_ier_next[ipic_idxr_ff] = csr2ipic_wdata_i[SCR1_IPIC_ICSR_IE];
	end
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			ipic_imr_ff <= 1'sb0;
		else if (icsr_wr_req)
			ipic_imr_ff <= ipic_imr_next;
	always @(*) begin
		if (_sv2v_0)
			;
		ipic_imr_next = ipic_imr_ff;
		if (icsr_wr_req)
			ipic_imr_next[ipic_idxr_ff] = csr2ipic_wdata_i[SCR1_IPIC_ICSR_IM];
	end
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			ipic_iinvr_ff <= 1'sb0;
		else if (icsr_wr_req)
			ipic_iinvr_ff <= ipic_iinvr_next;
	always @(*) begin
		if (_sv2v_0)
			;
		ipic_iinvr_next = ipic_iinvr_ff;
		if (icsr_wr_req)
			ipic_iinvr_next[ipic_idxr_ff] = csr2ipic_wdata_i[SCR1_IPIC_ICSR_INV];
	end
	assign ipic_icsr[8] = ipic_ipr_ff[ipic_idxr_ff];
	assign ipic_icsr[7] = ipic_ier_ff[ipic_idxr_ff];
	assign ipic_icsr[6] = ipic_imr_ff[ipic_idxr_ff];
	assign ipic_icsr[5] = ipic_iinvr_ff[ipic_idxr_ff];
	assign ipic_icsr[4] = ipic_isvr_ff[ipic_idxr_ff];
	assign ipic_icsr[3-:SCR1_IRQ_LINES_WIDTH] = ipic_idxr_ff;
	assign irq_req_v = ipic_ipr_ff & ipic_ier_ff;
	assign irr_priority = scr1_search_one_16(irq_req_v);
	assign irq_req_vd = irr_priority[4];
	assign irq_req_idx = irr_priority[3-:SCR1_IRQ_IDX_WIDTH];
	assign isvr_priority_eoi = scr1_search_one_16(ipic_isvr_eoi);
	assign irq_eoi_req_vd = isvr_priority_eoi[4];
	assign irq_eoi_req_idx = isvr_priority_eoi[3-:SCR1_IRQ_IDX_WIDTH];
	assign irq_hi_prior_pnd = irq_req_idx < irq_serv_idx;
	assign ipic2csr_irq_m_req_o = irq_req_vd & (~irq_serv_vd | irq_hi_prior_pnd);
	assign irq_start_vd = ipic2csr_irq_m_req_o & ipic_soi_req;
	initial _sv2v_0 = 0;
endmodule
