library IEEE;
use IEEE.std_logic_1164.all;

entity r_MEMWB is
  generic(Ns : integer := 32);
  port(i_dmem       : in std_logic_vector(Ns-1  downto 0);
       i_aluout	    : in std_logic_vector(Ns-1 downto 0);
       i_nextpc     : in std_logic_vector(Ns-1 downto 0);
       i_rdrtmux    : in std_logic_vector(4 downto 0);
       i_flush	    : in std_logic;
       i_stall      : in std_logic;
       i_halt	    : in std_logic;
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_rd	    : in std_logic_vector(4 downto 0);
       i_WB	    : in std_logic_vector(3 downto 0);
       i_jrmuxout   : in std_logic_vector(Ns-1  downto 0);
       i_memreadwrite : in std_logic;
       o_dmem       : out std_logic_vector(Ns-1  downto 0);
       o_aluout	    : out std_logic_vector(Ns-1 downto 0);
       o_nextpc     : out std_logic_vector(Ns-1 downto 0);
       o_rdrtmux    : out std_logic_vector(4 downto 0);
       o_WB	    : out std_logic_vector(3 downto 0);
       o_rd	    : out std_logic_vector(4 downto 0);
       o_jrmuxout   : out std_logic_vector(Ns-1  downto 0);
       o_memreadwrite : out std_logic;
       o_halt	    : out std_logic);
end r_MEMWB;

architecture behavior of r_MEMWB is

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
         o_Q          : out std_logic);   -- Data value output
  end component;

  signal tmp_we, tmp_halt_Reg, tmp_memreadwrite_Reg : std_logic;
  signal tmp_ALUreg, tmp_DMem, tmp_nextPCReg, tmp_jrmux_reg : std_logic_vector(31 downto 0);
  signal tmp_RDRTreg, tmp_reReg : std_logic_vector(4 downto 0);
  signal tmp_WBreg : std_logic_vector(3 downto 0);


begin
  tmp_we <= ((i_stall) or not(i_flush));
  tmp_RDRTreg <= i_rdrtmux when (i_flush='1') else "00000";
  tmp_ALUreg <= i_aluout when (i_flush='1') else x"00000000";
  tmp_DMem <= i_dmem when (i_flush='1') else x"00000000";
  tmp_reReg <= i_rd when (i_flush='1') else "00000";
  tmp_nextPCReg <= i_nextpc when (i_flush='1') else x"00000000";
  tmp_WBreg <= i_WB when (i_flush='1') else "0000";
  tmp_jrmux_reg <= i_jrmuxout when (i_flush='1') else x"00000000";
  tmp_halt_Reg <= i_halt when (i_flush='1') else '0';
  tmp_memreadwrite_Reg <= i_memreadwrite when (i_flush='1') else '0';


  RDRTreg: register_n--
  generic map(N => 5) 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_RDRTreg,
           o_Q   => o_rdrtmux);
  ALUreg: register_n--
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_ALUreg,
           o_Q   => o_aluout);
  DMem: register_n--
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_DMem,
           o_Q   => o_dmem);
  rdReg: register_n--
  generic map(N => 5)
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_reReg,
           o_Q   => o_rd);
  nextPCReg: register_n--
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => tmp_we,
           i_D   => tmp_nextPCReg,
           o_Q   => o_nextpc);
  WBreg: register_n--
  generic map(N => 4)
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => tmp_we,
           i_D   => tmp_WBreg,
           o_Q   => o_WB);
  jrmux_reg: register_n--
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => tmp_we,
           i_D   => tmp_jrmux_reg,
           o_Q   => o_jrmuxout);
  halt_Reg : dffg--
  port map(
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_WE    => tmp_we,
      i_D     => tmp_halt_Reg,
      o_Q     => o_halt);
  memreadwrite_Reg : dffg--
  port map(
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_WE    => tmp_we,
      i_D     => tmp_memreadwrite_Reg,
      o_Q     => o_memreadwrite);  

end behavior;