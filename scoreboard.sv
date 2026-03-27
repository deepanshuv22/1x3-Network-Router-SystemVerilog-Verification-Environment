class scoreboard;
  mailbox mon2scb;
  mailbox gen2scb;
  int passed = 0;
  int failed = 0;
  int packet_count = 0;
  function new(mailbox mon2scb, mailbox gen2scb);
    this.mon2scb = mon2scb;
    this.gen2scb = gen2scb;
  endfunction
  task run();
    packet exp_p, act_p;
    forever begin
      //GET BOTH THE PACKETS
      gen2scb.get(exp_p);
      mon2scb.get(act_p);
      //COMPARE DESTINATION ADDRESS
      if(act_p.dst_address == exp_p.dst_address) begin
        $display("[SCB] ADDR MATCH: %0d",act_p.dst_address);
        
      end 
      else begin
        $error("[SCB] ADDR MISMATCH! EXP: %0d ACT: %0d",exp_p.dst_address,act_p.dst_address);
        failed++;
      end
      //COMPARE PAYLOAD
      
      if(act_p.payload.size()!= exp_p.payload.size()) begin
        $error("[SCB] SIZE MISMATCH! EXP: %0d ACT: %0d",exp_p.payload.size(), act_p.payload.size());
        failed++;
      end
      if(act_p.payload == exp_p.payload) begin
        $display("[SCB] Payload match! size: %0d", act_p.payload.size());
        passed++;
      end else begin
        $error("[SCB] DATA MISMATCH IN PAYLOAD!");
        failed++;
      end

      
     
    $display("[SCB] SCORE: PASS=%0d, FAIL = %0d",passed,failed);
      
    end
    
  endtask
  
endclass