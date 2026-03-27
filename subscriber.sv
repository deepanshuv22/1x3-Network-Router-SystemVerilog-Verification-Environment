class subscriber;
  mailbox mon2cov;
  packet p;
  //COVERGROUP
  covergroup router_cg ;
    //CHECKING IF WE HIT ALL THE DESTINATIONS {0,1,2}
    dst_cp: coverpoint p.dst_address {
      bins port_0 = {0};
      bins port_1 = {1};
      bins port_2 = {2};
      ignore_bins invalid = {[3:15]};
      
    
    }
    //Checking if we hit payload sizes
    len_cp
    : coverpoint p.payload.size() {
      bins min_size = {10};
      bins max_size = {20};
      bins mid_size = {[11:19]};
     } 
    //CROSS COVERAGE
    cross_dst_len: cross dst_cp, len_cp;
  endgroup
  function new(mailbox mon2cov);
    this.mon2cov = mon2cov;
    router_cg = new();
  endfunction
  task run();
    
    forever begin
      //GET PACKET FROM MONITOR
      mon2cov.get(p);
      router_cg.sample();
      //router_cg.print();
      //coverage_score = router_cg.get_inst_coverage();
      $display("[COVERAGE] COVERAGE: %.2f%%",router_cg.get_inst_coverage());
    end
  endtask
  
endclass