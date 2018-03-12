`default_nettype none

`timescale 1ps / 1ps

  
  module tb_top();

   


   localparam PERIOD_100MHz = 10000; //100MHz

   
   logic clk = 0;

   logic req;
   logic ack;
   
   logic [7: 0] data_ary[];
   int        ary_size = 4;
   

   logic [7: 0] dat;
   
   
   always #(PERIOD_100MHz / 2) begin
      clk <= ~clk;
   end


  ifra_mst u_ifra_mst
  (
   .clk(clk),
   .ack(ack),
   .req(req),
   .dout(dat)
   );


  ifra_slv u_ifra_slv
  (
   .clk(clk),
   .req(req),
   .din(dat),
   .ack(ack)
   );

   logic [7: 0]        data_buf[$];

   
   initial begin

            
      //u_ifra_slv.set_delay(0);
      u_ifra_slv.set_random_delay(8);
      
      
      data_ary = new[ary_size];
      
      for (int i = 0; i < ary_size; i++) begin
         data_ary[i] = i+1;
      end


      

      repeat(100) @(posedge clk);

      u_ifra_mst.write_issue(data_ary, ary_size);


      repeat(20) @(posedge clk);

      u_ifra_slv.show_rcv_data();
      
      /*
      u_ifra_slv.get_rcv_data(data_buf);

      $display("**** data_buf **** size = %0d", data_buf.size());
      for (int i = 0; i < data_buf.size(); i++) begin
         $display("buf[%0d], %0d", i, data_buf[i]);
      end
      */

      
      
      $finish;
      
   end

endmodule


`default_nettype wire
   
