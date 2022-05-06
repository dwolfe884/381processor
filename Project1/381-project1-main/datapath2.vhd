library IEEE;
use IEEE.std_logic_1164.all;

entity datapath2 is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       ALUSrc	    : in std_logic;
       add_sub	    : in std_logic;
       i_memwrite   : in std_logic;
       i_mem2reg    : in std_logic;
       i_regDst	    : in std_logic;
       i_imm        : in std_logic_vector(15 downto 0);
       i_RT	    : in std_logic_vector(4 downto 0);
       i_RS	    : in std_logic_vector(4 downto 0);
       i_RD	    : in std_logic_vector(4 downto 0);
       test_out1    : out std_logic_vector(31 downto 0);
       test_out2    : out std_logic_vector(31 downto 0);
       alu_out      : out std_logic_vector(31 downto 0);
       o_Cout		: out std_logic);

end datapath2;

architecture structural of datapath2 is

component mux2t1_N is
    generic(bits : integer := 32);
    port(i_D0 		            : in std_logic_vector(bits downto 0);
       i_D1		            : in std_logic_vector(bits downto 0);
       i_S 		            : in std_logic;
       o_O 		            : out std_logic_vector(bits downto 0));
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
component AddSub is
    port(n_Add_Sub    : in std_logic;
       ALUSrc	    : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       imm	    : in std_logic_vector(N-1 downto 0);
       o_Sum        : out std_logic_vector(N-1 downto 0);
       o_Cout       : out std_logic);

  end component;

signal s_addsubout : std_logic_vector(N-1 downto 0) := x"00000000";
signal s_regout1, s_regout2, s_extended : std_logic_vector(N-1 downto 0);
signal s_memout, s_mem2reg : std_logic_vector(31 downto 0);
signal s_writeout : std_logic_vector(31 downto 0); 

begin
rammux: mux2t1_N port map(
		i_D0 => s_addsubout,
		i_D1 => s_memout,
		i_S => i_mem2reg,
		o_O => s_mem2reg
);

ram: mem port map(
		clk => i_CLk,
		addr => s_addsubout(9 downto 0),
		data => s_regout2,
		we => i_memwrite,
		q => s_memout
);

writeMux: mux2t1_N 
		generic map(bits => 5)
		port map(
		i_D0 => i_RT,
		i_D1 => i_RD,
		i_S => i_regDst,
		o_O => s_writeout
);

ext: bitext port map(
		i_in => i_imm,
		o_O =>  s_extended
);

Regs: regFile port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_input => s_writeout,
		i_write => i_RD,
		i_read1 => i_RT,
		i_read2 => i_RS,
		o_read1 => s_regout1,
		o_read2 => s_regout2
			);
test_out1 <= s_regout1;
test_out2 <= s_regout2;
alu: AddSub port map(
		n_Add_Sub => add_sub,
		ALUSrc => ALUSrc,
		i_D0 => s_regout2,
		i_D1 => s_regout1,
		imm => s_extended,
		o_Sum =>  s_addsubout,
		o_Cout => o_Cout
			);
alu_out <= s_addsubout;
end structural;