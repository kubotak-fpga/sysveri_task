`default_nettype none

  module tb_top();

`timescale 1ps / 1ps   

   localparam PERIOD_100MHz = 10000; //100MHz

   reg clk = 0;

   wire valid;
   wire ready;
   
   //reg [7: 0] data_ary[0 :3];
   reg [7: 0] data_ary[];
   int        ary_size = 8;
   

   wire [7: 0] dat;
   
   
   axist_mst u_axist_mst
     (
      .clk(clk),
      .ready(ready),
      .valid(valid),
      .dout(dat)
      );
   

   axist_slv u_axist_slv
     (
      .clk(clk),
      .valid(valid),
      .din(dat),
      .ready(ready)
      );
   

   always #(PERIOD_100MHz / 2) begin
      clk <= ~clk;
   end



   //shortint unsigned dat[4];


   reg done_flg = 0;
   
   initial begin


      while(done_flg == 1) @(posedge clk);
      
      u_axist_slv.force_set_ready(1'b0); 

      repeat(10) @(posedge clk);

      u_axist_slv.force_set_ready(1'b1); 

   end
   
   
   initial begin

      data_ary = new[ary_size];
      
      for (int i = 0; i < ary_size; i++) begin
         data_ary[i] = i+1;
      end

      done_flg <= 1'b0;
      

      repeat(100) @(posedge clk);

      u_axist_mst.write_issue(data_ary, ary_size);


      done_flg <= 1'b1;

      repeat(4) @(posedge clk);

      u_axist_mst.write_issue(data_ary, 2);

      repeat(100) @(posedge clk);
      
      $finish;
      
   end

endmodule


`default_nettype wire
   
