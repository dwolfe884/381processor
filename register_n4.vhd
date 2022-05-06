library IEEE;
use IEEE.std_logic_1164.all;

entity register_n4 is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D          : in std_logic_vector(N-1  downto 0);
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_WE	    : in std_logic;
       o_Q          : out std_logic_vector(N-1  downto 0));

end register_n4;

architecture structural of register_n4 is

  component dffg is
    port(i_CLK      : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

  end component;
  component notdffg is
    port(i_CLK      : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

  end component;
  
begin

  -- Instantiate N mux instances.

G_NBit_REG1: for i in 0 to N-11 generate
    dffi: dffg port map(
	      i_CLK    => i_CLK,
	      i_RST    => i_RST,
              i_WE     => i_WE,
              i_D      => i_D(i),      -- All instances share the same select input.
              o_Q      => o_Q(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_REG1;
      dffone: notdffg port map(
	      i_CLK    => i_CLK,
	      i_RST    => i_RST,
              i_WE     => i_WE,
              i_D      => i_D(22),      -- All instances share the same select input.
              o_Q      => o_Q(22));
G_NBit_REG2: for i in N-9 to N-1 generate
    dffi: dffg port map(
	      i_CLK    => i_CLK,
	      i_RST    => i_RST,
              i_WE     => i_WE,
              i_D      => i_D(i),      -- All instances share the same select input.
              o_Q      => o_Q(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_REG2;
end structural;