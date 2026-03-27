class generator;
  packet p;
  driver drv;
  mailbox gen2scb; //MAILBOX TO SCOREBOARD
  function new(driver drv, mailbox gen2scb);
    this.drv=drv;
    this.gen2scb = gen2scb;
  endfunction
  task run();
    packet p_copy;
    $display("-----Generator started-----");
    repeat(20) begin
      p=new();
      if(p.randomize()) begin
        p.display("GENERATOR");
      end
      else $display("RANDOMIZATION FAILED");
      p_copy = new p;
      gen2scb.put(p_copy);
      drv.drive(p);
    end
    $display("----GENERATOR ENDED-----");
    
    
  endtask
  
  
endclass