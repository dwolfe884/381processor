library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bitext is

  port(i_in          : in std_logic_vector(15 downto 0); 
       i_ext	     : in std_logic;
       o_O           : out std_logic_vector(31 downto 0));
       
end bitext;

architecture dataflow of bitext is

begin
	o_O <= std_logic_vector(resize(signed(i_in),o_O'length)) when i_ext='1' else
		std_logic_vector(resize(unsigned(i_in),o_O'length));
end dataflow;