/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_mem_axi (
	clk,
	rst_n,
	axi_reinit,
	core_idle,
	core_req_ack,
	core_req,
	core_cmd,
	core_width,
	core_addr,
	core_wdata,
	core_rdata,
	core_resp,
	awid,
	awaddr,
	awlen,
	awsize,
	awburst,
	awlock,
	awcache,
	awprot,
	awregion,
	awuser,
	awqos,
	awvalid,
	awready,
	wdata,
	wstrb,
	wlast,
	wuser,
	wvalid,
	wready,
	bid,
	bresp,
	bvalid,
	buser,
	bready,
	arid,
	araddr,
	arlen,
	arsize,
	arburst,
	arlock,
	arcache,
	arprot,
	arregion,
	aruser,
	arqos,
	arvalid,
	arready,
	rid,
	rdata,
	rresp,
	rlast,
	ruser,
	rvalid,
	rready
);
	reg _sv2v_0;
	parameter SCR1_REQ_BUF_SIZE = 2;
	parameter SCR1_AXI_IDWIDTH = 4;
	parameter SCR1_ADDR_WIDTH = 32;
	parameter SCR1_AXI_REQ_BP = 1;
	parameter SCR1_AXI_RESP_BP = 1;
	input wire clk;
	input wire rst_n;
	input wire axi_reinit;
	output reg core_idle;
	output wire core_req_ack;
	input wire core_req;
	input wire core_cmd;
	input wire [1:0] core_width;
	input wire [SCR1_ADDR_WIDTH - 1:0] core_addr;
	input wire [31:0] core_wdata;
	output reg [31:0] core_rdata;
	output reg [1:0] core_resp;
	output wire [SCR1_AXI_IDWIDTH - 1:0] awid;
	output wire [SCR1_ADDR_WIDTH - 1:0] awaddr;
	output wire [7:0] awlen;
	output wire [2:0] awsize;
	output wire [1:0] awburst;
	output wire awlock;
	output wire [3:0] awcache;
	output wire [2:0] awprot;
	output wire [3:0] awregion;
	output wire [3:0] awuser;
	output wire [3:0] awqos;
	output wire awvalid;
	input wire awready;
	output wire [31:0] wdata;
	output reg [3:0] wstrb;
	output wire wlast;
	output wire [3:0] wuser;
	output wire wvalid;
	input wire wready;
	input wire [SCR1_AXI_IDWIDTH - 1:0] bid;
	input wire [1:0] bresp;
	input wire bvalid;
	input wire [3:0] buser;
	output wire bready;
	output wire [SCR1_AXI_IDWIDTH - 1:0] arid;
	output wire [SCR1_ADDR_WIDTH - 1:0] araddr;
	output wire [7:0] arlen;
	output wire [2:0] arsize;
	output wire [1:0] arburst;
	output wire arlock;
	output wire [3:0] arcache;
	output wire [2:0] arprot;
	output wire [3:0] arregion;
	output wire [3:0] aruser;
	output wire [3:0] arqos;
	output wire arvalid;
	input wire arready;
	input wire [SCR1_AXI_IDWIDTH - 1:0] rid;
	input wire [31:0] rdata;
	input wire [1:0] rresp;
	input wire rlast;
	input wire [3:0] ruser;
	input wire rvalid;
	output wire rready;
	function automatic [2:0] width2axsize;
		input reg [1:0] width;
		reg [2:0] axsize;
		begin
			case (width)
				2'b00: axsize = 3'b000;
				2'b01: axsize = 3'b001;
				2'b10: axsize = 3'b010;
				default: axsize = 1'sbx;
			endcase
			width2axsize = axsize;
		end
	endfunction
	reg [(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (SCR1_REQ_BUF_SIZE * ((2 + SCR1_ADDR_WIDTH) + 32)) - 1 : (SCR1_REQ_BUF_SIZE * (1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + ((2 + SCR1_ADDR_WIDTH) + 30)):(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 0 : (2 + SCR1_ADDR_WIDTH) + 31)] req_fifo;
	reg [(SCR1_REQ_BUF_SIZE * 4) - 1:0] req_status;
	reg [(SCR1_REQ_BUF_SIZE * 4) - 1:0] req_status_new;
	reg [SCR1_REQ_BUF_SIZE - 1:0] req_status_en;
	reg [$clog2(SCR1_REQ_BUF_SIZE) - 1:0] req_aval_ptr;
	reg [$clog2(SCR1_REQ_BUF_SIZE) - 1:0] req_proc_ptr;
	reg [$clog2(SCR1_REQ_BUF_SIZE) - 1:0] req_done_ptr;
	wire rresp_err;
	reg [31:0] rcvd_rdata;
	reg [1:0] rcvd_resp;
	wire force_read;
	wire force_write;
	assign core_req_ack = (~axi_reinit & ~req_status[req_aval_ptr * 4]) & (core_resp != 2'b10);
	assign rready = ~req_status[(req_done_ptr * 4) + 3];
	assign bready = req_status[(req_done_ptr * 4) + 3];
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	assign force_read = (((sv2v_cast_1(SCR1_AXI_REQ_BP) & core_req) & core_req_ack) & (req_aval_ptr == req_proc_ptr)) & (core_cmd == 1'b0);
	assign force_write = (((sv2v_cast_1(SCR1_AXI_REQ_BP) & core_req) & core_req_ack) & (req_aval_ptr == req_proc_ptr)) & (core_cmd == 1'b1);
	always @(*) begin : idle_status
		if (_sv2v_0)
			;
		core_idle = 1'b1;
		begin : sv2v_autoblock_1
			reg [31:0] i;
			for (i = 0; i < SCR1_REQ_BUF_SIZE; i = i + 1)
				core_idle = core_idle & (req_status[i * 4] == 1'b0);
		end
	end
	always @(posedge clk)
		if (core_req & core_req_ack) begin
			req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_aval_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31))) : (((req_aval_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31)))) + ((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)) - 1)-:((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)] <= core_width;
			req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_aval_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? SCR1_ADDR_WIDTH + 31 : ((2 + SCR1_ADDR_WIDTH) + 31) - (SCR1_ADDR_WIDTH + 31)) : (((req_aval_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? SCR1_ADDR_WIDTH + 31 : ((2 + SCR1_ADDR_WIDTH) + 31) - (SCR1_ADDR_WIDTH + 31))) + ((SCR1_ADDR_WIDTH + 31) >= 32 ? SCR1_ADDR_WIDTH + 0 : 33 - (SCR1_ADDR_WIDTH + 31))) - 1)-:((SCR1_ADDR_WIDTH + 31) >= 32 ? SCR1_ADDR_WIDTH + 0 : 33 - (SCR1_ADDR_WIDTH + 31))] <= core_addr;
			req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_aval_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 31 : (2 + SCR1_ADDR_WIDTH) + 0) : ((req_aval_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 31 : (2 + SCR1_ADDR_WIDTH) + 0)) + 31)-:32] <= core_wdata;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		req_status_en = 1'sb0;
		req_status_new = req_status;
		if (core_req & core_req_ack) begin
			req_status_en[req_aval_ptr] = 1'd1;
			req_status_new[req_aval_ptr * 4] = 1'd1;
			req_status_new[(req_aval_ptr * 4) + 3] = core_cmd == 1'b1;
			req_status_new[(req_aval_ptr * 4) + 2] = ~((force_read & arready) | (force_write & awready));
			req_status_new[(req_aval_ptr * 4) + 1] = ~(((force_write & wready) & (awlen == 8'd0)) | (~force_write & (core_cmd == 1'b0)));
		end
		if ((awvalid & awready) | (arvalid & arready)) begin
			req_status_en[req_proc_ptr] = 1'd1;
			req_status_new[(req_proc_ptr * 4) + 2] = 1'd0;
		end
		if ((wvalid & wready) & wlast) begin
			req_status_en[req_proc_ptr] = 1'd1;
			req_status_new[(req_proc_ptr * 4) + 1] = 1'd0;
		end
		if ((bvalid & bready) | ((rvalid & rready) & rlast)) begin
			req_status_en[req_done_ptr] = 1'd1;
			req_status_new[req_done_ptr * 4] = 1'd0;
		end
	end
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			req_status <= 1'sb0;
		else begin : sv2v_autoblock_2
			reg [31:0] i;
			for (i = 0; i < SCR1_REQ_BUF_SIZE; i = i + 1)
				if (req_status_en[i])
					req_status[i * 4+:4] <= req_status_new[i * 4+:4];
		end
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			req_aval_ptr <= 1'sb0;
		else if (core_req & core_req_ack)
			req_aval_ptr <= req_aval_ptr + 1'b1;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			req_proc_ptr <= 1'sb0;
		else if (((((((awvalid & awready) & wvalid) & wready) & wlast) | (((~force_write & ~req_status[(req_proc_ptr * 4) + 1]) & awvalid) & awready)) | ((((~force_write & ~req_status[(req_proc_ptr * 4) + 2]) & wvalid) & wready) & wlast)) | ((~req_status[(req_proc_ptr * 4) + 1] & arvalid) & arready))
			req_proc_ptr <= req_proc_ptr + 1'b1;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			req_done_ptr <= 1'sb0;
		else if (((bvalid & bready) | ((rvalid & rready) & rlast)) & req_status[req_done_ptr * 4])
			req_done_ptr <= req_done_ptr + 1'b1;
	assign arvalid = (req_status[(req_proc_ptr * 4) + 2] & ~req_status[(req_proc_ptr * 4) + 3]) | force_read;
	assign awvalid = (req_status[(req_proc_ptr * 4) + 2] & req_status[(req_proc_ptr * 4) + 3]) | force_write;
	assign wvalid = (req_status[(req_proc_ptr * 4) + 1] & req_status[(req_proc_ptr * 4) + 3]) | force_write;
	assign araddr = (~force_read ? req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? SCR1_ADDR_WIDTH + 31 : ((2 + SCR1_ADDR_WIDTH) + 31) - (SCR1_ADDR_WIDTH + 31)) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? SCR1_ADDR_WIDTH + 31 : ((2 + SCR1_ADDR_WIDTH) + 31) - (SCR1_ADDR_WIDTH + 31))) + ((SCR1_ADDR_WIDTH + 31) >= 32 ? SCR1_ADDR_WIDTH + 0 : 33 - (SCR1_ADDR_WIDTH + 31))) - 1)-:((SCR1_ADDR_WIDTH + 31) >= 32 ? SCR1_ADDR_WIDTH + 0 : 33 - (SCR1_ADDR_WIDTH + 31))] : core_addr);
	assign awaddr = (~force_write ? req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? SCR1_ADDR_WIDTH + 31 : ((2 + SCR1_ADDR_WIDTH) + 31) - (SCR1_ADDR_WIDTH + 31)) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? SCR1_ADDR_WIDTH + 31 : ((2 + SCR1_ADDR_WIDTH) + 31) - (SCR1_ADDR_WIDTH + 31))) + ((SCR1_ADDR_WIDTH + 31) >= 32 ? SCR1_ADDR_WIDTH + 0 : 33 - (SCR1_ADDR_WIDTH + 31))) - 1)-:((SCR1_ADDR_WIDTH + 31) >= 32 ? SCR1_ADDR_WIDTH + 0 : 33 - (SCR1_ADDR_WIDTH + 31))] : core_addr);
	always @(*) begin
		if (_sv2v_0)
			;
		if ((bvalid & bready) & req_status[req_done_ptr * 4])
			rcvd_resp = (bresp == 2'b00 ? 2'b01 : 2'b10);
		else if (((rvalid & rready) & rlast) & req_status[req_done_ptr * 4])
			rcvd_resp = (rresp == 2'b00 ? 2'b01 : 2'b10);
		else
			rcvd_resp = 2'b00;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		if (force_write)
			case (core_width)
				2'b00: wstrb = 4'h1 << core_addr[1:0];
				2'b01: wstrb = 4'h3 << core_addr[1:0];
				2'b10: wstrb = 4'hf << core_addr[1:0];
				default: wstrb = 1'sbx;
			endcase
		else
			case (req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31))) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31)))) + ((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)) - 1)-:((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)])
				2'b00: wstrb = 4'h1 << req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1))) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)-:(((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)];
				2'b01: wstrb = 4'h3 << req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1))) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)-:(((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)];
				2'b10: wstrb = 4'hf << req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1))) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)-:(((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)];
				default: wstrb = 1'sbx;
			endcase
	end
	assign wdata = (force_write ? core_wdata << (8 * core_addr[1:0]) : req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 31 : (2 + SCR1_ADDR_WIDTH) + 0) : ((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 31 : (2 + SCR1_ADDR_WIDTH) + 0)) + 31)-:32] << (8 * req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1))) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)-:(((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)]));
	always @(*) begin
		if (_sv2v_0)
			;
		case (req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_done_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31))) : (((req_done_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31)))) + ((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)) - 1)-:((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)])
			2'b00: rcvd_rdata = rdata >> (8 * req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_done_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)) : (((req_done_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1))) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)-:(((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)]);
			2'b01: rcvd_rdata = rdata >> (8 * req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_done_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)) : (((req_done_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1))) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)-:(((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)]);
			2'b10: rcvd_rdata = rdata >> (8 * req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_done_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)) : (((req_done_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1) : ((2 + SCR1_ADDR_WIDTH) + 31) - (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2) : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1))) + (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)) - 1)-:(((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) >= ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) ? (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1))) + 1 : (((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 1)) - ((SCR1_ADDR_WIDTH + 31) - (SCR1_ADDR_WIDTH - 2))) + 1)]);
			default: rcvd_rdata = 1'sbx;
		endcase
	end
	generate
		if (SCR1_AXI_RESP_BP == 1) begin : axi_resp_bp
			wire [32:1] sv2v_tmp_30EEB;
			assign sv2v_tmp_30EEB = ((rvalid & rready) & rlast ? rcvd_rdata : {32 {1'sb0}});
			always @(*) core_rdata = sv2v_tmp_30EEB;
			wire [2:1] sv2v_tmp_0082D;
			assign sv2v_tmp_0082D = (axi_reinit ? 2'b00 : rcvd_resp);
			always @(*) core_resp = sv2v_tmp_0082D;
		end
		else begin : axi_resp_no_bp
			always @(negedge rst_n or posedge clk)
				if (~rst_n)
					core_resp <= 2'b00;
				else
					core_resp <= (axi_reinit ? 2'b00 : rcvd_resp);
			always @(posedge clk)
				if ((rvalid & rready) & rlast)
					core_rdata <= rcvd_rdata;
		end
	endgenerate
	function automatic signed [SCR1_AXI_IDWIDTH - 1:0] sv2v_cast_77DED_signed;
		input reg signed [SCR1_AXI_IDWIDTH - 1:0] inp;
		sv2v_cast_77DED_signed = inp;
	endfunction
	assign awid = sv2v_cast_77DED_signed(1);
	assign awlen = 8'd0;
	assign awsize = (force_write ? width2axsize(core_width) : width2axsize(req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31))) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31)))) + ((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)) - 1)-:((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)]));
	assign awburst = 2'd1;
	assign awcache = 4'd2;
	assign awlock = 1'sb0;
	assign awprot = 1'sb0;
	assign awregion = 1'sb0;
	assign awuser = 1'sb0;
	assign awqos = 1'sb0;
	assign arid = sv2v_cast_77DED_signed(0);
	assign arlen = 8'd0;
	assign arsize = (force_read ? width2axsize(core_width) : width2axsize(req_fifo[(((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31))) : (((req_proc_ptr * (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? (2 + SCR1_ADDR_WIDTH) + 32 : 1 - ((2 + SCR1_ADDR_WIDTH) + 31))) + (((2 + SCR1_ADDR_WIDTH) + 31) >= 0 ? 2 + (SCR1_ADDR_WIDTH + 31) : ((2 + SCR1_ADDR_WIDTH) + 31) - (2 + (SCR1_ADDR_WIDTH + 31)))) + ((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)) - 1)-:((2 + (SCR1_ADDR_WIDTH + 31)) >= (SCR1_ADDR_WIDTH + 32) ? ((2 + (SCR1_ADDR_WIDTH + 31)) - (SCR1_ADDR_WIDTH + 32)) + 1 : ((SCR1_ADDR_WIDTH + 32) - (2 + (SCR1_ADDR_WIDTH + 31))) + 1)]));
	assign arburst = 2'd1;
	assign arcache = 4'd2;
	assign arprot = 1'sb0;
	assign arregion = 1'sb0;
	assign arlock = 1'sb0;
	assign arqos = 1'sb0;
	assign aruser = 1'sb0;
	assign wlast = 1'd1;
	assign wuser = 1'sb0;
	initial _sv2v_0 = 0;
endmodule
