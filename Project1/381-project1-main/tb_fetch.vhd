library IEEE;
use IEEE.std_logic_1164.all;
-- mem load -infile dmem.hex -format hex /tb_fetch/DUT/mem0/ram

entity tb_fetch is
  generic(N : integer := 32;
	gCLK_HPER   : time := 50 ns);
end tb_fetch;

architecture behavior of tb_fetch is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component fetch
  port(
    i_clock             : in std_logic;
    i_reset             : in std_logic;
    o_Instr             : out std_logic_vector(31 downto 0));

  end component;

  --signals
  signal s_CLK      : std_logic;
  signal s_RST      : std_logic:= '0';
  --signal s_write    : std_logic:= '0';
  signal s_Out    : std_logic_vector(31 downto 0);

begin

  DUT: fetch 
  port map(
    i_clock     => s_CLK,
    i_reset     => s_RST,
    o_Instr     => s_Out
  );

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
    --s_input <= x"00000000";
    wait for cCLK_PER;
    
    --s_input <= x"00000001";
    s_RST <= '0';
    wait for cCLK_PER;
 
    --s_input <= x"00000002";
    wait for cCLK_PER;   

    --s_input <= x"00000003";
    wait for cCLK_PER; 

    --s_input <= x"00000004";
    wait for cCLK_PER; 

    --s_input <= x"00000005";
    wait for cCLK_PER; 

    --s_input <= x"00000006";
    wait for cCLK_PER; 

    --s_input <= x"00000007";
    wait for cCLK_PER; 

    --s_input <= x"00000008";
    wait for cCLK_PER; 

    --s_input <= x"00000009";
    wait for cCLK_PER;
  end process;
end behavior;