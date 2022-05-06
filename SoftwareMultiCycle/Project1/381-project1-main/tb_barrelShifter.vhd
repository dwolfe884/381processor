library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrelShifter is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
end tb_barrelShifter;

architecture behavior of tb_barrelShifter is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component BarrelShifter
    port(SHL : in std_logic_vector(4 downto 0);
	SHR : in std_logic_vector(4 downto 0);
	SHA : in std_logic_vector(4 downto 0);
	data_in: in std_logic_vector (N-1 downto 0);
	data_out: out std_logic_vector (N-1 downto 0));
  end component;


  signal s_CLK : std_logic;
  signal s_SHL, s_SHR, s_SHA : std_logic_vector(4 downto 0);
  signal s_data_in, s_data_out : std_logic_vector(N-1 downto 0);
  

begin

  DUT0: BarrelShifter 
  port map(
	SHL => s_SHL,
	SHR => s_SHR,
	SHA => s_SHA,
	data_in => s_data_in,
	data_out => s_data_out);

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
    
    --Shift the data_in 4 to the left
    s_data_in <= x"12345678";
    s_SHL <= "00100";
    s_SHR <= "00000";
    s_SHA <= "00000";
    wait for cCLK_PER;

--Shift the data_in 4 to the left
    s_data_in <= x"00000003";
    s_SHL <= "00000";
    s_SHR <= "00000";
    s_SHA <= "00000";
    wait for cCLK_PER;
    s_data_in <= x"00000003";
    s_SHL <= "00010";
    s_SHR <= "00000";
    s_SHA <= "00000";
    wait for cCLK_PER;
    s_data_in <= x"00000003";
    s_SHL <= "01000";
    s_SHR <= "00000";
    s_SHA <= "00000";
    wait for cCLK_PER;
    s_data_in <= x"00000003";
    s_SHL <= "10000";
    s_SHR <= "00000";
    s_SHA <= "00000";
    wait for cCLK_PER;

    --Shift the data_in 31 to the left
    s_data_in <= x"F1111111";
    s_SHL <= "11111";
    s_SHR <= "00000";
    s_SHA <= "00000";
    wait for cCLK_PER;

    --Shift the data_in 4 to the right
    s_data_in <= x"30000000";
    s_SHL <= "00000";
    s_SHR <= "00100";
    s_SHA <= "00000";
    wait for cCLK_PER;

    --Shift the data_in 31 to the right
    s_data_in <= x"FFFFFFFF";
    s_SHL <= "00000";
    s_SHR <= "11111";
    s_SHA <= "00000";
    wait for cCLK_PER;

    --Shift Arithmetic the data_in 12 to the right
    s_data_in <= x"EFFFFFFF";
    s_SHL <= "00000";
    s_SHR <= "00000";
    s_SHA <= "00100";
    wait for cCLK_PER;

    --Shift Arithmetic the data_in 31 to the right
    s_data_in <= x"F0000000";
    s_SHL <= "00000";
    s_SHR <= "00000";
    s_SHA <= "11111";
    wait for cCLK_PER;

--Shift Arithmetic the data_in 31 to the right
    s_data_in <= x"80000000";
    s_SHL <= "00000";
    s_SHR <= "00000";
    s_SHA <= "00001";
    wait for cCLK_PER;
--Shift Arithmetic the data_in 31 to the right
    s_data_in <= x"80000000";
    s_SHL <= "00000";
    s_SHR <= "00000";
    s_SHA <= "00010";
    wait for cCLK_PER;
--Shift Arithmetic the data_in 31 to the right
    s_data_in <= x"80000000";
    s_SHL <= "00000";
    s_SHR <= "00000";
    s_SHA <= "00100";
    wait for cCLK_PER;
--Shift Arithmetic the data_in 31 to the right
    s_data_in <= x"80000000";
    s_SHL <= "00000";
    s_SHR <= "00000";
    s_SHA <= "01000";
    wait for cCLK_PER;
--Shift Arithmetic the data_in 31 to the right
    s_data_in <= x"0FFFFFFF";
    s_SHL <= "00000";
    s_SHR <= "00000";
    s_SHA <= "10000";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
