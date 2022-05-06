library IEEE;
use IEEE.std_logic_1164.all;

entity singlecycle is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       test_out1    : out std_logic_vector(31 downto 0);
       test_out2    : out std_logic_vector(31 downto 0);
       alu_out      : out std_logic_vector(31 downto 0);
       o_Cout		: out std_logic);

end singlecycle;

architecture structural of singlecycle is

component mux2t1_N is
    port(i_D0 		            : in std_logic_vector(31 downto 0);
       i_D1		            : in std_logic_vector(31 downto 0);
       i_S 		            : in std_logic;
       o_O 		            : out std_logic_vector(31 downto 0));
end component;

component mux2t1_5 is
    port(i_D0 		            : in std_logic_vector(4 downto 0);
       i_D1		            : in std_logic_vector(4 downto 0);
       i_S 		            : in std_logic;
       o_O 		            : out std_logic_vector(4 downto 0));

end component;
component mem is
    port(clk	: in std_logic;
	 addr	: in std_logic_vector(9 downto 0);
	 data	: in std_logic_vector(31 downto 0);
	 we	: in std_logic := '1';
	 q	: out std_logic_vector(31 downto 0));
end component;
component bitext is
    port(i_in	: in std_logic_vector(15 downto 0);
	 o_O	: out std_logic_vector(31 downto 0));
end component;
component regFile is
    port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_input        : in std_logic_vector(31 downto 0);
       i_write	    : in std_logic_vector(4 downto 0);
       i_read1	    : in std_logic_vector(4 downto 0);
       i_read2	    : in std_logic_vector(4 downto 0);
       o_read1          : out std_logic_vector(N-1  downto 0);
       o_read2          : out std_logic_vector(N-1  downto 0));

  end component;
component alu is
    port(aluop    : in std_logic_vector(3 downto 0);
       ALUSrc	    : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       imm	    : in std_logic_vector(N-1 downto 0);
       o_Sum        : out std_logic_vector(N-1 downto 0);
       o_Cout       : out std_logic);

  end component;
component fetch is
    port(i_clock             : in std_logic;
        i_reset             : in std_logic;
        o_Instr             : out std_logic_vector(31 downto 0));
  end component;
component cu is
    port(i_op     : in std_logic_vector(5 downto 0);
       i_func   : in std_logic_vector(5 downto 0);
       aluControl   : out std_logic_vector(3 downto 0);
       b        : out std_logic;
       j	: out std_logic;
       memRead  : out std_logic;
       memToReg : out std_logic;
       memWrite : out std_logic;
       aluSrc   : out std_logic;
       regWrite : out std_logic;
       sign_ext	: out std_logic;
       regDst   : out std_logic);
  end component;
signal s_addsubout : std_logic_vector(N-1 downto 0) := x"00000000";
signal s_regout1, s_regout2, s_extended : std_logic_vector(N-1 downto 0);
signal s_memout, s_mem2reg : std_logic_vector(31 downto 0);
signal s_inst : std_logic_vector(31 downto 0); 
signal s_aluControl : std_logic_vector(3 downto 0);
signal s_writeout : std_logic_vector(4 downto 0);
signal s_b,s_j,s_memRead,s_memToReg,s_memWrite,s_aluSrc,s_regWrite,s_sign_ext,s_regDst : std_logic;

begin
rammux: mux2t1_N port map(
		i_D0 => s_addsubout,
		i_D1 => s_memout,
		i_S => s_memToReg,
		o_O => s_mem2reg
);

instFetch: fetch port map(
		i_clock => i_CLK,
		i_reset => i_RST,
		o_Instr => s_inst
);

control: cu port map(
		i_op => s_inst(31 downto 26),
		i_func => s_inst(5 downto 0),
		aluControl => s_aluControl,
		b => s_b,
		j => s_j,	
		memRead => s_memRead,
	        memToReg => s_memToReg,
 	        memWrite => s_memWrite,
	        aluSrc   => s_aluSrc,
	        regWrite => s_regWrite,
	        sign_ext => s_sign_ext,
       		regDst   => s_regDst
);

ram: mem port map(
		clk => i_CLK,
		addr => s_addsubout(9 downto 0),
		data => s_regout2,
		we => s_memWrite,
		q => s_memout
);

writeMux: mux2t1_5 port map(
		i_D0 => s_inst(20 downto 16),
		i_D1 => s_inst(15 downto 11),
		i_S => s_regDst,
		o_O => s_writeout
);

ext: bitext port map(
		i_in => s_inst(15 downto 0),
		o_O =>  s_extended
);

Regs: regFile port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_input => s_mem2reg,
		i_write => s_writeout,
		i_read1 => s_inst(20 downto 16),
		i_read2 => s_inst(25 downto 21),
		o_read1 => s_regout1,
		o_read2 => s_regout2
			);
test_out1 <= s_regout1;
test_out2 <= s_regout2;
alu0: alu port map(
		aluop => s_aluControl,
		ALUSrc => s_aluSrc,
		i_D0 => s_regout2,
		i_D1 => s_regout1,
		imm => s_extended,
		o_Sum =>  s_addsubout,
		o_Cout => o_Cout
			);
alu_out <= s_addsubout;
end structural;