/*
sc_lifo #(
	.data_width(32),
	.fifo_depth(10)
) sc_lifo_inst (
	.clk	(),
	.reset_n(),
		
	.wr		(),
	.data_in(),
	
	.rd			(),
	.data_out	(),
	
	.full		(),
	.empty		(),
	.use_words	(),
	.clear		()//active is HIGH
	
);

*/
module sc_lifo #(
	parameter data_width = 32,
	parameter lifo_depth = 10
)(
	input 	logic clk,
	input 	logic reset_n,
	
	input 	logic 						wr,
	input 	logic 	[data_width-1:0] 	data_in,
	
	input 	logic 						rd,
	output 	logic 	[data_width-1:0] 	data_out,
	
	output 	logic 						full,
	output 	logic 						empty,
	output 	logic 	[lifo_depth:0] 		use_words,
	input 	logic						clear 
	
);



reg [data_width-1:0] ram [2**lifo_depth-1:0];
reg [lifo_depth-1:0] wr_ptr, rd_ptr;
reg [lifo_depth:0] cnt_word;



always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) begin
        wr_ptr      <= {lifo_depth{1'b0}};
        rd_ptr      <= {lifo_depth{1'b0}};
        cnt_word    <= {(lifo_depth+1){1'b0}};
        full        <= 1'b0;
        empty       <= 1'b1;
    end
    else if(clear) begin
        wr_ptr      <= {lifo_depth{1'b0}};
        rd_ptr      <= {lifo_depth{1'b0}};
        cnt_word    <= {(lifo_depth+1){1'b0}};
        full        <= 1'b0;
        empty       <= 1'b1;
    end
    else begin
        case({rd & ~empty, wr & !full})
            2'b00, 2'b11: begin
                wr_ptr      <= wr_ptr;
                rd_ptr      <= rd_ptr;
                cnt_word    <= cnt_word;
                full        <= full;
                empty       <= empty;
            end

            2'b01: begin
                empty       <= 1'b0;
                rd_ptr      <= wr_ptr;
                cnt_word    <= cnt_word + 1'b1;

                if(&wr_ptr) begin
                    wr_ptr  <= {lifo_depth{1'b1}};
                    full    <= 1'b1;
                end
                else begin
                    wr_ptr  <= wr_ptr + 1'b1;
                    full    <= 1'b0;
                end
            end

            2'b10: begin
                full        <= 1'b0;
                wr_ptr      <= rd_ptr;
                cnt_word    <= cnt_word - 1'b1;
                
                if(rd_ptr == {lifo_depth{1'b0}}) begin
                    rd_ptr  <= {lifo_depth{1'b0}};
                    empty   <= 1'b1;
                end 
                else begin
                    rd_ptr  <= rd_ptr - 1'b1;
                    empty   <= 1'b0;
                end
            end
        endcase
    end

always_ff @ (posedge clk) begin
    if({rd & ~empty, wr & !full} == 2'b01) ram[wr_ptr] <= data_in; 
end



always_ff @ (posedge clk) begin
    case({rd & ~empty, wr & !full})
        2'b00, 2'b11: data_out <= data_in;
        2'b01, 2'b10: data_out <= ram[rd_ptr];
    endcase
end

assign use_words = cnt_word;


endmodule