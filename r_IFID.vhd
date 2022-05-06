library IEEE;
use IEEE.std_logic_1164.all;

entity r_IFID is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
  port(i_inst       : in std_logic_vector(N-1  downto 0);
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_nextPC	    : in std_logic_vector(N-1 downto 0);
       i_flush      : in std_logic;
       i_stall	    : in std_logic;
       o_inst       : out std_logic_vector(N-1  downto 0);
       o_nextPC     : out std_logic_vector(N-1  downto 0));
end r_IFID;

architecture behavior of r_IFID is

  signal s_temp_inst : std_logic_vector(N-1 downto 0);
  signal tmp_we : std_logic;
  signal tmp_D : std_logic_vector(N-1 downto 0);
  component register_n
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
         o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;

begin
  tmp_we <= ((i_stall) or not(i_flush));
  tmp_D <= i_inst when (i_flush='1') else x"00000000";
  InstReg: register_n 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_D,
           o_Q   => s_temp_inst);

  o_inst <= s_temp_inst;-- and i_stall;

  PCReg: register_n 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => '1',
           i_D   => i_nextPC,
           o_Q   => o_nextPC);
  
end behavior;