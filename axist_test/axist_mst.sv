//Simple BFM, axi stream master 

module axist_mst
  #(
    parameter DATA_WIDTH = 8
    )
   (
    input logic                    clk,
    input logic                    ready,
    output logic                   valid,
    output logic                   last,
    output logic [DATA_WIDTH-1: 0] dout
   
    );


   initial begin
      valid <= 1'b0;
      last <= 1'b0;
      dout <= 0;
   end



   task write_issue(logic [DATA_WIDTH-1: 0] din[], int num);
      
      for (int i = 0; i < num; i++) begin

         valid <= 1'b1;
         dout <= din[i];

         if (i == num -1 ) begin
            last <= 1'b1;
         end
         
         wait(ready);
         
         repeat(1) @(posedge clk);

      end

      valid <= 1'b0;
      last <= 1'b0;

      repeat(1) @(posedge clk);
      
   endtask


endmodule
