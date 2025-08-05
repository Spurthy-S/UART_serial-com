  
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



module receiver(
    input rxd,
    input sysclk,
    input rst,
    input bclk_8,
    input [2:0]sel,
    output reg [7:0] RDR,
    output reg rxd_readyH
    );
    
    wire  bclk; 
    
    reg [7:0] RSR;
    reg shiftRSR,loadRDR,ok_en,bclk_8_delay;
    reg rxd_sync,rxd_double_sync;
    reg [1:0]clr,inc;
    reg [2:0]ct1;
    reg [3:0]ct2;
    wire bclk_8_delayed_inv,bclk_8_rising;
    
    //state machine
    parameter idle=2'd0,
              start_detected=2'd1,
              recv_data=2'd2;
    reg [1:0]state,next; 
    
       
  brg b1(.rst(rst),.sysclk(sysclk),.sel(sel),.bclk(bclk),.bclk_8(bclk_8));
always @(posedge sysclk,negedge rst)
begin
    if(!rst)
    begin
      bclk_8_delay<=1'b0;
    end
    else
    begin
       bclk_8_delay<=bclk_8;
    end
end
assign bclk_8_rising=bclk_8&~bclk_8_delay;
       
       
/////////////Shift reg-SIPO
always @ (posedge bclk_8_rising,negedge rst)
begin
        if(!rst)
            RSR<=8'd0;
        else if (state==recv_data && ct2>=0 && ct2<=8 && ct1==7)
          //RSR<={RSR[6:0],rxd}; 
         	RSR<={rxd_double_sync,RSR[7:1]};
            
end


/////////////Shift reg-SIPO
always @ (posedge bclk_8_rising,negedge rst)
begin
    if(!rst)
      rxd_sync<=1'd0;      
    else
      rxd_sync<=rxd;
      rxd_double_sync<=rxd_sync;
end    
    
   
   always @(posedge bclk_8_rising,negedge rst)
   begin
        if(!rst)
        begin
            state<=idle;        
            
        end
        else 
          begin
            //$display("next state:%d",next);
            state<=next;
          end
   end
   
   
   always@(*)
   begin
        case(state)
 //idle
        idle:
            begin
              shiftRSR=1'd0;
              loadRDR=1'd0;
              clr=2'd0;
              inc=2'd0;
              ok_en=1'd0;
              //$display("In state:idle |rxd=%b| time=%t",rxd,$time);
              if(rxd) 
              begin
                
                next=idle;
              end
              else
                 next=start_detected;
             end

      start_detected:
            
                begin
                    if(rxd)
                        begin
                            clr[0]=1'b1;
                            inc[0]=1'b0;
                            
                            next=idle;
                        end
                     else
                        begin
                            if(ct1==3'd3)
                                begin
                                    clr[0]=1'b1;
                                    next=recv_data;
                                end
                            else
                                begin
                                    inc[0]=1'b1;                                    
                                    next=start_detected;
                                 end
                            end
                      end
              
                    
     recv_data:
          begin           
              inc[0]=1'b1;
              clr[0]=1'b0;
              if(ct1==3'd7)
                begin
                    
                    if(ct2==4'd8)
                    begin
                        if(!rxd)
                            begin
                                clr[0]=1'b1;
                                clr[1]=1'b1;
                                next=idle;
                                $display("rxd=%b",rxd);
                                
                            end
                        else
                            begin
                                loadRDR=1'b1;
                                ok_en=1'b1;
                                clr[0]=1'b1;                                
                                clr[1]=1'b1;
                                inc[1]=1'b0;
                                next=idle;
                                $display("pqr");
                             end
                        end
                     else
                     begin
                        shiftRSR=1'b1;                        
                        inc[1]=1'b1;
                        clr[1]=1'b0;
                        inc[0]=1'b0;
                        clr[0]=1'b1;                       
                        next=recv_data;
                        
                    end
               end
               else
                 begin
                   
                      
                      inc[1]=1'b0;
                      next=recv_data;
                  end
                 
          end
          
          
       endcase
       
    end
 
always@(posedge bclk_8_rising,negedge rst)
begin
//DFF-2
    if(!rst)
    begin
        rxd_readyH<=1'd0;
    end
    else
    begin
        rxd_readyH<=ok_en;
            
    end
end

//always @(posedge sysclk)
always@(posedge bclk_8_rising,negedge rst)
begin
     if(!rst)
     begin
        ct1<=3'd0;
     end
     else
     begin
      if(clr[0])
        ct1<=3'd0;
      else if(inc[0])
        ct1<=ct1+1'b1;
    end
end
  
//bitbit-cell counter
always @(posedge bclk_8_rising,negedge rst)
begin
     if(!rst)
     begin
        ct2<=3'd0;
     end
     else
     begin
        if(clr[1])
          ct2<=4'd0;
        else if(inc[1])
            begin
              ct2<=ct2+1'b1;              
            end         
    end
end
   
//received data loader
always @(posedge bclk_8_rising,negedge rst)
begin
  if(!rst)
     RDR[7:0]<=8'd0; 
  else if(loadRDR)
    begin
      RDR[7:0]<=RSR[7:0]; 
   end   
end    
 
endmodule


  
        
               



