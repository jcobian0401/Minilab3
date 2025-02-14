module minilab3_tb();

logic clk, rst_n, TXR, RXT;
//FOR DUT
logic dut_iocs, dut_iorw, dut_rda, dut_tbr;
wire [7:0] dut_databus; 
wire [1:0] dut_ioaddr; 
logic [1:0] br_cfg; 

//FOR TESTER
logic test_iocs, test_iorw, test_rda, test_tbr, test_databus_en;
logic [1:0] test_ioaddr;
wire [7:0] test_databus;
logic [7:0] test_dataout;


//Misc signals
logic [15:0] baud_rate;



////////////////////////Module instantiations/////////////////////////

spart duts0(
    .clk(clk),    
    .rst_n(rst_n),  
    .iocs(dut_iocs), 
    .iorw(dut_iorw), 
    .rda(dut_rda),
    .tbr(dut_tbr),
    .ioaddr(dut_ioaddr),
    .databus(dut_databus),
    .txd(TXR),
    .rxd(RXT)
);

driver dutd0(
    .clk(clk),
    .rst_n(rst_n),
    .br_cfg(br_cfg),
    .iocs(dut_iocs),		
    .iorw(dut_iorw),		
    .rda(dut_rda),			
    .tbr(dut_tbr),			
    .ioaddr(dut_ioaddr),	
    .databus(dut_databus)	
);


spart tester(
    .clk(clk),    
    .rst_n(rst_n),  
    .iocs(test_iocs), 
    .iorw(test_iorw), 
    .rda(test_rda),
    .tbr(test_tbr),
    .ioaddr(test_ioaddr),
    .databus(test_databus),
    .txd(RXT),
    .rxd(TXR)
);

assign test_databus = (test_databus_en) ? test_dataout : 8'bz;





initial begin
    clk = 0;
    rst_n = 0; 
    test_iocs = 1;
    test_iorw = 1;
    test_ioaddr = '0;
    test_databus_en = 0; //0 means listening
    baud_rate = 16'd9600;

    @(posedge clk);
    rst_n = 1;

    //Setting the baud rate of tester to 9600
    @(negedge clk);
    test_ioaddr = 2'b10; 
    test_dataout = baud_rate[7:0]; 
    test_databus_en = 1;



    @(negedge clk);
    test_ioaddr = 2'b11; 
    test_dataout = baud_rate[15:8]; 
    test_databus_en = 1;

    @(negedge clk);
    test_databus_en = 0;

    repeat(5) @(posedge clk);


    //Setting the baud rate of dut to 9600

    $stop; 
end







always #5 clk = ~clk;

endmodule
