`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2009 12:29:40 AM
// Design Name: 
// Module Name: transmitter
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


module transmitter_tb;
    reg [7:0]DBUS;
    reg sysclk;
    wire bclk,bclk_8;
    reg rst;
    reg txd_startH;
    reg [2:0]sel;
    wire txd,txd_doneH;
    
    
    brg b1(.rst(rst),.sysclk(sysclk),.sel(sel),.bclk(bclk),.bclk_8(bclk_8));
    transmitter t1(.DBUS(DBUS),.sysclk(sysclk),.bclk(bclk),.rst(rst),.txd_startH(txd_startH),.sel(sel),.txd(txd),.txd_doneH(txd_doneH));
    always
      #5 sysclk=~sysclk;
      
    initial
      begin
        sysclk=1'b0;
        rst=1'b0;
        sel=1'b0;
        txd_startH=1'b0;
        DBUS=8'h00;
        
        #20;
        rst=1;
        txd_startH=1'b1;
        DBUS=8'h55;
        //transmit_byte(8'haf);
        //@posedge(bclk);
        #25000;
        $finish;
    end
      
      
    
      
      
      /*task transmit_byte;
        input [7:0]data_in_tx;
        begin
          DBUS=data_in_tx;
        end
     endtask */
     
endmodule         
        
      
    