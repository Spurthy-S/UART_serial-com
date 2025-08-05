`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2022 08:23:12 PM
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
//////////////////////////////////////////////////////////////////////////////////1ps



module brg(
    input rst,
    input sysclk,
    input [2:0]sel,    
    output reg bclk,
    output reg  bclk_8
    
    );
    reg [1:0]q;//clkdiv counter
    reg [7:0]bit_8;//8 bit counter
    reg [2:0]counter_bclk;
    reg bclk_reset;
    reg bclk_8_delay,bclk_delay;
    reg clkdiv;
    
    always @(posedge sysclk)
    begin
        if (!rst)
        begin
            q<=2'd0;
            bclk_reset<=1'd0;
            clkdiv<=1'd1;
        end                       
        else
        begin            
            if (q==2'd1)
            begin
                q<=q+1;             
                clkdiv<=~clkdiv;
            end
            else if (q==2'd2)
            begin
                clkdiv<=~clkdiv;
                q<=2'd0;
            end
            else
            begin
                q<=q+1; 
                clkdiv<=clkdiv;
            end
            if(counter_bclk==3'd0)
                bclk_reset<=1'd1;
        end
  end
  
  always @(posedge clkdiv)
  begin
    if (!rst)
    begin
        bit_8<=8'd0; 
    end             
    else
    begin
        bit_8<=bit_8+1;
        
    end
  end
  
  
always @(posedge clkdiv)
begin
  if(!rst)
    bclk_8<=0;
else
  begin
    case(sel)
    3'd0:bclk_8=bit_8[0];
    3'd1:bclk_8=bit_8[1];
    3'd2:bclk_8=bit_8[2];
    3'd3:bclk_8=bit_8[3];
    3'd4:bclk_8=bit_8[4];
    3'd5:bclk_8=bit_8[5];
    3'd6:bclk_8=bit_8[6];
    3'd7:bclk_8=bit_8[7];
    endcase
  end
end

always @(posedge bclk_8)
  begin
    if (!bclk_reset)
    begin
        counter_bclk<=3'd0;
        bclk<=1'd0;
    end
    
    else
    begin   
        counter_bclk<=counter_bclk+1; 
        if(counter_bclk==3'd7)
            bclk<=~bclk; 
        else
            bclk<=bclk;
               
    end    
  end     
               
endmodule


  
           

