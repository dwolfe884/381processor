-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); 

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  --David is adding signals now
  signal s_aluzero, s_Carry	: std_logic; 
  signal s_sign_ext, s_regDst, s_aluSrc, s_memToReg, s_memRead, s_b, s_j	: std_logic;
  signal s_aluControl : std_logic_vector(3 downto 0);
  signal s_aluout, s_newpc, s_tempram    : std_logic_vector(31 downto 0);
  signal s_regout1, s_regout2, s_extended: std_logic_vector(31 downto 0);
  signal s_writeout : std_logic_vector(4 downto 0);
  signal s_andout : std_logic;
  signal s_branchmux_out, s_jumpmux_out : std_logic_vector(31 downto 0);
  signal s_branchshift_out, s_jumpshift_out : std_logic_vector(31 downto 0);
  signal s_branchadder_out, s_finalpc : std_logic_vector(31 downto 0);
  signal s_jr, s_jal, s_vsig : std_logic;
  signal s_tempwrite : std_logic_vector(4 downto 0);
  
  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
component register_n4 is
        port(i_D             : in std_logic_vector(N-1  downto 0);
            i_CLK            : in std_logic;
            i_RST            : in std_logic;
            i_WE     	     : in std_logic;
            o_Q              : out std_logic_vector(N-1  downto 0));
        
    end component;

    component RippleAdder is
        port(i_D0 		            : in std_logic_vector(N-1 downto 0);
            i_D1		            : in std_logic_vector(N-1 downto 0);
            i_Cin 		            : in std_logic;
            o_Sum 		            : out std_logic_vector(N-1 downto 0);
	    o_v				    : out std_logic;
            o_Cout 		            : out std_logic);
    end component;

component cu is
    port(i_op     : in std_logic_vector(5 downto 0);
       i_func   : in std_logic_vector(5 downto 0);
       aluControl   : out std_logic_vector(3 downto 0);
       b        : out std_logic;
       j	: out std_logic;
       jr	: out std_logic;
       jal	: out std_logic;
       memRead  : out std_logic;
       memToReg : out std_logic;
       memWrite : out std_logic;
       aluSrc   : out std_logic;
       regWrite : out std_logic;
       sign_ext	: out std_logic;
       regDst   : out std_logic;
       vsig	: out std_logic;
       halt	: out std_logic);
  end component;

component regFile is
    port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_we	    : in std_logic;
       i_input        : in std_logic_vector(31 downto 0);
       i_write	    : in std_logic_vector(4 downto 0);
       i_read1	    : in std_logic_vector(4 downto 0);
       i_read2	    : in std_logic_vector(4 downto 0);
       o_read1          : out std_logic_vector(N-1  downto 0);
       o_read2          : out std_logic_vector(N-1  downto 0));

  end component;

component alu is
    port(aluop    : in std_logic_vector(3 downto 0);
       ALUSrc	    : in std_logic;
       v_sig	    : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       imm	    : in std_logic_vector(N-1 downto 0);
       i_repl	    : in std_logic_vector(7 downto 0); --repl.qb imm
       shamt	    : in std_logic_vector(4 downto 0);
       o_Sum        : out std_logic_vector(N-1 downto 0);
       aluzero	    : out std_logic;
       o_v	    : out std_logic;
       o_Cout       : out std_logic);

  end component;
component bitext is
    port(i_in	: in std_logic_vector(15 downto 0);
	 i_ext  : in std_logic;
	 o_O	: out std_logic_vector(31 downto 0));
end component;

component mux2t1_N is
    generic(bits : integer := 32);
    port(i_D0 		            : in std_logic_vector(bits-1 downto 0);
       i_D1		            : in std_logic_vector(bits-1 downto 0);
       i_S 		            : in std_logic;
       o_O 		            : out std_logic_vector(bits-1 downto 0));
end component;

component BarrelShifter is
    port(SHL : in std_logic_vector(4 downto 0);
	SHR : in std_logic_vector(4 downto 0);
	SHA : in std_logic_vector(4 downto 0);
	data_in: in std_logic_vector (N-1 downto 0);
	data_out: out std_logic_vector (N-1 downto 0));
end component;
begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 
--JR MUX
with s_jr select s_finalpc <=
	s_jumpmux_out	when '0',
	s_regout1	when '1',
	s_jumpmux_out	when others;
--JR MUX
--FETCH PORTION
  pc_reg: register_n4 
    port map(
        i_D     => s_finalpc,       
        i_CLK   => iCLK,
        i_RST   => iRST,
        i_WE    => '1',
        o_Q     => s_NextInstAddr
    );
  adder: RippleAdder 
    port map(
        i_D0    => s_IMemAddr,	            
        i_D1	=> x"00000004",	           
        i_Cin 	=> '0',       
        o_Sum 	=> s_newpc,
	o_v	=> open,	            
        o_Cout 	=> s_Carry	 
    );
--FETCH PORTION
--CONTROL UNIT
control: cu port map(
		i_op => s_Inst(31 downto 26),
		i_func => s_Inst(5 downto 0),
		aluControl => s_aluControl,
		b => s_b,
		j => s_j,
		jr => s_jr,
		jal => s_jal,
		memRead => s_memRead,
	        memToReg => s_memToReg,
 	        memWrite => s_DMemWr, --
	        aluSrc   => s_aluSrc,
	        regWrite => s_RegWr, --
	        sign_ext => s_sign_ext,
       		regDst   => s_regDst,
		vsig 	 => s_vsig,
		halt 	 => s_Halt
);
--CONTROL UNIT
--REGISTER FILE
Regs: regFile port map(
		i_CLK => iCLK,
		i_RST => iRST,
		i_we => s_RegWr,
		i_input => s_RegWrData,
		i_write => s_RegWrAddr,
		i_read1 => s_Inst(25 downto 21), --rs
		i_read2 => s_Inst(20 downto 16), --rt
		o_read1 => s_regout1, --R[rs]
		o_read2 => s_regout2); --R[rt]

s_DMemData <= s_regout2;
--REGISTER FILE
--RAMMUX FOR JAL
with s_jal select s_tempram <=
	s_aluout	when '0',
	s_newpc		when '1',
	s_aluout	when others;
--RAMMUX FOR JAL
--RAM MUX
rammux: mux2t1_N port map(
		i_D0 => s_tempram,
		i_D1 => s_DMemOut,
		i_S => s_memToReg,
		o_O => s_RegWrData
);
--RAM MUX
--ALU
alu0: alu port map(
		aluop => s_aluControl,
		ALUSrc => s_aluSrc,
		v_sig => s_vsig,
		i_D0 => s_regout1, --R[rs]
		i_D1 => s_regout2, --R[rt]
		imm => s_extended,--s_Inst(15 downto 0),
		i_repl => s_Inst(23 downto 16),
		shamt => s_Inst(10 downto 6),
		o_Sum =>  s_aluout,
		aluzero	=> s_aluzero,
		o_v => s_Ovfl,
		o_Cout => open);

s_DMemAddr <= s_aluout;
oALUOut <= s_aluout;

--ALU
--BitExt
ext: bitext port map(
		i_in => s_Inst(15 downto 0),
		i_ext => s_sign_ext,
		o_O =>  s_extended
);
--BitExt
--MUX FOR JAL
with s_jal select s_tempwrite <=
	s_Inst(20 downto 16)	when '0',
	"11111"	when others;
--MUX FOR JAL
--MUX BEFORE WRITE REG
writeMux: mux2t1_N 
		generic map(bits => 5)
		port map(
		i_D0 => s_tempwrite,
		i_D1 => s_Inst(15 downto 11),
		i_S => s_regDst,
		o_O => s_RegWrAddr
);
--MUX BEFORE WRITE REG
--AND WITH ZERO AND BRANCH
s_andout <= s_b and s_aluzero;
--AND WITH ZERO AND BRANCH
--SHIFT FOR BRANCH
s_branchshift_out <=  s_extended(29 downto 0) & "00";
--SHIFT FOR BRANCH
--ADDER FOR BRANCH
branchAdder: RippleAdder 
    port map(
        i_D0    => s_newpc,	            
        i_D1	=> s_branchshift_out,	           
        i_Cin 	=> '0',
        o_Sum 	=> s_branchadder_out,	            
        o_Cout 	=> s_Carry	 
  );
--ADDER FOR BRANCH
--BRANCH MUX
branchmux: mux2t1_N port map(
		i_D0 => s_newpc,
		i_D1 => s_branchadder_out,
		i_S => s_andout,
		o_O => s_branchmux_out
);
--BRANCH MUX
--JUMP SHIFTER
s_jumpshift_out <= s_newpc(31 downto 28) & (s_Inst(25 downto 0) & "00");
--s_jumpshift_out(31 downto 28) <= s_newpc(31 downto 28) & x"00";
--JUMP SHIFTER
--JUMP MUX
jumpmux: mux2t1_N port map(
	i_D0 => s_branchmux_out,
	i_D1 => s_jumpshift_out,
	i_S => s_j,
	o_O => s_jumpmux_out);
--JUMP MUX
end structure;

