/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_tapc_synchronizer (
	pwrup_rst_n,
	dm_rst_n,
	clk,
	tapc_trst_n,
	tapc_tck,
	tapc2tapcsync_scu_ch_sel_i,
	tapcsync2scu_ch_sel_o,
	tapc2tapcsync_dmi_ch_sel_i,
	tapcsync2dmi_ch_sel_o,
	tapc2tapcsync_ch_id_i,
	tapcsync2core_ch_id_o,
	tapc2tapcsync_ch_capture_i,
	tapcsync2core_ch_capture_o,
	tapc2tapcsync_ch_shift_i,
	tapcsync2core_ch_shift_o,
	tapc2tapcsync_ch_update_i,
	tapcsync2core_ch_update_o,
	tapc2tapcsync_ch_tdi_i,
	tapcsync2core_ch_tdi_o,
	tapc2tapcsync_ch_tdo_i,
	tapcsync2core_ch_tdo_o
);
	input wire pwrup_rst_n;
	input wire dm_rst_n;
	input wire clk;
	input wire tapc_trst_n;
	input wire tapc_tck;
	input wire tapc2tapcsync_scu_ch_sel_i;
	output reg tapcsync2scu_ch_sel_o;
	input wire tapc2tapcsync_dmi_ch_sel_i;
	output reg tapcsync2dmi_ch_sel_o;
	localparam SCR1_DBG_DMI_CH_ID_WIDTH = 2'd2;
	input wire [SCR1_DBG_DMI_CH_ID_WIDTH - 1:0] tapc2tapcsync_ch_id_i;
	output reg [SCR1_DBG_DMI_CH_ID_WIDTH - 1:0] tapcsync2core_ch_id_o;
	input wire tapc2tapcsync_ch_capture_i;
	output reg tapcsync2core_ch_capture_o;
	input wire tapc2tapcsync_ch_shift_i;
	output reg tapcsync2core_ch_shift_o;
	input wire tapc2tapcsync_ch_update_i;
	output reg tapcsync2core_ch_update_o;
	input wire tapc2tapcsync_ch_tdi_i;
	output reg tapcsync2core_ch_tdi_o;
	output wire tapc2tapcsync_ch_tdo_i;
	input wire tapcsync2core_ch_tdo_o;
	reg tck_divpos;
	reg tck_divneg;
	wire tck_rise_load;
	wire tck_rise_reset;
	wire tck_fall_load;
	wire tck_fall_reset;
	reg [3:0] tck_divpos_sync;
	reg [3:0] tck_divneg_sync;
	reg [2:0] dmi_ch_capture_sync;
	reg [2:0] dmi_ch_shift_sync;
	reg [2:0] dmi_ch_tdi_sync;
	always @(posedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tck_divpos <= 1'b0;
		else
			tck_divpos <= ~tck_divpos;
	always @(negedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n)
			tck_divneg <= 1'b0;
		else
			tck_divneg <= ~tck_divneg;
	always @(posedge clk or negedge pwrup_rst_n)
		if (~pwrup_rst_n) begin
			tck_divpos_sync <= 4'd0;
			tck_divneg_sync <= 4'd0;
		end
		else begin
			tck_divpos_sync <= {tck_divpos_sync[2:0], tck_divpos};
			tck_divneg_sync <= {tck_divneg_sync[2:0], tck_divneg};
		end
	assign tck_rise_load = tck_divpos_sync[2] ^ tck_divpos_sync[1];
	assign tck_rise_reset = tck_divpos_sync[3] ^ tck_divpos_sync[2];
	assign tck_fall_load = tck_divneg_sync[2] ^ tck_divneg_sync[1];
	assign tck_fall_reset = tck_divneg_sync[3] ^ tck_divneg_sync[2];
	always @(posedge clk or negedge pwrup_rst_n)
		if (~pwrup_rst_n)
			tapcsync2core_ch_update_o <= 1'sb0;
		else if (tck_fall_load)
			tapcsync2core_ch_update_o <= tapc2tapcsync_ch_update_i;
		else if (tck_fall_reset)
			tapcsync2core_ch_update_o <= 1'sb0;
	always @(negedge tapc_tck or negedge tapc_trst_n)
		if (~tapc_trst_n) begin
			dmi_ch_capture_sync[0] <= 1'sb0;
			dmi_ch_shift_sync[0] <= 1'sb0;
		end
		else begin
			dmi_ch_capture_sync[0] <= tapc2tapcsync_ch_capture_i;
			dmi_ch_shift_sync[0] <= tapc2tapcsync_ch_shift_i;
		end
	always @(posedge clk or negedge pwrup_rst_n)
		if (~pwrup_rst_n) begin
			dmi_ch_capture_sync[2:1] <= 1'sb0;
			dmi_ch_shift_sync[2:1] <= 1'sb0;
		end
		else begin
			dmi_ch_capture_sync[2:1] <= {dmi_ch_capture_sync[1], dmi_ch_capture_sync[0]};
			dmi_ch_shift_sync[2:1] <= {dmi_ch_shift_sync[1], dmi_ch_shift_sync[0]};
		end
	always @(posedge clk or negedge pwrup_rst_n)
		if (~pwrup_rst_n)
			dmi_ch_tdi_sync <= 1'sb0;
		else
			dmi_ch_tdi_sync <= {dmi_ch_tdi_sync[1:0], tapc2tapcsync_ch_tdi_i};
	always @(posedge clk or negedge pwrup_rst_n)
		if (~pwrup_rst_n) begin
			tapcsync2core_ch_capture_o <= 1'sb0;
			tapcsync2core_ch_shift_o <= 1'sb0;
			tapcsync2core_ch_tdi_o <= 1'sb0;
		end
		else if (tck_rise_load) begin
			tapcsync2core_ch_capture_o <= dmi_ch_capture_sync[2];
			tapcsync2core_ch_shift_o <= dmi_ch_shift_sync[2];
			tapcsync2core_ch_tdi_o <= dmi_ch_tdi_sync[2];
		end
		else if (tck_rise_reset) begin
			tapcsync2core_ch_capture_o <= 1'sb0;
			tapcsync2core_ch_shift_o <= 1'sb0;
			tapcsync2core_ch_tdi_o <= 1'sb0;
		end
	always @(posedge clk or negedge dm_rst_n)
		if (~dm_rst_n) begin
			tapcsync2dmi_ch_sel_o <= 1'sb0;
			tapcsync2core_ch_id_o <= 1'sb0;
		end
		else if (tck_rise_load) begin
			tapcsync2dmi_ch_sel_o <= tapc2tapcsync_dmi_ch_sel_i;
			tapcsync2core_ch_id_o <= tapc2tapcsync_ch_id_i;
		end
	always @(posedge clk or negedge pwrup_rst_n)
		if (~pwrup_rst_n)
			tapcsync2scu_ch_sel_o <= 1'sb0;
		else if (tck_rise_load)
			tapcsync2scu_ch_sel_o <= tapc2tapcsync_scu_ch_sel_i;
	assign tapc2tapcsync_ch_tdo_i = tapcsync2core_ch_tdo_o;
endmodule
