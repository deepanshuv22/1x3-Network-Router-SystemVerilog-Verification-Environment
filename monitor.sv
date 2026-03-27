class monitor;
  virtual router_if vif;
  mailbox mon2scb;
  mailbox mon2cov;
  function new(virtual router_if vif, mailbox mon2scb, mailbox mon2cov);
    this.vif = vif;
    this.mon2scb = mon2scb;
    this.mon2cov = mon2cov;
    
  endfunction
  task run();
    $display("[MONITOR] STARTED WATCHING OUTPUTS....");
    //FORK JOIN
    fork
      monitor_port(0); //PORT 0
      monitor_port(1); //PORT 1
      monitor_port(2); //PORT 2
      
    join_none
    
  endtask
  task monitor_port(int id);
    packet p;
    bit [7:0] payload_q[$]; //QUEUE TO TEMP. STORE BYTES
    forever begin
      @(posedge vif.clk);
      if((id ==0 && vif.dout0_en)|| (id==1 && vif.dout1_en) || (id==2 && vif.dout2_en)) begin
        $display("[MONITOR] Port %0d Started Receiving packet....",id);
        p = new();
        payload_q.delete();
        //LOOP WHILE DATA ENABLE IS HIGH
        while ((id==0 && vif.dout0_en) || (id==1 && vif.dout1_en) || (id==2 && vif.dout2_en)) begin
          if(id==0) payload_q.push_back(vif.dout0);
          if(id==1) payload_q.push_back(vif.dout1);
          if(id==2) payload_q.push_back(vif.dout2);
          @(posedge vif.clk);
          
          
          
        end
        p.dst_address = payload_q.pop_front();
        p.payload = new[payload_q.size()];
        foreach(payload_q[i]) p.payload[i] = payload_q[i];
        
        mon2scb.put(p);
        mon2cov.put(p);
        
        $display("[MONITOR] PORT %0d sent packet to scoreboard!",id);
        
      end
    end
    
  endtask
  
  
  
endclass