library IEEE;
use IEEE.std_logic_1164.all;

entity r_EXMEM is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
  port(i_alu        : in std_logic_vector(N-1  downto 0);
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_flush        : in std_logic;
       i_stall        : in std_logic;
       i_WB	    : in std_logic_vector(3 downto 0);
       i_M	    : in std_logic_vector(2 downto 0);
       i_halt	    : in std_logic;
       i_ExMemMUX   : in std_logic_vector(N-1 downto 0);
       i_rdrtMUX    : in std_logic_vector(4 downto 0);
       i_nextpc	    : in std_logic_vector(N-1 downto 0);
       i_jrmuxout	    : in std_logic_vector(N-1 downto 0);
       i_memreadwrite : in std_logic;
       i_Zero	    : in std_logic;
       i_rd	    : in std_logic_vector(4 downto 0);
       o_WB	    : out std_logic_vector(3 downto 0);
       o_M	    : out std_logic_vector(2 downto 0);
       o_Zero	    : out std_logic;
       o_alu        : out std_logic_vector(N-1  downto 0);
       o_ExMemMUX   : out std_logic_vector(N-1 downto 0);
       o_rdrtMUX    : out std_logic_vector(4 downto 0);
       o_nextpc	    : out std_logic_vector(N-1 downto 0);
       o_rd	    : out std_logic_vector(4 downto 0);
       o_jrmuxout   : out std_logic_vector(N-1 downto 0);
       o_memreadwrite : out std_logic;
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

  signal tmp_we, tmp_zeroReg, tmp_halt_Reg, tmp_memreadwrite_Reg : std_logic;
  signal tmp_muxReg, tmp_aluReg, tmp_nextpcReg, tmp_jrmux_Reg : std_logic_vector(31 downto 0);
  signal tmp_rdrtMuxReg, tmp_rdReg : std_logic_vector(4 downto 0);
  signal tmp_WBReg : std_logic_vector(3 downto 0);
  signal tmp_MEMReg : std_logic_vector(2 downto 0);

begin
  tmp_we <= ((i_stall) or not(i_flush));--
  tmp_zeroReg <= i_Zero when (i_flush='1') else '0';--
  tmp_muxReg <= i_ExMemMUX when (i_flush='1') else x"00000000";--
  tmp_rdrtMuxReg <= i_rdrtMUX when (i_flush='1') else "00000";--
  tmp_rdReg <= i_rd when (i_flush='1') else "00000";--
  tmp_aluReg <= i_alu when (i_flush='1') else x"00000000";--
  tmp_WBReg <= i_WB when (i_flush='1') else "0000";
  tmp_MEMReg <= i_M when (i_flush='1') else "000";
  tmp_nextpcReg <= i_nextpc when (i_flush='1') else x"00000000";--
  tmp_jrmux_Reg <= i_jrmuxout when (i_flush='1') else x"00000000";--
  tmp_halt_Reg <= i_halt when (i_flush='1') else '0';--
  tmp_memreadwrite_Reg <= i_memreadwrite when (i_flush='1') else '0';--

  zeroReg: dffg--
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_zeroReg,
           o_Q   => o_Zero);
  muxReg: register_n--
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_muxReg,
           o_Q   => o_ExMemMUX);
  rdrtMuxReg: register_n--
  generic map(N => 5)
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_rdrtMuxReg,
           o_Q   => o_rdrtMUX);
  rdReg: register_n--
  generic map(N => 5)
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_rdReg,
           o_Q   => o_rd);
  aluReg: register_n--
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
           i_WE  => tmp_we,
           i_D   => tmp_aluReg,
           o_Q   => o_alu);
  WBReg: register_n--
  generic map(N => 4) 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => tmp_we,
           i_D   => tmp_WBReg,
           o_Q   => o_WB);
  MEMReg: register_n--
  generic map(N => 3) 
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => tmp_we,
           i_D   => tmp_MEMReg,
           o_Q   => o_M);
  nextpcReg: register_n--
  port map(i_CLK => i_CLK, 
           i_RST => i_RST,
	   i_WE  => tmp_we,
           i_D   => tmp_nextpcReg,
           o_Q   => o_nextpc);
  jrmux_Reg : register_n--
  port map(
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_WE    => tmp_we,
      i_D     => tmp_jrmux_Reg,
      o_Q     => o_jrmuxout);
  halt_Reg : dffg--
  port map(
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_WE    => tmp_we,
      i_D     => tmp_halt_Reg,
      o_Q     => o_halt);
  memreadwrite_Reg : dffg
  port map(
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_WE    => tmp_we,
      i_D     => tmp_memreadwrite_Reg,
      o_Q     => o_memreadwrite);  
  
end behavior;
