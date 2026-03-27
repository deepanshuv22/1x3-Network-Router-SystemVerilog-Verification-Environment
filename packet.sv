
class packet;
  rand bit [3:0] src_address; //SOURCE ADDRESS
  rand bit [3:0] dst_address; //Destination Address
  rand bit [7:0] payload[]; //DATA
  //CONSTRAINT
  constraint valid_size {payload.size() inside {[10:20]};}
  constraint dst_c {dst_address inside {[0:2]};}
  // SEND 70% TRAFFIC TO PORT ZERO
  constraint dist_dst {dst_address dist{0:=70,[1:2]:=10};}
  constraint dist_size {payload.size() dist {[10:12]:/80,[13:20]:/20};}
  
  
  
  
  function void display(string name = "PACKET");
    $display("----------------------");
    $display("[%s] Source:%0d, Dest: %0d",name, src_address, dst_address);
    $display("[%s] Payload size:%0d",name,payload.size());
    $display("----------------------");
    
    
    
  endfunction
  
endclass