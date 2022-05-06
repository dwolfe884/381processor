library IEEE;
use IEEE.std_logic_1164.all;

entity tb_singlecycle is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
end tb_singlecycle;

architecture behavior of tb_singlecycle is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component singlecycle
    port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       test_out1    : out std_logic_vector(31 downto 0);
       test_out2    : out std_logic_vector(31 downto 0);
       alu_out      : out std_logic_vector(31 downto 0);
       o_Cout		: out std_logic);

  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_ALUSrc, s_add_sub: std_logic;
  signal s_Cout : std_logic;
  signal s_out1, s_out2, s_alu_out : std_logic_vector(31 downto 0);
  signal s_regDst : std_logic;
begin

  DUT: singlecycle
  port map(i_CLK => s_CLK, 
           i_RST => s_RST,
           test_out1 => s_out1,
           test_out2 => s_out2,
           alu_out  => s_alu_out,
           o_Cout   => s_Cout);

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
s_RST <= '1';
wait for cCLK_PER; 
s_RST <= '0';
wait for cCLK_PER; 
wait for cCLK_PER; 
wait for cCLK_PER; 
    wait;
  end process;
  
end behavior;