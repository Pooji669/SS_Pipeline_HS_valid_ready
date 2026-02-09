module tb_pipeline_reg;

    parameter DATA_WIDTH = 32;

    logic clk;
    logic rst_n;

    logic [DATA_WIDTH-1:0] in_data;
    logic                  in_valid;
    logic                  in_ready;

    logic [DATA_WIDTH-1:0] out_data;
    logic                  out_valid;
    logic                  out_ready;

    // DUT
    pipeline_reg #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .in_data   (in_data),
        .in_valid  (in_valid),
        .in_ready  (in_ready),
        .out_data  (out_data),
        .out_valid (out_valid),
        .out_ready (out_ready)
    );

    // Clock
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_pipeline_reg);
    end

    initial begin
        // Init
        clk = 0;
        rst_n = 0;
        in_data = 0;
        in_valid = 0;
        out_ready = 0;

        // Reset
        #20 rst_n = 1;
        $display("Reset released");

        // =====================================
        // TEST 1: Simple transfer
        // =====================================
        @(posedge clk);
        in_data = 32'hA5A5A5A5;
        in_valid = 1;
        out_ready = 1;

        @(posedge clk);
        in_valid = 0;

        wait (out_valid);
        if (out_data !== 32'hA5A5A5A5) begin
            $error("TEST1 FAILED: Data mismatch");
            $finish;
        end
        $display("TEST1 PASSED");

        // =====================================
        // TEST 2: Backpressure
        // =====================================
        @(posedge clk);
        in_data = 32'hDEADBEEF;
        in_valid = 1;
        out_ready = 0;

        @(posedge clk);
        in_valid = 0;

        repeat (3) begin
            @(posedge clk);
            if (!out_valid) begin
                $error("TEST2 FAILED: Data lost during backpressure");
                $finish;
            end
        end

        out_ready = 1;
        @(posedge clk);

        if (out_data !== 32'hDEADBEEF) begin
            $error("TEST2 FAILED: Data mismatch after stall");
            $finish;
        end
        $display("TEST2 PASSED");

        // =====================================
        // TEST 3: Back-to-back transfers
        // =====================================
        @(posedge clk);
        in_valid = 1;
        out_ready = 1;
        in_data = 32'h11111111;

        @(posedge clk);
        in_data = 32'h22222222;

        @(posedge clk);
        in_valid = 0;

        wait (out_valid);
        if (out_data !== 32'h22222222) begin
            $error("TEST3 FAILED: Back-to-back transfer error");
            $finish;
        end
        $display("TEST3 PASSED");

        // =====================================
        // DONE
        // =====================================
        #20;
        $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
