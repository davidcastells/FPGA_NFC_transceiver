module uart_rx (
	input clk,
	input  rstn,
	input  i_uart_rx,
	input  o_tready,
	output  o_tvalid,
	output [7:0] o_tdata,
	output  o_overflow);
wire w_clock_desync;
wire w_tx_clk_pulse;
wire w_rx_sample;

ClockGenerationAndRecovery_1c4bcc730d0 i_clk(.clk(clk),.rx(i_uart_rx),.desync(w_clock_desync),.tx_clk_pulse(w_tx_clk_pulse),.rx_sample(w_rx_sample));
UARTDeserializer_1c4bd13c850 uart_rx(.clk(clk),.rx(i_uart_rx),.ready(o_tready),.rx_sample(w_rx_sample),.valid(o_tvalid),.v(o_tdata),.clock_desync(w_clock_desync));
endmodule

// This file was automatically created by py4hw RTL generator
module ClockGenerationAndRecovery_1c4bcc730d0 (
	input clk,
	input  rx,
	input  desync,
	output  tx_clk_pulse,
	output  rx_sample);
wire w_sync;
wire w_nactive;
wire w_uart_clk;
wire w_sync_uart_clk;
wire w_active;
wire w_start;
wire w_pre_rx_sample;
wire w_rx_neg;

ClockDivider_1c4bce8dad0 i_uart_clk(.clk(clk),.clkout(w_uart_clk));
ClockSyncFSM_1c4bcc7b8d0 i_clk_sync(.clk(clk),.start(w_start),.stop(desync),.sync(w_sync),.active(w_active));
ClockDivider_1c4bd16af10 i_sync_uart_clk(.clk(clk),.reset(w_start),.clkout(w_sync_uart_clk));
assign w_nactive = ~w_active;
EdgeDetector_1c4bd13eb90 i_pos_edge(.clk(clk),.a(w_uart_clk),.r(tx_clk_pulse));
EdgeDetector_1c4bd13fa50 i_rx_neg(.clk(clk),.a(rx),.r(w_rx_neg));
assign w_start = w_rx_neg & w_nactive;
EdgeDetector_1c4bd13e150 i_sample(.clk(clk),.a(w_sync_uart_clk),.r(w_pre_rx_sample));
assign rx_sample = w_pre_rx_sample & w_active;
endmodule

// This file was automatically created by py4hw RTL generator
module ClockDivider_1c4bce8dad0 (
	input clk,
	output  clkout);
wire [12:0] w_q;
wire w_i0;
wire w_t;
wire w_i1;

assign w_i0 = 1;
assign w_i1 = 0;
ModuloCounter_1c4bce95510 i_count(.clk(clk),.reset(w_i1),.inc(w_i0),.q(w_q),.carryout(w_t));
TReg_1c4bd168b50 i_clkout(.clk(clk),.t(w_t),.e(w_i0),.r(w_i1),.q(clkout));
endmodule

// This file was automatically created by py4hw RTL generator
module ModuloCounter_1c4bce95510 (
	input clk,
	input  reset,
	input  inc,
	output [12:0] q,
	output  carryout);
wire [12:0] w_one;
wire [12:0] w_d1;
wire [12:0] w_d;
wire [12:0] w_add;
wire w_anyreset;
wire [12:0] w_zero;
wire w_e_add;

assign w_one[12:0] = 1;
assign w_zero[12:0] = 0;
assign w_anyreset = reset | carryout;
assign w_d1 = (inc)? w_add : q;
assign w_d = (w_anyreset)? w_zero : w_d1;
assign w_e_add = reset | inc;
Add_1c4bd17db50 i_add(.a(q),.b(w_one),.r(w_add));
Reg13E i_reg(.clk(clk),.d(w_d),.e(w_e_add),.q(q));
assign carryout = (q == 4236)? 1 : 0;
endmodule

// This file was automatically created by py4hw RTL generator
module Add_1c4bd17db50 (
	input [12:0] a,
	input [12:0] b,
	output [12:0] r);
wire w_ci;

assign w_ci = 0;
assign r = a + b + w_ci;
endmodule

// This file was automatically created by py4hw RTL generator
module Reg13E (
	input clk,
	input [12:0] d,
	input  e,
	output [12:0] q);
reg [12:0] rq = 0;
always @(posedge clk)
if (e == 1)
begin
   rq <= d;
end
assign q = rq;
endmodule

// This file was automatically created by py4hw RTL generator
module TReg_1c4bd168b50 (
	input clk,
	input  t,
	input  e,
	input  r,
	output  q);
wire w_d;
wire w_nq;

assign w_nq = ~q;
assign w_d = (t)? w_nq : q;
Reg1RE i_reg(.clk(clk),.d(w_d),.e(e),.r(r),.q(q));
endmodule

// This file was automatically created by py4hw RTL generator
module Reg1RE (
	input clk,
	input  d,
	input  e,
	input  r,
	output  q);
reg  rq = 0;
always @(posedge clk)
if (r == 1)
begin
   rq <= 0;
end
else
begin
if (e == 1)
begin
   rq <= d;
end
end
assign q = rq;
endmodule

// This file was automatically created by py4hw RTL generator
module ClockSyncFSM_1c4bcc7b8d0 (
	input clk,
	input  start,
	input  stop,
	output  reg  sync,
	output  reg  active);
// Code generated from clock method
// wire/variable declaration
integer state;
// initial
initial
begin
    state=0;
end
// process
always @(posedge clk)
begin
    if (state==0)
    begin
        if (start)
        begin
            state=1;
            sync<=1;
            active<=1;
        end
        else
        begin
            sync<=0;
            active<=0;
        end
    end
    else
    begin
        if (state==1)
        begin
            sync<=0;
            if (stop)
            begin
                state=0;
                active<=0;
            end
            else
            begin
                active<=1;
            end
        end
    end
end
endmodule

// This file was automatically created by py4hw RTL generator
module ClockDivider_1c4bd16af10 (
	input clk,
	input  reset,
	output  clkout);
wire w_i0;
wire w_t;
wire [12:0] w_q;

assign w_i0 = 1;
ModuloCounter_1c4bd16a310 i_count(.clk(clk),.reset(reset),.inc(w_i0),.q(w_q),.carryout(w_t));
TReg_1c4bd13e6d0 i_clkout(.clk(clk),.t(w_t),.e(w_i0),.r(reset),.q(clkout));
endmodule

// This file was automatically created by py4hw RTL generator
module ModuloCounter_1c4bd16a310 (
	input clk,
	input  reset,
	input  inc,
	output [12:0] q,
	output  carryout);
wire [12:0] w_one;
wire [12:0] w_d1;
wire w_anyreset;
wire [12:0] w_zero;
wire w_e_add;
wire [12:0] w_d;
wire [12:0] w_add;

assign w_one[12:0] = 1;
assign w_zero[12:0] = 0;
assign w_anyreset = reset | carryout;
assign w_d1 = (inc)? w_add : q;
assign w_d = (w_anyreset)? w_zero : w_d1;
assign w_e_add = reset | inc;
Add_1c4bd1566d0 i_add(.a(q),.b(w_one),.r(w_add));
Reg13E i_reg(.clk(clk),.d(w_d),.e(w_e_add),.q(q));
assign carryout = (q == 4236)? 1 : 0;
endmodule

// This file was automatically created by py4hw RTL generator
module Add_1c4bd1566d0 (
	input [12:0] a,
	input [12:0] b,
	output [12:0] r);
wire w_ci;

assign w_ci = 0;
assign r = a + b + w_ci;
endmodule

// This file was automatically created by py4hw RTL generator
module TReg_1c4bd13e6d0 (
	input clk,
	input  t,
	input  e,
	input  r,
	output  q);
wire w_nq;
wire w_d;

assign w_nq = ~q;
assign w_d = (t)? w_nq : q;
Reg1RE i_reg(.clk(clk),.d(w_d),.e(e),.r(r),.q(q));
endmodule

// This file was automatically created by py4hw RTL generator
module EdgeDetector_1c4bd13eb90 (
	input clk,
	input  a,
	output  r);
wire w_z1;
wire w_nz1;

Reg1 i_z1(.clk(clk),.d(a),.q(w_z1));
assign w_nz1 = ~w_z1;
assign r = a & w_nz1;
endmodule

// This file was automatically created by py4hw RTL generator
module Reg1 (
	input clk,
	input  d,
	output  q);
reg  rq = 0;
always @(posedge clk)
   rq <= d;
assign q = rq;
endmodule

// This file was automatically created by py4hw RTL generator
module EdgeDetector_1c4bd13fa50 (
	input clk,
	input  a,
	output  r);
wire w_z1;
wire w_na;

Reg1 i_z1(.clk(clk),.d(a),.q(w_z1));
assign w_na = ~a;
assign r = w_na & w_z1;
endmodule

// This file was automatically created by py4hw RTL generator
module EdgeDetector_1c4bd13e150 (
	input clk,
	input  a,
	output  r);
wire w_z1;
wire w_nz1;

Reg1 i_z1(.clk(clk),.d(a),.q(w_z1));
assign w_nz1 = ~w_z1;
assign r = a & w_nz1;
endmodule

// This file was automatically created by py4hw RTL generator
module UARTDeserializer_1c4bd13c850 (
	input clk,
	input  rx,
	input  ready,
	input  rx_sample,
	output  reg  valid,
	output  reg [7:0] v,
	output  reg  clock_desync);
// Code generated from clock method
// wire/variable declaration
integer state;
integer count;
integer state_v;
integer temp;
// initial
initial
begin
    state=0;
    count=0;
    state_v=0;
    temp=0;
end
// process
always @(posedge clk)
begin
    if (state==0)
    begin
        clock_desync<=0;
        count=0;
        temp=0;
        if (rx_sample&&(rx==0))
        begin
            state=2;
        end
    end
    else
    begin
        if (state==2)
        begin
            if (rx_sample)
            begin
                if (count==8)
                begin
                    state=0;
                    state_v=1;
                    v<=temp;
                    clock_desync<=1;
                end
                else
                begin
                    temp=temp|(rx<<count);
                    count=count+1;
                end
            end
        end
    end
    if (state_v==1)
    begin
        if (ready)
        begin
            valid<=1;
            state_v=2;
        end
    end
    else
    begin
        if (state_v==2)
        begin
            if (ready)
            begin
                valid<=0;
                state_v=0;
            end
        end
    end
end
endmodule
