/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_imem_router (
	rst_n,
	clk,
	imem_req_ack,
	imem_req,
	imem_cmd,
	imem_addr,
	imem_rdata,
	imem_resp,
	port0_req_ack,
	port0_req,
	port0_cmd,
	port0_addr,
	port0_rdata,
	port0_resp,
	port1_req_ack,
	port1_req,
	port1_cmd,
	port1_addr,
	port1_rdata,
	port1_resp
);
	reg _sv2v_0;
	parameter SCR1_ADDR_MASK = 32'hffff0000;
	parameter SCR1_ADDR_PATTERN = 32'h00010000;
	input wire rst_n;
	input wire clk;
	output wire imem_req_ack;
	input wire imem_req;
	input wire imem_cmd;
	input wire [31:0] imem_addr;
	output wire [31:0] imem_rdata;
	output wire [1:0] imem_resp;
	input wire port0_req_ack;
	output reg port0_req;
	output wire port0_cmd;
	output wire [31:0] port0_addr;
	input wire [31:0] port0_rdata;
	input wire [1:0] port0_resp;
	input wire port1_req_ack;
	output reg port1_req;
	output wire port1_cmd;
	output wire [31:0] port1_addr;
	input wire [31:0] port1_rdata;
	input wire [1:0] port1_resp;
	reg fsm;
	wire port_sel;
	reg port_sel_r;
	wire [31:0] sel_rdata;
	wire [1:0] sel_resp;
	reg sel_req_ack;
	assign port_sel = (imem_addr & SCR1_ADDR_MASK) == SCR1_ADDR_PATTERN;
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			fsm <= 1'd0;
			port_sel_r <= 1'b0;
		end
		else
			case (fsm)
				1'd0:
					if (imem_req & sel_req_ack) begin
						fsm <= 1'd1;
						port_sel_r <= port_sel;
					end
				1'd1:
					case (sel_resp)
						2'b01:
							if (imem_req & sel_req_ack) begin
								fsm <= 1'd1;
								port_sel_r <= port_sel;
							end
							else
								fsm <= 1'd0;
						2'b10: fsm <= 1'd0;
						default:
							;
					endcase
				default:
					;
			endcase
	always @(*) begin
		if (_sv2v_0)
			;
		if ((fsm == 1'd0) | ((fsm == 1'd1) & (sel_resp == 2'b01)))
			sel_req_ack = (port_sel ? port1_req_ack : port0_req_ack);
		else
			sel_req_ack = 1'b0;
	end
	assign sel_rdata = (port_sel_r ? port1_rdata : port0_rdata);
	assign sel_resp = (port_sel_r ? port1_resp : port0_resp);
	assign imem_req_ack = sel_req_ack;
	assign imem_rdata = sel_rdata;
	assign imem_resp = sel_resp;
	always @(*) begin
		if (_sv2v_0)
			;
		port0_req = 1'b0;
		case (fsm)
			1'd0: port0_req = imem_req & ~port_sel;
			1'd1:
				if (sel_resp == 2'b01)
					port0_req = imem_req & ~port_sel;
			default:
				;
		endcase
	end
	assign port0_cmd = imem_cmd;
	assign port0_addr = imem_addr;
	always @(*) begin
		if (_sv2v_0)
			;
		port1_req = 1'b0;
		case (fsm)
			1'd0: port1_req = imem_req & port_sel;
			1'd1:
				if (sel_resp == 2'b01)
					port1_req = imem_req & port_sel;
			default:
				;
		endcase
	end
	assign port1_cmd = imem_cmd;
	assign port1_addr = imem_addr;
	initial _sv2v_0 = 0;
endmodule
