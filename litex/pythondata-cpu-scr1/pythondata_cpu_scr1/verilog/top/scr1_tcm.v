/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_tcm (
	clk,
	rst_n,
	imem_req_ack,
	imem_req,
	imem_addr,
	imem_rdata,
	imem_resp,
	dmem_req_ack,
	dmem_req,
	dmem_cmd,
	dmem_width,
	dmem_addr,
	dmem_wdata,
	dmem_rdata,
	dmem_resp
);
	reg _sv2v_0;
	parameter SCR1_TCM_SIZE = 32'h00010000;
	input wire clk;
	input wire rst_n;
	output wire imem_req_ack;
	input wire imem_req;
	input wire [31:0] imem_addr;
	output wire [31:0] imem_rdata;
	output reg [1:0] imem_resp;
	output wire dmem_req_ack;
	input wire dmem_req;
	input wire dmem_cmd;
	input wire [1:0] dmem_width;
	input wire [31:0] dmem_addr;
	input wire [31:0] dmem_wdata;
	output wire [31:0] dmem_rdata;
	output reg [1:0] dmem_resp;
	wire imem_req_en;
	wire dmem_req_en;
	wire imem_rd;
	wire dmem_rd;
	wire dmem_wr;
	reg [31:0] dmem_writedata;
	wire [31:0] dmem_rdata_local;
	reg [3:0] dmem_byteen;
	reg [1:0] dmem_rdata_shift_reg;
	assign imem_req_en = (imem_resp == 2'b01) ^ imem_req;
	assign dmem_req_en = (dmem_resp == 2'b01) ^ dmem_req;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			imem_resp <= 2'b00;
		else if (imem_req_en)
			imem_resp <= (imem_req ? 2'b01 : 2'b00);
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			dmem_resp <= 2'b00;
		else if (dmem_req_en)
			dmem_resp <= (dmem_req ? 2'b01 : 2'b00);
	assign imem_req_ack = 1'b1;
	assign dmem_req_ack = 1'b1;
	assign imem_rd = imem_req;
	assign dmem_rd = dmem_req & (dmem_cmd == 1'b0);
	assign dmem_wr = dmem_req & (dmem_cmd == 1'b1);
	always @(*) begin
		if (_sv2v_0)
			;
		dmem_writedata = dmem_wdata;
		dmem_byteen = 4'b1111;
		case (dmem_width)
			2'b00: begin
				dmem_writedata = {4 {dmem_wdata[7:0]}};
				dmem_byteen = 4'b0001 << dmem_addr[1:0];
			end
			2'b01: begin
				dmem_writedata = {2 {dmem_wdata[15:0]}};
				dmem_byteen = 4'b0011 << {dmem_addr[1], 1'b0};
			end
			default:
				;
		endcase
	end
	scr1_dp_memory #(
		.SCR1_WIDTH(32),
		.SCR1_SIZE(SCR1_TCM_SIZE)
	) i_dp_memory(
		.clk(clk),
		.rena(imem_rd),
		.addra(imem_addr[$clog2(SCR1_TCM_SIZE) - 1:2]),
		.qa(imem_rdata),
		.renb(dmem_rd),
		.wenb(dmem_wr),
		.webb(dmem_byteen),
		.addrb(dmem_addr[$clog2(SCR1_TCM_SIZE) - 1:2]),
		.qb(dmem_rdata_local),
		.datab(dmem_writedata)
	);
	always @(posedge clk)
		if (dmem_rd)
			dmem_rdata_shift_reg <= dmem_addr[1:0];
	assign dmem_rdata = dmem_rdata_local >> (8 * dmem_rdata_shift_reg);
	initial _sv2v_0 = 0;
endmodule
