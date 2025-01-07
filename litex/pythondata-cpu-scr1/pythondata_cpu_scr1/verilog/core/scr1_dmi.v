/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_dmi (
	rst_n,
	clk,
	tapcsync2dmi_ch_sel_i,
	tapcsync2dmi_ch_id_i,
	tapcsync2dmi_ch_capture_i,
	tapcsync2dmi_ch_shift_i,
	tapcsync2dmi_ch_update_i,
	tapcsync2dmi_ch_tdi_i,
	dmi2tapcsync_ch_tdo_o,
	dm2dmi_resp_i,
	dm2dmi_rdata_i,
	dmi2dm_req_o,
	dmi2dm_wr_o,
	dmi2dm_addr_o,
	dmi2dm_wdata_o
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	input wire tapcsync2dmi_ch_sel_i;
	localparam SCR1_DBG_DMI_CH_ID_WIDTH = 2'd2;
	input wire [SCR1_DBG_DMI_CH_ID_WIDTH - 1:0] tapcsync2dmi_ch_id_i;
	input wire tapcsync2dmi_ch_capture_i;
	input wire tapcsync2dmi_ch_shift_i;
	input wire tapcsync2dmi_ch_update_i;
	input wire tapcsync2dmi_ch_tdi_i;
	output wire dmi2tapcsync_ch_tdo_o;
	input wire dm2dmi_resp_i;
	localparam SCR1_DBG_DMI_DATA_WIDTH = 6'd32;
	input wire [SCR1_DBG_DMI_DATA_WIDTH - 1:0] dm2dmi_rdata_i;
	output reg dmi2dm_req_o;
	output reg dmi2dm_wr_o;
	localparam SCR1_DBG_DMI_ADDR_WIDTH = 6'd7;
	output reg [SCR1_DBG_DMI_ADDR_WIDTH - 1:0] dmi2dm_addr_o;
	output reg [SCR1_DBG_DMI_DATA_WIDTH - 1:0] dmi2dm_wdata_o;
	localparam DTMCS_RESERVEDB_HI = 5'd31;
	localparam DTMCS_RESERVEDB_LO = 5'd18;
	localparam DTMCS_DMIHARDRESET = 5'd17;
	localparam DTMCS_DMIRESET = 5'd16;
	localparam DTMCS_RESERVEDA = 5'd15;
	localparam DTMCS_IDLE_HI = 5'd14;
	localparam DTMCS_IDLE_LO = 5'd12;
	localparam DTMCS_DMISTAT_HI = 5'd11;
	localparam DTMCS_DMISTAT_LO = 5'd10;
	localparam DTMCS_ABITS_HI = 5'd9;
	localparam DTMCS_ABITS_LO = 5'd4;
	localparam DTMCS_VERSION_HI = 5'd3;
	localparam DTMCS_VERSION_LO = 5'd0;
	localparam DMI_OP_LO = 5'd0;
	localparam SCR1_DBG_DMI_OP_WIDTH = 2'd2;
	localparam DMI_OP_HI = (DMI_OP_LO + SCR1_DBG_DMI_OP_WIDTH) - 1;
	localparam DMI_DATA_LO = DMI_OP_HI + 1;
	localparam DMI_DATA_HI = (DMI_DATA_LO + SCR1_DBG_DMI_DATA_WIDTH) - 1;
	localparam DMI_ADDR_LO = DMI_DATA_HI + 1;
	localparam DMI_ADDR_HI = (DMI_ADDR_LO + SCR1_DBG_DMI_ADDR_WIDTH) - 1;
	wire tap_dr_upd;
	localparam SCR1_DBG_DMI_DR_DMI_ACCESS_WIDTH = (SCR1_DBG_DMI_OP_WIDTH + SCR1_DBG_DMI_DATA_WIDTH) + SCR1_DBG_DMI_ADDR_WIDTH;
	reg [SCR1_DBG_DMI_DR_DMI_ACCESS_WIDTH - 1:0] tap_dr_ff;
	wire [SCR1_DBG_DMI_DR_DMI_ACCESS_WIDTH - 1:0] tap_dr_shift;
	reg [SCR1_DBG_DMI_DR_DMI_ACCESS_WIDTH - 1:0] tap_dr_rdata;
	wire [SCR1_DBG_DMI_DR_DMI_ACCESS_WIDTH - 1:0] tap_dr_next;
	wire dm_rdata_upd;
	reg [SCR1_DBG_DMI_DATA_WIDTH - 1:0] dm_rdata_ff;
	wire tapc_dmi_access_req;
	wire tapc_dtmcs_sel;
	assign tapc_dtmcs_sel = tapcsync2dmi_ch_id_i == 1'd1;
	always @(*) begin
		if (_sv2v_0)
			;
		tap_dr_rdata = 1'sb0;
		if (tapc_dtmcs_sel) begin
			tap_dr_rdata[DTMCS_RESERVEDB_HI:DTMCS_RESERVEDB_LO] = 'b0;
			tap_dr_rdata[DTMCS_DMIHARDRESET] = 'b0;
			tap_dr_rdata[DTMCS_DMIRESET] = 'b0;
			tap_dr_rdata[DTMCS_RESERVEDA] = 'b0;
			tap_dr_rdata[DTMCS_IDLE_HI:DTMCS_IDLE_LO] = 'b0;
			tap_dr_rdata[DTMCS_DMISTAT_HI:DTMCS_DMISTAT_LO] = 'b0;
			tap_dr_rdata[DTMCS_ABITS_HI:DTMCS_ABITS_LO] = SCR1_DBG_DMI_ADDR_WIDTH;
			tap_dr_rdata[DTMCS_VERSION_LO] = 1'b1;
		end
		else begin
			tap_dr_rdata[DMI_ADDR_HI:DMI_ADDR_LO] = 'b0;
			tap_dr_rdata[DMI_DATA_HI:DMI_DATA_LO] = dm_rdata_ff;
			tap_dr_rdata[DMI_OP_HI:DMI_OP_LO] = 'b0;
		end
	end
	localparam SCR1_DBG_DMI_DR_DTMCS_WIDTH = 6'd32;
	assign tap_dr_shift = (tapc_dtmcs_sel ? {9'b000000000, tapcsync2dmi_ch_tdi_i, tap_dr_ff[SCR1_DBG_DMI_DR_DTMCS_WIDTH - 1:1]} : {tapcsync2dmi_ch_tdi_i, tap_dr_ff[SCR1_DBG_DMI_DR_DMI_ACCESS_WIDTH - 1:1]});
	assign tap_dr_upd = tapcsync2dmi_ch_capture_i | tapcsync2dmi_ch_shift_i;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			tap_dr_ff <= 1'sb0;
		else if (tap_dr_upd)
			tap_dr_ff <= tap_dr_next;
	assign tap_dr_next = (tapcsync2dmi_ch_capture_i ? tap_dr_rdata : (tapcsync2dmi_ch_shift_i ? tap_dr_shift : tap_dr_ff));
	assign dmi2tapcsync_ch_tdo_o = tap_dr_ff[0];
	assign tapc_dmi_access_req = (tapcsync2dmi_ch_update_i & tapcsync2dmi_ch_sel_i) & (tapcsync2dmi_ch_id_i == 2'd2);
	always @(*) begin
		if (_sv2v_0)
			;
		dmi2dm_req_o = 1'b0;
		dmi2dm_wr_o = 1'b0;
		dmi2dm_addr_o = 1'b0;
		dmi2dm_wdata_o = 1'b0;
		if (tapc_dmi_access_req) begin
			dmi2dm_req_o = tap_dr_ff[DMI_OP_HI:DMI_OP_LO] != 2'b00;
			dmi2dm_wr_o = tap_dr_ff[DMI_OP_HI:DMI_OP_LO] == 2'b10;
			dmi2dm_addr_o = tap_dr_ff[DMI_ADDR_HI:DMI_ADDR_LO];
			dmi2dm_wdata_o = tap_dr_ff[DMI_DATA_HI:DMI_DATA_LO];
		end
	end
	assign dm_rdata_upd = (dmi2dm_req_o & dm2dmi_resp_i) & ~dmi2dm_wr_o;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			dm_rdata_ff <= 1'sb0;
		else if (dm_rdata_upd)
			dm_rdata_ff <= dm2dmi_rdata_i;
	initial _sv2v_0 = 0;
endmodule
