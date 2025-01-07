/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_timer (
	rst_n,
	clk,
	rtc_clk,
	dmem_req,
	dmem_cmd,
	dmem_width,
	dmem_addr,
	dmem_wdata,
	dmem_req_ack,
	dmem_rdata,
	dmem_resp,
	timer_val,
	timer_irq
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	input wire rtc_clk;
	input wire dmem_req;
	input wire dmem_cmd;
	input wire [1:0] dmem_width;
	input wire [31:0] dmem_addr;
	input wire [31:0] dmem_wdata;
	output wire dmem_req_ack;
	output reg [31:0] dmem_rdata;
	output reg [1:0] dmem_resp;
	output wire [63:0] timer_val;
	output reg timer_irq;
	localparam [31:0] SCR1_TIMER_ADDR_WIDTH = 5;
	localparam [4:0] SCR1_TIMER_CONTROL = 5'h00;
	localparam [4:0] SCR1_TIMER_DIVIDER = 5'h04;
	localparam [4:0] SCR1_TIMER_MTIMELO = 5'h08;
	localparam [4:0] SCR1_TIMER_MTIMEHI = 5'h0c;
	localparam [4:0] SCR1_TIMER_MTIMECMPLO = 5'h10;
	localparam [4:0] SCR1_TIMER_MTIMECMPHI = 5'h14;
	localparam [31:0] SCR1_TIMER_CONTROL_EN_OFFSET = 0;
	localparam [31:0] SCR1_TIMER_CONTROL_CLKSRC_OFFSET = 1;
	localparam [31:0] SCR1_TIMER_DIVIDER_WIDTH = 10;
	reg [63:0] mtime_reg;
	reg [63:0] mtime_new;
	reg [63:0] mtimecmp_reg;
	reg [63:0] mtimecmp_new;
	reg timer_en;
	reg timer_clksrc_rtc;
	reg [9:0] timer_div;
	reg control_up;
	reg divider_up;
	reg mtimelo_up;
	reg mtimehi_up;
	reg mtimecmplo_up;
	reg mtimecmphi_up;
	wire dmem_req_valid;
	reg [3:0] rtc_sync;
	wire rtc_ext_pulse;
	reg [9:0] timeclk_cnt;
	wire timeclk_cnt_en;
	wire time_posedge;
	wire time_cmp_flag;
	always @(posedge clk or negedge rst_n)
		if (~rst_n) begin
			timer_en <= 1'b1;
			timer_clksrc_rtc <= 1'b0;
		end
		else if (control_up) begin
			timer_en <= dmem_wdata[SCR1_TIMER_CONTROL_EN_OFFSET];
			timer_clksrc_rtc <= dmem_wdata[SCR1_TIMER_CONTROL_CLKSRC_OFFSET];
		end
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			timer_div <= 1'sb0;
		else if (divider_up)
			timer_div <= dmem_wdata[9:0];
	assign time_posedge = timeclk_cnt_en & (timeclk_cnt == 0);
	always @(*) begin
		if (_sv2v_0)
			;
		mtime_new = mtime_reg;
		if (time_posedge)
			mtime_new = mtime_reg + 1'b1;
		if (mtimelo_up)
			mtime_new[31:0] = dmem_wdata;
		if (mtimehi_up)
			mtime_new[63:32] = dmem_wdata;
	end
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			mtime_reg <= 1'sb0;
		else if ((time_posedge | mtimelo_up) | mtimehi_up)
			mtime_reg <= mtime_new;
	always @(*) begin
		if (_sv2v_0)
			;
		mtimecmp_new = mtimecmp_reg;
		if (mtimecmplo_up)
			mtimecmp_new[31:0] = dmem_wdata;
		if (mtimecmphi_up)
			mtimecmp_new[63:32] = dmem_wdata;
	end
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			mtimecmp_reg <= 1'sb0;
		else if (mtimecmplo_up | mtimecmphi_up)
			mtimecmp_reg <= mtimecmp_new;
	assign time_cmp_flag = mtime_reg >= (mtimecmplo_up | mtimecmphi_up ? mtimecmp_new : mtimecmp_reg);
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			timer_irq <= 1'b0;
		else if (~timer_irq)
			timer_irq <= time_cmp_flag;
		else if (mtimecmplo_up | mtimecmphi_up)
			timer_irq <= time_cmp_flag;
	assign timeclk_cnt_en = (~timer_clksrc_rtc ? 1'b1 : rtc_ext_pulse) & timer_en;
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			timeclk_cnt <= 1'sb0;
		else
			case (1'b1)
				divider_up: timeclk_cnt <= dmem_wdata[9:0];
				time_posedge: timeclk_cnt <= timer_div;
				timeclk_cnt_en: timeclk_cnt <= timeclk_cnt - 1'b1;
				default:
					;
			endcase
	assign rtc_ext_pulse = rtc_sync[3] ^ rtc_sync[2];
	always @(negedge rst_n or posedge rtc_clk)
		if (~rst_n)
			rtc_sync[0] <= 1'b0;
		else if (timer_clksrc_rtc)
			rtc_sync[0] <= ~rtc_sync[0];
	always @(negedge rst_n or posedge clk)
		if (~rst_n)
			rtc_sync[3:1] <= 1'sb0;
		else if (timer_clksrc_rtc)
			rtc_sync[3:1] <= rtc_sync[2:0];
	assign dmem_req_valid = ((dmem_width == 2'b10) & ~|dmem_addr[1:0]) & (dmem_addr[4:2] <= SCR1_TIMER_MTIMECMPHI[4:2]);
	assign dmem_req_ack = 1'b1;
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	always @(negedge rst_n or posedge clk)
		if (~rst_n) begin
			dmem_resp <= 2'b00;
			dmem_rdata <= 1'sb0;
		end
		else if (dmem_req) begin
			if (dmem_req_valid) begin
				dmem_resp <= 2'b01;
				if (dmem_cmd == 1'b0)
					case (dmem_addr[4:0])
						SCR1_TIMER_CONTROL: dmem_rdata <= sv2v_cast_32({timer_clksrc_rtc, timer_en});
						SCR1_TIMER_DIVIDER: dmem_rdata <= sv2v_cast_32(timer_div);
						SCR1_TIMER_MTIMELO: dmem_rdata <= mtime_reg[31:0];
						SCR1_TIMER_MTIMEHI: dmem_rdata <= mtime_reg[63:32];
						SCR1_TIMER_MTIMECMPLO: dmem_rdata <= mtimecmp_reg[31:0];
						SCR1_TIMER_MTIMECMPHI: dmem_rdata <= mtimecmp_reg[63:32];
						default:
							;
					endcase
			end
			else
				dmem_resp <= 2'b10;
		end
		else begin
			dmem_resp <= 2'b00;
			dmem_rdata <= 1'sb0;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		control_up = 1'b0;
		divider_up = 1'b0;
		mtimelo_up = 1'b0;
		mtimehi_up = 1'b0;
		mtimecmplo_up = 1'b0;
		mtimecmphi_up = 1'b0;
		if ((dmem_req & dmem_req_valid) & (dmem_cmd == 1'b1))
			case (dmem_addr[4:0])
				SCR1_TIMER_CONTROL: control_up = 1'b1;
				SCR1_TIMER_DIVIDER: divider_up = 1'b1;
				SCR1_TIMER_MTIMELO: mtimelo_up = 1'b1;
				SCR1_TIMER_MTIMEHI: mtimehi_up = 1'b1;
				SCR1_TIMER_MTIMECMPLO: mtimecmplo_up = 1'b1;
				SCR1_TIMER_MTIMECMPHI: mtimecmphi_up = 1'b1;
				default:
					;
			endcase
	end
	assign timer_val = mtime_reg;
	initial _sv2v_0 = 0;
endmodule
