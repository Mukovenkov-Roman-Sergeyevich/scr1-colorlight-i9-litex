/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_tapc (
	tapc_trst_n,
	tapc_tck,
	tapc_tms,
	tapc_tdi,
	tapc_tdo,
	tapc_tdo_en,
	soc2tapc_fuse_idcode_i,
	tapc2tapcsync_scu_ch_sel_o,
	tapc2tapcsync_dmi_ch_sel_o,
	tapc2tapcsync_ch_id_o,
	tapc2tapcsync_ch_capture_o,
	tapc2tapcsync_ch_shift_o,
	tapc2tapcsync_ch_update_o,
	tapc2tapcsync_ch_tdi_o,
	tapcsync2tapc_ch_tdo_i
);
	reg _sv2v_0;
	input wire tapc_trst_n;
	input wire tapc_tck;
	input wire tapc_tms;
	input wire tapc_tdi;
	output wire tapc_tdo;
	output wire tapc_tdo_en;
	input wire [31:0] soc2tapc_fuse_idcode_i;
	output reg tapc2tapcsync_scu_ch_sel_o;
	output reg tapc2tapcsync_dmi_ch_sel_o;
	localparam SCR1_DBG_DMI_CH_ID_WIDTH = 2'd2;
	output reg [SCR1_DBG_DMI_CH_ID_WIDTH - 1:0] tapc2tapcsync_ch_id_o;
	output wire tapc2tapcsync_ch_capture_o;
	output wire tapc2tapcsync_ch_shift_o;
	output wire tapc2tapcsync_ch_update_o;
	output wire tapc2tapcsync_ch_tdi_o;
	input wire tapcsync2tapc_ch_tdo_i;
	reg trst_n_int;
	localparam [31:0] SCR1_TAP_STATE_WIDTH = 4;
	reg [3:0] tap_fsm_ff;
	reg [3:0] tap_fsm_next;
	wire tap_fsm_reset;
	wire tap_fsm_ir_upd;
	wire tap_fsm_ir_cap;
	wire tap_fsm_ir_shft;
	reg tap_fsm_ir_shift_ff;
	wire tap_fsm_ir_shift_next;
	reg tap_fsm_dr_capture_ff;
	wire tap_fsm_dr_capture_next;
	reg tap_fsm_dr_shift_ff;
	wire tap_fsm_dr_shift_next;
	reg tap_fsm_dr_update_ff;
	wire tap_fsm_dr_update_next;
	localparam [31:0] SCR1_TAP_INSTRUCTION_WIDTH = 5;
	reg [4:0] tap_ir_shift_ff;
	wire [4:0] tap_ir_shift_next;
	reg [4:0] tap_ir_ff;
	wire [4:0] tap_ir_next;
	reg dr_bypass_sel;
	wire dr_bypass_tdo;
	reg dr_idcode_sel;
	wire dr_idcode_tdo;
	reg dr_bld_id_sel;
	wire dr_bld_id_tdo;
	reg dr_out;
	reg tdo_en_ff;
	wire tdo_en_next;
	reg tdo_out_ff;
	wire tdo_out_next;
	always @(negedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			trst_n_int <= 1'b0;
		else
			trst_n_int <= ~tap_fsm_reset;
	function automatic [3:0] sv2v_cast_67B99;
		input reg [3:0] inp;
		sv2v_cast_67B99 = inp;
	endfunction
	always @(posedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tap_fsm_ff <= sv2v_cast_67B99(0);
		else
			tap_fsm_ff <= tap_fsm_next;
	always @(*) begin
		if (_sv2v_0)
			;
		case (tap_fsm_ff)
			sv2v_cast_67B99(0): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(0) : sv2v_cast_67B99(1));
			sv2v_cast_67B99(1): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(2) : sv2v_cast_67B99(1));
			sv2v_cast_67B99(2): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(9) : sv2v_cast_67B99(3));
			sv2v_cast_67B99(3): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(5) : sv2v_cast_67B99(4));
			sv2v_cast_67B99(4): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(5) : sv2v_cast_67B99(4));
			sv2v_cast_67B99(5): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(8) : sv2v_cast_67B99(6));
			sv2v_cast_67B99(6): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(7) : sv2v_cast_67B99(6));
			sv2v_cast_67B99(7): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(8) : sv2v_cast_67B99(4));
			sv2v_cast_67B99(8): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(2) : sv2v_cast_67B99(1));
			sv2v_cast_67B99(9): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(0) : sv2v_cast_67B99(10));
			sv2v_cast_67B99(10): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(12) : sv2v_cast_67B99(11));
			sv2v_cast_67B99(11): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(12) : sv2v_cast_67B99(11));
			sv2v_cast_67B99(12): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(15) : sv2v_cast_67B99(13));
			sv2v_cast_67B99(13): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(14) : sv2v_cast_67B99(13));
			sv2v_cast_67B99(14): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(15) : sv2v_cast_67B99(11));
			sv2v_cast_67B99(15): tap_fsm_next = (tapc_tms ? sv2v_cast_67B99(2) : sv2v_cast_67B99(1));
			default: tap_fsm_next = tap_fsm_ff;
		endcase
	end
	assign tap_fsm_reset = tap_fsm_ff == sv2v_cast_67B99(0);
	assign tap_fsm_ir_upd = tap_fsm_ff == sv2v_cast_67B99(15);
	assign tap_fsm_ir_cap = tap_fsm_ff == sv2v_cast_67B99(10);
	assign tap_fsm_ir_shft = tap_fsm_ff == sv2v_cast_67B99(11);
	always @(posedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tap_ir_shift_ff <= 1'sb0;
		else if (~trst_n_int)
			tap_ir_shift_ff <= 1'sb0;
		else
			tap_ir_shift_ff <= tap_ir_shift_next;
	assign tap_ir_shift_next = (tap_fsm_ir_cap ? {{4 {1'b0}}, 1'b1} : (tap_fsm_ir_shft ? {tapc_tdi, tap_ir_shift_ff[4:1]} : tap_ir_shift_ff));
	function automatic [4:0] sv2v_cast_E1108;
		input reg [4:0] inp;
		sv2v_cast_E1108 = inp;
	endfunction
	always @(negedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tap_ir_ff <= sv2v_cast_E1108(5'h01);
		else if (~trst_n_int)
			tap_ir_ff <= sv2v_cast_E1108(5'h01);
		else
			tap_ir_ff <= tap_ir_next;
	assign tap_ir_next = (tap_fsm_ir_upd ? tap_ir_shift_ff : tap_ir_ff);
	always @(posedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tap_fsm_ir_shift_ff <= 1'b0;
		else if (~trst_n_int)
			tap_fsm_ir_shift_ff <= 1'b0;
		else
			tap_fsm_ir_shift_ff <= tap_fsm_ir_shift_next;
	assign tap_fsm_ir_shift_next = tap_fsm_next == sv2v_cast_67B99(11);
	always @(posedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tap_fsm_dr_capture_ff <= 1'b0;
		else if (~trst_n_int)
			tap_fsm_dr_capture_ff <= 1'b0;
		else
			tap_fsm_dr_capture_ff <= tap_fsm_dr_capture_next;
	assign tap_fsm_dr_capture_next = tap_fsm_next == sv2v_cast_67B99(3);
	always @(posedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tap_fsm_dr_shift_ff <= 1'b0;
		else if (~trst_n_int)
			tap_fsm_dr_shift_ff <= 1'b0;
		else
			tap_fsm_dr_shift_ff <= tap_fsm_dr_shift_next;
	assign tap_fsm_dr_shift_next = tap_fsm_next == sv2v_cast_67B99(4);
	always @(posedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tap_fsm_dr_update_ff <= 1'b0;
		else if (~trst_n_int)
			tap_fsm_dr_update_ff <= 1'b0;
		else
			tap_fsm_dr_update_ff <= tap_fsm_dr_update_next;
	assign tap_fsm_dr_update_next = tap_fsm_next == sv2v_cast_67B99(8);
	always @(*) begin
		if (_sv2v_0)
			;
		dr_bypass_sel = 1'b0;
		dr_idcode_sel = 1'b0;
		dr_bld_id_sel = 1'b0;
		tapc2tapcsync_scu_ch_sel_o = 1'b0;
		tapc2tapcsync_dmi_ch_sel_o = 1'b0;
		case (tap_ir_ff)
			sv2v_cast_E1108(5'h10): tapc2tapcsync_dmi_ch_sel_o = 1'b1;
			sv2v_cast_E1108(5'h11): tapc2tapcsync_dmi_ch_sel_o = 1'b1;
			sv2v_cast_E1108(5'h01): dr_idcode_sel = 1'b1;
			sv2v_cast_E1108(5'h1f): dr_bypass_sel = 1'b1;
			sv2v_cast_E1108(5'h04): dr_bld_id_sel = 1'b1;
			sv2v_cast_E1108(5'h09): tapc2tapcsync_scu_ch_sel_o = 1'b1;
			default: dr_bypass_sel = 1'b1;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		tapc2tapcsync_ch_id_o = 1'sb0;
		case (tap_ir_ff)
			sv2v_cast_E1108(5'h10): tapc2tapcsync_ch_id_o = 'd1;
			sv2v_cast_E1108(5'h11): tapc2tapcsync_ch_id_o = 'd2;
			default: tapc2tapcsync_ch_id_o = 1'sb0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		dr_out = 1'b0;
		case (tap_ir_ff)
			sv2v_cast_E1108(5'h10): dr_out = tapcsync2tapc_ch_tdo_i;
			sv2v_cast_E1108(5'h11): dr_out = tapcsync2tapc_ch_tdo_i;
			sv2v_cast_E1108(5'h01): dr_out = dr_idcode_tdo;
			sv2v_cast_E1108(5'h1f): dr_out = dr_bypass_tdo;
			sv2v_cast_E1108(5'h04): dr_out = dr_bld_id_tdo;
			sv2v_cast_E1108(5'h09): dr_out = tapcsync2tapc_ch_tdo_i;
			default: dr_out = dr_bypass_tdo;
		endcase
	end
	always @(negedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tdo_en_ff <= 1'b0;
		else if (~trst_n_int)
			tdo_en_ff <= 1'b0;
		else
			tdo_en_ff <= tdo_en_next;
	assign tdo_en_next = tap_fsm_dr_shift_ff | tap_fsm_ir_shift_ff;
	always @(negedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tdo_out_ff <= 1'b0;
		else if (~trst_n_int)
			tdo_out_ff <= 1'b0;
		else
			tdo_out_ff <= tdo_out_next;
	assign tdo_out_next = (tap_fsm_dr_shift_ff ? dr_out : (tap_fsm_ir_shift_ff ? tap_ir_shift_ff[0] : 1'b0));
	assign tapc_tdo_en = tdo_en_ff;
	assign tapc_tdo = tdo_out_ff;
	localparam [31:0] SCR1_TAP_DR_BYPASS_WIDTH = 1;
	function automatic signed [0:0] sv2v_cast_A2C08_signed;
		input reg signed [0:0] inp;
		sv2v_cast_A2C08_signed = inp;
	endfunction
	scr1_tapc_shift_reg #(
		.SCR1_WIDTH(SCR1_TAP_DR_BYPASS_WIDTH),
		.SCR1_RESET_VALUE(sv2v_cast_A2C08_signed(0))
	) i_bypass_reg(
		.clk(tapc_tck),
		.rst_n(tapc_trst_n),
		.rst_n_sync(trst_n_int),
		.fsm_dr_select(dr_bypass_sel),
		.fsm_dr_capture(tap_fsm_dr_capture_ff),
		.fsm_dr_shift(tap_fsm_dr_shift_ff),
		.din_serial(tapc_tdi),
		.din_parallel(1'b0),
		.dout_serial(dr_bypass_tdo),
		.dout_parallel()
	);
	localparam [31:0] SCR1_TAP_DR_IDCODE_WIDTH = 32;
	function automatic signed [31:0] sv2v_cast_DEBC9_signed;
		input reg signed [31:0] inp;
		sv2v_cast_DEBC9_signed = inp;
	endfunction
	scr1_tapc_shift_reg #(
		.SCR1_WIDTH(SCR1_TAP_DR_IDCODE_WIDTH),
		.SCR1_RESET_VALUE(sv2v_cast_DEBC9_signed(0))
	) i_tap_idcode_reg(
		.clk(tapc_tck),
		.rst_n(tapc_trst_n),
		.rst_n_sync(trst_n_int),
		.fsm_dr_select(dr_idcode_sel),
		.fsm_dr_capture(tap_fsm_dr_capture_ff),
		.fsm_dr_shift(tap_fsm_dr_shift_ff),
		.din_serial(tapc_tdi),
		.din_parallel(soc2tapc_fuse_idcode_i),
		.dout_serial(dr_idcode_tdo),
		.dout_parallel()
	);
	localparam [31:0] SCR1_TAP_DR_BLD_ID_WIDTH = 32;
	localparam [31:0] SCR1_TAP_BLD_ID_VALUE = 32'h22011200;
	scr1_tapc_shift_reg #(
		.SCR1_WIDTH(SCR1_TAP_DR_BLD_ID_WIDTH),
		.SCR1_RESET_VALUE(sv2v_cast_DEBC9_signed(0))
	) i_tap_dr_bld_id_reg(
		.clk(tapc_tck),
		.rst_n(tapc_trst_n),
		.rst_n_sync(trst_n_int),
		.fsm_dr_select(dr_bld_id_sel),
		.fsm_dr_capture(tap_fsm_dr_capture_ff),
		.fsm_dr_shift(tap_fsm_dr_shift_ff),
		.din_serial(tapc_tdi),
		.din_parallel(SCR1_TAP_BLD_ID_VALUE),
		.dout_serial(dr_bld_id_tdo),
		.dout_parallel()
	);
	assign tapc2tapcsync_ch_tdi_o = tapc_tdi;
	assign tapc2tapcsync_ch_capture_o = tap_fsm_dr_capture_ff;
	assign tapc2tapcsync_ch_shift_o = tap_fsm_dr_shift_ff;
	assign tapc2tapcsync_ch_update_o = tap_fsm_dr_update_ff;
	initial _sv2v_0 = 0;
endmodule
