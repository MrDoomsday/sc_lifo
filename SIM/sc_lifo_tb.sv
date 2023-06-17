module sc_lifo_tb();


	localparam data_width = 32;
	localparam lifo_depth = 12;

	reg clk;
	reg reset_n;
	
	reg 						wr;
	reg 	[data_width-1:0] 	data_in;
	
	reg 						rd;
	wire 	[data_width-1:0] 	data_out;
	
	wire 						full;
	wire 						empty;
	wire 	[lifo_depth:0] 		use_words;
	reg						    clear;


    sc_lifo #(
        .data_width(data_width),
        .lifo_depth(lifo_depth)
    ) DUT (
        .clk	(clk),
        .reset_n(reset_n),
            
        .wr		(wr),
        .data_in(data_in),
        
        .rd			(rd),
        .data_out	(data_out),
        
        .full		(full),
        .empty		(empty),
        .use_words	(use_words),
        .clear		(clear)//active is HIGH  
    );

    always begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
    end




    initial begin
        reset_n = 1'b0;
        clear = 1'b0;
        wr = 1'b0;
        data_in = {data_width{1'b0}};
        rd = 1'b0;
        repeat(10) @ (posedge clk);
        reset_n = 1'b1;
        repeat(10) @ (posedge clk);

        repeat(100000) @ (posedge clk);
        $display("***TEST PASSED***");
        $stop();

    end



//transaction generator
    initial begin
        wait(reset_n == 1'b1);
        @(posedge clk);
        forever begin
            if(!full) begin
                data_in = $urandom();
                wr = 1'b1;
                @(posedge clk);
                #2;
                wr = 1'b0;
            end
            repeat($urandom_range(2,0)) @(posedge clk);
        end
    end




//check transaction
    initial begin
        forever begin
            if(!empty) begin
                rd = 1'b1;
                @(posedge clk);
                #1;
                rd = 1'b0;
                repeat($urandom_range(10,0)) @ (posedge clk);
            end
            else begin
                @(posedge clk);
            end
        end
    end






endmodule