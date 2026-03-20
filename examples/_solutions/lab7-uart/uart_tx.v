module uart_tx (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  data,
    input  wire        tx_start,
    output reg         tx,
    output reg         tx_complete
);

    //-------------------------------------------------
    // FSM states
    //-------------------------------------------------
    localparam IDLE               = 2'd0;
    localparam TRANSMIT_START_BIT = 2'd1;
    localparam TRANSMIT_DATA      = 2'd2;
    localparam TRANSMIT_STOP_BIT  = 2'd3;

    reg [1:0] current_state = IDLE;

    //-------------------------------------------------
    // Internal constants (like VHDL constants)
    //-------------------------------------------------
    localparam integer CLK_FREQ = 100_000_000; // 100 MHz
    localparam integer BAUDRATE = 9600;
    localparam integer N_PERIODS = CLK_FREQ / BAUDRATE;
    // localparam integer N_PERIODS = 2;  // For simulation

    //-------------------------------------------------
    // Internal registers
    //-------------------------------------------------
    reg [$clog2(N_PERIODS)-1:0] baud_count;
    reg [7:0] shift_reg;
    reg [2:0] current_bit_index;

    //-------------------------------------------------
    // FSM
    //-------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            tx                <= 1'b1;
            tx_complete       <= 1'b0;
            current_state     <= IDLE;
            shift_reg         <= 8'd0;
            current_bit_index <= 3'd0;
            baud_count        <= 0;

        end else begin
            case (current_state)

                //-------------------------------------------------
                // IDLE
                //-------------------------------------------------
                IDLE: begin
                    tx          <= 1'b1;
                    tx_complete <= 1'b0;

                    if (tx_start) begin
                        shift_reg         <= data;
                        current_bit_index  <= 3'd0;
                        baud_count         <= 0;
                        current_state      <= TRANSMIT_START_BIT;
                    end
                end

                //-------------------------------------------------
                // START BIT
                //-------------------------------------------------
                TRANSMIT_START_BIT: begin
                    tx <= 1'b0;

                    if (baud_count == N_PERIODS - 1) begin
                        baud_count    <= 0;
                        current_state <= TRANSMIT_DATA;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end

                //-------------------------------------------------
                // DATA BITS
                //-------------------------------------------------
                TRANSMIT_DATA: begin
                    tx <= shift_reg[0];

                    if (baud_count == N_PERIODS - 1) begin
                        shift_reg <= {1'b0, shift_reg[7:1]};

                        if (current_bit_index == 3'd7) begin
                            current_state <= TRANSMIT_STOP_BIT;
                        end else begin
                            current_bit_index <= current_bit_index + 1;
                        end

                        baud_count <= 0;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end

                //-------------------------------------------------
                // STOP BIT
                //-------------------------------------------------
                TRANSMIT_STOP_BIT: begin
                    tx          <= 1'b1;
                    tx_complete <= 1'b1;

                    if (baud_count == N_PERIODS - 1) begin
                        current_state <= IDLE;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end

                //-------------------------------------------------
                default: begin
                    current_state <= IDLE;
                end

            endcase
        end
    end

endmodule
