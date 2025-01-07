/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_mprf (
	rst_n,
	clk,
	exu2mprf_rs1_addr_i,
	mprf2exu_rs1_data_o,
	exu2mprf_rs2_addr_i,
	mprf2exu_rs2_data_o,
	exu2mprf_w_req_i,
	exu2mprf_rd_addr_i,
	exu2mprf_rd_data_i
);
	input wire rst_n;
	input wire clk;
	input wire [4:0] exu2mprf_rs1_addr_i;
	output wire [31:0] mprf2exu_rs1_data_o;
	input wire [4:0] exu2mprf_rs2_addr_i;
	output wire [31:0] mprf2exu_rs2_data_o;
	input wire exu2mprf_w_req_i;
	input wire [4:0] exu2mprf_rd_addr_i;
	input wire [31:0] exu2mprf_rd_data_i;
	wire wr_req_vd;
	wire rs1_addr_vd;
	wire rs2_addr_vd;
	reg [1023:32] mprf_int;
	assign rs1_addr_vd = |exu2mprf_rs1_addr_i;
	assign rs2_addr_vd = |exu2mprf_rs2_addr_i;
	assign wr_req_vd = exu2mprf_w_req_i & |exu2mprf_rd_addr_i;
	assign mprf2exu_rs1_data_o = (rs1_addr_vd ? mprf_int[(32 - exu2mprf_rs1_addr_i) * 32+:32] : {32 {1'sb0}});
	assign mprf2exu_rs2_data_o = (rs2_addr_vd ? mprf_int[(32 - exu2mprf_rs2_addr_i) * 32+:32] : {32 {1'sb0}});
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			mprf_int <= {31 {32'b00000000000000000000000000000000}};
		else if (wr_req_vd)
			mprf_int[(32 - exu2mprf_rd_addr_i) * 32+:32] <= exu2mprf_rd_data_i;
endmodule
