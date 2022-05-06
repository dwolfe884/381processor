library IEEE;
use IEEE.std_logic_1164.all;

entity norg32 is

  port(i_in1          : in std_logic_vector(31 downto 0);
       i_in2          : in std_logic_vector(31 downto 0);
       o_Out          : out std_logic_vector(31 downto 0));

end norg32;

architecture structural of norg32 is

component norg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
end component;

begin
    norer: for i in 0 to 31 generate
     N_nor: norg2 port map(
        i_A	=> i_in1(i),
        i_B	=> i_in2(i),
        o_F	=> o_Out(i));
    end generate norer;
end structural;