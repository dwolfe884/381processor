library IEEE;
use IEEE.std_logic_1164.all;

entity norg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end norg2;

architecture dataflow of norg2 is
begin

  o_F <= i_A nor i_B;
  
end dataflow;