library IEEE;
use IEEE.std_logic_1164.all;

entity tb_org32 is
  generic(DATA_WIDTH : natural := 32;
	  ADDR_WIDTH : natural := 10;
          gCLK_HPER   : time := 25 ns);
end tb_org32;

architecture behavior of tb_org32 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component org32
    port(i_1          : in std_logic_vector(31 downto 0);
       i_2          : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  -- signal s_CLK, s_RST, s_ALUSrc, s_add_sub : std_logic;
  signal s_CLK : std_logic;
  signal s_num1, s_num2 : std_logic_vector(31 downto 0) := x"00000000";
  signal s_out : std_logic_vector(31 downto 0);

begin

  og: org32 
  port map(i_1 => s_num1, 
	   i_2 => s_num2,
           o_O => s_out);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
-- addi $1, $0, 1
    s_num1 <= x"11111111";
    s_num2 <= x"00000000";
    wait for cCLK_PER;
    s_num1 <= x"11110000";
    s_num2 <= x"11110000";
    wait for cCLK_PER;
    s_num1 <= x"10101010";
    s_num2 <= x"11111111";
    wait for cCLK_PER; 

    wait;
  end process;
  
end behavior;