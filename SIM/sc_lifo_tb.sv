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

        repeat(1000000) @ (posedge clk);
        $display("***TEST PASSED***");
        $stop();

    end

reg [data_width-1:0] queue_transaction [$];

//transaction generator
    initial begin
        wait(reset_n == 1'b1);
        @(posedge clk);
        forever begin
            repeat(100000) begin
                if(!full) begin
                    data_in = $urandom();
                    wr = $urandom_range(1,0);
                    @(posedge clk);
                    #1;
                    if(wr) begin
                        queue_transaction.push_back(data_in);
                        $display("Data write in queue %0x", data_in);
                    end
                    wr = 1'b0;
                end
                else begin
                    wr = 1'b0;
                    @(posedge clk);
                end
            end

            wait(empty == 1'b1);
            repeat(10) @ (posedge clk);
        end
    end




//check transaction
    initial begin
        repeat(1000) @(posedge clk);
        wait(full == 1'b1);
        forever begin
            if(!empty) begin
                rd = $urandom_range(1,0);
                @(posedge clk);
                #2;
                if(rd == 1'b1) begin
                    if(data_out == queue_transaction.pop_back()) begin
                        $display("Transaction OK");
                    end
                    else begin
                        $display("Transaction %0x FAILED", data_out);
                        $display("***TEST FAILED***");
                        $stop();
                    end
                end
                rd = 1'b0;
            end
            else begin
                @(posedge clk);
            end
        end
    end




//  Covergroup: cg_write
//
    covergroup cg_wr_lifo @(posedge clk);
        //  Coverpoint: c1
        c1: coverpoint wr {
            bins b1 = (0=>0=>0);
            bins b2 = (0=>0=>1);
            bins b3 = (0=>1=>0);
            bins b4 = (0=>1=>1);
            bins b5 = (1=>0=>0);
            bins b6 = (1=>0=>1);
            bins b7 = (1=>1=>0);
            bins b8 = (1=>1=>1);
        }
    endgroup
    
    
    covergroup cg_rd_lifo @ (posedge clk);
        c1: coverpoint rd {
            bins b1 = (0=>0=>0);
            bins b2 = (0=>0=>1);
            bins b3 = (0=>1=>0);
            bins b4 = (0=>1=>1);
            bins b5 = (1=>0=>0);
            bins b6 = (1=>0=>1);
            bins b7 = (1=>1=>0);
            bins b8 = (1=>1=>1);
        }
    endgroup
    
    
    covergroup cg_full_lifo @ (posedge clk);
        c1: coverpoint full {
            bins b1 = (0=>0=>0);
            bins b2 = (0=>0=>1);
            bins b3 = (0=>1=>0);
            bins b4 = (0=>1=>1);
            bins b5 = (1=>0=>0);
            ignore_bins b6 = (1=>0=>1);//not check in coverage
            bins b7 = (1=>1=>0);
            bins b8 = (1=>1=>1);
        }
    endgroup
    
    
    cg_wr_lifo cg_wr_lifo_inst = new();
    cg_rd_lifo cg_rd_lifo_inst = new();
    cg_full_lifo cg_full_lifo_inst = new();

endmodule