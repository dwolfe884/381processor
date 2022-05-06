-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- andg2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input AND 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity org32 is

  port(i_1          : in std_logic_vector(31 downto 0);
       i_2          : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end org32;

architecture structural of org32 is

component org2
	port(i_A          : in std_logic;
       	     i_B          : in std_logic;
	     o_F          : out std_logic);
end component;

begin
  orer: for i in 0 to 31 generate
     N_or: org2 port map(
	i_A	=> i_1(i),
	i_B	=> i_2(i),
	o_F	=> o_O(i));
  end generate orer;

end structural;