//Interface
interface router_if(input bit clk);
  logic reset_n;
  logic [7:0] din; //8 bit data input
  logic din_en; //DATA ENABLE SIGNAL
  logic [7:0] dout0; //8-bit data output
  logic dout0_en; //OUTPUT VALID
  logic [7:0] dout1; //8-bit data output
  logic dout1_en; //OUTPUT VALID
  logic [7:0] dout2; //8-bit data output
  logic dout2_en; //OUTPUT VALID
  
  // ASSERTION: CHECK FOR UNKNOWNS
  property no_x_in_data;
    @(posedge clk) din_en |-> !$isunknown(din);
  endproperty
  ASSERT_NO_X: assert property (no_x_in_data)
    else $error("[ASSERTION FAILED] 'din' has X value while enebled!");
    //RESET CHECK
    property reset_check;
      @(posedge clk) !reset_n |-> !din_en;
    endproperty
    
    ASSERT_RESET: assert property(reset_check)
      else $error("[ASSERTION FAILED] Driver sending data during reset!");
  
  
  
endinterface