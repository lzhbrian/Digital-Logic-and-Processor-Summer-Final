// Created by Lin, Tzu-Heng
// Created on 2016.8.27 8:00
// All rights reserved
// UART

module UART(
	input sysclk,
	input clk,
	input reset_t,

	input rd, 				// 读使能信号
	input wr,				// 写使能信号

	input [31:0] addr, 		// 地址
	input [31:0] wdata, 	// 写入数据
	output reg [31:0] rdata, // 读出数据

	input UART_RX,
	output wire UART_TX
);


wire reset = ~reset_t;

wire clock_153600;
wire clock_9600;
wire RX_STATUS;
wire TX_STATUS;
wire [7:0] RX_DATA;
wire [7:0] TX_DATA;
wire TX_EN;


reg [4:0] UART_CON; // 串口状态、控制	0x40000018
reg [7:0] UART_TXD; // 串口发送数据	0x4000001C
reg [7:0] UART_RXD; // 串口接受数据	0x40000020

reg [7:0] TX_DATA_r;
assign TX_DATA = TX_DATA_r;

assign TX_EN = UART_CON[0]; // 告诉 发射器 是否可以传输 (发送中断使能)


Clock_153600_Generator Clock_153600_Generator_uut(sysclk,clock_153600);
Clock_9600_Generator Clock_9600_Generator_uut(clock_153600,clock_9600);

UART_Receiver UART_Receiver_uut(clk,UART_RX,clock_153600,RX_STATUS,RX_DATA);
// controller controller(sysclk, RX_DATA, RX_STATUS, TX_STATUS, TX_DATA, TX_EN);
UART_Sender UART_Sender_uut(clk,TX_DATA,TX_EN,clock_9600,TX_STATUS,UART_TX);


always @(*) begin

	// 若读使能，则读出对应地址的数据
	if (rd) begin
		case (addr)
			32'h40000018: rdata <= {24'b0, UART_TXD};
			32'h4000001C: rdata <= {24'b0, UART_RXD};
			32'h40000020: rdata <= {26'b0, UART_CON};
			default: rdata <= 32'b0;
		endcase
	end
	else rdata <= 32'b0;

end


// Other
always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		UART_TXD <= 32'b0;
		UART_RXD <= 32'b0;
		UART_CON <= 32'b0;
	end
	else begin

		// 若接受到数据
		if (RX_STATUS) begin
			UART_RXD <= RX_DATA;
			UART_CON[3] <= 1; // 接受中断状态
		end

		if (TX_STATUS && TX_EN) begin
			TX_DATA_r <= UART_TXD;
			UART_CON[2] <= 1; // 发送中断状态
		end

		if (rd && (addr == 32'h4000_0020)) begin
            if(UART_CON[2] == 1'b1)
                UART_CON[2] <= 1'b0;
            if(UART_CON[3] == 1'b1)
                UART_CON[3] <= 1'b0;
		end

		// 如果写使能，则写入地址
		if (wr) begin
			case (addr)
				32'h40000018: begin // 如果对该地址进行写操作，将触发新的UART发送
					UART_TXD <= wdata[7:0];
					UART_CON[0] <= 1'b1; //（发送中断使能，TX_EN）
				end
				32'h4000001C: UART_RXD <= wdata[7:0];
				32'h40000020: UART_CON <= wdata[4:0];
				default: ;
			endcase
		end

		if (UART_CON[0])
			UART_CON[0] <= 0; //（发送中断使能，TX_EN）
	
	end
end



endmodule



//串口接收器*******************************
module UART_Receiver(sysclk,UART_RX,clock_153600,RX_STATUS,RX_DATA);

	input sysclk;
	input UART_RX;
	input clock_153600;

	output wire RX_STATUS;
	output wire [7:0] RX_DATA; //7是最低位，0是最高位

	reg RX_STATUS_r;
	reg [7:0] RX_DATA_r;
	reg [7:0] counter;
	reg samplingclock; //采样时钟
	reg startstate;

	reg [7:0] RX_DATA_temp;

	assign RX_STATUS = RX_STATUS_r;
	assign RX_DATA = RX_DATA_r;

	initial begin
		startstate = 0; //指示开始计数的信号
		counter = 0; //计数器
		samplingclock = 0; //采样时钟
		RX_STATUS_r = 0; //提示是否传输完
		RX_DATA_r = 0; //初始化接收数据
		RX_DATA_temp = 0;
	end

	wire reset = RX_STATUS;

	//开始计数 信号
	always @(posedge clock_153600 or posedge reset) begin
		if (reset) begin
			startstate <= 0; //结束计数
			counter <= 0; //计数器清零
		end
		else begin
			if (UART_RX == 0 && startstate == 0) begin //刚开始计数
				counter <= 0;
				startstate <= 1;
			end
			else if (startstate == 1) begin //已经开始计数
				if (counter >= 8'd144) begin
					counter <= 0;
					startstate <= 0;
				end
				else begin
					counter <= counter + 1;
				end
			end
		end
	end

	//指示是否传输完信号
	always @(posedge sysclk) begin
		if (counter == 8'd144) begin
			// RX_DATA_r <= RX_DATA_temp;
			RX_STATUS_r <= 1;

			RX_DATA_r[7] <= RX_DATA_temp[0];
			RX_DATA_r[6] <= RX_DATA_temp[1];
			RX_DATA_r[5] <= RX_DATA_temp[2];
			RX_DATA_r[4] <= RX_DATA_temp[3];
			RX_DATA_r[3] <= RX_DATA_temp[4];
			RX_DATA_r[2] <= RX_DATA_temp[5];
			RX_DATA_r[1] <= RX_DATA_temp[6];
			RX_DATA_r[0] <= RX_DATA_temp[7];
			
		end
		else begin
			RX_DATA_r = RX_DATA_r;
			RX_STATUS_r = 0;
		end
	end

	//生成采样信号 samplingclock
	always @(posedge clock_153600) begin
		if (startstate == 1) begin
			case(counter)
				8'd24:begin//第1次采样
					samplingclock=1;
				end
				8'd25:begin
					samplingclock=0;
				end
				8'd40:begin//第2次采样
					samplingclock=1;
				end
				8'd41:begin
					samplingclock=0;
				end
				8'd56:begin//第3次采样
					samplingclock=1;
				end
				8'd57:begin
					samplingclock=0;
				end
				8'd72:begin//第4次采样
					samplingclock=1;
				end
				8'd73:begin
					samplingclock=0;
				end
				8'd88:begin//第5次采样
					samplingclock=1;
				end
				8'd89:begin
					samplingclock=0;
				end
				8'd104:begin//第6次采样
					samplingclock=1;
				end
				8'd105:begin
					samplingclock=0;
				end
				8'd120:begin//第7次采样
					samplingclock=1;
				end
				8'd121:begin
					samplingclock=0;
				end
				8'd136:begin//第8次采样
					samplingclock=1;
				end
				8'd137:begin
					samplingclock=0;
				end
			endcase
		end
	end

	//使用采样时钟采样
	always @(posedge samplingclock) begin
		RX_DATA_temp <= RX_DATA_temp*2 + UART_RX;
	end
endmodule


//串口发射器*******************************
module UART_Sender(sysclk,TX_DATA,TX_EN,clock_9600,TX_STATUS,UART_TX);
	
	input sysclk;
	input [7:0] TX_DATA;
	input TX_EN; // 允许发送
	input clock_9600;

	output TX_STATUS;
	output UART_TX;

	reg TX_STATUS_r;
	reg UART_TX_r;
	reg [4:0] counter;

	assign TX_STATUS = TX_STATUS_r;
	assign UART_TX = UART_TX_r;


	initial begin
		TX_STATUS_r = 1;
		counter = 0;
		UART_TX_r = 1;
	end

	wire reset = TX_EN;

	always @(posedge clock_9600 or posedge reset) begin
		if (reset) begin
			//从controller接到信号，指示串口可以输出信号了；这个信号只闪一个系统时钟周期；
			counter <= 0;
		end
		else if(counter < 4'b1001) begin
			case(counter)
				4'b0000: UART_TX_r <= 0;
				4'b0001: UART_TX_r <= TX_DATA[0];
				4'b0010: UART_TX_r <= TX_DATA[1];
			  	4'b0011: UART_TX_r <= TX_DATA[2];
			  	4'b0100: UART_TX_r <= TX_DATA[3];
			  	4'b0101: UART_TX_r <= TX_DATA[4];
			  	4'b0110: UART_TX_r <= TX_DATA[5];
			  	4'b0111: UART_TX_r <= TX_DATA[6];
			  	4'b1000: UART_TX_r <= TX_DATA[7];
			  	4'b1001: UART_TX_r <= 1;
			endcase
			counter <= counter + 1;
		end
		else begin
			UART_TX_r <= 1;
		end
	end

	// always @(counter) begin
	// 	case(counter)
	// 		4'b0000: UART_TX_r <= 0;
	// 		4'b0001: UART_TX_r <= TX_DATA[7];
	// 		4'b0010: UART_TX_r <= TX_DATA[6];
	// 	  	4'b0011: UART_TX_r <= TX_DATA[5];
	// 	  	4'b0100: UART_TX_r <= TX_DATA[4];
	// 	  	4'b0101: UART_TX_r <= TX_DATA[3];
	// 	  	4'b0110: UART_TX_r <= TX_DATA[2];
	// 	  	4'b0111: UART_TX_r <= TX_DATA[1];
	// 	  	4'b1000: UART_TX_r <= TX_DATA[0];
	// 	  	4'b1001: UART_TX_r <= 1;
	// 	endcase
	// end
	
	always @(posedge sysclk) begin
		if (counter == 4'b1001) begin
			TX_STATUS_r <= 1;
		end
		else begin
			TX_STATUS_r <= 0;
		end
	end
endmodule




//波特率发生器*******************************
//产生153600Hz信号
module Clock_153600_Generator(sysclk,clock_153600);

	input sysclk;
	output clock_153600;

	reg [10:0]divide;
	reg [10:0]counter;
	reg clock_153600_r;
	assign clock_153600 = clock_153600_r;

	initial begin
		divide = 10'b10_1000_1010; //153600Hz, 分频比为650
		counter = 10'b0;
		clock_153600_r = 0;
	end

	always@(posedge sysclk)//按divide分频
	begin
		if(counter==0)
			clock_153600_r=~clock_153600_r;

		counter=counter+10'b00_0000_0010;
		if(counter==divide)
			counter=10'b00_0000_0000;
	end
endmodule

//产生9600Hz信号
module Clock_9600_Generator(clock_153600,clock_9600);

	input clock_153600;
	output clock_9600;

	reg [4:0]counter;
	reg clock_9600_r;
	assign clock_9600 = clock_9600_r;

	initial begin
		counter = 4'b0;
		clock_9600_r = 0;
	end

	always@(posedge clock_153600)//按divide分频
	begin
		if(counter==0)
			clock_9600_r=~clock_9600_r;

		counter=counter+10'b00_0000_0010;
		if(counter==5'd16)
			counter=4'b0;
	end
endmodule


// // Testbench
// module tb;
// 	reg UART_RX,sysclk,reset;
// 	wire UART_TX;
// 	top uut(sysclk,UART_RX,reset,UART_TX);
// 	initial begin
// 		reset=0;
// 		sysclk=0;
// 		UART_RX=1;
// 		#100 reset=1;
// 		#5 reset=0;

// 		// 11010100 -> 11010100
// 		#500000 UART_RX=1;
// 		#104160 UART_RX=0;

// 		#104160 UART_RX=1;//1
// 		#104160 UART_RX=1;//2
// 		#104160 UART_RX=0;//3
// 		#104160 UART_RX=1;//4
// 		#104160 UART_RX=0;//5
// 		#104160 UART_RX=1;//6
// 		#104160 UART_RX=0;//7
// 		#104160 UART_RX=0;//8


// 		// 01101001 -> 10010111
// 		#104160 UART_RX=1;
// 		#104160 UART_RX=0; 
		
// 		#104160 UART_RX=0;//1
// 		#104160 UART_RX=1;//2
// 		#104160 UART_RX=1;//3
// 		#104160 UART_RX=0;//4
// 		#104160 UART_RX=1;//5
// 		#104160 UART_RX=0;//6
// 		#104160 UART_RX=0;//7
// 		#104160 UART_RX=1;//8

// 		// 01110110 -> 01110110
// 		#104160 UART_RX=1;
// 		#104160 UART_RX=0; 

// 		#104160 UART_RX=0;//1
// 		#104160 UART_RX=1;//2
// 		#104160 UART_RX=1;//3
// 		#104160 UART_RX=1;//4
// 		#104160 UART_RX=0;//5
// 		#104160 UART_RX=1;//6
// 		#104160 UART_RX=1;//7
// 		#104160 UART_RX=0;//8


// 		// Final
// 		#104160 UART_RX=1;
// 		#104160 UART_RX=1;
// 	end
// 	initial begin
// 		forever #5 sysclk<=~sysclk;
// 	end
// endmodule 


