SRC_DIR := .
CORE_DIR := $(SRC_DIR)/core
INCLUDE_DIR := $(SRC_DIR)/includes

CORE_FILES := $(shell cat $(SRC_DIR)/core.files)

V_DIR := build/verilog

SV2V := sv2v
YOSYS := yosys

TOP_MODULE := scr1_top

# ahb or axi (axi by default)
BUS ?= axi

ifeq ($(BUS), ahb)
	BUS_FILES := $(shell cat $(SRC_DIR)/ahb_top.files)
else ifeq ($(BUS), axi)
	BUS_FILES := $(shell cat $(SRC_DIR)/axi_top.files)
else
	$(error Unrecognized bus: "$(BUS)"\n Available bus values are: "ahb", "axi")
endif

SV_FILES := $(CORE_FILES) $(BUS_FILES)

V_FILES := $(SV_FILES:%.sv=$(V_DIR)/%.v) $()

all: $(V_FILES) $(V_DIR)/$(TOP_MODULE)_$(BUS).json $(V_DIR)/$(TOP_MODULE)_$(BUS).config

$(V_DIR)/%.v: $(SRC_DIR)/%.sv | $(V_DIR)
	@echo $(V_FILES)
	@echo "\nConverting $< to Verilog...\n"
	@mkdir -p $(dir $@)
	$(SV2V) -I$(INCLUDE_DIR) $< > $@
	
$(V_DIR):
	@mkdir -p $(V_DIR)

$(V_DIR)/$(TOP_MODULE)_$(BUS).json: $(V_FILES)
	@echo "Running Yosys synthesis..."
	$(YOSYS) -p "read_verilog $(V_FILES); synth_ecp5 -top $(TOP_MODULE)_$(BUS); write_json $(V_DIR)/$(TOP_MODULE)_$(BUS).json; stat" 2>&1 | tee yosys_warnings.log

$(V_DIR)/$(TOP_MODULE)_$(BUS).config: $(V_DIR)/$(TOP_MODULE)_$(BUS).json
	nextpnr-ecp5 --45k --package CABGA381 --speed 6 --json $< --textcfg $@ --lpf $(ADDONS_DIR)/colorlight_i9.lpf --freq 65

clean:
	@echo "Cleaning up..."
	@rm -rf $(V_DIR)

.PHONY: all synth clean


