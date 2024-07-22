`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Daniel Lopez
// 
// Create Date: 07/14/2024 02:15:08 AM
// Design Name: 
// Module Name: axis_max1119x_adc
// Project Name: AXIS max1119x_adc
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


module axis_max1119x_adc(
    input wire clk,        // System clock
    input wire reset,      // Reset signal
    input wire miso,       // Master Input Slave Output
    output reg ask_sample,     // Chip Select output
    //output reg [15:0] data_out, // Data read from the slave
    output reg SCLK_PIN,    // Serial Clock output
    
    // AXIS interface
    output reg [15:0] m_axis_tdata, // AXIS data output
    output reg m_axis_tvalid       // AXIS valid signal
);

    // Timer constants
    parameter ASK_SAMPLE_OFF = 30; // 0.1-second interval (100 ms)
    parameter ASK_SAMPLE_ON = 15; // 500 ms interval
    parameter PER_SCLK = 10;

    // Timer variables
    reg [31:0] counter;
    reg [31:0] counter_sclk;
    reg state;
    
    // Shift register for data collection
    reg [15:0] shift_reg;
    reg [4:0] bit_count;
    
    // Aux
    reg read_data;

    // Initialization
    initial begin
        counter <= 0;
        state <= 0;
        counter_sclk <= 0;
        bit_count <= 5'd0;
        read_data <= 0; 
        SCLK_PIN <= 0;
        m_axis_tvalid <= 1; 
    end

    // Main logic
    always @(posedge clk) begin
        if (reset) begin 
            counter_sclk <= 0;
            SCLK_PIN <= 0;
        end else begin
            counter_sclk <= counter_sclk + 1;            
            if (counter_sclk >= PER_SCLK) begin
                counter_sclk <= 0;
                SCLK_PIN <= ~SCLK_PIN;
            end
        end        
    end
    
    always @(posedge SCLK_PIN) begin
        if (reset) begin 
            counter <= 0;
            ask_sample <= 0;
            state <= 0;
            read_data <=0;
        end else begin
            counter <= counter + 1;
            if (state == 0) begin
                ask_sample <= 1'b1;
                if (counter >= ASK_SAMPLE_OFF) begin
                    counter <= 0;
                    state <= 1;
                end
            end else begin
                ask_sample <= 1'b0;
                if (counter >= ASK_SAMPLE_ON) begin
                    counter <= 0;
                    state <= 0;
                    read_data <= 1;                                       
                end
            end
       
            if (bit_count < 16 && ask_sample && read_data) begin    
                // Shift each bit to the left and insert miso at the least significant bit
                shift_reg[15] <= shift_reg[14];
                shift_reg[14] <= shift_reg[13];
                shift_reg[13] <= shift_reg[12];
                shift_reg[12] <= shift_reg[11];
                shift_reg[11] <= shift_reg[10];
                shift_reg[10] <= shift_reg[9];
                shift_reg[9] <= shift_reg[8];
                shift_reg[8] <= shift_reg[7];
                shift_reg[7] <= shift_reg[6];
                shift_reg[6] <= shift_reg[5];
                shift_reg[5] <= shift_reg[4];
                shift_reg[4] <= shift_reg[3];
                shift_reg[3] <= shift_reg[2];
                shift_reg[2] <= shift_reg[1];
                shift_reg[1] <= shift_reg[0];
                shift_reg[0] <= miso; // Insert the new bit at the least significant position   
                bit_count <= bit_count + 1;
            end else if (bit_count >= 16) begin
                bit_count <= 0; // Reset bit counter for next data collection;
                read_data <= 0;
                m_axis_tdata <= shift_reg;
                m_axis_tvalid <= 1;                
            end
        end       
    end    
    
endmodule