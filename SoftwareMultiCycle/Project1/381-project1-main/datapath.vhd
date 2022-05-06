library IEEE;
use IEEE.std_logic_1164.all;

entity datapath is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       ALUSrc	    : in std_logic;
       add_sub	    : in std_logic;
       i_imm        : in std_logic_vector(31 downto 0);
       i_RT	    : in std_logic_vector(4 downto 0);
       i_RS	    : in std_logic_vector(4 downto 0);
       i_RD	    : in std_logic_vector(4 downto 0);
       test_out1    : out std_logic_vector(31 downto 0);
       test_out2    : out std_logic_vector(31 downto 0);
       alu_out      : out std_logic_vector(31 downto 0);
       o_Cout		: out std_logic);

end datapath;

architecture structural of datapath is
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
signal s_regout1, s_regout2 : std_logic_vector(N-1 downto 0);
 
begin
Regs: regFile port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_input => s_addsubout,
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
		imm => i_imm,
		o_Sum =>  s_addsubout,
		o_Cout => o_Cout
			);
alu_out <= s_addsubout;
end structural;