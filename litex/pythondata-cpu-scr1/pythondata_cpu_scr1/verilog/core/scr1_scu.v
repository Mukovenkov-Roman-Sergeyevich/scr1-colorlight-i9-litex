/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_scu (
	pwrup_rst_n,
	rst_n,
	cpu_rst_n,
	test_mode,
	test_rst_n,
	clk,
	tapcsync2scu_ch_sel_i,
	tapcsync2scu_ch_id_i,
	tapcsync2scu_ch_capture_i,
	tapcsync2scu_ch_shift_i,
	tapcsync2scu_ch_update_i,
	tapcsync2scu_ch_tdi_i,
	scu2tapcsync_ch_tdo_o,
	ndm_rst_n_i,
	hart_rst_n_i,
	sys_rst_n_o,
	core_rst_n_o,
	dm_rst_n_o,
	hdu_rst_n_o,
	sys_rst_status_o,
	core_rst_status_o,
	sys_rdc_qlfy_o,
	core_rdc_qlfy_o,
	core2hdu_rdc_qlfy_o,
	core2dm_rdc_qlfy_o,
	hdu2dm_rdc_qlfy_o
);
	reg _sv2v_0;
	input wire pwrup_rst_n;
	input wire rst_n;
	input wire cpu_rst_n;
	input wire test_mode;
	input wire test_rst_n;
	input wire clk;
	input wire tapcsync2scu_ch_sel_i;
	input wire tapcsync2scu_ch_id_i;
	input wire tapcsync2scu_ch_capture_i;
	input wire tapcsync2scu_ch_shift_i;
	input wire tapcsync2scu_ch_update_i;
	input wire tapcsync2scu_ch_tdi_i;
	output wire scu2tapcsync_ch_tdo_o;
	input wire ndm_rst_n_i;
	input wire hart_rst_n_i;
	output wire sys_rst_n_o;
	output wire core_rst_n_o;
	output wire dm_rst_n_o;
	output wire hdu_rst_n_o;
	output wire sys_rst_status_o;
	output wire core_rst_status_o;
	output wire sys_rdc_qlfy_o;
	output wire core_rdc_qlfy_o;
	output wire core2hdu_rdc_qlfy_o;
	output wire core2dm_rdc_qlfy_o;
	output wire hdu2dm_rdc_qlfy_o;
	localparam [31:0] SCR1_SCU_RST_SYNC_STAGES_NUM = 2;
	wire scu_csr_req;
	wire tapc_dr_cap_req;
	wire tapc_dr_shft_req;
	wire tapc_dr_upd_req;
	wire tapc_shift_upd;
	localparam [31:0] SCR1_SCU_DR_SYSCTRL_ADDR_WIDTH = 2;
	localparam [31:0] SCR1_SCU_DR_SYSCTRL_DATA_WIDTH = 4;
	localparam [31:0] SCR1_SCU_DR_SYSCTRL_OP_WIDTH = 2;
	reg [((SCR1_SCU_DR_SYSCTRL_DATA_WIDTH + SCR1_SCU_DR_SYSCTRL_ADDR_WIDTH) + SCR1_SCU_DR_SYSCTRL_OP_WIDTH) - 1:0] tapc_shift_ff;
	wire [((SCR1_SCU_DR_SYSCTRL_DATA_WIDTH + SCR1_SCU_DR_SYSCTRL_ADDR_WIDTH) + SCR1_SCU_DR_SYSCTRL_OP_WIDTH) - 1:0] tapc_shift_next;
	reg [((SCR1_SCU_DR_SYSCTRL_DATA_WIDTH + SCR1_SCU_DR_SYSCTRL_ADDR_WIDTH) + SCR1_SCU_DR_SYSCTRL_OP_WIDTH) - 1:0] tapc_shadow_ff;
	reg [3:0] scu_csr_wdata;
	reg [3:0] scu_csr_rdata;
	reg [3:0] scu_control_ff;
	reg scu_control_wr_req;
	reg [3:0] scu_mode_ff;
	reg scu_mode_wr_req;
	wire [3:0] scu_status_ff;
	reg [3:0] scu_status_ff_dly;
	wire [3:0] scu_status_ff_posedge;
	reg [3:0] scu_sticky_sts_ff;
	reg scu_sticky_sts_wr_req;
	wire pwrup_rst_n_sync;
	wire rst_n_sync;
	wire cpu_rst_n_sync;
	wire sys_rst_n_in;
	wire sys_rst_n_status;
	wire sys_rst_n_status_sync;
	wire sys_rst_n_qlfy;
	wire sys_reset_n;
	wire core_rst_n_in_sync;
	wire core_rst_n_status;
	wire core_rst_n_status_sync;
	wire core_rst_n_qlfy;
	wire core_reset_n;
	wire hdu_rst_n_in_sync;
	wire hdu_rst_n_status;
	wire hdu_rst_n_status_sync;
	wire hdu_rst_n_qlfy;
	wire dm_rst_n_in;
	wire dm_rst_n_status;
	assign scu_csr_req = tapcsync2scu_ch_sel_i & (tapcsync2scu_ch_id_i == 1'b0);
	assign tapc_dr_cap_req = scu_csr_req & tapcsync2scu_ch_capture_i;
	assign tapc_dr_shft_req = scu_csr_req & tapcsync2scu_ch_shift_i;
	assign tapc_dr_upd_req = scu_csr_req & tapcsync2scu_ch_update_i;
	assign tapc_shift_upd = tapc_dr_cap_req | tapc_dr_shft_req;
	always @(posedge clk or negedge pwrup_rst_n_sync)
		if (~pwrup_rst_n_sync)
			tapc_shift_ff <= 1'sb0;
		else if (tapc_shift_upd)
			tapc_shift_ff <= tapc_shift_next;
	assign tapc_shift_next = (tapc_dr_cap_req ? tapc_shadow_ff : (tapc_dr_shft_req ? {tapcsync2scu_ch_tdi_i, tapc_shift_ff[((SCR1_SCU_DR_SYSCTRL_DATA_WIDTH + SCR1_SCU_DR_SYSCTRL_ADDR_WIDTH) + SCR1_SCU_DR_SYSCTRL_OP_WIDTH) - 1:1]} : tapc_shift_ff));
	always @(posedge clk or negedge pwrup_rst_n_sync)
		if (~pwrup_rst_n_sync)
			tapc_shadow_ff <= 1'sb0;
		else if (tapc_dr_upd_req) begin
			tapc_shadow_ff[1-:SCR1_SCU_DR_SYSCTRL_OP_WIDTH] <= tapc_shift_ff[1-:SCR1_SCU_DR_SYSCTRL_OP_WIDTH];
			tapc_shadow_ff[3-:2] <= tapc_shift_ff[3-:2];
			tapc_shadow_ff[7-:4] <= scu_csr_wdata;
		end
	assign scu2tapcsync_ch_tdo_o = tapc_shift_ff[0];
	function automatic [1:0] sv2v_cast_4192F;
		input reg [1:0] inp;
		sv2v_cast_4192F = inp;
	endfunction
	function automatic [1:0] sv2v_cast_D5441;
		input reg [1:0] inp;
		sv2v_cast_D5441 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		scu_control_wr_req = 1'b0;
		scu_mode_wr_req = 1'b0;
		scu_sticky_sts_wr_req = 1'b0;
		if (tapc_dr_upd_req && (tapc_shift_ff[1-:SCR1_SCU_DR_SYSCTRL_OP_WIDTH] != sv2v_cast_4192F(2'h1)))
			case (tapc_shift_ff[3-:2])
				sv2v_cast_D5441(2'h0): scu_control_wr_req = 1'b1;
				sv2v_cast_D5441(2'h1): scu_mode_wr_req = 1'b1;
				sv2v_cast_D5441(2'h3): scu_sticky_sts_wr_req = tapc_shift_ff[1-:SCR1_SCU_DR_SYSCTRL_OP_WIDTH] == sv2v_cast_4192F(2'h3);
				default:
					;
			endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		scu_csr_wdata = 1'sb0;
		if (tapc_dr_upd_req)
			case (tapc_shift_ff[1-:SCR1_SCU_DR_SYSCTRL_OP_WIDTH])
				sv2v_cast_4192F(2'h0): scu_csr_wdata = tapc_shift_ff[7-:4];
				sv2v_cast_4192F(2'h1): scu_csr_wdata = scu_csr_rdata;
				sv2v_cast_4192F(2'h2): scu_csr_wdata = scu_csr_rdata | tapc_shift_ff[7-:4];
				sv2v_cast_4192F(2'h3): scu_csr_wdata = scu_csr_rdata & ~tapc_shift_ff[7-:4];
				default:
					;
			endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		scu_csr_rdata = 1'sb0;
		if (tapc_dr_upd_req)
			case (tapc_shift_ff[3-:2])
				sv2v_cast_D5441(2'h0): scu_csr_rdata = scu_control_ff;
				sv2v_cast_D5441(2'h1): scu_csr_rdata = scu_mode_ff;
				sv2v_cast_D5441(2'h2): scu_csr_rdata = scu_status_ff;
				sv2v_cast_D5441(2'h3): scu_csr_rdata = scu_sticky_sts_ff;
				default: scu_csr_rdata = 1'sbx;
			endcase
	end
	always @(posedge clk or negedge pwrup_rst_n_sync)
		if (~pwrup_rst_n_sync)
			scu_control_ff <= 1'sb0;
		else if (scu_control_wr_req)
			scu_control_ff <= scu_csr_wdata;
	always @(posedge clk or negedge pwrup_rst_n_sync)
		if (~pwrup_rst_n_sync)
			scu_mode_ff <= 1'sb0;
		else if (scu_mode_wr_req)
			scu_mode_ff <= scu_csr_wdata;
	assign scu_status_ff[0] = sys_rst_status_o;
	assign scu_status_ff[1] = core_rst_status_o;
	assign scu_status_ff[2] = ~dm_rst_n_status;
	assign scu_status_ff[3] = ~hdu_rst_n_status_sync;
	always @(posedge clk or negedge pwrup_rst_n_sync)
		if (~pwrup_rst_n_sync)
			scu_status_ff_dly <= 1'sb0;
		else
			scu_status_ff_dly <= scu_status_ff;
	assign scu_status_ff_posedge = scu_status_ff & ~scu_status_ff_dly;
	always @(posedge clk or negedge pwrup_rst_n_sync)
		if (~pwrup_rst_n_sync)
			scu_sticky_sts_ff <= 1'sb0;
		else begin : sv2v_autoblock_1
			reg [31:0] i;
			for (i = 0; i < 4; i = i + 1)
				if (scu_status_ff_posedge[i])
					scu_sticky_sts_ff[i] <= 1'b1;
				else if (scu_sticky_sts_wr_req)
					scu_sticky_sts_ff[i] <= scu_csr_wdata[i];
		end
	assign pwrup_rst_n_sync = pwrup_rst_n;
	assign rst_n_sync = rst_n;
	assign cpu_rst_n_sync = cpu_rst_n;
	assign sys_reset_n = ~scu_control_ff[0];
	assign core_reset_n = ~scu_control_ff[1];
	scr1_reset_qlfy_adapter_cell_sync i_sys_rstn_qlfy_adapter_cell_sync(
		.rst_n(pwrup_rst_n_sync),
		.clk(clk),
		.test_rst_n(test_rst_n),
		.test_mode(test_mode),
		.reset_n_in_sync(sys_rst_n_in),
		.reset_n_out_qlfy(sys_rst_n_qlfy),
		.reset_n_out(sys_rst_n_o),
		.reset_n_status(sys_rst_n_status)
	);
	assign sys_rst_n_in = (sys_reset_n & ndm_rst_n_i) & rst_n_sync;
	scr1_data_sync_cell #(.STAGES_AMOUNT(SCR1_SCU_RST_SYNC_STAGES_NUM)) i_sys_rstn_status_sync(
		.rst_n(pwrup_rst_n_sync),
		.clk(clk),
		.data_in(sys_rst_n_status),
		.data_out(sys_rst_n_status_sync)
	);
	assign sys_rst_status_o = ~sys_rst_n_status_sync;
	assign sys_rdc_qlfy_o = sys_rst_n_qlfy;
	scr1_reset_qlfy_adapter_cell_sync i_core_rstn_qlfy_adapter_cell_sync(
		.rst_n(pwrup_rst_n_sync),
		.clk(clk),
		.test_rst_n(test_rst_n),
		.test_mode(test_mode),
		.reset_n_in_sync(core_rst_n_in_sync),
		.reset_n_out_qlfy(core_rst_n_qlfy),
		.reset_n_out(core_rst_n_o),
		.reset_n_status(core_rst_n_status)
	);
	assign core_rst_n_in_sync = ((sys_rst_n_in & hart_rst_n_i) & core_reset_n) & cpu_rst_n_sync;
	scr1_data_sync_cell #(.STAGES_AMOUNT(SCR1_SCU_RST_SYNC_STAGES_NUM)) i_core_rstn_status_sync(
		.rst_n(pwrup_rst_n_sync),
		.clk(clk),
		.data_in(core_rst_n_status),
		.data_out(core_rst_n_status_sync)
	);
	assign core_rst_status_o = ~core_rst_n_status_sync;
	assign core_rdc_qlfy_o = core_rst_n_qlfy;
	assign core2hdu_rdc_qlfy_o = core_rst_n_qlfy;
	assign core2dm_rdc_qlfy_o = core_rst_n_qlfy;
	scr1_reset_qlfy_adapter_cell_sync i_hdu_rstn_qlfy_adapter_cell_sync(
		.rst_n(pwrup_rst_n_sync),
		.clk(clk),
		.test_rst_n(test_rst_n),
		.test_mode(test_mode),
		.reset_n_in_sync(hdu_rst_n_in_sync),
		.reset_n_out_qlfy(hdu_rst_n_qlfy),
		.reset_n_out(hdu_rst_n_o),
		.reset_n_status(hdu_rst_n_status)
	);
	assign hdu_rst_n_in_sync = scu_mode_ff[1] | core_rst_n_in_sync;
	scr1_data_sync_cell #(.STAGES_AMOUNT(SCR1_SCU_RST_SYNC_STAGES_NUM)) i_hdu_rstn_status_sync(
		.rst_n(pwrup_rst_n_sync),
		.clk(clk),
		.data_in(hdu_rst_n_status),
		.data_out(hdu_rst_n_status_sync)
	);
	assign hdu2dm_rdc_qlfy_o = hdu_rst_n_qlfy;
	scr1_reset_buf_cell i_dm_rstn_buf_cell(
		.rst_n(pwrup_rst_n_sync),
		.clk(clk),
		.test_mode(test_mode),
		.test_rst_n(test_rst_n),
		.reset_n_in(dm_rst_n_in),
		.reset_n_out(dm_rst_n_o),
		.reset_n_status(dm_rst_n_status)
	);
	assign dm_rst_n_in = ~scu_mode_ff[0] | sys_reset_n;
	initial _sv2v_0 = 0;
endmodule
