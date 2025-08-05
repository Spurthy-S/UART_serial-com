
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


module transmitter(
    input [7:0]DBUS,
    input sysclk,
    input bclk,
    input rst,
    input txd_startH,
    input [2:0]sel,
    output reg txd,txd_doneH
    

    );
    reg shiftTSR,loadTSR,start,bclk_delayed,inc,clr,txd_done;
    reg [8:0]TSR;
    wire bclk_8;
    reg [3:0]bct;
    reg bclk_delay;
    wire bclk_rising;
    
    
     //state machine
       parameter idle=2'd0,
                 synch=2'd1,
                 tdata=2'd2;
       reg [1:0]state,next;
      //brg b1(.rst(rst),.sysclk(sysclk),.sel(sel),.bclk(bclk),.bclk_8(bclk_8));
      


always @(posedge sysclk,negedge rst)
begin
    if(!rst)
    begin
      bclk_delay<=1'b0;
    end
    else
    begin
       bclk_delay<=bclk;
    end
end
assign bclk_rising=bclk&~bclk_delay;
          
always @(posedge bclk_rising,negedge rst)
begin
  if(!rst)
  begin
     state<=idle;
        
  end
  else
     state<=next;
end
          
always @(txd_startH,state,bct)
begin
  
  case(state)
   idle:
        begin
        if (txd_startH)
           begin
             loadTSR=1'b1;
             shiftTSR=1'd0;
             next=synch;
             clr=1'b0;
             txd_done=1'd0;
           end
        else
           next=idle;
        end
    synch:
        
        begin
           start=1'b1;
           shiftTSR=1'b1;
           next=tdata;
        end
     tdata:
        
        begin
           if (bct==4'd9)
           begin
              txd_done=1'b1;
              clr=1'b1;
              inc=1'b0;
              next=idle;
            end
            else if (bct==4'd0)
            begin
               txd_done=1'b0;
               //shiftTSR=1'b1;
               loadTSR=1'd0;
               inc=1'b1;
               clr=1'b0;
               next=tdata;
           end
            else
            begin
               txd_done=1'b0;
               shiftTSR=1'b1;
               loadTSR=1'd0;
               inc=1'b1;
               clr=1'b0;
               next=tdata;
               
            end
         end                     
    endcase
 end

always @(posedge sysclk, negedge rst)
begin
    
        txd_doneH<=txd_done;  
end

//counter
always @(posedge bclk_rising, negedge rst)
begin
    if(!rst)
    begin
        bct<=4'd0;
    end
    else
    begin 
       if(inc)
          bct<=bct+1'b1;
      else           
          bct<=4'd0;
    end
end
        
always @(posedge bclk_rising or negedge rst)
  begin
    if (!rst)
      begin
        TSR <= 9'd0;
        txd <= 1'b1; // Idle line state
      end
    else
      begin
        if (loadTSR)
            TSR <= {DBUS, 1'b1};  // 8 data bits + stop bit
        else if (shiftTSR)
        begin
            txd <= TSR[0];
            TSR <= {1'b0, TSR[8:1]};
        end
      end
    end                   
       
endmodule



