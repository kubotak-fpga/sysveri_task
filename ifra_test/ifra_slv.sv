//Simple BFM, req/ack interface slave


module ifra_slv
  #(
    parameter DATA_WIDTH = 8
    )
   (
    input logic                    clk,
    input logic                    req,
    input logic [DATA_WIDTH -1: 0] din,
    output logic                   ack
    );


   int                             m_delay = 0;
   int                             m_random_flg = 0;
   int                             m_max_delay; //use random_flg = 1
   
   int                             state;
   int                             cnt;
   

   //recieved data buffer
   logic [DATA_WIDTH -1: 0]        rcv_buf[$];
   

   //private tak
   task receive_transfe();

      int delay;
      
      while (req != 1'b1) @(posedge clk);

      if (m_random_flg) begin
         delay = $random() % m_max_delay;
         
         if (delay < 0) delay = -delay;
         
         $display("random %0d", delay);                
      end
      else begin
         delay = m_delay;
      end

      repeat(delay) @(posedge clk);

      ack <= 1'b1;
      rcv_buf.push_back(din);

      @(posedge clk);

      ack <= 1'b0;

      @(posedge clk);
      
   endtask

   
   initial begin

      ack <= 1'b0;

      @(posedge clk);
      
      forever begin
         receive_transfe();
      end
   end
   

   /*** public function **********************/
   
   //arg delay:0 - xxx
   function void set_delay(int delay);
      m_delay = delay;
      m_random_flg = 0;
   endfunction

   function void set_random_delay(int max_delay);
      m_max_delay = max_delay;
      m_random_flg = 1;
   endfunction

   //function void show_rcv_data();
   function void show_rcv_data();

      int rcv_num;
      rcv_num = rcv_buf.size();
      
      $display("**** recieved data ****, num = %0d", rcv_num);

      for (int i = 0; i < rcv_num; i++) begin
         
         $display("rcv[%0d], %0d", i, rcv_buf[i]);
      end

   endfunction

   function void get_rcv_data(output logic [DATA_WIDTH -1: 0] out_buf[$]);
      

      int rcv_num;
      rcv_num = rcv_buf.size();
      
      $display("**** recieved data ****, num = %0d", rcv_num);

      for (int i = 0; i < rcv_num; i++) begin

         out_buf[i] = rcv_buf[i];
         
         //$display("out_buf[%0d], %0d", i, out_buf[i]);
      end
      
   endfunction

   
endmodule




