library IEEE;
use IEEE.std_logic_1164.all;

entity tb_cu is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
end tb_cu;

architecture behavior of tb_cu is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component cu
    port(i_op     	: in std_logic_vector(5 downto 0);
       i_func   	: in std_logic_vector(5 downto 0);
       aluControl  	: out std_logic_vector(3 downto 0);
       b       		: out std_logic;
       j		: out std_logic;
       jr		: out std_logic;
       jal		: out std_logic;
       memRead  	: out std_logic;
       memToReg 	: out std_logic;
       memWrite 	: out std_logic;
       aluSrc   	: out std_logic;
       regWrite 	: out std_logic;
       sign_ext		: out std_logic;
       regDst   	: out std_logic;
       halt		: out std_logic); 
   end component;


  signal s_CLK 		: std_logic;
  signal s_op, s_func 	: std_logic_vector(5 downto 0);
  signal s_alucontrol 	: std_logic_vector(3 downto 0);
  signal s_b 		: std_logic;
  signal s_j 		: std_logic;
  signal s_jr		: std_logic;
  signal s_jal 		: std_logic;
  signal s_memRead 	: std_logic;
  signal s_memToReg	: std_logic;
  signal s_memWrite 	: std_logic;
  signal s_aluSrc 	: std_logic;
  signal s_regWrite 	: std_logic;
  signal s_sign_ext 	: std_logic;
  signal s_regDst 	: std_logic;
  signal s_halt 	: std_logic;

begin

  CUtestbench: cu 
  port map(
	i_op   		=> s_op,
       i_func   	=> s_func,
       aluControl 	=> s_aluControl,
       b      		=> s_b,
       j		=> s_j,
       jr		=> s_jr,
       jal		=> s_jal,
       memRead  	=> s_memRead,
       memToReg 	=> s_memToReg,
       memWrite 	=> s_memWrite,
       aluSrc   	=> s_aluSrc,
       regWrite 	=> s_regWrite,
       sign_ext		=> s_sign_ext,
       regDst   	=> s_regDst,
       halt		=> s_halt);

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
	--R-type instructions
	--add
	s_op <="000000";
	s_func <="100000";
	wait for cCLK_PER;

	--addu
	s_op <="000000";
	s_func <="100001";
	wait for cCLK_PER;
  
	--sub
	s_op <="000000";
	s_func <="100010";
	wait for cCLK_PER;  

	--subu
	s_op <="000000";
	s_func <="100011";
	wait for cCLK_PER;

	--and
	s_op <="000000";
	s_func <="100100";
	wait for cCLK_PER;

	--or
	s_op <="000000";
	s_func <="100101";
	wait for cCLK_PER;

	--xor
	s_op <="000000";
	s_func <="100110";
	wait for cCLK_PER;

	--nor
	s_op <="000000";
	s_func <="100111";
	wait for cCLK_PER;

	--sll
	s_op <="000000";
	s_func <="000000";
	wait for cCLK_PER;

	--srl
	s_op <="000000";
	s_func <="000010";
	wait for cCLK_PER;

	--sra
	s_op <="000000";
	s_func <="000011";
	wait for cCLK_PER;

	--slt
	s_op <="000000";
	s_func <="101010";
	wait for cCLK_PER;

	--jr
	s_op <="000000";
	s_func <="001000";
	wait for cCLK_PER;
   
	--I and J type instructions
	--addi
	s_op <="001000";
	s_func <="000000";
	wait for cCLK_PER;

	--addiu
	s_op <="001001";
	s_func <="000000";
	wait for cCLK_PER;

	--halt
	s_op <="010100";
	s_func <="000000";
	wait for cCLK_PER;

	--lw
	s_op <="100011";
	s_func <="000000";
	wait for cCLK_PER;

	--sw
	s_op <="101011";
	s_func <="000000";
	wait for cCLK_PER;

	--lui
	s_op <="001111";
	s_func <="000000";
	wait for cCLK_PER;

	--andi
	s_op <="001100";
	s_func <="000000";
	wait for cCLK_PER;

	--ori
	s_op <="001101";
	s_func <="000000";
	wait for cCLK_PER;

	--xori
	s_op <="001110";
	s_func <="000000";
	wait for cCLK_PER;

	--slti
	s_op <="001010";
	s_func <="000000";
	wait for cCLK_PER;

	--beq
	s_op <="000100";
	s_func <="000000";
	wait for cCLK_PER;

	--bne
	s_op <="000101";
	s_func <="000000";
	wait for cCLK_PER;

	--j
	s_op <="000010";
	s_func <="000000";
	wait for cCLK_PER;

	--jal
	s_op <="000011";
	s_func <="000000";
	wait for cCLK_PER;

	--repl.qb
	s_op <="011111";
	s_func <="000000";
	wait for cCLK_PER;
 
    wait;
  end process;
  
end behavior;