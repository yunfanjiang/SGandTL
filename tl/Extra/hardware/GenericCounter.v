`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 			University of Edinburgh
// Engineer: 			Godwin Enemali
// 
// Create Date:   	00:26:38 11/08/2013 
// Design Name: 		Digital System Lab A (Assignment III)
// Module Name:   	Generic_Counter4_VGA 
// Project Name: 		Colouring The World
// Target Devices:	FPGA Board; Digilent BASYS 2
// Tool versions: 	P.49d
// Description: 		This generic counter has variable width with three interfaces, an input clk
//							output COUNT and output Triger_out. It is instantiated within the VGA_CTRL module
// Dependencies: 		It depends on the VGA_CTRL module for its complete functionality
//
// Revision: Nil
// Revision 0.01 - File Created
// Additional Comments: Nil
//
//////////////////////////////////////////////////////////////////////////////////

//Intaface list for the generic counter, without stating them
//as input or output, or even stating their dimentions
//since it is a generic module

module GenericCounter( 
    CLK,
    RESET,
    ENABLE,
    COUNT,
    TRIGER_OUT
    );

    //Two parameters - Counter Width and its Maximum count are defined
    //here. They are like 'variables' that could be uniquely defined
    //for any particular instance 
    parameter COUNTER_WIDTH = 4;
    parameter COUNTER_MAX = 9;
    
    //Defining interfaces as either input or output
    //and specifying their dimenions
    input CLK;
    input RESET;
    input ENABLE;
    output [COUNTER_WIDTH-1:0] COUNT;
    output TRIGER_OUT;
    
    //Define registers which keep the values
    //of COUNT as well as TRIGER_OUT between clks
    reg [COUNTER_WIDTH-1:0] counts;
    reg trigger_out;
    
    //The synchronous count logic description for counts
    //this counters only counts UP to Max and returns 0
    always@(posedge CLK or posedge RESET) begin
        if (RESET)
            counts <= 0;
        else begin
            if (ENABLE) begin
                if(counts == COUNTER_MAX)
                    counts <= 0;
                else
                    counts <= counts + 1;
            end
        end
    end
    
    //desciption of synchronous triger_out logic
    //triger-out turns hig at the end  every count
    //cycle
    always@(posedge CLK or posedge RESET) begin
        if (RESET)
            trigger_out<=0;
        else begin
            if(ENABLE && (counts == COUNTER_MAX))
                trigger_out <= 1;
            else
                trigger_out <= 0;
            end
        end
        
    //Finally for this counter, assigment
    //is used t tie the counts value and
    //triger_out to the OUTPUTS
    assign COUNT = counts;
    assign TRIGER_OUT = trigger_out;

endmodule
