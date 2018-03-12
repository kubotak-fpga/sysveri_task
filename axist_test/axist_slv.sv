module axist_slv
  (
   input wire         clk,
   input logic        valid,
   input logic [7: 0] din,
   output logic       ready
   );


   initial begin
      ready <= 1'b1;
   end


   task force_set_ready(bit val);
      

      ready <= val;
      
      @ (posedge clk);

      
   endtask


endmodule
