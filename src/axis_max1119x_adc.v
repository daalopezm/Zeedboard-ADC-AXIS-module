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
    parameter ASK_SAMPLE_OFF = 600; // 0.1-second interval (100 ms)
    parameter ASK_SAMPLE_ON = 300; // 500 ms interval
    parameter PER_SCLK = 10;
    parameter SEND_CLK = 10000; 

    // Timer variables
    reg [31:0] counter;
    reg [31:0] counter_sclk;
    reg [31:0] counter_send;
    reg state;
    reg send;
    
    // Shift register for data collection
    reg [15:0] shift_reg;
    reg [4:0] bit_count;
    
    // Aux
    reg read_data;
    assign miso_memory=miso;

    // Initialization
    initial begin
        counter <= 0;
        state <= 0;
        counter_sclk <= 0;
        bit_count <= 5'd0;
        read_data <= 0; 
        SCLK_PIN <= 0;
        send <=0;
        m_axis_tvalid <= 1; 
    end

    // Main logic
    always @(posedge clk) begin
        counter <= counter + 1;
        counter_sclk <= counter_sclk + 1;
        counter_send <= counter_send + 1;
        if (reset) begin
            counter <= 0;          
            state <= 0;   
            counter_sclk <= 0;
            SCLK_PIN <= 0; 
        end
            
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
            end
        end
        
        if (counter_sclk >= PER_SCLK) begin
            counter_sclk <= 0;
            SCLK_PIN <= ~SCLK_PIN;
        end
        
        if (counter_send >= SEND_CLK) begin
            counter_send <= 0;
            send <= ~send;
        end
        
    end
    
    always @(posedge SCLK_PIN) begin
        if (ask_sample && read_data) begin
            
            shift_reg <= {shift_reg[15:0], miso_memory};
            bit_count <= bit_count + 1;
            if (bit_count == 16) begin
                bit_count <= 0; // Reset bit counter for next data collection
                read_data <= 0;
            end
        end
    end
    
    always @(posedge ask_sample) begin
        read_data <= 1;
    end
    
    always @(posedge send) begin
        m_axis_tdata <= shift_reg;
    end
    
    
endmodule