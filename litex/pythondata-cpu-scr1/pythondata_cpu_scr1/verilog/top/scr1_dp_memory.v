/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_dp_memory (
	clk,
	rena,
	addra,
	qa,
	renb,
	wenb,
	webb,
	addrb,
	datab,
	qb
);
	parameter SCR1_WIDTH = 32;
	parameter SCR1_SIZE = 32'h00010000;
	parameter SCR1_NBYTES = SCR1_WIDTH / 8;
	input wire clk;
	input wire rena;
	input wire [$clog2(SCR1_SIZE) - 1:2] addra;
	output reg [SCR1_WIDTH - 1:0] qa;
	input wire renb;
	input wire wenb;
	input wire [SCR1_NBYTES - 1:0] webb;
	input wire [$clog2(SCR1_SIZE) - 1:2] addrb;
	input wire [SCR1_WIDTH - 1:0] datab;
	output reg [SCR1_WIDTH - 1:0] qb;
	localparam [31:0] RAM_SIZE_WORDS = SCR1_SIZE / SCR1_NBYTES;
	reg [SCR1_WIDTH - 1:0] ram_block [RAM_SIZE_WORDS - 1:0];
	always @(posedge clk)
		if (rena)
			qa <= ram_block[addra];
	always @(posedge clk) begin
		if (wenb) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < SCR1_NBYTES; i = i + 1)
				if (webb[i])
					ram_block[addrb][i * 8+:8] <= datab[i * 8+:8];
		end
		if (renb)
			qb <= ram_block[addrb];
	end
endmodule
