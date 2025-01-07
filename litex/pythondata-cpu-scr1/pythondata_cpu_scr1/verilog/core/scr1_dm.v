/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details
module scr1_dm (
	rst_n,
	clk,
	dmi2dm_req_i,
	dmi2dm_wr_i,
	dmi2dm_addr_i,
	dmi2dm_wdata_i,
	dm2dmi_resp_o,
	dm2dmi_rdata_o,
	ndm_rst_n_o,
	hart_rst_n_o,
	dm2pipe_active_o,
	dm2pipe_cmd_req_o,
	dm2pipe_cmd_o,
	pipe2dm_cmd_resp_i,
	pipe2dm_cmd_rcode_i,
	pipe2dm_hart_event_i,
	pipe2dm_hart_status_i,
	soc2dm_fuse_mhartid_i,
	pipe2dm_pc_sample_i,
	pipe2dm_pbuf_addr_i,
	dm2pipe_pbuf_instr_o,
	pipe2dm_dreg_req_i,
	pipe2dm_dreg_wr_i,
	pipe2dm_dreg_wdata_i,
	dm2pipe_dreg_resp_o,
	dm2pipe_dreg_fail_o,
	dm2pipe_dreg_rdata_o
);
	reg _sv2v_0;
	input wire rst_n;
	input wire clk;
	input wire dmi2dm_req_i;
	input wire dmi2dm_wr_i;
	localparam SCR1_DBG_DMI_ADDR_WIDTH = 6'd7;
	input wire [SCR1_DBG_DMI_ADDR_WIDTH - 1:0] dmi2dm_addr_i;
	localparam SCR1_DBG_DMI_DATA_WIDTH = 6'd32;
	input wire [SCR1_DBG_DMI_DATA_WIDTH - 1:0] dmi2dm_wdata_i;
	output wire dm2dmi_resp_o;
	output reg [SCR1_DBG_DMI_DATA_WIDTH - 1:0] dm2dmi_rdata_o;
	output wire ndm_rst_n_o;
	output wire hart_rst_n_o;
	output wire dm2pipe_active_o;
	output wire dm2pipe_cmd_req_o;
	output wire [1:0] dm2pipe_cmd_o;
	input wire pipe2dm_cmd_resp_i;
	input wire pipe2dm_cmd_rcode_i;
	input wire pipe2dm_hart_event_i;
	input wire [3:0] pipe2dm_hart_status_i;
	input wire [31:0] soc2dm_fuse_mhartid_i;
	input wire [31:0] pipe2dm_pc_sample_i;
	localparam [31:0] SCR1_HDU_PBUF_ADDR_SPAN = 8;
	localparam [31:0] SCR1_HDU_PBUF_ADDR_WIDTH = 3;
	input wire [2:0] pipe2dm_pbuf_addr_i;
	localparam [31:0] SCR1_HDU_CORE_INSTR_WIDTH = 32;
	output reg [31:0] dm2pipe_pbuf_instr_o;
	input wire pipe2dm_dreg_req_i;
	input wire pipe2dm_dreg_wr_i;
	input wire [31:0] pipe2dm_dreg_wdata_i;
	output wire dm2pipe_dreg_resp_o;
	output wire dm2pipe_dreg_fail_o;
	output wire [31:0] dm2pipe_dreg_rdata_o;
	localparam SCR1_DBG_ABSTRACTCS_CMDERR_HI = 5'd10;
	localparam SCR1_DBG_ABSTRACTCS_CMDERR_LO = 5'd8;
	localparam SCR1_DBG_ABSTRACTCS_CMDERR_WDTH = SCR1_DBG_ABSTRACTCS_CMDERR_HI - SCR1_DBG_ABSTRACTCS_CMDERR_LO;
	localparam SCR1_OP_SYSTEM = 7'b1110011;
	localparam SCR1_OP_LOAD = 7'b0000011;
	localparam SCR1_OP_STORE = 7'b0100011;
	localparam SCR1_FUNCT3_CSRRW = 3'b001;
	localparam SCR1_FUNCT3_CSRRS = 3'b010;
	localparam SCR1_FUNCT3_SB = 3'b000;
	localparam SCR1_FUNCT3_SH = 3'b001;
	localparam SCR1_FUNCT3_SW = 3'b010;
	localparam SCR1_FUNCT3_LW = 3'b010;
	localparam SCR1_FUNCT3_LBU = 3'b100;
	localparam SCR1_FUNCT3_LHU = 3'b101;
	localparam DMCONTROL_HARTRESET = 1'd0;
	localparam DMCONTROL_RESERVEDB = 1'd0;
	localparam DMCONTROL_HASEL = 1'd0;
	localparam DMCONTROL_HARTSELLO = 1'd0;
	localparam DMCONTROL_HARTSELHI = 1'd0;
	localparam DMCONTROL_RESERVEDA = 1'd0;
	localparam DMSTATUS_RESERVEDC = 1'd0;
	localparam DMSTATUS_IMPEBREAK = 1'd1;
	localparam DMSTATUS_RESERVEDB = 1'd0;
	localparam DMSTATUS_ALLUNAVAIL = 1'd0;
	localparam DMSTATUS_ANYUNAVAIL = 1'd0;
	localparam DMSTATUS_ALLANYUNAVAIL = 1'd0;
	localparam DMSTATUS_ALLANYNONEXIST = 1'b0;
	localparam DMSTATUS_AUTHENTICATED = 1'd1;
	localparam DMSTATUS_AUTHBUSY = 1'd0;
	localparam DMSTATUS_RESERVEDA = 1'd0;
	localparam DMSTATUS_DEVTREEVALID = 1'd0;
	localparam DMSTATUS_VERSION = 2'd2;
	localparam HARTINFO_RESERVEDB = 1'd0;
	localparam HARTINFO_NSCRATCH = 4'd1;
	localparam HARTINFO_RESERVEDA = 1'd0;
	localparam HARTINFO_DATAACCESS = 1'd0;
	localparam HARTINFO_DATASIZE = 4'd1;
	localparam HARTINFO_DATAADDR = 12'h7b2;
	localparam ABSTRACTCS_RESERVEDD = 1'd0;
	localparam ABSTRACTCS_PROGBUFSIZE = 5'd6;
	localparam ABSTRACTCS_RESERVEDC = 1'd0;
	localparam ABSTRACTCS_RESERVEDB = 1'd0;
	localparam ABSTRACTCS_RESERVEDA = 1'd0;
	localparam ABSTRACTCS_DATACOUNT = 4'd2;
	localparam ABS_CMD_HARTREG = 1'd0;
	localparam ABS_CMD_HARTMEM = 2'd2;
	localparam ABS_CMD_HARTREG_CSR = 4'b0000;
	localparam ABS_CMD_HARTREG_INTFPU = 4'b0001;
	localparam ABS_CMD_HARTREG_INT = 7'b0000000;
	localparam ABS_CMD_HARTREG_FPU = 7'b0000001;
	localparam ABS_EXEC_EBREAK = 32'b00000000000100000000000001110011;
	reg dmi_req_dmcontrol;
	reg dmi_req_abstractcs;
	reg dmi_req_abstractauto;
	reg dmi_req_command;
	reg dmi_rpt_command;
	reg dmi_req_data0;
	reg dmi_req_data1;
	reg dmi_req_progbuf0;
	reg dmi_req_progbuf1;
	reg dmi_req_progbuf2;
	reg dmi_req_progbuf3;
	reg dmi_req_progbuf4;
	reg dmi_req_progbuf5;
	wire dmi_req_any;
	wire dmcontrol_wr_req;
	wire abstractcs_wr_req;
	wire data0_wr_req;
	wire data1_wr_req;
	wire dreg_wr_req;
	wire command_wr_req;
	wire autoexec_wr_req;
	wire progbuf0_wr_req;
	wire progbuf1_wr_req;
	wire progbuf2_wr_req;
	wire progbuf3_wr_req;
	wire progbuf4_wr_req;
	wire progbuf5_wr_req;
	wire clk_en_dm;
	reg clk_en_dm_ff;
	reg dmcontrol_haltreq_ff;
	reg dmcontrol_haltreq_next;
	reg dmcontrol_resumereq_ff;
	reg dmcontrol_resumereq_next;
	reg dmcontrol_ackhavereset_ff;
	reg dmcontrol_ackhavereset_next;
	reg dmcontrol_ndmreset_ff;
	reg dmcontrol_ndmreset_next;
	reg dmcontrol_dmactive_ff;
	wire dmcontrol_dmactive_next;
	reg havereset_skip_pwrup_ff;
	wire havereset_skip_pwrup_next;
	reg dmstatus_allany_havereset_ff;
	wire dmstatus_allany_havereset_next;
	reg dmstatus_allany_resumeack_ff;
	wire dmstatus_allany_resumeack_next;
	reg dmstatus_allany_halted_ff;
	wire dmstatus_allany_halted_next;
	wire [SCR1_DBG_DMI_DATA_WIDTH - 1:0] abs_cmd;
	reg abs_cmd_csr_ro;
	localparam SCR1_DBG_COMMAND_TYPE_HI = 5'd31;
	localparam SCR1_DBG_COMMAND_TYPE_LO = 5'd24;
	localparam SCR1_DBG_COMMAND_TYPE_WDTH = SCR1_DBG_COMMAND_TYPE_HI - SCR1_DBG_COMMAND_TYPE_LO;
	reg [SCR1_DBG_COMMAND_TYPE_WDTH:0] abs_cmd_type;
	reg abs_cmd_regacs;
	localparam SCR1_DBG_COMMAND_ACCESSREG_REGNO_HI = 5'd15;
	reg [SCR1_DBG_COMMAND_ACCESSREG_REGNO_HI - 12:0] abs_cmd_regtype;
	reg [6:0] abs_cmd_regfile;
	reg abs_cmd_regwr;
	localparam SCR1_DBG_COMMAND_ACCESSREG_SIZE_HI = 5'd22;
	localparam SCR1_DBG_COMMAND_ACCESSREG_SIZE_LO = 5'd20;
	localparam SCR1_DBG_COMMAND_ACCESSREG_SIZE_WDTH = SCR1_DBG_COMMAND_ACCESSREG_SIZE_HI - SCR1_DBG_COMMAND_ACCESSREG_SIZE_LO;
	reg [SCR1_DBG_COMMAND_ACCESSREG_SIZE_WDTH:0] abs_cmd_regsize;
	reg abs_cmd_execprogbuf;
	reg abs_cmd_regvalid;
	reg [2:0] abs_cmd_memsize;
	reg abs_cmd_memwr;
	reg abs_cmd_memvalid;
	wire abs_cmd_regsize_vd;
	wire abs_cmd_memsize_vd;
	reg abs_cmd_wr_ff;
	reg abs_cmd_wr_next;
	reg abs_cmd_postexec_ff;
	reg abs_cmd_postexec_next;
	reg [11:0] abs_cmd_regno;
	reg [11:0] abs_cmd_regno_ff;
	reg [1:0] abs_cmd_size_ff;
	reg [1:0] abs_cmd_size_next;
	wire abs_reg_access_csr;
	wire abs_reg_access_mprf;
	wire abs_cmd_hartreg_vd;
	wire abs_cmd_hartmem_vd;
	wire abs_cmd_reg_access_req;
	wire abs_cmd_csr_access_req;
	wire abs_cmd_mprf_access_req;
	wire abs_cmd_execprogbuf_req;
	wire abs_cmd_csr_ro_access_vd;
	wire abs_cmd_csr_rw_access_vd;
	wire abs_cmd_mprf_access_vd;
	wire abs_cmd_mem_access_vd;
	reg [3:0] abs_fsm_ff;
	reg [3:0] abs_fsm_next;
	wire abs_fsm_idle;
	wire abs_fsm_exec;
	wire abs_fsm_csr_ro;
	wire abs_fsm_err;
	wire abs_fsm_use_addr;
	wire clk_en_abs;
	wire abstractcs_busy;
	wire abstractcs_ro_en;
	reg [31:0] abs_command_ff;
	wire [31:0] abs_command_next;
	reg abs_autoexec_ff;
	wire abs_autoexec_next;
	reg [31:0] abs_progbuf0_ff;
	reg [31:0] abs_progbuf1_ff;
	reg [31:0] abs_progbuf2_ff;
	reg [31:0] abs_progbuf3_ff;
	reg [31:0] abs_progbuf4_ff;
	reg [31:0] abs_progbuf5_ff;
	wire data0_xreg_save;
	reg [31:0] abs_data0_ff;
	reg [31:0] abs_data0_next;
	reg [31:0] abs_data1_ff;
	reg [31:0] abs_data1_next;
	wire abs_err_exc_upd;
	reg abs_err_exc_ff;
	wire abs_err_exc_next;
	wire abs_err_acc_busy_upd;
	reg abs_err_acc_busy_ff;
	wire abs_err_acc_busy_next;
	reg [SCR1_DBG_ABSTRACTCS_CMDERR_WDTH:0] abstractcs_cmderr_ff;
	reg [SCR1_DBG_ABSTRACTCS_CMDERR_WDTH:0] abstractcs_cmderr_next;
	wire abs_exec_req_next;
	reg abs_exec_req_ff;
	reg [4:0] abs_instr_rd;
	reg [4:0] abs_instr_rs1;
	wire [4:0] abs_instr_rs2;
	reg [2:0] abs_instr_mem_funct3;
	reg [31:0] abs_exec_instr_next;
	reg [31:0] abs_exec_instr_ff;
	reg [2:0] dhi_fsm_next;
	reg [2:0] dhi_fsm_ff;
	reg [2:0] dhi_req;
	wire dhi_fsm_idle;
	wire dhi_fsm_exec;
	wire dhi_fsm_exec_halt;
	wire dhi_fsm_halt_req;
	wire dhi_fsm_resume_req;
	wire cmd_resp_ok;
	wire hart_rst_unexp;
	wire halt_req_vd;
	wire resume_req_vd;
	wire dhi_resp;
	wire dhi_resp_exc;
	reg hart_pbuf_ebreak_ff;
	wire hart_pbuf_ebreak_next;
	reg hart_cmd_req_ff;
	wire hart_cmd_req_next;
	reg [1:0] hart_cmd_ff;
	reg [1:0] hart_cmd_next;
	wire hart_state_reset;
	wire hart_state_run;
	wire hart_state_drun;
	wire hart_state_dhalt;
	localparam SCR1_DBG_ABSTRACTAUTO = 7'h18;
	localparam SCR1_DBG_ABSTRACTCS = 7'h16;
	localparam SCR1_DBG_COMMAND = 7'h17;
	localparam SCR1_DBG_DATA0 = 7'h04;
	localparam SCR1_DBG_DATA1 = 7'h05;
	localparam SCR1_DBG_DMCONTROL = 7'h10;
	localparam SCR1_DBG_PROGBUF0 = 7'h20;
	localparam SCR1_DBG_PROGBUF1 = 7'h21;
	localparam SCR1_DBG_PROGBUF2 = 7'h22;
	localparam SCR1_DBG_PROGBUF3 = 7'h23;
	localparam SCR1_DBG_PROGBUF4 = 7'h24;
	localparam SCR1_DBG_PROGBUF5 = 7'h25;
	always @(*) begin
		if (_sv2v_0)
			;
		dmi_req_dmcontrol = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_DMCONTROL);
		dmi_req_abstractcs = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_ABSTRACTCS);
		dmi_req_abstractauto = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_ABSTRACTAUTO);
		dmi_req_data0 = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_DATA0);
		dmi_req_data1 = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_DATA1);
		dmi_req_command = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_COMMAND);
		dmi_rpt_command = abs_autoexec_ff & dmi_req_data0;
		dmi_req_progbuf0 = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_PROGBUF0);
		dmi_req_progbuf1 = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_PROGBUF1);
		dmi_req_progbuf2 = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_PROGBUF2);
		dmi_req_progbuf3 = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_PROGBUF3);
		dmi_req_progbuf4 = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_PROGBUF4);
		dmi_req_progbuf5 = dmi2dm_req_i & (dmi2dm_addr_i == SCR1_DBG_PROGBUF5);
	end
	assign dmi_req_any = (((((((((dmi_req_command | dmi_rpt_command) | dmi_req_abstractauto) | dmi_req_data0) | dmi_req_data1) | dmi_req_progbuf0) | dmi_req_progbuf1) | dmi_req_progbuf2) | dmi_req_progbuf3) | dmi_req_progbuf4) | dmi_req_progbuf5;
	localparam SCR1_DBG_ABSTRACTCS_BUSY = 5'd12;
	localparam SCR1_DBG_ABSTRACTCS_DATACOUNT_HI = 5'd3;
	localparam SCR1_DBG_ABSTRACTCS_DATACOUNT_LO = 5'd0;
	localparam SCR1_DBG_ABSTRACTCS_PROGBUFSIZE_HI = 5'd28;
	localparam SCR1_DBG_ABSTRACTCS_PROGBUFSIZE_LO = 5'd24;
	localparam SCR1_DBG_ABSTRACTCS_RESERVEDA_HI = 5'd7;
	localparam SCR1_DBG_ABSTRACTCS_RESERVEDA_LO = 5'd4;
	localparam SCR1_DBG_ABSTRACTCS_RESERVEDB = 5'd11;
	localparam SCR1_DBG_ABSTRACTCS_RESERVEDC_HI = 5'd23;
	localparam SCR1_DBG_ABSTRACTCS_RESERVEDC_LO = 5'd13;
	localparam SCR1_DBG_ABSTRACTCS_RESERVEDD_HI = 5'd31;
	localparam SCR1_DBG_ABSTRACTCS_RESERVEDD_LO = 5'd29;
	localparam SCR1_DBG_DMCONTROL_ACKHAVERESET = 5'd28;
	localparam SCR1_DBG_DMCONTROL_DMACTIVE = 5'd0;
	localparam SCR1_DBG_DMCONTROL_HALTREQ = 5'd31;
	localparam SCR1_DBG_DMCONTROL_HARTRESET = 5'd29;
	localparam SCR1_DBG_DMCONTROL_HARTSELHI_HI = 5'd15;
	localparam SCR1_DBG_DMCONTROL_HARTSELHI_LO = 5'd6;
	localparam SCR1_DBG_DMCONTROL_HARTSELLO_HI = 5'd25;
	localparam SCR1_DBG_DMCONTROL_HARTSELLO_LO = 5'd16;
	localparam SCR1_DBG_DMCONTROL_HASEL = 5'd26;
	localparam SCR1_DBG_DMCONTROL_NDMRESET = 5'd1;
	localparam SCR1_DBG_DMCONTROL_RESERVEDA_HI = 5'd5;
	localparam SCR1_DBG_DMCONTROL_RESERVEDA_LO = 5'd2;
	localparam SCR1_DBG_DMCONTROL_RESERVEDB = 5'd27;
	localparam SCR1_DBG_DMCONTROL_RESUMEREQ = 5'd30;
	localparam SCR1_DBG_DMSTATUS = 7'h11;
	localparam SCR1_DBG_DMSTATUS_ALLHALTED = 5'd9;
	localparam SCR1_DBG_DMSTATUS_ALLHAVERESET = 5'd19;
	localparam SCR1_DBG_DMSTATUS_ALLNONEXISTENT = 5'd15;
	localparam SCR1_DBG_DMSTATUS_ALLRESUMEACK = 5'd17;
	localparam SCR1_DBG_DMSTATUS_ALLRUNNING = 5'd11;
	localparam SCR1_DBG_DMSTATUS_ALLUNAVAIL = 5'd13;
	localparam SCR1_DBG_DMSTATUS_ANYHALTED = 5'd8;
	localparam SCR1_DBG_DMSTATUS_ANYHAVERESET = 5'd18;
	localparam SCR1_DBG_DMSTATUS_ANYNONEXISTENT = 5'd14;
	localparam SCR1_DBG_DMSTATUS_ANYRESUMEACK = 5'd16;
	localparam SCR1_DBG_DMSTATUS_ANYRUNNING = 5'd10;
	localparam SCR1_DBG_DMSTATUS_ANYUNAVAIL = 5'd12;
	localparam SCR1_DBG_DMSTATUS_AUTHBUSY = 5'd6;
	localparam SCR1_DBG_DMSTATUS_AUTHENTICATED = 5'd7;
	localparam SCR1_DBG_DMSTATUS_DEVTREEVALID = 5'd4;
	localparam SCR1_DBG_DMSTATUS_IMPEBREAK = 5'd22;
	localparam SCR1_DBG_DMSTATUS_RESERVEDA = 5'd5;
	localparam SCR1_DBG_DMSTATUS_RESERVEDB_HI = 5'd21;
	localparam SCR1_DBG_DMSTATUS_RESERVEDB_LO = 5'd20;
	localparam SCR1_DBG_DMSTATUS_RESERVEDC_HI = 5'd31;
	localparam SCR1_DBG_DMSTATUS_RESERVEDC_LO = 5'd23;
	localparam SCR1_DBG_DMSTATUS_VERSION_HI = 5'd3;
	localparam SCR1_DBG_DMSTATUS_VERSION_LO = 5'd0;
	localparam SCR1_DBG_HALTSUM0 = 7'h40;
	localparam SCR1_DBG_HARTINFO = 7'h12;
	localparam SCR1_DBG_HARTINFO_DATAACCESS = 5'd16;
	localparam SCR1_DBG_HARTINFO_DATAADDR_HI = 5'd11;
	localparam SCR1_DBG_HARTINFO_DATAADDR_LO = 5'd0;
	localparam SCR1_DBG_HARTINFO_DATASIZE_HI = 5'd15;
	localparam SCR1_DBG_HARTINFO_DATASIZE_LO = 5'd12;
	localparam SCR1_DBG_HARTINFO_NSCRATCH_HI = 5'd23;
	localparam SCR1_DBG_HARTINFO_NSCRATCH_LO = 5'd20;
	localparam SCR1_DBG_HARTINFO_RESERVEDA_HI = 5'd19;
	localparam SCR1_DBG_HARTINFO_RESERVEDA_LO = 5'd17;
	localparam SCR1_DBG_HARTINFO_RESERVEDB_HI = 5'd31;
	localparam SCR1_DBG_HARTINFO_RESERVEDB_LO = 5'd24;
	always @(*) begin
		if (_sv2v_0)
			;
		dm2dmi_rdata_o = 1'sb0;
		case (dmi2dm_addr_i)
			SCR1_DBG_DMSTATUS: begin
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_RESERVEDC_HI:SCR1_DBG_DMSTATUS_RESERVEDC_LO] = DMSTATUS_RESERVEDC;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_IMPEBREAK] = DMSTATUS_IMPEBREAK;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_RESERVEDB_HI:SCR1_DBG_DMSTATUS_RESERVEDB_LO] = DMSTATUS_RESERVEDB;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ALLHAVERESET] = dmstatus_allany_havereset_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ANYHAVERESET] = dmstatus_allany_havereset_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ALLRESUMEACK] = dmstatus_allany_resumeack_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ANYRESUMEACK] = dmstatus_allany_resumeack_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ALLNONEXISTENT] = DMSTATUS_ALLANYNONEXIST;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ANYNONEXISTENT] = DMSTATUS_ALLANYNONEXIST;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ALLUNAVAIL] = DMSTATUS_ALLANYUNAVAIL;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ANYUNAVAIL] = DMSTATUS_ALLANYUNAVAIL;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ALLRUNNING] = ~dmstatus_allany_halted_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ANYRUNNING] = ~dmstatus_allany_halted_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ALLHALTED] = dmstatus_allany_halted_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_ANYHALTED] = dmstatus_allany_halted_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_AUTHENTICATED] = DMSTATUS_AUTHENTICATED;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_AUTHBUSY] = DMSTATUS_AUTHBUSY;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_RESERVEDA] = DMSTATUS_RESERVEDA;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_DEVTREEVALID] = DMSTATUS_DEVTREEVALID;
				dm2dmi_rdata_o[SCR1_DBG_DMSTATUS_VERSION_HI:SCR1_DBG_DMSTATUS_VERSION_LO] = DMSTATUS_VERSION;
			end
			SCR1_DBG_DMCONTROL: begin
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_HALTREQ] = dmcontrol_haltreq_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_RESUMEREQ] = dmcontrol_resumereq_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_HARTRESET] = DMCONTROL_HARTRESET;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_ACKHAVERESET] = dmcontrol_ackhavereset_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_RESERVEDB] = DMCONTROL_RESERVEDB;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_HASEL] = DMCONTROL_HASEL;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_HARTSELLO_HI:SCR1_DBG_DMCONTROL_HARTSELLO_LO] = DMCONTROL_HARTSELLO;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_HARTSELHI_HI:SCR1_DBG_DMCONTROL_HARTSELHI_LO] = DMCONTROL_HARTSELHI;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_RESERVEDA_HI:SCR1_DBG_DMCONTROL_RESERVEDA_LO] = DMCONTROL_RESERVEDA;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_NDMRESET] = dmcontrol_ndmreset_ff;
				dm2dmi_rdata_o[SCR1_DBG_DMCONTROL_DMACTIVE] = dmcontrol_dmactive_ff;
			end
			SCR1_DBG_ABSTRACTCS: begin
				dm2dmi_rdata_o[SCR1_DBG_ABSTRACTCS_RESERVEDD_HI:SCR1_DBG_ABSTRACTCS_RESERVEDD_LO] = ABSTRACTCS_RESERVEDD;
				dm2dmi_rdata_o[SCR1_DBG_ABSTRACTCS_PROGBUFSIZE_HI:SCR1_DBG_ABSTRACTCS_PROGBUFSIZE_LO] = ABSTRACTCS_PROGBUFSIZE;
				dm2dmi_rdata_o[SCR1_DBG_ABSTRACTCS_RESERVEDC_HI:SCR1_DBG_ABSTRACTCS_RESERVEDC_LO] = ABSTRACTCS_RESERVEDC;
				dm2dmi_rdata_o[SCR1_DBG_ABSTRACTCS_BUSY] = abstractcs_busy;
				dm2dmi_rdata_o[SCR1_DBG_ABSTRACTCS_RESERVEDB] = ABSTRACTCS_RESERVEDB;
				dm2dmi_rdata_o[SCR1_DBG_ABSTRACTCS_CMDERR_HI:SCR1_DBG_ABSTRACTCS_CMDERR_LO] = abstractcs_cmderr_ff;
				dm2dmi_rdata_o[SCR1_DBG_ABSTRACTCS_RESERVEDA_HI:SCR1_DBG_ABSTRACTCS_RESERVEDA_LO] = ABSTRACTCS_RESERVEDA;
				dm2dmi_rdata_o[SCR1_DBG_ABSTRACTCS_DATACOUNT_HI:SCR1_DBG_ABSTRACTCS_DATACOUNT_LO] = ABSTRACTCS_DATACOUNT;
			end
			SCR1_DBG_HARTINFO: begin
				dm2dmi_rdata_o[SCR1_DBG_HARTINFO_RESERVEDB_HI:SCR1_DBG_HARTINFO_RESERVEDB_LO] = HARTINFO_RESERVEDB;
				dm2dmi_rdata_o[SCR1_DBG_HARTINFO_NSCRATCH_HI:SCR1_DBG_HARTINFO_NSCRATCH_LO] = HARTINFO_NSCRATCH;
				dm2dmi_rdata_o[SCR1_DBG_HARTINFO_RESERVEDA_HI:SCR1_DBG_HARTINFO_RESERVEDA_LO] = HARTINFO_RESERVEDA;
				dm2dmi_rdata_o[SCR1_DBG_HARTINFO_DATAACCESS] = HARTINFO_DATAACCESS;
				dm2dmi_rdata_o[SCR1_DBG_HARTINFO_DATASIZE_HI:SCR1_DBG_HARTINFO_DATASIZE_LO] = HARTINFO_DATASIZE;
				dm2dmi_rdata_o[SCR1_DBG_HARTINFO_DATAADDR_HI:SCR1_DBG_HARTINFO_DATAADDR_LO] = HARTINFO_DATAADDR;
			end
			SCR1_DBG_ABSTRACTAUTO: dm2dmi_rdata_o[0] = abs_autoexec_ff;
			SCR1_DBG_DATA0: dm2dmi_rdata_o = abs_data0_ff;
			SCR1_DBG_DATA1: dm2dmi_rdata_o = abs_data1_ff;
			SCR1_DBG_PROGBUF0: dm2dmi_rdata_o = abs_progbuf0_ff;
			SCR1_DBG_PROGBUF1: dm2dmi_rdata_o = abs_progbuf1_ff;
			SCR1_DBG_PROGBUF2: dm2dmi_rdata_o = abs_progbuf2_ff;
			SCR1_DBG_PROGBUF3: dm2dmi_rdata_o = abs_progbuf3_ff;
			SCR1_DBG_PROGBUF4: dm2dmi_rdata_o = abs_progbuf4_ff;
			SCR1_DBG_PROGBUF5: dm2dmi_rdata_o = abs_progbuf5_ff;
			SCR1_DBG_HALTSUM0: dm2dmi_rdata_o[0] = dmstatus_allany_halted_ff;
			default: dm2dmi_rdata_o = 1'sb0;
		endcase
	end
	assign dm2dmi_resp_o = 1'b1;
	assign dmcontrol_wr_req = dmi_req_dmcontrol & dmi2dm_wr_i;
	assign data0_wr_req = dmi_req_data0 & dmi2dm_wr_i;
	assign data1_wr_req = dmi_req_data1 & dmi2dm_wr_i;
	assign dreg_wr_req = pipe2dm_dreg_req_i & pipe2dm_dreg_wr_i;
	assign command_wr_req = dmi_req_command & dmi2dm_wr_i;
	assign autoexec_wr_req = dmi_req_abstractauto & dmi2dm_wr_i;
	assign progbuf0_wr_req = dmi_req_progbuf0 & dmi2dm_wr_i;
	assign progbuf1_wr_req = dmi_req_progbuf1 & dmi2dm_wr_i;
	assign progbuf2_wr_req = dmi_req_progbuf2 & dmi2dm_wr_i;
	assign progbuf3_wr_req = dmi_req_progbuf3 & dmi2dm_wr_i;
	assign progbuf4_wr_req = dmi_req_progbuf4 & dmi2dm_wr_i;
	assign progbuf5_wr_req = dmi_req_progbuf5 & dmi2dm_wr_i;
	assign abstractcs_wr_req = dmi_req_abstractcs & dmi2dm_wr_i;
	assign hart_state_reset = pipe2dm_hart_status_i[1-:2] == 2'b00;
	assign hart_state_run = pipe2dm_hart_status_i[1-:2] == 2'b01;
	assign hart_state_dhalt = pipe2dm_hart_status_i[1-:2] == 2'b10;
	assign hart_state_drun = pipe2dm_hart_status_i[1-:2] == 2'b11;
	assign clk_en_dm = (dmcontrol_wr_req | dmcontrol_dmactive_ff) | clk_en_dm_ff;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			clk_en_dm_ff <= 1'b0;
		else if (clk_en_dm)
			clk_en_dm_ff <= dmcontrol_dmactive_ff;
	assign dm2pipe_active_o = clk_en_dm_ff;
	always @(posedge clk or negedge rst_n)
		if (~rst_n) begin
			dmcontrol_dmactive_ff <= 1'b0;
			dmcontrol_ndmreset_ff <= 1'b0;
			dmcontrol_ackhavereset_ff <= 1'b0;
			dmcontrol_haltreq_ff <= 1'b0;
			dmcontrol_resumereq_ff <= 1'b0;
		end
		else if (clk_en_dm) begin
			dmcontrol_dmactive_ff <= dmcontrol_dmactive_next;
			dmcontrol_ndmreset_ff <= dmcontrol_ndmreset_next;
			dmcontrol_ackhavereset_ff <= dmcontrol_ackhavereset_next;
			dmcontrol_haltreq_ff <= dmcontrol_haltreq_next;
			dmcontrol_resumereq_ff <= dmcontrol_resumereq_next;
		end
	assign dmcontrol_dmactive_next = (dmcontrol_wr_req ? dmi2dm_wdata_i[SCR1_DBG_DMCONTROL_DMACTIVE] : dmcontrol_dmactive_ff);
	always @(*) begin
		if (_sv2v_0)
			;
		dmcontrol_ndmreset_next = dmcontrol_ndmreset_ff;
		dmcontrol_ackhavereset_next = dmcontrol_ackhavereset_ff;
		dmcontrol_haltreq_next = dmcontrol_haltreq_ff;
		dmcontrol_resumereq_next = dmcontrol_resumereq_ff;
		if (~dmcontrol_dmactive_ff) begin
			dmcontrol_ndmreset_next = 1'b0;
			dmcontrol_ackhavereset_next = 1'b0;
			dmcontrol_haltreq_next = 1'b0;
			dmcontrol_resumereq_next = 1'b0;
		end
		else if (dmcontrol_wr_req) begin
			dmcontrol_ndmreset_next = dmi2dm_wdata_i[SCR1_DBG_DMCONTROL_NDMRESET];
			dmcontrol_ackhavereset_next = dmi2dm_wdata_i[SCR1_DBG_DMCONTROL_ACKHAVERESET];
			dmcontrol_haltreq_next = dmi2dm_wdata_i[SCR1_DBG_DMCONTROL_HALTREQ];
			dmcontrol_resumereq_next = dmi2dm_wdata_i[SCR1_DBG_DMCONTROL_RESUMEREQ];
		end
	end
	assign hart_rst_n_o = ~dmcontrol_ndmreset_ff;
	assign ndm_rst_n_o = ~dmcontrol_ndmreset_ff;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			havereset_skip_pwrup_ff <= 1'b1;
		else if (clk_en_dm)
			havereset_skip_pwrup_ff <= havereset_skip_pwrup_next;
	assign havereset_skip_pwrup_next = (~dmcontrol_dmactive_ff ? 1'b1 : (havereset_skip_pwrup_ff ? (hart_state_reset & ndm_rst_n_o) & hart_rst_n_o : havereset_skip_pwrup_ff));
	always @(posedge clk or negedge rst_n)
		if (~rst_n) begin
			dmstatus_allany_havereset_ff <= 1'b0;
			dmstatus_allany_resumeack_ff <= 1'b0;
			dmstatus_allany_halted_ff <= 1'b0;
		end
		else if (clk_en_dm) begin
			dmstatus_allany_havereset_ff <= dmstatus_allany_havereset_next;
			dmstatus_allany_resumeack_ff <= dmstatus_allany_resumeack_next;
			dmstatus_allany_halted_ff <= dmstatus_allany_halted_next;
		end
	assign dmstatus_allany_havereset_next = (~dmcontrol_dmactive_ff ? 1'b0 : (~havereset_skip_pwrup_ff & hart_state_reset ? 1'b1 : (dmcontrol_ackhavereset_ff ? 1'b0 : dmstatus_allany_havereset_ff)));
	assign dmstatus_allany_resumeack_next = (~dmcontrol_dmactive_ff ? 1'b0 : (~dmcontrol_resumereq_ff ? 1'b0 : (hart_state_run ? 1'b1 : dmstatus_allany_resumeack_ff)));
	assign dmstatus_allany_halted_next = (~dmcontrol_dmactive_ff ? 1'b0 : (hart_state_dhalt ? 1'b1 : (hart_state_run ? 1'b0 : dmstatus_allany_halted_ff)));
	assign clk_en_abs = clk_en_dm & dmcontrol_dmactive_ff;
	assign abs_cmd = (dmi_req_command ? dmi2dm_wdata_i : abs_command_ff);
	localparam [31:0] SCR1_CSR_ADDR_WIDTH = 12;
	function automatic [11:0] sv2v_cast_C1AAB;
		input reg [11:0] inp;
		sv2v_cast_C1AAB = inp;
	endfunction
	localparam [11:0] SCR1_CSR_ADDR_MARCHID = sv2v_cast_C1AAB('hf12);
	localparam [11:0] SCR1_CSR_ADDR_MHARTID = sv2v_cast_C1AAB('hf14);
	localparam [11:0] SCR1_CSR_ADDR_MIMPID = sv2v_cast_C1AAB('hf13);
	localparam [11:0] SCR1_CSR_ADDR_MISA = sv2v_cast_C1AAB('h301);
	localparam [11:0] SCR1_CSR_ADDR_MVENDORID = sv2v_cast_C1AAB('hf11);
	localparam SCR1_DBG_COMMAND_ACCESSMEM_AAMPOSTINC = 5'd19;
	localparam SCR1_DBG_COMMAND_ACCESSMEM_AAMSIZE_HI = 5'd22;
	localparam SCR1_DBG_COMMAND_ACCESSMEM_AAMSIZE_LO = 5'd20;
	localparam SCR1_DBG_COMMAND_ACCESSMEM_AAMVIRTUAL = 5'd23;
	localparam SCR1_DBG_COMMAND_ACCESSMEM_RESERVEDA_HI = 5'd13;
	localparam SCR1_DBG_COMMAND_ACCESSMEM_RESERVEDB_HI = 5'd18;
	localparam SCR1_DBG_COMMAND_ACCESSMEM_WRITE = 5'd16;
	localparam SCR1_DBG_COMMAND_ACCESSREG_POSTEXEC = 5'd18;
	localparam SCR1_DBG_COMMAND_ACCESSREG_REGNO_LO = 5'd0;
	localparam SCR1_DBG_COMMAND_ACCESSREG_RESERVEDA = 5'd19;
	localparam SCR1_DBG_COMMAND_ACCESSREG_RESERVEDB = 5'd23;
	localparam SCR1_DBG_COMMAND_ACCESSREG_TRANSFER = 5'd17;
	localparam SCR1_DBG_COMMAND_ACCESSREG_WRITE = 5'd16;
	localparam [11:0] SCR1_CSR_ADDR_HDU_MBASE = sv2v_cast_C1AAB('h7b0);
	localparam [11:0] SCR1_CSR_ADDR_HDU_MSPAN = sv2v_cast_C1AAB('h4);
	localparam [31:0] SCR1_HDU_DEBUGCSR_ADDR_SPAN = SCR1_CSR_ADDR_HDU_MSPAN;
	localparam [31:0] SCR1_HDU_DEBUGCSR_ADDR_WIDTH = $clog2(SCR1_HDU_DEBUGCSR_ADDR_SPAN);
	function automatic [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] sv2v_cast_68C55;
		input reg [SCR1_HDU_DEBUGCSR_ADDR_WIDTH - 1:0] inp;
		sv2v_cast_68C55 = inp;
	endfunction
	localparam SCR1_HDU_DBGCSR_OFFS_DPC = sv2v_cast_68C55('d1);
	localparam [11:0] SCR1_HDU_DBGCSR_ADDR_DPC = SCR1_CSR_ADDR_HDU_MBASE + SCR1_HDU_DBGCSR_OFFS_DPC;
	always @(*) begin
		if (_sv2v_0)
			;
		abs_cmd_regno = abs_cmd[SCR1_DBG_COMMAND_ACCESSREG_REGNO_LO+:12];
		abs_cmd_csr_ro = (((((abs_cmd_regno == SCR1_CSR_ADDR_MISA) | (abs_cmd_regno == SCR1_CSR_ADDR_MVENDORID)) | (abs_cmd_regno == SCR1_CSR_ADDR_MARCHID)) | (abs_cmd_regno == SCR1_CSR_ADDR_MIMPID)) | (abs_cmd_regno == SCR1_CSR_ADDR_MHARTID)) | (abs_cmd_regno == SCR1_HDU_DBGCSR_ADDR_DPC);
		abs_cmd_type = abs_cmd[SCR1_DBG_COMMAND_TYPE_HI:SCR1_DBG_COMMAND_TYPE_LO];
		abs_cmd_regacs = abs_cmd[SCR1_DBG_COMMAND_ACCESSREG_TRANSFER];
		abs_cmd_regtype = abs_cmd[SCR1_DBG_COMMAND_ACCESSREG_REGNO_HI:12];
		abs_cmd_regfile = abs_cmd[11:5];
		abs_cmd_regsize = abs_cmd[SCR1_DBG_COMMAND_ACCESSREG_SIZE_HI:SCR1_DBG_COMMAND_ACCESSREG_SIZE_LO];
		abs_cmd_regwr = abs_cmd[SCR1_DBG_COMMAND_ACCESSREG_WRITE];
		abs_cmd_execprogbuf = abs_cmd[SCR1_DBG_COMMAND_ACCESSREG_POSTEXEC];
		abs_cmd_regvalid = ~(|{abs_cmd[SCR1_DBG_COMMAND_ACCESSREG_RESERVEDB], abs_cmd[SCR1_DBG_COMMAND_ACCESSREG_RESERVEDA]});
		abs_cmd_memsize = abs_cmd[SCR1_DBG_COMMAND_ACCESSMEM_AAMSIZE_HI:SCR1_DBG_COMMAND_ACCESSMEM_AAMSIZE_LO];
		abs_cmd_memwr = abs_cmd[SCR1_DBG_COMMAND_ACCESSMEM_WRITE];
		abs_cmd_memvalid = ~(|{abs_cmd[SCR1_DBG_COMMAND_ACCESSMEM_AAMVIRTUAL], abs_cmd[SCR1_DBG_COMMAND_ACCESSMEM_AAMPOSTINC], abs_cmd[SCR1_DBG_COMMAND_ACCESSMEM_RESERVEDB_HI:SCR1_DBG_COMMAND_ACCESSMEM_RESERVEDB_HI], abs_cmd[SCR1_DBG_COMMAND_ACCESSMEM_RESERVEDA_HI:SCR1_DBG_COMMAND_ACCESSMEM_RESERVEDA_HI]});
	end
	assign abs_reg_access_csr = abs_cmd_regtype == ABS_CMD_HARTREG_CSR;
	assign abs_reg_access_mprf = (abs_cmd_regtype == ABS_CMD_HARTREG_INTFPU) & (abs_cmd_regfile == ABS_CMD_HARTREG_INT);
	assign abs_cmd_regsize_vd = abs_cmd_regsize == 3'h2;
	assign abs_cmd_memsize_vd = abs_cmd_memsize < 3'h3;
	assign abs_cmd_hartreg_vd = (abs_cmd_type == ABS_CMD_HARTREG) & abs_cmd_regvalid;
	assign abs_cmd_hartmem_vd = (abs_cmd_type == ABS_CMD_HARTMEM) & abs_cmd_memvalid;
	assign abs_cmd_reg_access_req = abs_cmd_hartreg_vd & abs_cmd_regacs;
	assign abs_cmd_csr_access_req = abs_cmd_reg_access_req & abs_reg_access_csr;
	assign abs_cmd_mprf_access_req = abs_cmd_reg_access_req & abs_reg_access_mprf;
	assign abs_cmd_execprogbuf_req = abs_cmd_hartreg_vd & abs_cmd_execprogbuf;
	assign abs_cmd_csr_ro_access_vd = ((((abs_cmd_csr_access_req & abs_cmd_regsize_vd) & ~abs_cmd_regwr) & ~abs_cmd_execprogbuf) & abs_cmd_csr_ro) & hart_state_run;
	assign abs_cmd_csr_rw_access_vd = (abs_cmd_csr_access_req & abs_cmd_regsize_vd) & (abs_cmd_regwr | ~abs_cmd_csr_ro_access_vd);
	assign abs_cmd_mprf_access_vd = abs_cmd_mprf_access_req & abs_cmd_regsize_vd;
	assign abs_cmd_mem_access_vd = abs_cmd_hartmem_vd & abs_cmd_memsize_vd;
	always @(posedge clk)
		if (clk_en_abs & abs_fsm_idle) begin
			abs_cmd_postexec_ff <= abs_cmd_postexec_next;
			abs_cmd_wr_ff <= abs_cmd_wr_next;
			abs_cmd_regno_ff <= abs_cmd_regno;
			abs_cmd_size_ff <= abs_cmd_size_next;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		abs_cmd_wr_next = 1'b0;
		abs_cmd_postexec_next = 1'b0;
		abs_cmd_size_next = abs_cmd_size_ff;
		if (((command_wr_req | dmi_rpt_command) & hart_state_dhalt) & abs_fsm_idle) begin
			if (abs_cmd_csr_rw_access_vd) begin
				abs_cmd_wr_next = abs_cmd_regwr;
				abs_cmd_postexec_next = abs_cmd_execprogbuf;
			end
			else if (abs_cmd_mprf_access_vd) begin
				abs_cmd_wr_next = abs_cmd_regwr;
				abs_cmd_size_next = abs_cmd_regsize[1:0];
				abs_cmd_postexec_next = abs_cmd_execprogbuf;
			end
			else if (abs_cmd_mem_access_vd) begin
				abs_cmd_wr_next = abs_cmd_memwr;
				abs_cmd_size_next = abs_cmd_memsize[1:0];
			end
		end
	end
	always @(posedge clk)
		if (clk_en_dm) begin
			if (~dmcontrol_dmactive_ff)
				abs_fsm_ff <= 4'd0;
			else
				abs_fsm_ff <= abs_fsm_next;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		abs_fsm_next = abs_fsm_ff;
		case (abs_fsm_ff)
			4'd0:
				if (command_wr_req | dmi_rpt_command)
					case (1'b1)
						abs_cmd_csr_ro_access_vd: abs_fsm_next = 4'd9;
						abs_cmd_csr_rw_access_vd: abs_fsm_next = (hart_state_dhalt ? 4'd10 : 4'd1);
						abs_cmd_mprf_access_vd: abs_fsm_next = (hart_state_dhalt ? 4'd3 : 4'd1);
						abs_cmd_execprogbuf_req: abs_fsm_next = 4'd2;
						abs_cmd_mem_access_vd: abs_fsm_next = (hart_state_dhalt ? 4'd4 : 4'd1);
						default: abs_fsm_next = 4'd1;
					endcase
			4'd2:
				if (dhi_resp) begin
					if (dhi_resp_exc | abs_err_acc_busy_ff)
						abs_fsm_next = 4'd1;
					else
						abs_fsm_next = 4'd0;
				end
			4'd3:
				if (dhi_resp)
					case (1'b1)
						abs_err_acc_busy_ff: abs_fsm_next = 4'd1;
						abs_cmd_postexec_ff: abs_fsm_next = 4'd2;
						default: abs_fsm_next = 4'd0;
					endcase
			4'd9: abs_fsm_next = (abs_err_acc_busy_ff ? 4'd1 : 4'd0);
			4'd10: abs_fsm_next = (dhi_resp ? 4'd11 : 4'd10);
			4'd11: abs_fsm_next = (dhi_resp ? 4'd12 : 4'd11);
			4'd12:
				if (dhi_resp)
					case (1'b1)
						abs_err_exc_ff: abs_fsm_next = 4'd1;
						abs_err_acc_busy_ff: abs_fsm_next = 4'd1;
						abs_cmd_postexec_ff: abs_fsm_next = 4'd2;
						default: abs_fsm_next = 4'd0;
					endcase
			4'd4: abs_fsm_next = (dhi_resp ? 4'd5 : 4'd4);
			4'd5: abs_fsm_next = (dhi_resp ? 4'd6 : 4'd5);
			4'd6: abs_fsm_next = (dhi_resp ? 4'd7 : 4'd6);
			4'd7: abs_fsm_next = (dhi_resp ? 4'd8 : 4'd7);
			4'd8:
				if (dhi_resp)
					case (1'b1)
						abs_err_exc_ff: abs_fsm_next = 4'd1;
						abs_err_acc_busy_ff: abs_fsm_next = 4'd1;
						abs_cmd_postexec_ff: abs_fsm_next = 4'd2;
						default: abs_fsm_next = 4'd0;
					endcase
			4'd1:
				if (abstractcs_wr_req & (abstractcs_cmderr_next == 3'b000))
					abs_fsm_next = 4'd0;
		endcase
		if (~abs_fsm_idle & hart_state_reset)
			abs_fsm_next = 4'd1;
	end
	assign abs_fsm_idle = abs_fsm_ff == 4'd0;
	assign abs_fsm_exec = abs_fsm_ff == 4'd2;
	assign abs_fsm_csr_ro = abs_fsm_ff == 4'd9;
	assign abs_fsm_err = abs_fsm_ff == 4'd1;
	assign abs_fsm_use_addr = (abs_fsm_ff == 4'd5) | (abs_fsm_ff == 4'd8);
	assign abs_err_acc_busy_upd = clk_en_abs & (abs_fsm_idle | dmi_req_any);
	always @(posedge clk)
		if (abs_err_acc_busy_upd)
			abs_err_acc_busy_ff <= abs_err_acc_busy_next;
	assign abs_err_acc_busy_next = ~abs_fsm_idle & dmi_req_any;
	assign abs_err_exc_upd = clk_en_abs & (abs_fsm_idle | (dhi_resp & dhi_resp_exc));
	always @(posedge clk)
		if (abs_err_exc_upd)
			abs_err_exc_ff <= abs_err_exc_next;
	assign abs_err_exc_next = (~abs_fsm_idle & dhi_resp) & dhi_resp_exc;
	assign abs_exec_req_next = ~((abs_fsm_idle | abs_fsm_csr_ro) | abs_fsm_err) & ~dhi_resp;
	always @(posedge clk)
		if (clk_en_dm) begin
			if (~dmcontrol_dmactive_ff)
				abs_exec_req_ff <= 1'b0;
			else
				abs_exec_req_ff <= abs_exec_req_next;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		case (abs_cmd_size_ff)
			2'b00: abs_instr_mem_funct3 = (abs_cmd_wr_ff ? SCR1_FUNCT3_SB : SCR1_FUNCT3_LBU);
			2'b01: abs_instr_mem_funct3 = (abs_cmd_wr_ff ? SCR1_FUNCT3_SH : SCR1_FUNCT3_LHU);
			2'b10: abs_instr_mem_funct3 = (abs_cmd_wr_ff ? SCR1_FUNCT3_SW : SCR1_FUNCT3_LW);
			default: abs_instr_mem_funct3 = SCR1_FUNCT3_SB;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		abs_instr_rs1 = 5'h00;
		case (abs_fsm_ff)
			4'd3: abs_instr_rs1 = (abs_cmd_wr_ff ? 5'h00 : abs_cmd_regno_ff[4:0]);
			4'd10: abs_instr_rs1 = 5'h05;
			4'd4: abs_instr_rs1 = 5'h05;
			4'd12: abs_instr_rs1 = 5'h05;
			4'd7: abs_instr_rs1 = 5'h05;
			4'd11: abs_instr_rs1 = (abs_cmd_wr_ff ? 5'h05 : 5'h00);
			4'd5: abs_instr_rs1 = 5'h06;
			4'd8: abs_instr_rs1 = 5'h06;
			4'd6: abs_instr_rs1 = 5'h06;
			default:
				;
		endcase
	end
	assign abs_instr_rs2 = 5'h05;
	always @(*) begin
		if (_sv2v_0)
			;
		abs_instr_rd = 5'h00;
		case (abs_fsm_ff)
			4'd3: abs_instr_rd = (abs_cmd_wr_ff ? abs_cmd_regno_ff[4:0] : 5'h00);
			4'd10: abs_instr_rd = (abs_cmd_wr_ff ? 5'h05 : 5'h00);
			4'd4: abs_instr_rd = (abs_cmd_wr_ff ? 5'h05 : 5'h00);
			4'd11: abs_instr_rd = (abs_cmd_wr_ff ? 5'h00 : 5'h05);
			4'd6: abs_instr_rd = (abs_cmd_wr_ff ? 5'h00 : 5'h05);
			4'd12: abs_instr_rd = 5'h05;
			4'd7: abs_instr_rd = 5'h05;
			4'd5: abs_instr_rd = 5'h06;
			4'd8: abs_instr_rd = 5'h06;
			default:
				;
		endcase
	end
	always @(posedge clk)
		if (clk_en_abs)
			abs_exec_instr_ff <= abs_exec_instr_next;
	localparam SCR1_HDU_DBGCSR_OFFS_DSCRATCH0 = sv2v_cast_68C55('d2);
	localparam [11:0] SCR1_HDU_DBGCSR_ADDR_DSCRATCH0 = SCR1_CSR_ADDR_HDU_MBASE + SCR1_HDU_DBGCSR_OFFS_DSCRATCH0;
	always @(*) begin
		if (_sv2v_0)
			;
		abs_exec_instr_next = abs_exec_instr_ff;
		case (abs_fsm_ff)
			4'd3, 4'd10, 4'd12, 4'd4, 4'd5, 4'd7, 4'd8: abs_exec_instr_next = {SCR1_HDU_DBGCSR_ADDR_DSCRATCH0, abs_instr_rs1, SCR1_FUNCT3_CSRRW, abs_instr_rd, SCR1_OP_SYSTEM};
			4'd11: abs_exec_instr_next = (abs_cmd_wr_ff ? {abs_cmd_regno_ff[11:0], abs_instr_rs1, SCR1_FUNCT3_CSRRW, abs_instr_rd, SCR1_OP_SYSTEM} : {abs_cmd_regno_ff[11:0], abs_instr_rs1, SCR1_FUNCT3_CSRRS, abs_instr_rd, SCR1_OP_SYSTEM});
			4'd6: abs_exec_instr_next = (abs_cmd_wr_ff ? {7'h00, abs_instr_rs2, abs_instr_rs1, abs_instr_mem_funct3, 5'h00, SCR1_OP_STORE} : {12'h000, abs_instr_rs1, abs_instr_mem_funct3, abs_instr_rd, SCR1_OP_LOAD});
			default:
				;
		endcase
	end
	function automatic [((SCR1_DBG_ABSTRACTCS_CMDERR_WDTH + 0) >= 0 ? SCR1_DBG_ABSTRACTCS_CMDERR_WDTH + 1 : 1 - (SCR1_DBG_ABSTRACTCS_CMDERR_WDTH + 0)) - 1:0] sv2v_cast_11E98;
		input reg [((SCR1_DBG_ABSTRACTCS_CMDERR_WDTH + 0) >= 0 ? SCR1_DBG_ABSTRACTCS_CMDERR_WDTH + 1 : 1 - (SCR1_DBG_ABSTRACTCS_CMDERR_WDTH + 0)) - 1:0] inp;
		sv2v_cast_11E98 = inp;
	endfunction
	function automatic [(SCR1_DBG_ABSTRACTCS_CMDERR_WDTH >= 0 ? SCR1_DBG_ABSTRACTCS_CMDERR_WDTH + 1 : 1 - SCR1_DBG_ABSTRACTCS_CMDERR_WDTH) - 1:0] sv2v_cast_0E3B4;
		input reg [(SCR1_DBG_ABSTRACTCS_CMDERR_WDTH >= 0 ? SCR1_DBG_ABSTRACTCS_CMDERR_WDTH + 1 : 1 - SCR1_DBG_ABSTRACTCS_CMDERR_WDTH) - 1:0] inp;
		sv2v_cast_0E3B4 = inp;
	endfunction
	always @(posedge clk)
		if (clk_en_dm) begin
			if (~dmcontrol_dmactive_ff)
				abstractcs_cmderr_ff <= sv2v_cast_0E3B4(sv2v_cast_11E98('d0));
			else
				abstractcs_cmderr_ff <= abstractcs_cmderr_next;
		end
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		abstractcs_cmderr_next = abstractcs_cmderr_ff;
		case (abs_fsm_ff)
			4'd0:
				if (command_wr_req | dmi_rpt_command) begin
					if (abs_cmd_hartreg_vd)
						case (1'b1)
							abs_cmd_reg_access_req:
								case (1'b1)
									abs_cmd_csr_rw_access_vd: abstractcs_cmderr_next = (hart_state_dhalt ? abstractcs_cmderr_ff : sv2v_cast_0E3B4(sv2v_cast_11E98('d4)));
									abs_cmd_mprf_access_vd: abstractcs_cmderr_next = (hart_state_dhalt ? abstractcs_cmderr_ff : sv2v_cast_0E3B4(sv2v_cast_11E98('d4)));
									abs_cmd_csr_ro_access_vd: abstractcs_cmderr_next = abstractcs_cmderr_ff;
									default: abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d2));
								endcase
							abs_cmd_execprogbuf_req: abstractcs_cmderr_next = abstractcs_cmderr_ff;
							default: abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d2));
						endcase
					else if (abs_cmd_hartmem_vd)
						abstractcs_cmderr_next = (~abs_cmd_memsize_vd ? sv2v_cast_0E3B4(sv2v_cast_11E98('d2)) : (~hart_state_dhalt ? sv2v_cast_0E3B4(sv2v_cast_11E98('d4)) : abstractcs_cmderr_ff));
					else
						abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d2));
				end
			4'd2:
				if (dhi_resp) begin
					if (dhi_resp_exc)
						abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d3));
					else if (abs_err_acc_busy_ff)
						abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d1));
				end
			4'd3, 4'd9:
				if (abs_err_acc_busy_ff)
					abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d1));
			4'd12, 4'd8:
				if (dhi_resp)
					case (1'b1)
						abs_err_exc_ff: abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d3));
						abs_err_acc_busy_ff: abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d1));
						default: abstractcs_cmderr_next = abstractcs_cmderr_ff;
					endcase
			4'd1:
				if (dmi_req_abstractcs & dmi2dm_wr_i)
					abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_1(abstractcs_cmderr_ff) & ~dmi2dm_wdata_i[SCR1_DBG_ABSTRACTCS_CMDERR_HI:SCR1_DBG_ABSTRACTCS_CMDERR_LO]);
			default:
				;
		endcase
		if (~abs_fsm_idle & hart_state_reset)
			abstractcs_cmderr_next = sv2v_cast_0E3B4(sv2v_cast_11E98('d3));
	end
	assign abstractcs_busy = ~abs_fsm_idle & ~abs_fsm_err;
	always @(posedge clk)
		if (clk_en_dm)
			abs_command_ff <= abs_command_next;
	assign abs_command_next = (~dmcontrol_dmactive_ff ? {32 {1'sb0}} : (command_wr_req & abs_fsm_idle ? dmi2dm_wdata_i : abs_command_ff));
	always @(posedge clk)
		if (clk_en_dm)
			abs_autoexec_ff <= abs_autoexec_next;
	assign abs_autoexec_next = (~dmcontrol_dmactive_ff ? 1'b0 : (autoexec_wr_req & abs_fsm_idle ? dmi2dm_wdata_i[0] : abs_autoexec_ff));
	always @(posedge clk)
		if (clk_en_abs & abs_fsm_idle) begin
			if (progbuf0_wr_req)
				abs_progbuf0_ff <= dmi2dm_wdata_i;
			if (progbuf1_wr_req)
				abs_progbuf1_ff <= dmi2dm_wdata_i;
			if (progbuf2_wr_req)
				abs_progbuf2_ff <= dmi2dm_wdata_i;
			if (progbuf3_wr_req)
				abs_progbuf3_ff <= dmi2dm_wdata_i;
			if (progbuf4_wr_req)
				abs_progbuf4_ff <= dmi2dm_wdata_i;
			if (progbuf5_wr_req)
				abs_progbuf5_ff <= dmi2dm_wdata_i;
		end
	always @(posedge clk)
		if (clk_en_abs)
			abs_data0_ff <= abs_data0_next;
	assign data0_xreg_save = dreg_wr_req & ~abs_cmd_wr_ff;
	localparam [31:0] SCR1_CSR_MARCHID = 32'd8;
	localparam [31:0] SCR1_CSR_MIMPID = 32'h22011200;
	localparam [1:0] SCR1_MISA_MXL_32 = 2'd1;
	localparam [31:0] SCR1_CSR_MISA = (((SCR1_MISA_MXL_32 << 30) | 32'h00000100) | 32'h00000004) | 32'h00001000;
	localparam [31:0] SCR1_CSR_MVENDORID = 32'h00000000;
	always @(*) begin
		if (_sv2v_0)
			;
		abs_data0_next = abs_data0_ff;
		case (abs_fsm_ff)
			4'd0: abs_data0_next = (data0_wr_req ? dmi2dm_wdata_i : abs_data0_ff);
			4'd2: abs_data0_next = (dreg_wr_req ? pipe2dm_dreg_wdata_i : abs_data0_ff);
			4'd10: abs_data0_next = (dreg_wr_req ? pipe2dm_dreg_wdata_i : abs_data0_ff);
			4'd12: abs_data0_next = (dreg_wr_req ? pipe2dm_dreg_wdata_i : abs_data0_ff);
			4'd4: abs_data0_next = (dreg_wr_req ? pipe2dm_dreg_wdata_i : abs_data0_ff);
			4'd7: abs_data0_next = (dreg_wr_req ? pipe2dm_dreg_wdata_i : abs_data0_ff);
			4'd3: abs_data0_next = (data0_xreg_save ? pipe2dm_dreg_wdata_i : abs_data0_ff);
			4'd9:
				case (abs_cmd_regno_ff[11:0])
					SCR1_CSR_ADDR_MISA: abs_data0_next = SCR1_CSR_MISA;
					SCR1_CSR_ADDR_MVENDORID: abs_data0_next = SCR1_CSR_MVENDORID;
					SCR1_CSR_ADDR_MARCHID: abs_data0_next = SCR1_CSR_MARCHID;
					SCR1_CSR_ADDR_MIMPID: abs_data0_next = SCR1_CSR_MIMPID;
					SCR1_CSR_ADDR_MHARTID: abs_data0_next = soc2dm_fuse_mhartid_i;
					default: abs_data0_next = pipe2dm_pc_sample_i;
				endcase
			default:
				;
		endcase
	end
	always @(posedge clk)
		if (clk_en_abs)
			abs_data1_ff <= abs_data1_next;
	always @(*) begin
		if (_sv2v_0)
			;
		abs_data1_next = abs_data1_ff;
		case (abs_fsm_ff)
			4'd0: abs_data1_next = (data1_wr_req ? dmi2dm_wdata_i : abs_data1_ff);
			4'd5: abs_data1_next = (dreg_wr_req ? pipe2dm_dreg_wdata_i : abs_data1_ff);
			4'd8: abs_data1_next = (dreg_wr_req ? pipe2dm_dreg_wdata_i : abs_data1_ff);
			default:
				;
		endcase
	end
	assign cmd_resp_ok = pipe2dm_cmd_resp_i & ~pipe2dm_cmd_rcode_i;
	assign hart_rst_unexp = (~dhi_fsm_idle & ~dhi_fsm_halt_req) & hart_state_reset;
	assign halt_req_vd = dmcontrol_haltreq_ff & ~hart_state_dhalt;
	assign resume_req_vd = (dmcontrol_resumereq_ff & ~dmstatus_allany_resumeack_ff) & hart_state_dhalt;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			dhi_fsm_ff <= 3'd0;
		else if (clk_en_dm)
			dhi_fsm_ff <= dhi_fsm_next;
	always @(*) begin
		if (_sv2v_0)
			;
		dhi_fsm_next = dhi_fsm_ff;
		if (~hart_rst_unexp & dmcontrol_dmactive_ff)
			case (dhi_fsm_ff)
				3'd0: dhi_fsm_next = dhi_req;
				3'd1: dhi_fsm_next = (cmd_resp_ok ? 3'd2 : 3'd1);
				3'd2: dhi_fsm_next = (hart_state_drun ? 3'd3 : 3'd2);
				3'd4: dhi_fsm_next = (cmd_resp_ok ? 3'd3 : 3'd4);
				3'd3: dhi_fsm_next = (hart_state_dhalt ? 3'd0 : 3'd3);
				3'd5: dhi_fsm_next = (cmd_resp_ok ? 3'd6 : 3'd5);
				3'd6: dhi_fsm_next = (hart_state_run ? 3'd0 : 3'd6);
				default: dhi_fsm_next = dhi_fsm_ff;
			endcase
		else
			dhi_fsm_next = 3'd0;
	end
	assign dhi_fsm_idle = dhi_fsm_ff == 3'd0;
	assign dhi_fsm_halt_req = dhi_fsm_ff == 3'd4;
	assign dhi_fsm_exec = dhi_fsm_ff == 3'd1;
	assign dhi_fsm_exec_halt = dhi_fsm_ff == 3'd3;
	assign dhi_fsm_resume_req = dhi_fsm_ff == 3'd5;
	always @(*) begin
		if (_sv2v_0)
			;
		case (1'b1)
			abs_exec_req_ff: dhi_req = 3'd1;
			halt_req_vd: dhi_req = 3'd4;
			resume_req_vd: dhi_req = 3'd5;
			default: dhi_req = 3'd0;
		endcase
	end
	assign dhi_resp = dhi_fsm_exec_halt & hart_state_dhalt;
	assign dhi_resp_exc = (pipe2dm_hart_event_i & pipe2dm_hart_status_i[3]) & ~pipe2dm_hart_status_i[2];
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			hart_cmd_req_ff <= 1'b0;
		else if (clk_en_dm)
			hart_cmd_req_ff <= hart_cmd_req_next;
	assign hart_cmd_req_next = (((dhi_fsm_exec | dhi_fsm_halt_req) | dhi_fsm_resume_req) & ~cmd_resp_ok) & dmcontrol_dmactive_ff;
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			hart_cmd_ff <= 2'b01;
		else if (clk_en_dm)
			hart_cmd_ff <= hart_cmd_next;
	always @(*) begin
		if (_sv2v_0)
			;
		hart_cmd_next = 2'b01;
		if (dmcontrol_dmactive_ff)
			case (dhi_fsm_ff)
				3'd1: hart_cmd_next = 2'b11;
				3'd4: hart_cmd_next = 2'b10;
				3'd5: hart_cmd_next = 2'b01;
				default: hart_cmd_next = dm2pipe_cmd_o;
			endcase
	end
	assign dm2pipe_cmd_req_o = hart_cmd_req_ff;
	assign dm2pipe_cmd_o = hart_cmd_ff;
	always @(posedge clk)
		if (clk_en_dm)
			hart_pbuf_ebreak_ff <= hart_pbuf_ebreak_next;
	assign hart_pbuf_ebreak_next = abs_fsm_exec & (dm2pipe_pbuf_instr_o == ABS_EXEC_EBREAK);
	always @(*) begin
		if (_sv2v_0)
			;
		dm2pipe_pbuf_instr_o = ABS_EXEC_EBREAK;
		if (abs_fsm_exec & ~hart_pbuf_ebreak_ff)
			case (pipe2dm_pbuf_addr_i)
				3'h0: dm2pipe_pbuf_instr_o = abs_progbuf0_ff;
				3'h1: dm2pipe_pbuf_instr_o = abs_progbuf1_ff;
				3'h2: dm2pipe_pbuf_instr_o = abs_progbuf2_ff;
				3'h3: dm2pipe_pbuf_instr_o = abs_progbuf3_ff;
				3'h4: dm2pipe_pbuf_instr_o = abs_progbuf4_ff;
				3'h5: dm2pipe_pbuf_instr_o = abs_progbuf5_ff;
				default:
					;
			endcase
		else if (pipe2dm_pbuf_addr_i == 3'b000)
			dm2pipe_pbuf_instr_o = abs_exec_instr_ff;
	end
	assign dm2pipe_dreg_resp_o = 1'b1;
	assign dm2pipe_dreg_fail_o = 1'b0;
	assign dm2pipe_dreg_rdata_o = (abs_fsm_use_addr ? abs_data1_ff : abs_data0_ff);
	initial _sv2v_0 = 0;
endmodule
