/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_csr (
	rst_n,
	clk,
	soc2csr_irq_ext_i,
	soc2csr_irq_soft_i,
	soc2csr_irq_mtimer_i,
	soc2csr_mtimer_val_i,
	soc2csr_fuse_mhartid_i,
	exu2csr_r_req_i,
	exu2csr_rw_addr_i,
	csr2exu_r_data_o,
	exu2csr_w_req_i,
	exu2csr_w_cmd_i,
	exu2csr_w_data_i,
	csr2exu_rw_exc_o,
	exu2csr_take_irq_i,
	exu2csr_take_exc_i,
	exu2csr_mret_update_i,
	exu2csr_mret_instr_i,
	exu2csr_exc_code_i,
	exu2csr_trap_val_i,
	csr2exu_irq_o,
	csr2exu_ip_ie_o,
	csr2exu_mstatus_mie_up_o,
	csr2ipic_r_req_o,
	csr2ipic_w_req_o,
	csr2ipic_addr_o,
	csr2ipic_wdata_o,
	ipic2csr_rdata_i,
	csr2hdu_req_o,
	csr2hdu_cmd_o,
	csr2hdu_addr_o,
	csr2hdu_wdata_o,
	hdu2csr_rdata_i,
	hdu2csr_resp_i,
	hdu2csr_no_commit_i,
	csr2tdu_req_o,
	csr2tdu_cmd_o,
	csr2tdu_addr_o,
	csr2tdu_wdata_o,
	tdu2csr_rdata_i,
	tdu2csr_resp_i,
	exu2csr_instret_no_exc_i,
	exu2csr_pc_curr_i,
	exu2csr_pc_next_i,
	csr2exu_new_pc_o
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	input wire soc2csr_irq_ext_i;
	input wire soc2csr_irq_soft_i;
	input wire soc2csr_irq_mtimer_i;
	input wire [63:0] soc2csr_mtimer_val_i;
	input wire [31:0] soc2csr_fuse_mhartid_i;
	input wire exu2csr_r_req_i;
	localparam [31:0] SCR1_CSR_ADDR_WIDTH = 12;
	input wire [11:0] exu2csr_rw_addr_i;
	output wire [31:0] csr2exu_r_data_o;
	input wire exu2csr_w_req_i;
	localparam SCR1_CSR_CMD_ALL_NUM_E = 4;
	localparam SCR1_CSR_CMD_WIDTH_E = 2;
	input wire [1:0] exu2csr_w_cmd_i;
	input wire [31:0] exu2csr_w_data_i;
	output wire csr2exu_rw_exc_o;
	input wire exu2csr_take_irq_i;
	input wire exu2csr_take_exc_i;
	input wire exu2csr_mret_update_i;
	input wire exu2csr_mret_instr_i;
	localparam [31:0] SCR1_EXC_CODE_WIDTH_E = 4;
	input wire [3:0] exu2csr_exc_code_i;
	input wire [31:0] exu2csr_trap_val_i;
	output wire csr2exu_irq_o;
	output wire csr2exu_ip_ie_o;
	output wire csr2exu_mstatus_mie_up_o;
	output reg csr2ipic_r_req_o;
	output reg csr2ipic_w_req_o;
	output wire [2:0] csr2ipic_addr_o;
	output wire [31:0] csr2ipic_wdata_o;
	input wire [31:0] ipic2csr_rdata_i;
	output wire csr2hdu_req_o;
	output wire [1:0] csr2hdu_cmd_o;
	function automatic [11:0] sv2v_cast_C1AAB;
		input reg [11:0] inp;
		sv2v_cast_C1AAB = inp;
	endfunction
	localparam [11:0] SCR1_CSR_ADDR_HDU_MSPAN = sv2v_cast_C1AAB('h4);
	localparam [31:0] SCR1_HDU_DEBUGCSR_ADDR_SPAN = SCR1_CSR_ADDR_HDU_MSPAN;
	localparam [31:0] SCR1_HDU_DEBUGCSR_ADDR_WIDTH = $clog2(SCR1_HDU_DEBUGCSR_ADDR_SPAN);
	output wire [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] csr2hdu_addr_o;
	output wire [31:0] csr2hdu_wdata_o;
	input wire [31:0] hdu2csr_rdata_i;
	input wire hdu2csr_resp_i;
	input wire hdu2csr_no_commit_i;
	output wire csr2tdu_req_o;
	output wire [1:0] csr2tdu_cmd_o;
	localparam SCR1_CSR_ADDR_TDU_OFFS_W = 3;
	output wire [2:0] csr2tdu_addr_o;
	output wire [31:0] csr2tdu_wdata_o;
	input wire [31:0] tdu2csr_rdata_i;
	input wire tdu2csr_resp_i;
	input wire exu2csr_instret_no_exc_i;
	input wire [31:0] exu2csr_pc_curr_i;
	input wire [31:0] exu2csr_pc_next_i;
	output reg [31:0] csr2exu_new_pc_o;
	localparam PC_LSB = 1;
	reg csr_mstatus_upd;
	reg [31:0] csr_mstatus;
	reg csr_mstatus_mie_ff;
	reg csr_mstatus_mie_next;
	reg csr_mstatus_mpie_ff;
	reg csr_mstatus_mpie_next;
	reg csr_mie_upd;
	reg [31:0] csr_mie;
	reg csr_mie_mtie_ff;
	reg csr_mie_meie_ff;
	reg csr_mie_msie_ff;
	reg csr_mtvec_upd;
	localparam [31:0] SCR1_CSR_MTVEC_BASE_ZERO_BITS = 6;
	reg [31:SCR1_CSR_MTVEC_BASE_ZERO_BITS] csr_mtvec_base;
	wire csr_mtvec_mode;
	reg csr_mtvec_mode_ff;
	wire csr_mtvec_mode_vect;
	reg csr_mscratch_upd;
	reg [31:0] csr_mscratch_ff;
	reg csr_mepc_upd;
	reg [31:PC_LSB] csr_mepc_ff;
	reg [31:PC_LSB] csr_mepc_next;
	wire [31:0] csr_mepc;
	reg csr_mcause_upd;
	reg csr_mcause_i_ff;
	reg csr_mcause_i_next;
	reg [3:0] csr_mcause_ec_ff;
	reg [3:0] csr_mcause_ec_next;
	reg [3:0] csr_mcause_ec_new;
	reg csr_mtval_upd;
	reg [31:0] csr_mtval_ff;
	reg [31:0] csr_mtval_next;
	reg [31:0] csr_mip;
	wire csr_mip_mtip;
	wire csr_mip_meip;
	wire csr_mip_msip;
	reg [1:0] csr_minstret_upd;
	localparam [31:0] SCR1_CSR_COUNTERS_WIDTH = 64;
	wire [63:0] csr_minstret;
	wire csr_minstret_lo_inc;
	wire csr_minstret_lo_upd;
	reg [7:0] csr_minstret_lo_ff;
	wire [7:0] csr_minstret_lo_next;
	wire csr_minstret_hi_inc;
	wire csr_minstret_hi_upd;
	reg [63:8] csr_minstret_hi_ff;
	wire [63:8] csr_minstret_hi_next;
	wire [63:8] csr_minstret_hi_new;
	reg [1:0] csr_mcycle_upd;
	wire [63:0] csr_mcycle;
	wire csr_mcycle_lo_inc;
	wire csr_mcycle_lo_upd;
	reg [7:0] csr_mcycle_lo_ff;
	wire [7:0] csr_mcycle_lo_next;
	wire csr_mcycle_hi_inc;
	wire csr_mcycle_hi_upd;
	reg [63:8] csr_mcycle_hi_ff;
	wire [63:8] csr_mcycle_hi_next;
	wire [63:8] csr_mcycle_hi_new;
	reg csr_mcounten_upd;
	reg [31:0] csr_mcounten;
	reg csr_mcounten_cy_ff;
	reg csr_mcounten_ir_ff;
	reg [31:0] csr_r_data;
	reg [31:0] csr_w_data;
	wire e_exc;
	wire e_irq;
	wire e_mret;
	wire e_irq_nmret;
	wire csr_eirq_pnd_en;
	wire csr_sirq_pnd_en;
	wire csr_tirq_pnd_en;
	reg csr_w_exc;
	reg csr_r_exc;
	wire exu_req_no_exc;
	wire csr_ipic_req;
	reg csr_hdu_req;
	reg csr_brkm_req;
	assign e_exc = exu2csr_take_exc_i & ~hdu2csr_no_commit_i;
	assign e_irq = (exu2csr_take_irq_i & ~exu2csr_take_exc_i) & ~hdu2csr_no_commit_i;
	assign e_mret = exu2csr_mret_update_i & ~hdu2csr_no_commit_i;
	assign e_irq_nmret = e_irq & ~exu2csr_mret_instr_i;
	assign csr_eirq_pnd_en = csr_mip_meip & csr_mie_meie_ff;
	assign csr_sirq_pnd_en = csr_mip_msip & csr_mie_msie_ff;
	assign csr_tirq_pnd_en = csr_mip_mtip & csr_mie_mtie_ff;
	localparam [3:0] SCR1_EXC_CODE_IRQ_M_EXTERNAL = 4'd11;
	localparam [3:0] SCR1_EXC_CODE_IRQ_M_SOFTWARE = 4'd3;
	localparam [3:0] SCR1_EXC_CODE_IRQ_M_TIMER = 4'd7;
	function automatic [3:0] sv2v_cast_92043;
		input reg [3:0] inp;
		sv2v_cast_92043 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			csr_eirq_pnd_en: csr_mcause_ec_new = sv2v_cast_92043(SCR1_EXC_CODE_IRQ_M_EXTERNAL);
			csr_sirq_pnd_en: csr_mcause_ec_new = sv2v_cast_92043(SCR1_EXC_CODE_IRQ_M_SOFTWARE);
			csr_tirq_pnd_en: csr_mcause_ec_new = sv2v_cast_92043(SCR1_EXC_CODE_IRQ_M_TIMER);
			default: csr_mcause_ec_new = sv2v_cast_92043(SCR1_EXC_CODE_IRQ_M_EXTERNAL);
		endcase
	end
	assign exu_req_no_exc = (exu2csr_r_req_i & ~csr_r_exc) | (exu2csr_w_req_i & ~csr_w_exc);
	localparam [6:0] SCR1_CSR_ADDR_HPMCOUNTERH_MASK = 7'b1100100;
	localparam [6:0] SCR1_CSR_ADDR_HPMCOUNTER_MASK = 7'b1100000;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_BASE = sv2v_cast_C1AAB('hbf0);
	localparam [2:0] SCR1_IPIC_CICSR = 3'h1;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_CICSR = SCR1_CSR_ADDR_IPIC_BASE + SCR1_IPIC_CICSR;
	localparam [2:0] SCR1_IPIC_CISV = 3'h0;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_CISV = SCR1_CSR_ADDR_IPIC_BASE + SCR1_IPIC_CISV;
	localparam [2:0] SCR1_IPIC_EOI = 3'h4;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_EOI = SCR1_CSR_ADDR_IPIC_BASE + SCR1_IPIC_EOI;
	localparam [2:0] SCR1_IPIC_ICSR = 3'h7;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_ICSR = SCR1_CSR_ADDR_IPIC_BASE + SCR1_IPIC_ICSR;
	localparam [2:0] SCR1_IPIC_IDX = 3'h6;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_IDX = SCR1_CSR_ADDR_IPIC_BASE + SCR1_IPIC_IDX;
	localparam [2:0] SCR1_IPIC_IPR = 3'h2;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_IPR = SCR1_CSR_ADDR_IPIC_BASE + SCR1_IPIC_IPR;
	localparam [2:0] SCR1_IPIC_ISVR = 3'h3;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_ISVR = SCR1_CSR_ADDR_IPIC_BASE + SCR1_IPIC_ISVR;
	localparam [2:0] SCR1_IPIC_SOI = 3'h5;
	localparam [11:0] SCR1_CSR_ADDR_IPIC_SOI = SCR1_CSR_ADDR_IPIC_BASE + SCR1_IPIC_SOI;
	localparam [11:0] SCR1_CSR_ADDR_MARCHID = sv2v_cast_C1AAB('hf12);
	localparam [11:0] SCR1_CSR_ADDR_MCAUSE = sv2v_cast_C1AAB('h342);
	localparam [11:0] SCR1_CSR_ADDR_MCOUNTEN = sv2v_cast_C1AAB('h7e0);
	localparam [11:0] SCR1_CSR_ADDR_MEPC = sv2v_cast_C1AAB('h341);
	localparam [11:0] SCR1_CSR_ADDR_MHARTID = sv2v_cast_C1AAB('hf14);
	localparam [6:0] SCR1_CSR_ADDR_MHPMCOUNTERH_MASK = 7'b1011100;
	localparam [6:0] SCR1_CSR_ADDR_MHPMCOUNTER_MASK = 7'b1011000;
	localparam [6:0] SCR1_CSR_ADDR_MHPMEVENT_MASK = 7'b0011001;
	localparam [11:0] SCR1_CSR_ADDR_MIE = sv2v_cast_C1AAB('h304);
	localparam [11:0] SCR1_CSR_ADDR_MIMPID = sv2v_cast_C1AAB('hf13);
	localparam [11:0] SCR1_CSR_ADDR_MIP = sv2v_cast_C1AAB('h344);
	localparam [11:0] SCR1_CSR_ADDR_MISA = sv2v_cast_C1AAB('h301);
	localparam [11:0] SCR1_CSR_ADDR_MSCRATCH = sv2v_cast_C1AAB('h340);
	localparam [11:0] SCR1_CSR_ADDR_MSTATUS = sv2v_cast_C1AAB('h300);
	localparam [11:0] SCR1_CSR_ADDR_MTVAL = sv2v_cast_C1AAB('h343);
	localparam [11:0] SCR1_CSR_ADDR_MTVEC = sv2v_cast_C1AAB('h305);
	localparam [11:0] SCR1_CSR_ADDR_MVENDORID = sv2v_cast_C1AAB('hf11);
	localparam [11:0] SCR1_CSR_ADDR_TDU_MBASE = sv2v_cast_C1AAB('h7a0);
	localparam [2:0] SCR1_CSR_ADDR_TDU_OFFS_TDATA1 = 3'sd1;
	localparam [11:0] SCR1_CSR_ADDR_TDU_TDATA1 = SCR1_CSR_ADDR_TDU_MBASE + SCR1_CSR_ADDR_TDU_OFFS_TDATA1;
	localparam [2:0] SCR1_CSR_ADDR_TDU_OFFS_TDATA2 = 3'sd2;
	localparam [11:0] SCR1_CSR_ADDR_TDU_TDATA2 = SCR1_CSR_ADDR_TDU_MBASE + SCR1_CSR_ADDR_TDU_OFFS_TDATA2;
	localparam [2:0] SCR1_CSR_ADDR_TDU_OFFS_TINFO = 3'sd4;
	localparam [11:0] SCR1_CSR_ADDR_TDU_TINFO = SCR1_CSR_ADDR_TDU_MBASE + SCR1_CSR_ADDR_TDU_OFFS_TINFO;
	localparam [2:0] SCR1_CSR_ADDR_TDU_OFFS_TSELECT = 3'sd0;
	localparam [11:0] SCR1_CSR_ADDR_TDU_TSELECT = SCR1_CSR_ADDR_TDU_MBASE + SCR1_CSR_ADDR_TDU_OFFS_TSELECT;
	localparam [31:0] SCR1_CSR_MARCHID = 32'd8;
	localparam [31:0] SCR1_CSR_MIMPID = 32'h22011200;
	localparam [1:0] SCR1_MISA_MXL_32 = 2'd1;
	localparam [31:0] SCR1_CSR_MISA = (((SCR1_MISA_MXL_32 << 30) | 32'h00000100) | 32'h00000004) | 32'h00001000;
	localparam [31:0] SCR1_CSR_MVENDORID = 32'h00000000;
	localparam [11:0] SCR1_CSR_ADDR_HDU_MBASE = sv2v_cast_C1AAB('h7b0);
	function automatic [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] sv2v_cast_68C55;
		input reg [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] inp;
		sv2v_cast_68C55 = inp;
	endfunction
	localparam SCR1_HDU_DBGCSR_OFFS_DCSR = sv2v_cast_68C55('d0);
	localparam [11:0] SCR1_HDU_DBGCSR_ADDR_DCSR = SCR1_CSR_ADDR_HDU_MBASE + SCR1_HDU_DBGCSR_OFFS_DCSR;
	localparam SCR1_HDU_DBGCSR_OFFS_DPC = sv2v_cast_68C55('d1);
	localparam [11:0] SCR1_HDU_DBGCSR_ADDR_DPC = SCR1_CSR_ADDR_HDU_MBASE + SCR1_HDU_DBGCSR_OFFS_DPC;
	localparam SCR1_HDU_DBGCSR_OFFS_DSCRATCH0 = sv2v_cast_68C55('d2);
	localparam [11:0] SCR1_HDU_DBGCSR_ADDR_DSCRATCH0 = SCR1_CSR_ADDR_HDU_MBASE + SCR1_HDU_DBGCSR_OFFS_DSCRATCH0;
	localparam SCR1_HDU_DBGCSR_OFFS_DSCRATCH1 = sv2v_cast_68C55('d3);
	localparam [11:0] SCR1_HDU_DBGCSR_ADDR_DSCRATCH1 = SCR1_CSR_ADDR_HDU_MBASE + SCR1_HDU_DBGCSR_OFFS_DSCRATCH1;
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	function automatic [30:0] sv2v_cast_31;
		input reg [30:0] inp;
		sv2v_cast_31 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		csr_r_data = 1'sb0;
		csr_r_exc = 1'b0;
		csr_hdu_req = 1'b0;
		csr_brkm_req = 1'b0;
		csr2ipic_r_req_o = 1'b0;
		casez (exu2csr_rw_addr_i)
			SCR1_CSR_ADDR_MVENDORID: csr_r_data = SCR1_CSR_MVENDORID;
			SCR1_CSR_ADDR_MARCHID: csr_r_data = SCR1_CSR_MARCHID;
			SCR1_CSR_ADDR_MIMPID: csr_r_data = SCR1_CSR_MIMPID;
			SCR1_CSR_ADDR_MHARTID: csr_r_data = soc2csr_fuse_mhartid_i;
			SCR1_CSR_ADDR_MSTATUS: csr_r_data = csr_mstatus;
			SCR1_CSR_ADDR_MISA: csr_r_data = SCR1_CSR_MISA;
			SCR1_CSR_ADDR_MIE: csr_r_data = csr_mie;
			SCR1_CSR_ADDR_MTVEC: csr_r_data = {csr_mtvec_base, 4'd0, sv2v_cast_2(csr_mtvec_mode)};
			SCR1_CSR_ADDR_MSCRATCH: csr_r_data = csr_mscratch_ff;
			SCR1_CSR_ADDR_MEPC: csr_r_data = csr_mepc;
			SCR1_CSR_ADDR_MCAUSE: csr_r_data = {csr_mcause_i_ff, sv2v_cast_31(csr_mcause_ec_ff)};
			SCR1_CSR_ADDR_MTVAL: csr_r_data = csr_mtval_ff;
			SCR1_CSR_ADDR_MIP: csr_r_data = csr_mip;
			{SCR1_CSR_ADDR_HPMCOUNTER_MASK, 5'bzzzzz}:
				case (exu2csr_rw_addr_i[4:0])
					5'd1: csr_r_data = soc2csr_mtimer_val_i[31:0];
					5'd0: csr_r_data = csr_mcycle[31:0];
					5'd2: csr_r_data = csr_minstret[31:0];
					default:
						;
				endcase
			{SCR1_CSR_ADDR_HPMCOUNTERH_MASK, 5'bzzzzz}:
				case (exu2csr_rw_addr_i[4:0])
					5'd1: csr_r_data = soc2csr_mtimer_val_i[63:32];
					5'd0: csr_r_data = csr_mcycle[63:32];
					5'd2: csr_r_data = csr_minstret[63:32];
					default:
						;
				endcase
			{SCR1_CSR_ADDR_MHPMCOUNTER_MASK, 5'bzzzzz}:
				case (exu2csr_rw_addr_i[4:0])
					5'd1: csr_r_exc = exu2csr_r_req_i;
					5'd0: csr_r_data = csr_mcycle[31:0];
					5'd2: csr_r_data = csr_minstret[31:0];
					default:
						;
				endcase
			{SCR1_CSR_ADDR_MHPMCOUNTERH_MASK, 5'bzzzzz}:
				case (exu2csr_rw_addr_i[4:0])
					5'd1: csr_r_exc = exu2csr_r_req_i;
					5'd0: csr_r_data = csr_mcycle[63:32];
					5'd2: csr_r_data = csr_minstret[63:32];
					default:
						;
				endcase
			{SCR1_CSR_ADDR_MHPMEVENT_MASK, 5'bzzzzz}:
				case (exu2csr_rw_addr_i[4:0])
					5'd0, 5'd1, 5'd2: csr_r_exc = exu2csr_r_req_i;
					default:
						;
				endcase
			SCR1_CSR_ADDR_MCOUNTEN: csr_r_data = csr_mcounten;
			SCR1_CSR_ADDR_IPIC_CISV, SCR1_CSR_ADDR_IPIC_CICSR, SCR1_CSR_ADDR_IPIC_IPR, SCR1_CSR_ADDR_IPIC_ISVR, SCR1_CSR_ADDR_IPIC_EOI, SCR1_CSR_ADDR_IPIC_SOI, SCR1_CSR_ADDR_IPIC_IDX, SCR1_CSR_ADDR_IPIC_ICSR: begin
				csr_r_data = ipic2csr_rdata_i;
				csr2ipic_r_req_o = exu2csr_r_req_i;
			end
			SCR1_HDU_DBGCSR_ADDR_DCSR, SCR1_HDU_DBGCSR_ADDR_DPC, SCR1_HDU_DBGCSR_ADDR_DSCRATCH0, SCR1_HDU_DBGCSR_ADDR_DSCRATCH1: begin
				csr_hdu_req = 1'b1;
				csr_r_data = hdu2csr_rdata_i;
			end
			SCR1_CSR_ADDR_TDU_TSELECT, SCR1_CSR_ADDR_TDU_TDATA1, SCR1_CSR_ADDR_TDU_TDATA2, SCR1_CSR_ADDR_TDU_TINFO: begin
				csr_brkm_req = 1'b1;
				csr_r_data = tdu2csr_rdata_i;
			end
			default: csr_r_exc = exu2csr_r_req_i;
		endcase
	end
	assign csr2exu_r_data_o = csr_r_data;
	function automatic [1:0] sv2v_cast_999B9;
		input reg [1:0] inp;
		sv2v_cast_999B9 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		case (exu2csr_w_cmd_i)
			sv2v_cast_999B9({32 {1'sb0}} + 1): csr_w_data = exu2csr_w_data_i;
			sv2v_cast_999B9({32 {1'sb0}} + 2): csr_w_data = exu2csr_w_data_i | csr_r_data;
			sv2v_cast_999B9({32 {1'sb0}} + 3): csr_w_data = ~exu2csr_w_data_i & csr_r_data;
			default: csr_w_data = 1'sb0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		csr_mstatus_upd = 1'b0;
		csr_mie_upd = 1'b0;
		csr_mscratch_upd = 1'b0;
		csr_mepc_upd = 1'b0;
		csr_mcause_upd = 1'b0;
		csr_mtval_upd = 1'b0;
		csr_mtvec_upd = 1'b0;
		csr_mcycle_upd = 2'b00;
		csr_minstret_upd = 2'b00;
		csr_mcounten_upd = 1'b0;
		csr_w_exc = 1'b0;
		csr2ipic_w_req_o = 1'b0;
		if (exu2csr_w_req_i)
			casez (exu2csr_rw_addr_i)
				SCR1_CSR_ADDR_MSTATUS: csr_mstatus_upd = 1'b1;
				SCR1_CSR_ADDR_MISA:
					;
				SCR1_CSR_ADDR_MIE: csr_mie_upd = 1'b1;
				SCR1_CSR_ADDR_MTVEC: csr_mtvec_upd = 1'b1;
				SCR1_CSR_ADDR_MSCRATCH: csr_mscratch_upd = 1'b1;
				SCR1_CSR_ADDR_MEPC: csr_mepc_upd = 1'b1;
				SCR1_CSR_ADDR_MCAUSE: csr_mcause_upd = 1'b1;
				SCR1_CSR_ADDR_MTVAL: csr_mtval_upd = 1'b1;
				SCR1_CSR_ADDR_MIP:
					;
				{SCR1_CSR_ADDR_MHPMCOUNTER_MASK, 5'bzzzzz}:
					case (exu2csr_rw_addr_i[4:0])
						5'd1: csr_w_exc = 1'b1;
						5'd0: csr_mcycle_upd[0] = 1'b1;
						5'd2: csr_minstret_upd[0] = 1'b1;
						default:
							;
					endcase
				{SCR1_CSR_ADDR_MHPMCOUNTERH_MASK, 5'bzzzzz}:
					case (exu2csr_rw_addr_i[4:0])
						5'd1: csr_w_exc = 1'b1;
						5'd0: csr_mcycle_upd[1] = 1'b1;
						5'd2: csr_minstret_upd[1] = 1'b1;
						default:
							;
					endcase
				{SCR1_CSR_ADDR_MHPMEVENT_MASK, 5'bzzzzz}:
					case (exu2csr_rw_addr_i[4:0])
						5'd0, 5'd1, 5'd2: csr_w_exc = 1'b1;
						default:
							;
					endcase
				SCR1_CSR_ADDR_MCOUNTEN: csr_mcounten_upd = 1'b1;
				SCR1_CSR_ADDR_IPIC_CICSR, SCR1_CSR_ADDR_IPIC_IPR, SCR1_CSR_ADDR_IPIC_EOI, SCR1_CSR_ADDR_IPIC_SOI, SCR1_CSR_ADDR_IPIC_IDX, SCR1_CSR_ADDR_IPIC_ICSR: csr2ipic_w_req_o = 1'b1;
				SCR1_CSR_ADDR_IPIC_CISV, SCR1_CSR_ADDR_IPIC_ISVR:
					;
				SCR1_HDU_DBGCSR_ADDR_DCSR, SCR1_HDU_DBGCSR_ADDR_DPC, SCR1_HDU_DBGCSR_ADDR_DSCRATCH0, SCR1_HDU_DBGCSR_ADDR_DSCRATCH1:
					;
				SCR1_CSR_ADDR_TDU_TSELECT, SCR1_CSR_ADDR_TDU_TDATA1, SCR1_CSR_ADDR_TDU_TDATA2, SCR1_CSR_ADDR_TDU_TINFO:
					;
				default: csr_w_exc = 1'b1;
			endcase
	end
	localparam [0:0] SCR1_CSR_MSTATUS_MIE_RST_VAL = 1'b0;
	localparam [0:0] SCR1_CSR_MSTATUS_MPIE_RST_VAL = 1'b1;
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			csr_mstatus_mie_ff <= SCR1_CSR_MSTATUS_MIE_RST_VAL;
			csr_mstatus_mpie_ff <= SCR1_CSR_MSTATUS_MPIE_RST_VAL;
		end
		else begin
			csr_mstatus_mie_ff <= csr_mstatus_mie_next;
			csr_mstatus_mpie_ff <= csr_mstatus_mpie_next;
		end
	localparam [31:0] SCR1_CSR_MSTATUS_MIE_OFFSET = 3;
	localparam [31:0] SCR1_CSR_MSTATUS_MPIE_OFFSET = 7;
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			e_exc, e_irq: begin
				csr_mstatus_mie_next = 1'b0;
				csr_mstatus_mpie_next = csr_mstatus_mie_ff;
			end
			e_mret: begin
				csr_mstatus_mie_next = csr_mstatus_mpie_ff;
				csr_mstatus_mpie_next = 1'b1;
			end
			csr_mstatus_upd: begin
				csr_mstatus_mie_next = csr_w_data[SCR1_CSR_MSTATUS_MIE_OFFSET];
				csr_mstatus_mpie_next = csr_w_data[SCR1_CSR_MSTATUS_MPIE_OFFSET];
			end
			default: begin
				csr_mstatus_mie_next = csr_mstatus_mie_ff;
				csr_mstatus_mpie_next = csr_mstatus_mpie_ff;
			end
		endcase
	end
	localparam [1:0] SCR1_CSR_MSTATUS_MPP = 2'b11;
	localparam [31:0] SCR1_CSR_MSTATUS_MPP_OFFSET = 11;
	always @(*) begin
		if (_sv2v_0)
			;
		csr_mstatus = 1'sb0;
		csr_mstatus[SCR1_CSR_MSTATUS_MIE_OFFSET] = csr_mstatus_mie_ff;
		csr_mstatus[SCR1_CSR_MSTATUS_MPIE_OFFSET] = csr_mstatus_mpie_ff;
		csr_mstatus[12:SCR1_CSR_MSTATUS_MPP_OFFSET] = SCR1_CSR_MSTATUS_MPP;
	end
	localparam [31:0] SCR1_CSR_MIE_MEIE_OFFSET = 11;
	localparam [0:0] SCR1_CSR_MIE_MEIE_RST_VAL = 1'b0;
	localparam [31:0] SCR1_CSR_MIE_MSIE_OFFSET = 3;
	localparam [0:0] SCR1_CSR_MIE_MSIE_RST_VAL = 1'b0;
	localparam [31:0] SCR1_CSR_MIE_MTIE_OFFSET = 7;
	localparam [0:0] SCR1_CSR_MIE_MTIE_RST_VAL = 1'b0;
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			csr_mie_mtie_ff <= SCR1_CSR_MIE_MTIE_RST_VAL;
			csr_mie_meie_ff <= SCR1_CSR_MIE_MEIE_RST_VAL;
			csr_mie_msie_ff <= SCR1_CSR_MIE_MSIE_RST_VAL;
		end
		else if (csr_mie_upd) begin
			csr_mie_mtie_ff <= csr_w_data[SCR1_CSR_MIE_MTIE_OFFSET];
			csr_mie_meie_ff <= csr_w_data[SCR1_CSR_MIE_MEIE_OFFSET];
			csr_mie_msie_ff <= csr_w_data[SCR1_CSR_MIE_MSIE_OFFSET];
		end
	always @(*) begin
		if (_sv2v_0)
			;
		csr_mie = 1'sb0;
		csr_mie[SCR1_CSR_MIE_MSIE_OFFSET] = csr_mie_msie_ff;
		csr_mie[SCR1_CSR_MIE_MTIE_OFFSET] = csr_mie_mtie_ff;
		csr_mie[SCR1_CSR_MIE_MEIE_OFFSET] = csr_mie_meie_ff;
	end
	localparam [31:0] SCR1_MTVEC_BASE_WR_BITS = 26;
	localparam [31:0] SCR1_CSR_MTVEC_BASE_RO_BITS = 32 - (SCR1_CSR_MTVEC_BASE_ZERO_BITS + SCR1_MTVEC_BASE_WR_BITS);
	localparam [31:0] SCR1_ARCH_MTVEC_BASE = 'hfffc0080;
	localparam [31:0] SCR1_CSR_MTVEC_BASE_VAL_BITS = 26;
	function automatic [25:0] sv2v_cast_961FC;
		input reg [25:0] inp;
		sv2v_cast_961FC = inp;
	endfunction
	localparam [31:SCR1_CSR_MTVEC_BASE_ZERO_BITS] SCR1_CSR_MTVEC_BASE_WR_RST_VAL = sv2v_cast_961FC(SCR1_ARCH_MTVEC_BASE >> SCR1_CSR_MTVEC_BASE_ZERO_BITS);
	localparam [31:SCR1_CSR_MTVEC_BASE_ZERO_BITS] SCR1_CSR_MTVEC_BASE_RST_VAL = SCR1_CSR_MTVEC_BASE_WR_RST_VAL;
	generate
		if (1) begin : mtvec_base_rw
			always @(negedge rst_n or posedge clk)
				if (~rst_n)
					csr_mtvec_base <= SCR1_CSR_MTVEC_BASE_RST_VAL;
				else if (csr_mtvec_upd)
					csr_mtvec_base <= csr_w_data[31:SCR1_CSR_MTVEC_BASE_ZERO_BITS];
		end
	endgenerate
	localparam [0:0] SCR1_CSR_MTVEC_MODE_DIRECT = 1'b0;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			csr_mtvec_mode_ff <= SCR1_CSR_MTVEC_MODE_DIRECT;
		else if (csr_mtvec_upd)
			csr_mtvec_mode_ff <= csr_w_data[0];
	assign csr_mtvec_mode = csr_mtvec_mode_ff;
	localparam [0:0] SCR1_CSR_MTVEC_MODE_VECTORED = 1'b1;
	assign csr_mtvec_mode_vect = csr_mtvec_mode_ff == SCR1_CSR_MTVEC_MODE_VECTORED;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			csr_mscratch_ff <= 1'sb0;
		else if (csr_mscratch_upd)
			csr_mscratch_ff <= csr_w_data;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			csr_mepc_ff <= 1'sb0;
		else
			csr_mepc_ff <= csr_mepc_next;
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			e_exc: csr_mepc_next = exu2csr_pc_curr_i[31:PC_LSB];
			e_irq_nmret: csr_mepc_next = exu2csr_pc_next_i[31:PC_LSB];
			csr_mepc_upd: csr_mepc_next = csr_w_data[31:PC_LSB];
			default: csr_mepc_next = csr_mepc_ff;
		endcase
	end
	assign csr_mepc = {csr_mepc_ff, 1'b0};
	localparam [3:0] SCR1_EXC_CODE_RESET = 4'd0;
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			csr_mcause_i_ff <= 1'b0;
			csr_mcause_ec_ff <= sv2v_cast_92043(SCR1_EXC_CODE_RESET);
		end
		else begin
			csr_mcause_i_ff <= csr_mcause_i_next;
			csr_mcause_ec_ff <= csr_mcause_ec_next;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			e_exc: begin
				csr_mcause_i_next = 1'b0;
				csr_mcause_ec_next = exu2csr_exc_code_i;
			end
			e_irq: begin
				csr_mcause_i_next = 1'b1;
				csr_mcause_ec_next = csr_mcause_ec_new;
			end
			csr_mcause_upd: begin
				csr_mcause_i_next = csr_w_data[31];
				csr_mcause_ec_next = csr_w_data[3:0];
			end
			default: begin
				csr_mcause_i_next = csr_mcause_i_ff;
				csr_mcause_ec_next = csr_mcause_ec_ff;
			end
		endcase
	end
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			csr_mtval_ff <= 1'sb0;
		else
			csr_mtval_ff <= csr_mtval_next;
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			e_exc: csr_mtval_next = exu2csr_trap_val_i;
			e_irq: csr_mtval_next = 1'sb0;
			csr_mtval_upd: csr_mtval_next = csr_w_data;
			default: csr_mtval_next = csr_mtval_ff;
		endcase
	end
	assign csr_mip_mtip = soc2csr_irq_mtimer_i;
	assign csr_mip_meip = soc2csr_irq_ext_i;
	assign csr_mip_msip = soc2csr_irq_soft_i;
	always @(*) begin
		if (_sv2v_0)
			;
		csr_mip = 1'sb0;
		csr_mip[SCR1_CSR_MIE_MSIE_OFFSET] = csr_mip_msip;
		csr_mip[SCR1_CSR_MIE_MTIE_OFFSET] = csr_mip_mtip;
		csr_mip[SCR1_CSR_MIE_MEIE_OFFSET] = csr_mip_meip;
	end
	assign csr_mcycle_lo_inc = 1'b1 & csr_mcounten_cy_ff;
	assign csr_mcycle_hi_inc = csr_mcycle_lo_inc & (&csr_mcycle_lo_ff);
	assign csr_mcycle_lo_upd = csr_mcycle_lo_inc | csr_mcycle_upd[0];
	assign csr_mcycle_hi_upd = csr_mcycle_hi_inc | (|csr_mcycle_upd);
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			csr_mcycle_lo_ff <= 1'sb0;
			csr_mcycle_hi_ff <= 1'sb0;
		end
		else begin
			if (csr_mcycle_lo_upd)
				csr_mcycle_lo_ff <= csr_mcycle_lo_next;
			if (csr_mcycle_hi_upd)
				csr_mcycle_hi_ff <= csr_mcycle_hi_next;
		end
	assign csr_mcycle_hi_new = csr_mcycle_hi_ff + 1'b1;
	assign csr_mcycle_lo_next = (csr_mcycle_upd[0] ? csr_w_data[7:0] : (csr_mcycle_lo_inc ? csr_mcycle_lo_ff + 1'b1 : csr_mcycle_lo_ff));
	assign csr_mcycle_hi_next = (csr_mcycle_upd[0] ? {csr_mcycle_hi_new[63:32], csr_w_data[31:8]} : (csr_mcycle_upd[1] ? {csr_w_data, csr_mcycle_hi_new[31:8]} : (csr_mcycle_hi_inc ? csr_mcycle_hi_new : csr_mcycle_hi_ff)));
	assign csr_mcycle = {csr_mcycle_hi_ff, csr_mcycle_lo_ff};
	assign csr_minstret_lo_inc = exu2csr_instret_no_exc_i & csr_mcounten_ir_ff;
	assign csr_minstret_hi_inc = csr_minstret_lo_inc & (&csr_minstret_lo_ff);
	assign csr_minstret_lo_upd = csr_minstret_lo_inc | csr_minstret_upd[0];
	assign csr_minstret_hi_upd = csr_minstret_hi_inc | (|csr_minstret_upd);
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			csr_minstret_lo_ff <= 1'sb0;
			csr_minstret_hi_ff <= 1'sb0;
		end
		else begin
			if (csr_minstret_lo_upd)
				csr_minstret_lo_ff <= csr_minstret_lo_next;
			if (csr_minstret_hi_upd)
				csr_minstret_hi_ff <= csr_minstret_hi_next;
		end
	assign csr_minstret_hi_new = csr_minstret_hi_ff + 1'b1;
	assign csr_minstret_lo_next = (csr_minstret_upd[0] ? csr_w_data[7:0] : (csr_minstret_lo_inc ? csr_minstret_lo_ff + 1'b1 : csr_minstret_lo_ff));
	assign csr_minstret_hi_next = (csr_minstret_upd[0] ? {csr_minstret_hi_new[63:32], csr_w_data[31:8]} : (csr_minstret_upd[1] ? {csr_w_data, csr_minstret_hi_new[31:8]} : (csr_minstret_hi_inc ? csr_minstret_hi_new : csr_minstret_hi_ff)));
	assign csr_minstret = {csr_minstret_hi_ff, csr_minstret_lo_ff};
	localparam [31:0] SCR1_CSR_MCOUNTEN_CY_OFFSET = 0;
	localparam [31:0] SCR1_CSR_MCOUNTEN_IR_OFFSET = 2;
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			csr_mcounten_cy_ff <= 1'b1;
			csr_mcounten_ir_ff <= 1'b1;
		end
		else if (csr_mcounten_upd) begin
			csr_mcounten_cy_ff <= csr_w_data[SCR1_CSR_MCOUNTEN_CY_OFFSET];
			csr_mcounten_ir_ff <= csr_w_data[SCR1_CSR_MCOUNTEN_IR_OFFSET];
		end
	always @(*) begin
		if (_sv2v_0)
			;
		csr_mcounten = 1'sb0;
		csr_mcounten[SCR1_CSR_MCOUNTEN_CY_OFFSET] = csr_mcounten_cy_ff;
		csr_mcounten[SCR1_CSR_MCOUNTEN_IR_OFFSET] = csr_mcounten_ir_ff;
	end
	assign csr2exu_rw_exc_o = ((csr_r_exc | csr_w_exc) | (csr2hdu_req_o & (hdu2csr_resp_i != 1'd0))) | (csr2tdu_req_o & (tdu2csr_resp_i != 1'd0));
	assign csr2exu_ip_ie_o = (csr_eirq_pnd_en | csr_sirq_pnd_en) | csr_tirq_pnd_en;
	assign csr2exu_irq_o = csr2exu_ip_ie_o & csr_mstatus_mie_ff;
	assign csr2exu_mstatus_mie_up_o = (csr_mstatus_upd | csr_mie_upd) | e_mret;
	function automatic signed [5:0] sv2v_cast_13C0F_signed;
		input reg signed [5:0] inp;
		sv2v_cast_13C0F_signed = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		if (exu2csr_mret_instr_i & ~exu2csr_take_irq_i)
			csr2exu_new_pc_o = csr_mepc;
		else if (csr_mtvec_mode_vect)
			case (1'b1)
				exu2csr_take_exc_i: csr2exu_new_pc_o = {csr_mtvec_base, sv2v_cast_13C0F_signed(0)};
				csr_eirq_pnd_en: csr2exu_new_pc_o = {csr_mtvec_base, SCR1_EXC_CODE_IRQ_M_EXTERNAL, 2'd0};
				csr_sirq_pnd_en: csr2exu_new_pc_o = {csr_mtvec_base, SCR1_EXC_CODE_IRQ_M_SOFTWARE, 2'd0};
				csr_tirq_pnd_en: csr2exu_new_pc_o = {csr_mtvec_base, SCR1_EXC_CODE_IRQ_M_TIMER, 2'd0};
				default: csr2exu_new_pc_o = {csr_mtvec_base, sv2v_cast_13C0F_signed(0)};
			endcase
		else
			csr2exu_new_pc_o = {csr_mtvec_base, sv2v_cast_13C0F_signed(0)};
	end
	assign csr_ipic_req = csr2ipic_r_req_o | csr2ipic_w_req_o;
	assign csr2ipic_addr_o = (csr_ipic_req ? exu2csr_rw_addr_i[2:0] : {3 {1'sb0}});
	assign csr2ipic_wdata_o = (csr2ipic_w_req_o ? exu2csr_w_data_i : {32 {1'sb0}});
	assign csr2hdu_req_o = csr_hdu_req & exu_req_no_exc;
	assign csr2hdu_cmd_o = exu2csr_w_cmd_i;
	assign csr2hdu_addr_o = exu2csr_rw_addr_i[SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0];
	assign csr2hdu_wdata_o = exu2csr_w_data_i;
	assign csr2tdu_req_o = csr_brkm_req & exu_req_no_exc;
	assign csr2tdu_cmd_o = exu2csr_w_cmd_i;
	assign csr2tdu_addr_o = exu2csr_rw_addr_i[2:0];
	assign csr2tdu_wdata_o = exu2csr_w_data_i;
	initial _sv2v_0 = 0;
endmodule
