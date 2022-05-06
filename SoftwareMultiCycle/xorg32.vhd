library IEEE;
use IEEE.std_logic_1164.all;

entity xorg32 is

  port(i_1          : in std_logic_vector(31 downto 0);
       i_2          : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end xorg32;

architecture structural of xorg32 is

component xorg2
	port(i_A          : in std_logic;
       i_B          : in std_logic;
	     o_F          : out std_logic);
end component;

begin
  xorer: for i in 0 to 31 generate
     N_xor: xorg2 port map(
        i_A	=> i_1(i),
        i_B	=> i_2(i),
        o_F	=> o_O(i));
  end generate xorer;

end structural;