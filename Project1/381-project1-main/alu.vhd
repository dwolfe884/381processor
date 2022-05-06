-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(aluop    : in std_logic_vector(3 downto 0);
       ALUSrc	    : in std_logic;
       v_sig	    : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0); --R[rs]
       i_D1         : in std_logic_vector(N-1 downto 0); --R[rt]
       i_repl	    : in std_logic_vector(7 downto 0); --repl.qb imm
       imm	    : in std_logic_vector(N-1 downto 0);
       shamt	    : in std_logic_vector(4 downto 0);
       o_Sum        : out std_logic_vector(N-1 downto 0);
       aluzero	    : out std_logic;
       o_v	    : out std_logic;
       o_Cout       : out std_logic);

end alu;

architecture structural of alu is

  component mux2t1_N is
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));

  end component;
  
  component invg_N is
    port(i_A                  : in std_logic_vector(N-1 downto 0);
         o_F                  : out std_logic_vector(N-1 downto 0));
  end component;

  component RippleAdder is
    port(i_D0 		            : in std_logic_vector(N-1 downto 0);
         i_D1		            : in std_logic_vector(N-1 downto 0);
         i_Cin 		            : in std_logic;
         o_Sum 		            : out std_logic_vector(N-1 downto 0);
	 o_v			    : out std_logic;
         o_Cout 		    : out std_logic);
  end component;
  component andg32 is
    port(i_1          : in std_logic_vector(31 downto 0);
       i_2          : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;
  component org32 is
    port(i_1          : in std_logic_vector(31 downto 0);
       i_2          : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;
  component xorg32 is 
    port(i_1          : in std_logic_vector(31 downto 0);
       i_2          : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;
  component norg32 is
    port(i_in1          : in std_logic_vector(31 downto 0);
       i_in2          : in std_logic_vector(31 downto 0);
       o_Out          : out std_logic_vector(31 downto 0));
  end component;
  component BarrelShifter
    port(
	SHL : in std_logic_vector(4 downto 0);
	SHR : in std_logic_vector(4 downto 0);
	SHA : in std_logic_vector(4 downto 0);
	data_in: in std_logic_vector (N-1 downto 0);
	data_out: out std_logic_vector (N-1 downto 0));
  end component;

signal s_mux : std_logic_vector(N-1 downto 0);
signal s_not, s_src : std_logic_vector(N-1 downto 0);
signal s_adder_out : std_logic_vector(N-1 downto 0);
--bs signals
signal s_CLK : std_logic := '0';
signal s_shifter_out : std_logic_vector(N-1 downto 0);
signal s_shl, s_shr, s_sha : std_logic_vector(4 downto 0);
--bs signals
--and/or signals
signal s_ander_out, s_orer_out : std_logic_vector(N-1 downto 0);
--and/or signals  
--xor/nor signal
signal s_xorer_out, s_norer_out : std_logic_vector(N-1 downto 0);
--xor/nor signal
--slt signal
signal s_slt_out : std_logic_vector(N-1 downto 0);
--slt signal
--testing
signal temp_zero, tmp_slt, temp_v : std_logic;
signal s_sum : std_logic_vector(31 downto 0);
--testing
begin

  muxSrc: mux2t1_N port map(
	      i_S      => ALUSrc,
              i_D0     => i_D1, --R[rt]
              i_D1     => imm,
              o_O      => s_src); --R[rt] or imm

  notI: invg_N port map(
              i_A      => s_src,  --R[rt] or imm       
              o_F      => s_not); --not R[rt] or not imm

  muxI: mux2t1_N port map(
              i_S      => (aluop(3) and not aluop(2) and not aluop(0)) or (not aluop(3) and aluop(2) and not aluop(1) and aluop(0)), --bit for subtraction
              i_D0     => s_src, --R[rt] or imm
              i_D1     => s_not, --not R[rt] or not imm
              o_O      => s_mux);
  ander: andg32 port map(
		i_1 => i_D0, --R[rs]
		i_2 => s_mux,
		o_O => s_ander_out);
  orer: org32 port map(
		i_1 => i_D0, --R[rs]
		i_2 => s_mux,
		o_O => s_orer_out);
  xorer: xorg32 port map(
		i_1 => i_D0,
	        i_2 => s_mux,   
      	 	o_O => s_xorer_out);
  norer: norg32 port map(
		i_in1 => i_D0,
       		i_in2 => s_mux,
       		o_Out => s_norer_out);

  adderI: RippleAdder port map(
              i_D0     => i_D0, --R[rs]
              i_D1     => s_mux,
              i_Cin    => (aluop(3) and not aluop(2) and not aluop(0)) or (not aluop(3) and aluop(2) and not aluop(1) and aluop(0)), --bit for subtraction
              o_Sum    => s_adder_out,
	      o_v      => temp_v,
              o_Cout   => o_Cout);
o_v <= temp_v and v_sig;
  --s_shiftdir <= aluop(3) and aluop(2) and aluop(1) and not aluop(0)
with aluop select s_shl <=
	imm(10 downto 6) when "1110", --sll
	"10000"	when "0011", --lui
	"00000"	when others;
with aluop select s_shr <=
	imm(10 downto 6) when "1111", --srl
	"00000"	when others;
with aluop select s_sha <=
	imm(10 downto 6) when "0110", --sra
	"00000"	when others;
  bs: BarrelShifter 
  port map(
	SHL =>s_shl,
	SHR =>s_shr,
	SHA =>s_sha,
	data_in =>s_mux,
	data_out =>s_shifter_out);

--TODO : ADD ORER AND ANDER output to mux
--s_slt_out <= s_adder_out(N-1)
--tmp_slt <= (s_adder_out(N-1) and not o_v) or (not s_adder_out(N-1) and o_v);
tmp_slt <= s_adder_out(N-1) xor temp_v;
with tmp_slt select s_slt_out <=
	x"00000001"	when '1',
	x"00000000"	when others;

with aluop select s_sum <=
	s_adder_out	when "0000",
	s_adder_out	when "1000",
	s_orer_out	when "1011", --or/ori
	s_xorer_out	when "1001",
	s_norer_out	when "1100",
	s_ander_out	when "0001",
	s_shifter_out   when "1110", --sll
	imm(15 downto 0) & x"0000"	when "0011", --lui
	s_shifter_out   when "1111", --srl
	s_shifter_out   when "0110", --sra
	s_slt_out       when "1010", --slt/sli
	i_repl&i_repl&i_repl&i_repl		when "0100",
	s_ander_out	when others;
o_Sum <= s_sum;
with s_sum select temp_zero <=
	'1'	when x"00000000",
	'0'	when others;

with aluop select aluzero <=
	not temp_zero	when "0101",
	temp_zero	when others;

--outMux: mux2t1_N port map(
 --             i_S      => not aluop(3) and not aluop(2) and aluop(1) and aluop(0),
  --            i_D0     => s_adder_out,
   --           i_D1     => s_data_out,
    --          o_O      => o_Sum);

  
end structural;