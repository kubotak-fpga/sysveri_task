//Simple BFM, req/ack interface master

module ifra_mst
  #(
    parameter DATA_WIDTH = 8
    )
  (
   input logic         clk,
   input logic         ack,
   output logic        req,
   output logic [DATA_WIDTH -1: 0] dout
  
   );

   initial begin
      $display("*** ifra_mst init *****");
      req <= 1'b0;
      dout <= 0;
   end

   task write_issue(logic [DATA_WIDTH -1: 0] din[], int num);

      for (int i = 0; i < num; i++) begin

         req <= 1'b1;
         dout <= din[i];

         wait (ack == 1'b1);
         
         repeat(1) @(posedge clk);
         
         req <= 1'b0;
         dout <= 0;
         
         repeat(1) @(posedge clk);
         
      end

   endtask // write_issue

endmodule
