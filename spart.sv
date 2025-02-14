//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spart(
    input clk, //Runs at 50MHz
    input rst_n, //
    input iocs, //Active High
    input iorw, //If High then read (SPART -> Driver) if low then Write (Driver -> Spart)
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );
    ////////////////Declared Variables//////////////////
    localparam Baud4800 = 16'h028C;
    localparam Baud9600 = 16'h0145;
    localparam Baud19200 = 16'h00A3;
    localparam Baud38400 = 16'h0052;
    logic [15:0] DB;
    logic [15:0] DC, iDC;
    logic [7:0] tx_data, rx_data, databus_i, status_reg;
    logic uart_clk, fill_dc, tbr_i, rda_i, rxd_i, txd_i, transmit;

    ////////////////Instantated Modules/////////////////
    UART_tx tx (
        .clk(clk), 
        .rst_n(rst_n), 
        .trmt(transmit), 
        .baud_clk(uart_clk),
        .tx_data(tx_data),
        .TX(txd_i), 
        .tx_done(tbr_i)
    );

    UART_rx rx (
        .clk(clk), 
        .rst_n(rst_n), 
        .RX(rxd_i), 
        .baud_clk(uart_clk),
        .rx_data(rx_data), 
        .rdy(rda_i)
    );
    ///////////////////////Bus Interface///////////////////////
    assign rda = iocs ? rda_i : 1'b0;
    assign tbr = iocs ? tbr_i : 1'b1;
    assign txd = iocs ? txd_i : 1'b1;
    assign rxd = iocs ? rxd_i : 1'b1;
    assign databus = iocs ? databus_i : 8'bz;

    //RDA is in 0 and TBR is in 
    assign status_reg = {{6'b000000}, tbr, rda};

    //IO addressing
    //00 -> Transmit Buffer (IOR/W = 0) : Receive Buffer (IOR/W = 1)
    //01 -> Status Register (IOR/W = 1)
    //10 -> DB(Low) Division Buffer
    //11 -> DB(High) Division Buffer
    always_comb begin
        casez({ioaddr, iorw})
            3'b000: databus_i = tx_data;

            3'b001: databus_i = rx_data;

            3'b011: databus_i = status_reg;

            3'b10?: databus_i = DB[7:0];
            
            3'b11?: databus_i = DB[15:8];

            default: databus_i = 8'bz;
        endcase
    end

    //Transmission logic
    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            transmit <= '0;
        else
            transmit <= ~iorw;
    end
    //If High then read (SPART -> Driver) if low then Write (Driver -> Spart)
 

    //////////////////////Division Counter///////////////////////

    always_comb begin
            case(DB)
                16'd4800: 
                    iDC = Baud4800;
                16'd9600: 
                    iDC = Baud9600;
                16'd19200: 
                    iDC = Baud19200;
                16'd38400: 
                    iDC = Baud38400;
                default: 
                    iDC = Baud9600;
            endcase
    end
    
    assign uart_clk = ~|DC;

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            DB <= '0;
        end
        else if(DC == 16'b0) begin
            DC <= iDC;
        end
        else begin
            DC <= DC - 1;
        end
    end

endmodule
