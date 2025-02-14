module driver(
    input clk,
    input rst_n,
    input [1:0] br_cfg,
    output iocs,		// Chip select
    output iorw,		// Determines direction of transfer
    input rda,			// Receive data availible
    input tbr,			// Indicates the transmit buffer is ready
    output [1:0] ioaddr,	// Selects which register interacts with databus
    inout [7:0] databus		// bus used for information control
    );

    // Internal signals
    logic iocs_reg;
    logic iorw_reg;
    logic [1:0] ioaddr_reg;
    logic [7:0] data_out, save_buffer;           // Data to be written to SPART
    logic [15:0] baud_divisor;      // Full baud rate divisor
    logic data_bus_en, save;              // Enable driver's databus output
    logic br_set;

    assign iocs = iocs_reg;
    assign iorw = iorw_reg;
    assign ioaddr = ioaddr_reg;

    logic [1:0] br_cfg_flopped;
    logic br_change;

    always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
	    br_cfg_flopped <= '0;
	end else begin
	    br_cfg_flopped <= br_cfg; 
	end
    end

    always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
	    br_change <= 1;
	end else if (br_cfg != br_cfg_flopped) begin
	    br_change <= 1;
	end else if (br_set) begin
	    br_change <= 0;
	end
    end

    // Calculate baud divisor based on br_cfg
    // You'll need to adjust these values based on your clock frequency
    always_comb begin
        case(br_cfg)
            2'b00   : baud_divisor = 16'd4800; // 4800 baud
            2'b01   : baud_divisor = 16'd9600; // 9600 baud
            2'b10   : baud_divisor = 16'd19200;  // 19200 baud
            2'b11   : baud_divisor = 16'd38400;  // 38400 baud
            default : baud_divisor = 16'd9600; // Default to 9600 baud
        endcase
    end
	
    always_ff @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
	    save_buffer <= '0;
	end
	else if(save) begin
	    save_buffer <= databus;
	end 
    end

    // Tri-state buffer for bidirectional databus
    assign databus = (data_bus_en) ? data_out : 8'bz;
    

    // State encoding
    typedef enum logic [2:0] {
        IDLE,
        INIT_BRG_LOW,   // Initialize Baud Rate Generator Low byte
        INIT_BRG_HIGH,  // Initialize Baud Rate Generator High byte
        WAIT_RDA,       // Wait for transmit buffer ready
        READ_DATA,      // Read received data
        WRITE_DATA      // Write data for transmission
    } state_t;

    state_t current_state, next_state;
    
    // Sequential logic for state machine
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and outputs
    always_comb begin
        // Default values
	save = 0;
        next_state = current_state;
        iocs_reg = 1'b1; //?? this might need to be changed
        iorw_reg = 1'b1;
        ioaddr_reg = 2'b00;
        data_out = 8'h00;
        data_bus_en = 1'b0;
	br_set = 1'b0;
        
        case (current_state)
            IDLE: begin
	        if (br_change) begin
		        next_state = INIT_BRG_LOW;
		    end
                if (rda) begin
                    iocs_reg = 1'b1;
                    iorw_reg = 1'b1;         // Read
                    ioaddr_reg = 2'b00;      // Receive Buffer address
                    save = 1;
                    next_state = READ_DATA;
                end 
            end
            INIT_BRG_LOW: begin
                iocs_reg = 1'b1;
                iorw_reg = 1'b0;         // Write
                ioaddr_reg = 2'b10;      // Low Division Buffer address
                data_out = baud_divisor[7:0];  // Lower byte
                data_bus_en = 1'b1;
                next_state = INIT_BRG_HIGH;
            end

            INIT_BRG_HIGH: begin
                iocs_reg = 1'b1;
                iorw_reg = 1'b0;         // Write
                ioaddr_reg = 2'b11;      // High Division Buffer address
                data_out = baud_divisor[15:8]; // Upper byte
                data_bus_en = 1'b1;
		        br_set = 1'b1;
                next_state = WAIT_RDA;
            end

           READ_DATA: begin
		        if (tbr) 
		            next_state = WRITE_DATA;
            end
            WRITE_DATA: begin
                iocs_reg = 1'b1;
                iorw_reg = 1'b0;     // Write
                ioaddr_reg = 2'b00;  // Transmit Buffer address
                data_out = save_buffer;  // Echo back the received data
                data_bus_en = 1'b1;
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule