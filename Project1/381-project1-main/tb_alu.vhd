library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
end tb_alu;

architecture behavior of tb_alu is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component alu
    port(aluop    : in std_logic_vector(3 downto 0);
       ALUSrc	    : in std_logic;
       v_sig	    : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0); --R[rs]
       i_D1         : in std_logic_vector(N-1 downto 0); --R[rt]
       i_repl	    : in std_logic_vector(7 downto 0); --repl.qb imm
       imm	    : in std_logic_vector(N-1 downto 0);
       shamt	    : in std_logic_vector(4 downto 0);
       o_Sum        : out std_logic_vector(N-1 downto 0);
       aluzero	    : out std_logic;
       o_v	    : out std_logic;
       o_Cout       : out std_logic);
   end component;

  signal s_CLK : std_logic;
  signal s_aluop 	: std_logic_vector(3 downto 0);
  signal s_alusrc	: std_logic;
  signal s_v_sig 	: std_logic;
  signal s_D0 		: std_logic_vector(N-1 downto 0); --R[rs]
  signal s_D1 		: std_logic_vector(N-1 downto 0); --R[rt]
  signal s_repl	    	: std_logic_vector(7 downto 0); --repl.qb imm
  signal s_imm	    	: std_logic_vector(N-1 downto 0);
  signal s_shamt	: std_logic_vector(4 downto 0);
  signal s_o_Sum        : std_logic_vector(N-1 downto 0);
  signal s_aluzero	: std_logic;
  signal s_o_v	   	: std_logic;
  signal s_o_Cout       : std_logic;

begin

  aluUnit: alu 
  port map(
       aluop		=> s_aluop,
       ALUSrc	   	=> s_alusrc,
       v_sig	  	=> s_v_sig,
       i_D0       	=> s_D0,
       i_D1        	=> s_D1,
       i_repl	   	=> s_repl,
       imm	   	=> s_imm,
       shamt	  	=> s_shamt,
       o_Sum  		=> s_o_sum,
       aluzero 		=> s_aluzero,
       o_v		=> s_o_v,
       o_Cout		=> s_o_Cout);

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
  --reset
	s_aluop		<= "0000";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '0';
       s_D0       	<= x"00000000";
       s_D1        	<= x"00000000";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER;
  --add
	s_aluop		<= "0000";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000001"; --output 2
       s_D1        	<= x"00000001";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER;
  --and
	s_aluop		<= "0001";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000011";
       s_D1        	<= x"00000010";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER;      
  --nor
	s_aluop		<= "1100";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000011";
       s_D1        	<= x"00000010";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER;   
 --xor
	s_aluop		<= "1001";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000011";
       s_D1        	<= x"00000000";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER; 
 --xori
	s_aluop		<= "1001";
       s_ALUSrc	   	<= '1';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000011";
       s_D1        	<= x"00000010";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000001";
       s_shamt	 	<= "00000";
	wait for cCLK_PER; 
 --or
	s_aluop		<= "1011";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000011";
       s_D1        	<= x"00000010";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER;
 --sll
	s_aluop		<= "1110";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000011";
       s_D1        	<= x"00000010";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER;  
 --sub
	s_aluop		<= "1000";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000011";
       s_D1        	<= x"00000010";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER; 
 --repl
	s_aluop		<= "0100";
       s_ALUSrc	   	<= '0';
       s_v_sig	  	<= '1';
       s_D0       	<= x"00000011";
       s_D1        	<= x"00000010";
       s_repl	   	<= x"00";
       s_imm	   	<= x"00000000";
       s_shamt	 	<= "00000";
	wait for cCLK_PER; 
    wait;
  end process;
  
end behavior;