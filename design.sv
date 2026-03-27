module router(
  input bit clk,
  input bit reset_n,
  input bit [7:0] din,
  input bit din_en,
  output bit [7:0] dout0, dout1, dout2,
  output bit dout0_en, dout1_en, dout2_en
);
  
  int state = 0; 
  // State 0: Waiting for Header
  // State 1: Routing Payload
  
  bit [1:0] current_dest; // Stores where we are sending data

  always @(posedge clk) begin
    if(!reset_n) begin
      dout0_en <= 0; dout1_en <= 0; dout2_en <= 0;
      state <= 0;
    end else begin
      
      // LOGIC: Reset outputs every cycle unless driven
      dout0_en <= 0; dout1_en <= 0; dout2_en <= 0;

      if(din_en) begin
        if(state == 0) begin
          // This is the Header Byte!
          current_dest = din[1:0]; // Read address
          state = 1; // Move to payload state
          
          // Drive the header to the output immediately
          case(current_dest)
            0: begin dout0 <= din; dout0_en <= 1; end
            1: begin dout1 <= din; dout1_en <= 1; end
            2: begin dout2 <= din; dout2_en <= 1; end
          endcase
        end 
        
        else if(state == 1) begin

          case(current_dest)
            0: begin dout0 <= din; dout0_en <= 1; end
            1: begin dout1 <= din; dout1_en <= 1; end
            2: begin dout2 <= din; dout2_en <= 1; end
          endcase
        end
      end 
      else begin
        // din_en is 0, packet ended
        state = 0; 
      end
    end
  end
endmodule