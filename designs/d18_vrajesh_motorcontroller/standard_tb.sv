`default_nettype none

`define ASSERT(x) if (!(x)) begin \
    $display("Assert failed at line %d", `__LINE__); \
    $finish(1); \
end



module standard_tb (
    output logic [11:0] io_in,
    input logic [11:0] io_out,
    input logic ready,
    input logic clock, reset
);


    logic in_clk, in_mosi, in_cs_n, adc_clk, adc_spi_miso, adc_mosi, adc_cs_n, pwm_a, pwm_b;
    logic [15:0] message, temp;

    assign io_in[11] = in_clk;
    assign io_in[10] = in_mosi;
    assign io_in[9]  = in_cs_n;
    assign io_in[8]  = adc_spi_miso;

    assign adc_clk  = io_out[11];
    assign adc_mosi = io_out[10]; 
    assign adc_cs_n = io_out[9];
    assign pwm_a    = io_out[8];
    assign pwm_b    = io_out[7];


    task pulse_clock();
        in_clk = 0;
        @(negedge clock);
        @(negedge clock);
        in_clk = 1;
        @(negedge clock);
        @(negedge clock);
        in_clk = 0;
    endtask

    initial begin

        in_clk = 0; in_mosi = 0; in_cs_n = 1; adc_spi_miso = 0;
        message = 16'h00A6;
        temp    = message;
        #100;
        while (!ready) @(negedge clock);

        // Pins based on README.md. 
        $monitor("[%d] {in_clk, in_mosi, in_cs_n, adc_spi_miso}=%b, {adc_clk, adc_mosi, adc_cs_n, pwm_a, pwm_b}=%b", 
                 $time, io_in[11:8], io_out[11:7]);

        repeat(10000) @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        pulse_clock();
        pulse_clock();

        in_cs_n = 0;
        for (int i = 15; i >= 0; i--) begin
            in_mosi = temp[15];
            pulse_clock();
            temp = temp << 1;
        end

        in_cs_n = 1;
        pulse_clock(); pulse_clock();
        repeat(10000) @(negedge clock);

        $finish(0); // pass
    end

endmodule
