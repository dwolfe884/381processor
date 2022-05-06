library IEEE;
use IEEE.std_logic_1164.all;

entity r_EXMEM is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
  port(i_alu        : in std_logic_vector(N-1  downto 0);
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_WB	    : in std_logic_vector(2 downto 0);
       i_M	    : in std_logic_vector(2 downto 0);
       i_halt	    : in std_logic;
       i_ExMemMUX   : in std_logic_vector(N-1 downto 0);
       i_rdrtMUX    : in std_logic_vector(4 downto 0);
       i_nextpc	    : in std_logic_vector(N-1 downto 0);
       i_Zero	    : in std_logic;
       o_WB	    : out std_logic_vector(2 downto 0);
       o_M	    : out std_logic_vector(2 downto 0);
       o_Zero	    : out std_logic;
       o_alu        : out std_logic_vector(N-1  downto 0);
       o_ExMemMUX   : out std_logic_vector(N-1 downto 0);
       o_rdrtMUX    : out std_logic_vector(4 downto 0);
       o_nextpc	    : out std_logic_vector(N-1 downto 0);
       o_halt	    : out std_logic);
end r_EXMEM;

architecture behavior of r_EXMEM is

  component register_n
    generic(N : integer := 32);
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
         o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;
  component dffg
    port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);
  end component;


begin
  zeroReg: dffg 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => '1',
           i_D   => i_Zero,
           o_Q   => o_Zero);
  muxReg: register_n 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => '1',
           i_D   => i_ExMemMUX,
           o_Q   => o_ExMemMUX);
  rdrtMuxReg: register_n 
  generic map(N => 5)
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => '1',
           i_D   => i_rdrtMUX,
           o_Q   => o_rdrtMUX);
  aluReg: register_n 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => '1',
           i_D   => i_alu,
           o_Q   => o_alu);
  WBReg: register_n
  generic map(N => 3) 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => '1',
           i_D   => i_WB,
           o_Q   => o_WB);
  MEMReg: register_n
  generic map(N => 3) 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => '1',
           i_D   => i_M,
           o_Q   => o_M);
  nextpcReg: register_n 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => '1',
           i_D   => i_nextpc,
           o_Q   => o_nextpc);
  halt_Reg : dffg
  port map(
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_WE    => '1',
      i_D     => i_halt,
      o_Q     => o_halt);
  
end behavior;