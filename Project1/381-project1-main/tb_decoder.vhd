library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
end tb_decoder;

architecture behavior of tb_decoder is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component decoder
    port(i_in           : in std_logic_vector(4 downto 0);     
         o_out          : out std_logic_vector(31 downto 0));

  end component;

  -- Temporary signals to connect to the dff component.
  signal s_in : std_logic_vector(4 downto 0):= "00000"; 
  signal s_out : std_logic_vector(31 downto 0);

begin

  DUT: decoder 
  port map(i_in   => s_in,
           o_out   => s_out);

  -- Testbench process  
  P_TB: process
  begin
    -- Reset the FF
    s_in   <= "00000";
    wait for cCLK_PER;
    s_in   <= "00001";
    wait for cCLK_PER;
    s_in   <= "00010";
    wait for cCLK_PER;
    s_in   <= "00011";
    wait for cCLK_PER;
    s_in   <= "00100";
    wait for cCLK_PER;
    s_in   <= "00101";
    wait for cCLK_PER;
    s_in   <= "00110";
    wait for cCLK_PER;
    s_in   <= "00111";
    wait for cCLK_PER;
    s_in   <= "01000";
    wait for cCLK_PER;
    s_in   <= "01001";
    wait for cCLK_PER;
    s_in   <= "01011";
    wait for cCLK_PER;
    s_in   <= "01100";
    wait for cCLK_PER;
    s_in   <= "01101";
    wait for cCLK_PER;
    s_in   <= "01110";
    wait for cCLK_PER;
    s_in   <= "01111";
    wait for cCLK_PER;
  end process;
  
end behavior;