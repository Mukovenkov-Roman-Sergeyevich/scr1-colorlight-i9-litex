/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_pipe_idu (
	idu2ifu_rdy_o,
	ifu2idu_instr_i,
	ifu2idu_imem_err_i,
	ifu2idu_err_rvi_hi_i,
	ifu2idu_vd_i,
	idu2exu_req_o,
	idu2exu_cmd_o,
	idu2exu_use_rs1_o,
	idu2exu_use_rs2_o,
	idu2exu_use_rd_o,
	idu2exu_use_imm_o,
	exu2idu_rdy_i
);
	reg _sv2v_0;
	output wire idu2ifu_rdy_o;
	input wire [31:0] ifu2idu_instr_i;
	input wire ifu2idu_imem_err_i;
	input wire ifu2idu_err_rvi_hi_i;
	input wire ifu2idu_vd_i;
	output wire idu2exu_req_o;
	localparam SCR1_GPR_FIELD_WIDTH = 5;
	localparam SCR1_CSR_CMD_ALL_NUM_E = 4;
	localparam SCR1_CSR_CMD_WIDTH_E = 2;
	localparam SCR1_CSR_OP_ALL_NUM_E = 2;
	localparam SCR1_CSR_OP_WIDTH_E = 1;
	localparam [31:0] SCR1_EXC_CODE_WIDTH_E = 4;
	localparam SCR1_IALU_CMD_ALL_NUM_E = 23;
	localparam SCR1_IALU_CMD_WIDTH_E = 5;
	localparam SCR1_IALU_OP_ALL_NUM_E = 2;
	localparam SCR1_IALU_OP_WIDTH_E = 1;
	localparam SCR1_SUM2_OP_ALL_NUM_E = 2;
	localparam SCR1_SUM2_OP_WIDTH_E = 1;
	localparam SCR1_LSU_CMD_ALL_NUM_E = 9;
	localparam SCR1_LSU_CMD_WIDTH_E = 4;
	localparam SCR1_RD_WB_ALL_NUM_E = 7;
	localparam SCR1_RD_WB_WIDTH_E = 3;
	output reg [74:0] idu2exu_cmd_o;
	output reg idu2exu_use_rs1_o;
	output reg idu2exu_use_rs2_o;
	output reg idu2exu_use_rd_o;
	output reg idu2exu_use_imm_o;
	input wire exu2idu_rdy_i;
	localparam [4:0] SCR1_MPRF_ZERO_ADDR = 5'd0;
	localparam [4:0] SCR1_MPRF_RA_ADDR = 5'd1;
	localparam [4:0] SCR1_MPRF_SP_ADDR = 5'd2;
	wire [31:0] instr;
	wire [1:0] instr_type;
	wire [6:2] rvi_opcode;
	reg rvi_illegal;
	wire [2:0] funct3;
	wire [6:0] funct7;
	wire [11:0] funct12;
	wire [4:0] shamt;
	reg rvc_illegal;
	assign idu2ifu_rdy_o = exu2idu_rdy_i;
	assign idu2exu_req_o = ifu2idu_vd_i;
	assign instr = ifu2idu_instr_i;
	assign instr_type = instr[1:0];
	assign rvi_opcode = instr[6:2];
	assign funct3 = (instr_type == 2'b11 ? instr[14:12] : instr[15:13]);
	assign funct7 = instr[31:25];
	assign funct12 = instr[31:20];
	assign shamt = instr[24:20];
	function automatic [0:0] sv2v_cast_EFCFF;
		input reg [0:0] inp;
		sv2v_cast_EFCFF = inp;
	endfunction
	function automatic [4:0] sv2v_cast_305D4;
		input reg [4:0] inp;
		sv2v_cast_305D4 = inp;
	endfunction
	function automatic [0:0] sv2v_cast_64327;
		input reg [0:0] inp;
		sv2v_cast_64327 = inp;
	endfunction
	function automatic [3:0] sv2v_cast_268FE;
		input reg [3:0] inp;
		sv2v_cast_268FE = inp;
	endfunction
	function automatic [0:0] sv2v_cast_E449B;
		input reg [0:0] inp;
		sv2v_cast_E449B = inp;
	endfunction
	function automatic [1:0] sv2v_cast_AF896;
		input reg [1:0] inp;
		sv2v_cast_AF896 = inp;
	endfunction
	function automatic [2:0] sv2v_cast_FEE4F;
		input reg [2:0] inp;
		sv2v_cast_FEE4F = inp;
	endfunction
	function automatic [3:0] sv2v_cast_92043;
		input reg [3:0] inp;
		sv2v_cast_92043 = inp;
	endfunction
	function automatic [2:0] sv2v_cast_4D524;
		input reg [2:0] inp;
		sv2v_cast_4D524 = inp;
	endfunction
	function automatic [3:0] sv2v_cast_4A511;
		input reg [3:0] inp;
		sv2v_cast_4A511 = inp;
	endfunction
	function automatic [4:0] sv2v_cast_9DDEB;
		input reg [4:0] inp;
		sv2v_cast_9DDEB = inp;
	endfunction
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	function automatic [1:0] sv2v_cast_999B9;
		input reg [1:0] inp;
		sv2v_cast_999B9 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		idu2exu_cmd_o[74] = 1'b0;
		idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
		idu2exu_cmd_o[72-:5] = sv2v_cast_305D4(1'sb0);
		idu2exu_cmd_o[67-:1] = sv2v_cast_64327(0);
		idu2exu_cmd_o[66-:4] = sv2v_cast_268FE(1'sb0);
		idu2exu_cmd_o[62-:1] = sv2v_cast_E449B(1);
		idu2exu_cmd_o[61-:2] = sv2v_cast_AF896(1'sb0);
		idu2exu_cmd_o[59-:3] = sv2v_cast_FEE4F(1'sb0);
		idu2exu_cmd_o[56] = 1'b0;
		idu2exu_cmd_o[55] = 1'b0;
		idu2exu_cmd_o[54] = 1'b0;
		idu2exu_cmd_o[53] = 1'b0;
		idu2exu_cmd_o[52] = 1'b0;
		idu2exu_cmd_o[51-:5] = 1'sb0;
		idu2exu_cmd_o[46-:5] = 1'sb0;
		idu2exu_cmd_o[41-:5] = 1'sb0;
		idu2exu_cmd_o[36-:32] = 1'sb0;
		idu2exu_cmd_o[4] = 1'b0;
		idu2exu_cmd_o[3-:SCR1_EXC_CODE_WIDTH_E] = sv2v_cast_92043(4'd0);
		idu2exu_use_rs1_o = 1'b0;
		idu2exu_use_rs2_o = 1'b0;
		idu2exu_use_rd_o = 1'b0;
		idu2exu_use_imm_o = 1'b0;
		rvi_illegal = 1'b0;
		rvc_illegal = 1'b0;
		if (ifu2idu_imem_err_i) begin
			idu2exu_cmd_o[4] = 1'b1;
			idu2exu_cmd_o[3-:SCR1_EXC_CODE_WIDTH_E] = sv2v_cast_92043(4'd1);
			idu2exu_cmd_o[74] = ifu2idu_err_rvi_hi_i;
		end
		else
			case (instr_type)
				2'b11: begin
					idu2exu_cmd_o[51-:5] = instr[19:15];
					idu2exu_cmd_o[46-:5] = instr[24:20];
					idu2exu_cmd_o[41-:5] = instr[11:7];
					case (rvi_opcode)
						5'b00101: begin
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(0);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 2);
							idu2exu_cmd_o[36-:32] = {instr[31:12], 12'b000000000000};
						end
						5'b01101: begin
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 3);
							idu2exu_cmd_o[36-:32] = {instr[31:12], 12'b000000000000};
						end
						5'b11011: begin
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(0);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 4);
							idu2exu_cmd_o[56] = 1'b1;
							idu2exu_cmd_o[36-:32] = {{12 {instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
						end
						5'b00000: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 5);
							idu2exu_cmd_o[36-:32] = {{21 {instr[31]}}, instr[30:20]};
							case (funct3)
								3'b000: idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 1);
								3'b001: idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 2);
								3'b010: idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 3);
								3'b100: idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 4);
								3'b101: idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 5);
								default: rvi_illegal = 1'b1;
							endcase
						end
						5'b01000: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rs2_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
							idu2exu_cmd_o[36-:32] = {{21 {instr[31]}}, instr[30:25], instr[11:7]};
							case (funct3)
								3'b000: idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 6);
								3'b001: idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 7);
								3'b010: idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 8);
								default: rvi_illegal = 1'b1;
							endcase
						end
						5'b01100: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rs2_o = 1'b1;
							idu2exu_use_rd_o = 1'b1;
							idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
							case (funct7)
								7'b0000000:
									case (funct3)
										3'b000: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 4);
										3'b001: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 12);
										3'b010: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 6);
										3'b011: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 7);
										3'b100: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 3);
										3'b101: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 13);
										3'b110: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 2);
										3'b111: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 1);
									endcase
								7'b0100000:
									case (funct3)
										3'b000: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 5);
										3'b101: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 14);
										default: rvi_illegal = 1'b1;
									endcase
								7'b0000001:
									case (funct3)
										3'b000: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 15);
										3'b001: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 18);
										3'b010: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 17);
										3'b011: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 16);
										3'b100: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 19);
										3'b101: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 20);
										3'b110: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 21);
										3'b111: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 22);
									endcase
								default: rvi_illegal = 1'b1;
							endcase
						end
						5'b00100: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[36-:32] = {{21 {instr[31]}}, instr[30:20]};
							idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(0);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
							case (funct3)
								3'b000: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 4);
								3'b010: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 6);
								3'b011: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 7);
								3'b100: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 3);
								3'b110: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 2);
								3'b111: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 1);
								3'b001:
									case (funct7)
										7'b0000000: begin
											idu2exu_cmd_o[36-:32] = sv2v_cast_32(shamt);
											idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 12);
										end
										default: rvi_illegal = 1'b1;
									endcase
								3'b101:
									case (funct7)
										7'b0000000: begin
											idu2exu_cmd_o[36-:32] = sv2v_cast_32(shamt);
											idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 13);
										end
										7'b0100000: begin
											idu2exu_cmd_o[36-:32] = sv2v_cast_32(shamt);
											idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 14);
										end
										default: rvi_illegal = 1'b1;
									endcase
							endcase
						end
						5'b00011:
							case (funct3)
								3'b000:
									if (~|{instr[31:28], instr[19:15], instr[11:7]})
										;
									else
										rvi_illegal = 1'b1;
								3'b001:
									if (~|{instr[31:15], instr[11:7]})
										idu2exu_cmd_o[53] = 1'b1;
									else
										rvi_illegal = 1'b1;
								default: rvi_illegal = 1'b1;
							endcase
						5'b11000: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rs2_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[36-:32] = {{20 {instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
							idu2exu_cmd_o[55] = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(0);
							idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
							case (funct3)
								3'b000: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 8);
								3'b001: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 9);
								3'b100: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 6);
								3'b101: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 10);
								3'b110: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 7);
								3'b111: idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 11);
								default: rvi_illegal = 1'b1;
							endcase
						end
						5'b11001: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							case (funct3)
								3'b000: begin
									idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 4);
									idu2exu_cmd_o[56] = 1'b1;
									idu2exu_cmd_o[36-:32] = {{21 {instr[31]}}, instr[30:20]};
								end
								default: rvi_illegal = 1'b1;
							endcase
						end
						5'b11100: begin
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[36-:32] = sv2v_cast_32({funct3, instr[31:20]});
							case (funct3)
								3'b000: begin
									idu2exu_use_rd_o = 1'b0;
									idu2exu_use_imm_o = 1'b0;
									case ({instr[19:15], instr[11:7]})
										10'd0:
											case (funct12)
												12'h000: begin
													idu2exu_cmd_o[4] = 1'b1;
													idu2exu_cmd_o[3-:SCR1_EXC_CODE_WIDTH_E] = sv2v_cast_92043(4'd11);
												end
												12'h001: begin
													idu2exu_cmd_o[4] = 1'b1;
													idu2exu_cmd_o[3-:SCR1_EXC_CODE_WIDTH_E] = sv2v_cast_92043(4'd3);
												end
												12'h302: idu2exu_cmd_o[54] = 1'b1;
												12'h105: idu2exu_cmd_o[52] = 1'b1;
												default: rvi_illegal = 1'b1;
											endcase
										default: rvi_illegal = 1'b1;
									endcase
								end
								3'b001: begin
									idu2exu_use_rs1_o = 1'b1;
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 6);
									idu2exu_cmd_o[61-:2] = sv2v_cast_999B9({32 {1'sb0}} + 1);
									idu2exu_cmd_o[62-:1] = sv2v_cast_E449B(1);
								end
								3'b010: begin
									idu2exu_use_rs1_o = 1'b1;
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 6);
									idu2exu_cmd_o[61-:2] = sv2v_cast_999B9({32 {1'sb0}} + 2);
									idu2exu_cmd_o[62-:1] = sv2v_cast_E449B(1);
								end
								3'b011: begin
									idu2exu_use_rs1_o = 1'b1;
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 6);
									idu2exu_cmd_o[61-:2] = sv2v_cast_999B9({32 {1'sb0}} + 3);
									idu2exu_cmd_o[62-:1] = sv2v_cast_E449B(1);
								end
								3'b101: begin
									idu2exu_use_rs1_o = 1'b1;
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 6);
									idu2exu_cmd_o[61-:2] = sv2v_cast_999B9({32 {1'sb0}} + 1);
									idu2exu_cmd_o[62-:1] = sv2v_cast_E449B(0);
								end
								3'b110: begin
									idu2exu_use_rs1_o = 1'b1;
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 6);
									idu2exu_cmd_o[61-:2] = sv2v_cast_999B9({32 {1'sb0}} + 2);
									idu2exu_cmd_o[62-:1] = sv2v_cast_E449B(0);
								end
								3'b111: begin
									idu2exu_use_rs1_o = 1'b1;
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 6);
									idu2exu_cmd_o[61-:2] = sv2v_cast_999B9({32 {1'sb0}} + 3);
									idu2exu_cmd_o[62-:1] = sv2v_cast_E449B(0);
								end
								default: rvi_illegal = 1'b1;
							endcase
						end
						default: rvi_illegal = 1'b1;
					endcase
				end
				2'b00: begin
					idu2exu_cmd_o[74] = 1'b1;
					idu2exu_use_rs1_o = 1'b1;
					idu2exu_use_imm_o = 1'b1;
					case (funct3)
						3'b000: begin
							if (~|instr[12:5])
								rvc_illegal = 1'b1;
							idu2exu_use_rd_o = 1'b1;
							idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 4);
							idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(0);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
							idu2exu_cmd_o[51-:5] = SCR1_MPRF_SP_ADDR;
							idu2exu_cmd_o[41-:5] = {2'b01, instr[4:2]};
							idu2exu_cmd_o[36-:32] = {22'd0, instr[10:7], instr[12:11], instr[5], instr[6], 2'b00};
						end
						3'b010: begin
							idu2exu_use_rd_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
							idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 3);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 5);
							idu2exu_cmd_o[51-:5] = {2'b01, instr[9:7]};
							idu2exu_cmd_o[41-:5] = {2'b01, instr[4:2]};
							idu2exu_cmd_o[36-:32] = {25'd0, instr[5], instr[12:10], instr[6], 2'b00};
						end
						3'b110: begin
							idu2exu_use_rs2_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
							idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 8);
							idu2exu_cmd_o[51-:5] = {2'b01, instr[9:7]};
							idu2exu_cmd_o[46-:5] = {2'b01, instr[4:2]};
							idu2exu_cmd_o[36-:32] = {25'd0, instr[5], instr[12:10], instr[6], 2'b00};
						end
						default: rvc_illegal = 1'b1;
					endcase
				end
				2'b01: begin
					idu2exu_cmd_o[74] = 1'b1;
					idu2exu_use_rd_o = 1'b1;
					idu2exu_use_imm_o = 1'b1;
					case (funct3)
						3'b000: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 4);
							idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(0);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
							idu2exu_cmd_o[51-:5] = instr[11:7];
							idu2exu_cmd_o[41-:5] = instr[11:7];
							idu2exu_cmd_o[36-:32] = {{27 {instr[12]}}, instr[6:2]};
						end
						3'b001: begin
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(0);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 4);
							idu2exu_cmd_o[56] = 1'b1;
							idu2exu_cmd_o[41-:5] = SCR1_MPRF_RA_ADDR;
							idu2exu_cmd_o[36-:32] = {{21 {instr[12]}}, instr[8], instr[10:9], instr[6], instr[7], instr[2], instr[11], instr[5:3], 1'b0};
						end
						3'b010: begin
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 3);
							idu2exu_cmd_o[41-:5] = instr[11:7];
							idu2exu_cmd_o[36-:32] = {{27 {instr[12]}}, instr[6:2]};
						end
						3'b011: begin
							if (~|{instr[12], instr[6:2]})
								rvc_illegal = 1'b1;
							if (instr[11:7] == SCR1_MPRF_SP_ADDR) begin
								idu2exu_use_rs1_o = 1'b1;
								idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 4);
								idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(0);
								idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
								idu2exu_cmd_o[51-:5] = SCR1_MPRF_SP_ADDR;
								idu2exu_cmd_o[41-:5] = SCR1_MPRF_SP_ADDR;
								idu2exu_cmd_o[36-:32] = {{23 {instr[12]}}, instr[4:3], instr[5], instr[2], instr[6], 4'd0};
							end
							else begin
								idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 3);
								idu2exu_cmd_o[41-:5] = instr[11:7];
								idu2exu_cmd_o[36-:32] = {{15 {instr[12]}}, instr[6:2], 12'd0};
							end
						end
						3'b100: begin
							idu2exu_cmd_o[51-:5] = {2'b01, instr[9:7]};
							idu2exu_cmd_o[41-:5] = {2'b01, instr[9:7]};
							idu2exu_cmd_o[46-:5] = {2'b01, instr[4:2]};
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rd_o = 1'b1;
							case (instr[11:10])
								2'b00: begin
									if (instr[12])
										rvc_illegal = 1'b1;
									idu2exu_use_imm_o = 1'b1;
									idu2exu_cmd_o[36-:32] = {27'd0, instr[6:2]};
									idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 13);
									idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(0);
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
								end
								2'b01: begin
									if (instr[12])
										rvc_illegal = 1'b1;
									idu2exu_use_imm_o = 1'b1;
									idu2exu_cmd_o[36-:32] = {27'd0, instr[6:2]};
									idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 14);
									idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(0);
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
								end
								2'b10: begin
									idu2exu_use_imm_o = 1'b1;
									idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 1);
									idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(0);
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
									idu2exu_cmd_o[36-:32] = {{27 {instr[12]}}, instr[6:2]};
								end
								2'b11: begin
									idu2exu_use_rs2_o = 1'b1;
									case ({instr[12], instr[6:5]})
										3'b000: begin
											idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 5);
											idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
											idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
										end
										3'b001: begin
											idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 3);
											idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
											idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
										end
										3'b010: begin
											idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 2);
											idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
											idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
										end
										3'b011: begin
											idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 1);
											idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
											idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
										end
										default: rvc_illegal = 1'b1;
									endcase
								end
							endcase
						end
						3'b101: begin
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(0);
							idu2exu_cmd_o[56] = 1'b1;
							idu2exu_cmd_o[36-:32] = {{21 {instr[12]}}, instr[8], instr[10:9], instr[6], instr[7], instr[2], instr[11], instr[5:3], 1'b0};
						end
						3'b110: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rs2_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 8);
							idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(0);
							idu2exu_cmd_o[55] = 1'b1;
							idu2exu_cmd_o[51-:5] = {2'b01, instr[9:7]};
							idu2exu_cmd_o[46-:5] = SCR1_MPRF_ZERO_ADDR;
							idu2exu_cmd_o[36-:32] = {{24 {instr[12]}}, instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0};
						end
						3'b111: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rs2_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 9);
							idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(0);
							idu2exu_cmd_o[55] = 1'b1;
							idu2exu_cmd_o[51-:5] = {2'b01, instr[9:7]};
							idu2exu_cmd_o[46-:5] = SCR1_MPRF_ZERO_ADDR;
							idu2exu_cmd_o[36-:32] = {{24 {instr[12]}}, instr[6:5], instr[2], instr[11:10], instr[4:3], 1'b0};
						end
					endcase
				end
				2'b10: begin
					idu2exu_cmd_o[74] = 1'b1;
					idu2exu_use_rs1_o = 1'b1;
					case (funct3)
						3'b000: begin
							if (instr[12])
								rvc_illegal = 1'b1;
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[51-:5] = instr[11:7];
							idu2exu_cmd_o[41-:5] = instr[11:7];
							idu2exu_cmd_o[36-:32] = {27'd0, instr[6:2]};
							idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 12);
							idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(0);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
						end
						3'b010: begin
							if (~|instr[11:7])
								rvc_illegal = 1'b1;
							idu2exu_use_rd_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
							idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 3);
							idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 5);
							idu2exu_cmd_o[51-:5] = SCR1_MPRF_SP_ADDR;
							idu2exu_cmd_o[41-:5] = instr[11:7];
							idu2exu_cmd_o[36-:32] = {24'd0, instr[3:2], instr[12], instr[6:4], 2'b00};
						end
						3'b100:
							if (~instr[12]) begin
								if (|instr[6:2]) begin
									idu2exu_use_rs2_o = 1'b1;
									idu2exu_use_rd_o = 1'b1;
									idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 4);
									idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
									idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
									idu2exu_cmd_o[51-:5] = SCR1_MPRF_ZERO_ADDR;
									idu2exu_cmd_o[46-:5] = instr[6:2];
									idu2exu_cmd_o[41-:5] = instr[11:7];
								end
								else begin
									if (~|instr[11:7])
										rvc_illegal = 1'b1;
									idu2exu_use_imm_o = 1'b1;
									idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
									idu2exu_cmd_o[56] = 1'b1;
									idu2exu_cmd_o[51-:5] = instr[11:7];
									idu2exu_cmd_o[36-:32] = 0;
								end
							end
							else if (~|instr[11:2]) begin
								idu2exu_cmd_o[4] = 1'b1;
								idu2exu_cmd_o[3-:SCR1_EXC_CODE_WIDTH_E] = sv2v_cast_92043(4'd3);
							end
							else if (~|instr[6:2]) begin
								idu2exu_use_rs1_o = 1'b1;
								idu2exu_use_rd_o = 1'b1;
								idu2exu_use_imm_o = 1'b1;
								idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
								idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 4);
								idu2exu_cmd_o[56] = 1'b1;
								idu2exu_cmd_o[51-:5] = instr[11:7];
								idu2exu_cmd_o[41-:5] = SCR1_MPRF_RA_ADDR;
								idu2exu_cmd_o[36-:32] = 0;
							end
							else begin
								idu2exu_use_rs1_o = 1'b1;
								idu2exu_use_rs2_o = 1'b1;
								idu2exu_use_rd_o = 1'b1;
								idu2exu_cmd_o[72-:5] = sv2v_cast_9DDEB({32 {1'sb0}} + 4);
								idu2exu_cmd_o[73-:1] = sv2v_cast_EFCFF(1);
								idu2exu_cmd_o[59-:3] = sv2v_cast_4D524({32 {1'sb0}} + 1);
								idu2exu_cmd_o[51-:5] = instr[11:7];
								idu2exu_cmd_o[46-:5] = instr[6:2];
								idu2exu_cmd_o[41-:5] = instr[11:7];
							end
						3'b110: begin
							idu2exu_use_rs1_o = 1'b1;
							idu2exu_use_rs2_o = 1'b1;
							idu2exu_use_imm_o = 1'b1;
							idu2exu_cmd_o[67-:1] = sv2v_cast_64327(1);
							idu2exu_cmd_o[66-:4] = sv2v_cast_4A511({32 {1'sb0}} + 8);
							idu2exu_cmd_o[51-:5] = SCR1_MPRF_SP_ADDR;
							idu2exu_cmd_o[46-:5] = instr[6:2];
							idu2exu_cmd_o[36-:32] = {24'd0, instr[8:7], instr[12:9], 2'b00};
						end
						default: rvc_illegal = 1'b1;
					endcase
				end
				default:
					;
			endcase
		if (rvi_illegal | rvc_illegal) begin
			idu2exu_cmd_o[72-:5] = sv2v_cast_305D4(1'sb0);
			idu2exu_cmd_o[66-:4] = sv2v_cast_268FE(1'sb0);
			idu2exu_cmd_o[61-:2] = sv2v_cast_AF896(1'sb0);
			idu2exu_cmd_o[59-:3] = sv2v_cast_FEE4F(1'sb0);
			idu2exu_cmd_o[56] = 1'b0;
			idu2exu_cmd_o[55] = 1'b0;
			idu2exu_cmd_o[54] = 1'b0;
			idu2exu_cmd_o[53] = 1'b0;
			idu2exu_cmd_o[52] = 1'b0;
			idu2exu_use_rs1_o = 1'b0;
			idu2exu_use_rs2_o = 1'b0;
			idu2exu_use_rd_o = 1'b0;
			idu2exu_use_imm_o = 1'b1;
			idu2exu_cmd_o[36-:32] = instr;
			idu2exu_cmd_o[4] = 1'b1;
			idu2exu_cmd_o[3-:SCR1_EXC_CODE_WIDTH_E] = sv2v_cast_92043(4'd2);
		end
	end
	initial _sv2v_0 = 0;
endmodule
