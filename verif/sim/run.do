# Create the library.
if [ file exists work] {
    vdel -all
}

vlib work

# compile DUT				

vcom ../../dut/axi_myip_v1_0_M00_AXIS.vhd
vcom ../../dut/axi_myip_v1_0_S00_AXIL.vhd
vcom ../../dut/axi_myip_v1_0_S01_AXIS.vhd
vcom ../../dut/IP.vhd
vcom ../../dut/mem_subsystem.vhd
vcom ../../dut/axi_myip_v1_0.vhd 

		
# compile testbench
vlog -sv \
    +incdir+$env(UVM_HOME) \
    +incdir+../sv \
    ../sv/eq_verif_pkg.sv \
    ../sv/eq_verif_top.sv

# run simulation
vopt eq_verif_top -o opttop +cover
vsim eq_verif_top -novopt +UVM_TESTNAME=test_eq_my_1 +UVM_VERBOSITY=UVM_LOW -sv_seed random

vsim -coverage opttop
coverage save eq_verif_top.ucdb

#vsim -coverage opttop  -novopt +UVM_TIMEOUT=200 +UVM_TESTNAME=test_svm_dskw_simple_2 #+UVM_VERBOSITY=UVM_NONE -sv_seed random 

# do wave.do 
run -all
