/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_tapc_shift_reg (
	clk,
	rst_n,
	rst_n_sync,
	fsm_dr_select,
	fsm_dr_capture,
	fsm_dr_shift,
	din_serial,
	din_parallel,
	dout_serial,
	dout_parallel
);
	parameter [31:0] SCR1_WIDTH = 8;
	parameter [SCR1_WIDTH - 1:0] SCR1_RESET_VALUE = 1'sb0;
	input wire clk;
	input wire rst_n;
	input wire rst_n_sync;
	input wire fsm_dr_select;
	input wire fsm_dr_capture;
	input wire fsm_dr_shift;
	input wire din_serial;
	input wire [SCR1_WIDTH - 1:0] din_parallel;
	output wire dout_serial;
	output wire [SCR1_WIDTH - 1:0] dout_parallel;
	reg [SCR1_WIDTH - 1:0] shift_reg;
	generate
		if (SCR1_WIDTH > 1) begin : dr_shift_reg
			always @(posedge clk or negedge rst_n)
				if (~rst_n)
					shift_reg <= SCR1_RESET_VALUE;
				else if (~rst_n_sync)
					shift_reg <= SCR1_RESET_VALUE;
				else if (fsm_dr_select & fsm_dr_capture)
					shift_reg <= din_parallel;
				else if (fsm_dr_select & fsm_dr_shift)
					shift_reg <= {din_serial, shift_reg[SCR1_WIDTH - 1:1]};
		end
		else begin : dr_shift_reg
			always @(posedge clk or negedge rst_n)
				if (~rst_n)
					shift_reg <= SCR1_RESET_VALUE;
				else if (~rst_n_sync)
					shift_reg <= SCR1_RESET_VALUE;
				else if (fsm_dr_select & fsm_dr_capture)
					shift_reg <= din_parallel;
				else if (fsm_dr_select & fsm_dr_shift)
					shift_reg <= din_serial;
		end
	endgenerate
	assign dout_parallel = shift_reg;
	assign dout_serial = shift_reg[0];
endmodule
