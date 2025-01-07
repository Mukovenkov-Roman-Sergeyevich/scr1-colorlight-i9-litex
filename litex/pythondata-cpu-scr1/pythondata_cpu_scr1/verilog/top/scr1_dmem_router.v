/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_dmem_router (
	rst_n,
	clk,
	dmem_req_ack,
	dmem_req,
	dmem_cmd,
	dmem_width,
	dmem_addr,
	dmem_wdata,
	dmem_rdata,
	dmem_resp,
	port0_req_ack,
	port0_req,
	port0_cmd,
	port0_width,
	port0_addr,
	port0_wdata,
	port0_rdata,
	port0_resp,
	port1_req_ack,
	port1_req,
	port1_cmd,
	port1_width,
	port1_addr,
	port1_wdata,
	port1_rdata,
	port1_resp,
	port2_req_ack,
	port2_req,
	port2_cmd,
	port2_width,
	port2_addr,
	port2_wdata,
	port2_rdata,
	port2_resp
);
	reg _sv2v_0;
	parameter SCR1_PORT1_ADDR_MASK = 32'hffff0000;
	parameter SCR1_PORT1_ADDR_PATTERN = 32'h00010000;
	parameter SCR1_PORT2_ADDR_MASK = 32'hffff0000;
	parameter SCR1_PORT2_ADDR_PATTERN = 32'h00020000;
	input wire rst_n;
	input wire clk;
	output wire dmem_req_ack;
	input wire dmem_req;
	input wire dmem_cmd;
	input wire [1:0] dmem_width;
	input wire [31:0] dmem_addr;
	input wire [31:0] dmem_wdata;
	output wire [31:0] dmem_rdata;
	output wire [1:0] dmem_resp;
	input wire port0_req_ack;
	output reg port0_req;
	output wire port0_cmd;
	output wire [1:0] port0_width;
	output wire [31:0] port0_addr;
	output wire [31:0] port0_wdata;
	input wire [31:0] port0_rdata;
	input wire [1:0] port0_resp;
	input wire port1_req_ack;
	output reg port1_req;
	output wire port1_cmd;
	output wire [1:0] port1_width;
	output wire [31:0] port1_addr;
	output wire [31:0] port1_wdata;
	input wire [31:0] port1_rdata;
	input wire [1:0] port1_resp;
	input wire port2_req_ack;
	output reg port2_req;
	output wire port2_cmd;
	output wire [1:0] port2_width;
	output wire [31:0] port2_addr;
	output wire [31:0] port2_wdata;
	input wire [31:0] port2_rdata;
	input wire [1:0] port2_resp;
	reg fsm;
	reg [1:0] port_sel;
	reg [1:0] port_sel_r;
	reg [31:0] sel_rdata;
	reg [1:0] sel_resp;
	reg sel_req_ack;
	always @(*) begin
		if (_sv2v_0)
			;
		port_sel = 2'd0;
		if ((dmem_addr & SCR1_PORT1_ADDR_MASK) == SCR1_PORT1_ADDR_PATTERN)
			port_sel = 2'd1;
		else if ((dmem_addr & SCR1_PORT2_ADDR_MASK) == SCR1_PORT2_ADDR_PATTERN)
			port_sel = 2'd2;
	end
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			fsm <= 1'd0;
			port_sel_r <= 2'd0;
		end
		else
			case (fsm)
				1'd0:
					if (dmem_req & sel_req_ack) begin
						fsm <= 1'd1;
						port_sel_r <= port_sel;
					end
				1'd1:
					case (sel_resp)
						2'b01:
							if (dmem_req & sel_req_ack) begin
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
			case (port_sel)
				2'd0: sel_req_ack = port0_req_ack;
				2'd1: sel_req_ack = port1_req_ack;
				2'd2: sel_req_ack = port2_req_ack;
				default: sel_req_ack = 1'b0;
			endcase
		else
			sel_req_ack = 1'b0;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		case (port_sel_r)
			2'd0: begin
				sel_rdata = port0_rdata;
				sel_resp = port0_resp;
			end
			2'd1: begin
				sel_rdata = port1_rdata;
				sel_resp = port1_resp;
			end
			2'd2: begin
				sel_rdata = port2_rdata;
				sel_resp = port2_resp;
			end
			default: begin
				sel_rdata = 1'sb0;
				sel_resp = 2'b10;
			end
		endcase
	end
	assign dmem_req_ack = sel_req_ack;
	assign dmem_rdata = sel_rdata;
	assign dmem_resp = sel_resp;
	always @(*) begin
		if (_sv2v_0)
			;
		port0_req = 1'b0;
		case (fsm)
			1'd0: port0_req = dmem_req & (port_sel == 2'd0);
			1'd1:
				if (sel_resp == 2'b01)
					port0_req = dmem_req & (port_sel == 2'd0);
			default:
				;
		endcase
	end
	assign port0_cmd = dmem_cmd;
	assign port0_width = dmem_width;
	assign port0_addr = dmem_addr;
	assign port0_wdata = dmem_wdata;
	always @(*) begin
		if (_sv2v_0)
			;
		port1_req = 1'b0;
		case (fsm)
			1'd0: port1_req = dmem_req & (port_sel == 2'd1);
			1'd1:
				if (sel_resp == 2'b01)
					port1_req = dmem_req & (port_sel == 2'd1);
			default:
				;
		endcase
	end
	assign port1_cmd = dmem_cmd;
	assign port1_width = dmem_width;
	assign port1_addr = dmem_addr;
	assign port1_wdata = dmem_wdata;
	always @(*) begin
		if (_sv2v_0)
			;
		port2_req = 1'b0;
		case (fsm)
			1'd0: port2_req = dmem_req & (port_sel == 2'd2);
			1'd1:
				if (sel_resp == 2'b01)
					port2_req = dmem_req & (port_sel == 2'd2);
			default:
				;
		endcase
	end
	assign port2_cmd = dmem_cmd;
	assign port2_width = dmem_width;
	assign port2_addr = dmem_addr;
	assign port2_wdata = dmem_wdata;
	initial _sv2v_0 = 0;
endmodule
