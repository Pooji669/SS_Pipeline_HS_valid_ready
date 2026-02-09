module pipeline_reg #(
    parameter DATA_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // Input interface
    input  logic [DATA_WIDTH-1:0] in_data,
    input  logic                  in_valid,
    output logic                  in_ready,

    // Output interface
    output logic [DATA_WIDTH-1:0] out_data,
    output logic                  out_valid,
    input  logic                  out_ready
);

    // Storage register
    logic [DATA_WIDTH-1:0] data_reg;
    logic                 valid_reg;

    // Ready when pipeline is empty OR downstream is ready
    assign in_ready = ~valid_reg || out_ready;

    // Output assignments
    assign out_data  = data_reg;
    assign out_valid = valid_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_reg <= 1'b0;
        end
        else begin
            // Accept new data
            if (in_valid && in_ready) begin
                data_reg  <= in_data;
                valid_reg <= 1'b1;
            end
            // Data consumed without replacement
            else if (out_ready && valid_reg) begin
                valid_reg <= 1'b0;
            end
        end
    end

endmodule
