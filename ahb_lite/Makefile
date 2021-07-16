VCS = /ece/synopsys/vcs/R-2020.12-SP1/bin/vcs
VFLAGS = -full64 -debug_all

all: ahb_lite.v ahb_lite_tb.v
	$(VCS) $(VFLAGS) ahb_lite.v ahb_lite_tb.v

sim: simv
	./simv -gui

clean:
	rm -rf csrc DVEfiles simv.daidir .restartSimSession.tcl.old ahb_lite.vcd inter.vpd simv