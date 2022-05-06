library IEEE;
use IEEE.std_logic_1164.all;

entity tb_datapath2 is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
end tb_datapath2;

architecture behavior of tb_datapath2 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component datapath2
    port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       ALUSrc	    : in std_logic;
       add_sub	    : in std_logic;
       i_memwrite   : in std_logic;
       i_mem2reg    : in std_logic;
       i_regDst	    : in std_logic;
       i_imm        : in std_logic_vector(15 downto 0);
       i_RT	    : in std_logic_vector(4 downto 0);
       i_RS	    : in std_logic_vector(4 downto 0);
       i_RD	    : in std_logic_vector(4 downto 0);
       test_out1    : out std_logic_vector(31 downto 0);
       test_out2    : out std_logic_vector(31 downto 0);
       alu_out      : out std_logic_vector(31 downto 0);
       o_Cout		: out std_logic);

  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_ALUSrc, s_add_sub: std_logic;
  signal s_memwrite, s_mem2reg : std_logic := '0';
  signal s_imm : std_logic_vector(15 downto 0):= x"0000"; 
  signal s_RT, s_RS,s_RD : std_logic_vector(4 downto 0) := "00000";
  signal s_Cout : std_logic;
  signal s_out1, s_out2, s_alu_out : std_logic_vector(31 downto 0);
  signal s_regDst : std_logic;
begin

  DUT: datapath2
  port map(i_CLK => s_CLK, 
           i_RST => s_RST,
	   ALUSrc => s_ALUSrc,
	   add_sub => s_add_sub,
	   i_memwrite => s_memwrite,
	   i_mem2reg => s_mem2reg,
	   i_regDst  => s_regDst,
           i_imm  => s_imm,
	   i_RT  => s_RS,
           i_RS   => s_RT,
           i_RD   => s_RD,
           test_out1 => s_out1,
           test_out2 => s_out2,
           alu_out  => s_alu_out,
           o_Cout   => s_Cout);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- Reset the reg file
    s_regDst <= '1';
    s_RST <= '1';
    s_imm <= x"0000";
    wait for cCLK_PER;
    -- addi $25, $0, 0
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_RT <= "11001"; --register or imm
    s_RD <= "11001"; --dest register
    s_RS <= "00000"; --2nd reg
    s_imm <= x"0000"; --imm
    wait for cCLK_PER; 
    -- addi $26, $0, 256
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_RT <= "11010"; --register or imm
    s_RD <= "11010"; --dest register
    s_RS <= "00000"; --2nd reg
    s_imm <= x"0100"; --imm
    wait for cCLK_PER; 
    -- lw $1, 0($25)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '1';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00001"; --dest register, unused for sw
    s_RS <= "11001"; --2nd reg, used for memory addr
    s_imm <= x"0000"; --imm
    wait for cCLK_PER;
    -- lw $1, 4($25)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '1';
    s_RT <= "00010"; --register or imm, used for memory data_in
    s_RD <= "00010"; --dest register, unused for sw
    s_RS <= "11001"; --2nd reg, used for memory addr
    s_imm <= x"0001"; --imm
    wait for cCLK_PER; 
    -- add $1, $1, $2
    s_RST <= '0';
    s_ALUSrc <= '0';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00001"; --dest register, unused for sw
    s_RS <= "00010"; --2nd reg, used for memory addr
    s_imm <= x"0000"; --imm
    wait for cCLK_PER; 
    -- sw $1, 0($26)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '1';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00000"; --dest register, unused for sw
    s_RS <= "11010"; --2nd reg, used for memory addr
    s_imm <= x"0000"; --imm
    wait for cCLK_PER; 
    -- lw $2, 8($25)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '1';
    s_RT <= "00010"; --register or imm, used for memory data_in
    s_RD <= "00010"; --dest register, unused for sw
    s_RS <= "11001"; --2nd reg, used for memory addr
    s_imm <= x"0002"; --imm
    wait for cCLK_PER; 
    -- add $1, $1, $2
    s_RST <= '0';
    s_ALUSrc <= '0';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00001"; --dest register, unused for sw
    s_RS <= "00010"; --2nd reg, used for memory addr
    s_imm <= x"0000"; --imm
    wait for cCLK_PER;
    -- sw $1, 4($26)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '1';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00000"; --dest register, unused for sw
    s_RS <= "11010"; --2nd reg, used for memory addr
    s_imm <= x"0001"; --imm
    wait for cCLK_PER; 
    -- lw $2, 12($25)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '1';
    s_RT <= "00010"; --register or imm, used for memory data_in
    s_RD <= "00010"; --dest register, unused for sw
    s_RS <= "11001"; --2nd reg, used for memory addr
    s_imm <= x"0003"; --imm
    wait for cCLK_PER; 
    -- add $1, $1, $2
    s_RST <= '0';
    s_ALUSrc <= '0';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00001"; --dest register, unused for sw
    s_RS <= "00010"; --2nd reg, used for memory addr
    s_imm <= x"0000"; --imm
    wait for cCLK_PER;
    -- sw $1, 8($26)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '1';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00000"; --dest register, unused for sw
    s_RS <= "11010"; --2nd reg, used for memory addr
    s_imm <= x"0002"; --imm
    wait for cCLK_PER; 
    -- lw $2, 16($25)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '1';
    s_RT <= "00010"; --register or imm, used for memory data_in
    s_RD <= "00010"; --dest register, unused for sw
    s_RS <= "11001"; --2nd reg, used for memory addr
    s_imm <= x"0004"; --imm
    wait for cCLK_PER; 
    -- add $1, $1, $2
    s_RST <= '0';
    s_ALUSrc <= '0';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00001"; --dest register, unused for sw
    s_RS <= "00010"; --2nd reg, used for memory addr
    s_imm <= x"0000"; --imm
    wait for cCLK_PER;
    -- sw $1, 12($26)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '1';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00000"; --dest register, unused for sw
    s_RS <= "11010"; --2nd reg, used for memory addr
    s_imm <= x"0003"; --imm
    wait for cCLK_PER; 
    -- lw $2, 20($25)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '1';
    s_RT <= "00010"; --register or imm, used for memory data_in
    s_RD <= "00010"; --dest register, unused for sw
    s_RS <= "11001"; --2nd reg, used for memory addr
    s_imm <= x"0005"; --imm
    wait for cCLK_PER; 
    -- add $1, $1, $2
    s_RST <= '0';
    s_ALUSrc <= '0';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00001"; --dest register, unused for sw
    s_RS <= "00010"; --2nd reg, used for memory addr
    s_imm <= x"0000"; --imm
    wait for cCLK_PER;
    -- sw $1, 16($26)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '1';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00000"; --dest register, unused for sw
    s_RS <= "11010"; --2nd reg, used for memory addr
    s_imm <= x"0004"; --imm
    wait for cCLK_PER; 
    -- lw $2, 24($25)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '1';
    s_RT <= "00010"; --register or imm, used for memory data_in
    s_RD <= "00010"; --dest register, unused for sw
    s_RS <= "11001"; --2nd reg, used for memory addr
    s_imm <= x"0006"; --imm
    wait for cCLK_PER; 
    -- add $1, $1, $2
    s_RST <= '0';
    s_ALUSrc <= '0';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00001"; --dest register, unused for sw
    s_RS <= "00010"; --2nd reg, used for memory addr
    s_imm <= x"0000"; --imm
    wait for cCLK_PER;
    -- addi $27, $0, 512
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '0';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "11011"; --dest register, unused for sw
    s_RS <= "00000"; --2nd reg, used for memory addr
    s_imm <= x"0200"; --imm
    wait for cCLK_PER;   
    -- sw $1, -4($27)
    s_RST <= '0';
    s_ALUSrc <= '1';
    s_add_sub <= '0';
    s_memwrite <= '1';
    s_mem2reg <= '0';
    s_RT <= "00001"; --register or imm, used for memory data_in
    s_RD <= "00000"; --dest register, unused for sw
    s_RS <= "11011"; --2nd reg, used for memory addr
    s_imm <= x"FFFF"; --imm 
    wait;
  end process;
  
end behavior;