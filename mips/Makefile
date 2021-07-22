VCS = /ece/synopsys/vcs/R-2020.12-SP1/bin/vcs
VFLAGS = -full64 -debug_all

all: mips.v mips_tb.v
	$(VCS) $(VFLAGS) mips.v mips_tb.v

sim: simv
	./simv -gui

clean:
	rm -rf mips.vcd csrc DVEfiles simv.daidir .restartSimSession.tcl.old inter.vpd simv ucli.key