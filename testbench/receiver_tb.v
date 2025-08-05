  
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2009 12:30:14 AM
// Design Name: 
// Module Name: brg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module receiver_tb;
  reg rxd,sysclk,rst;
  reg [2:0]sel;
  wire [7:0]RDR;
  wire rxd_readyH;
  wire bclk,bclk_8;
  
  
  brg b1(.rst(rst),.sysclk(sysclk),.sel(sel),.bclk(bclk),.bclk_8(bclk_8));
  receiver r1(.rxd(rxd),.sysclk(sysclk),.rst(rst),.bclk_8(bclk_8),.sel(sel),.RDR(RDR),.rxd_readyH(rxd_readyH));
  

  always
  begin
     #2 sysclk=~sysclk;
 end
 
  initial
    begin
      sysclk=0;
      rst=1'b0;
      sel=3'd0;
      #5;
      rst=1'b1;
      rxd=1'b1;
  
      recv_byte(8'ha5);
      //recv_byte(8'hff);         
      @(posedge bclk_8);
      #20000;
      $finish;
  end  
  
 task recv_byte;
   
     
     input [7:0]data;
     integer h,i,j,k;
      begin
       for(h=0;h<=3;h=h+1)
        begin
          rxd=0;
          @(posedge bclk_8);          
        end
        for(i=0;i<8;i=i+1)
        begin
          for(j=0;j<8;j=j+1)
          begin
            @(posedge bclk_8);
         
            rxd=data[i];
            $display("Sending bit %0d = %b at time %t", i, data[i], $time);
            $display("value of j=%b",j);
            
         
          end
        end
        for(k=0;k<8;k=k+1)
        begin
            rxd=1;//stop bit
        end
       
    
  end
  endtask 

  
     
    
 endmodule  