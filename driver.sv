class driver;
  virtual router_if vif;
  function new(virtual router_if vif);
    this.vif = vif;
  endfunction
  
  task drive(packet p);
    $display("[DRIVER] Sending packet to address %0d",p.dst_address);
    @(posedge vif.clk);
    vif.din_en <=1;
    vif.din <= p.dst_address;
    foreach (p.payload[i]) begin
      @(posedge vif.clk);
      vif.din <= p.payload[i];
      
    end
    @(posedge vif.clk);
    vif.din_en <=0;
    vif.din<=0;
  endtask

endclass