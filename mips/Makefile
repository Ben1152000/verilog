VCS = /ece/synopsys/vcs/R-2020.12-SP1/bin/vcs
VFLAGS = -full64 -debug_all

all: alu.v control.v mem.v mips.v reg.v rom.v mips_tb.v
	$(VCS) $(VFLAGS) alu.v control.v mem.v mips.v reg.v rom.v mips_tb.v

sim: simv
	./simv -gui

clean:
	rm -rf mips.vcd csrc DVEfiles simv.daidir .restartSimSession.tcl.old inter.vpd simv ucli.key