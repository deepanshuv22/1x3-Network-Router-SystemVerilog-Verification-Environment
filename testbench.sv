`include "packet.sv"
`include "interface.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "generator.sv"
`include "subscriber.sv"

module top;
  
  bit clk;
  always #5 clk = ~clk;
  router_if rif(clk);
  //DUT INSTANTIATION
 router dut (
  .clk     (rif.clk),
  .reset_n (rif.reset_n),
  .din     (rif.din),
  .din_en  (rif.din_en),

  .dout0   (rif.dout0),
  .dout1   (rif.dout1),
  .dout2   (rif.dout2),

  .dout0_en(rif.dout0_en),
  .dout1_en(rif.dout1_en),
  .dout2_en(rif.dout2_en)
);



  driver drv;
  generator gen;
  monitor mon;
  scoreboard scb;
  subscriber cov;
  mailbox m_mon2scb;
  mailbox m_gen2scb;
  mailbox m_mon2cov;
  initial begin
    clk=0;
    rif.reset_n=0;
    #20;
    rif.reset_n=1;
    m_mon2scb = new();
    m_gen2scb = new();
    m_mon2cov = new();
    drv = new(rif);
    gen = new(drv,m_gen2scb);
    mon = new(rif,m_mon2scb,m_mon2cov);
    scb = new(m_mon2scb,m_gen2scb);
    cov = new(m_mon2cov);
    fork
    mon.run();
    scb.run();
      cov.run();
    join_none
    gen.run();
   // $display("INTERFACE RESET STATUS:%0b",rif.reset_n);
    #1000;$finish;
  end
  initial begin
    $dumpfile("waves.vcd");
  $dumpvars(0, top);   // dump everything under top
end
  
  
endmodule