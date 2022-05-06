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
  signal s_branchadder_out, s_finalpc, s_jrmux_out : std_logic_vector(31 downto 0);
  signal s_jr, s_jal, s_vsig : std_logic;
  signal s_tempwrite, s_temp_RegWrAddr, s_WriteMuxOut : std_logic_vector(4 downto 0);
  --Multicycle signals
  signal s_ifidinst, s_ifidnextpc : std_logic_vector(31 downto 0);
  signal s_memwbnextpc, s_exmemnextpc, s_idexnextpc : std_logic_vector(31 downto 0);
  signal s_exmemforward : std_logic_vector(31 downto 0);
  signal s_memwbdmem, s_memwbforward : std_logic_vector(31 downto 0);
  signal s_exmemwb : std_logic_vector(2 downto 0) := "000";
  signal s_rtrdMUX : std_logic_vector(31 downto 0);
  signal s_idexwb, s_memwbwb : std_logic_vector(2 downto 0);
  signal s_idexmem, s_exmemmem : std_logic_vector(2 downto 0);
  signal s_idexex : std_logic_vector(5 downto 0) := "000000";
  signal s_idexreg1, s_idexreg2, s_idexinst : std_logic_vector(31 downto 0);
  signal s_idexrs, s_idexrt, s_idexrd, s_exmemrdrtmux : std_logic_vector(4 downto 0);
  signal s_exmemmux : std_logic_vector(31 downto 0);
  signal s_exmemzero, s_regequal, s_temp_DMemWr, s_temp_RegWr : std_logic;
  signal s_exmemaluout, s_memwbaluout, s_idexsignext, s_exmembranchaddr : std_logic_vector(31 downto 0);
  signal s_temp_Halt, s_idexhalt, s_exmemhalt : std_logic := '0';
  --Multicycle signals
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
-- ADDING COMPONENTS FOR MULTICYCLE
component r_IFID is
  port(i_inst       : in std_logic_vector(N-1  downto 0);
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_nextPC	    : in std_logic_vector(N-1 downto 0);
       o_inst       : out std_logic_vector(N-1  downto 0);
       o_nextPC     : out std_logic_vector(N-1  downto 0));
end component;
component r_MEMWB is
  port(i_dmem       : in std_logic_vector(N-1  downto 0);
       i_forward    : in std_logic_vector(N-1 downto 0);
       i_aluout	    : in std_logic_vector(N-1 downto 0);
       i_nextpc     : in std_logic_vector(N-1 downto 0);
       i_rdrtmux    : in std_logic_vector(4 downto 0);
       i_halt	    : in std_logic;
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_WB	    : in std_logic_vector(2 downto 0);
       o_dmem       : out std_logic_vector(N-1  downto 0);
       o_forward    : out std_logic_vector(N-1  downto 0);
       o_aluout	    : out std_logic_vector(N-1 downto 0);
       o_nextpc     : out std_logic_vector(N-1 downto 0);
       o_rdrtmux    : out std_logic_vector(4 downto 0);
       o_WB	    : out std_logic_vector(2 downto 0);
       o_halt	    : out std_logic);
end component;
component r_EXMEM is
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
end component;
component r_IDEX is
  port(
        i_WB		: in std_logic_vector(2 downto 0);
        i_MEM		: in std_logic_vector(2 downto 0);
        i_EX	        : in std_logic_vector(5 downto 0);
        i_halt		: in std_logic;
        i_reg1out    	: in std_logic_vector(N-1  downto 0);
        i_reg2out    	: in std_logic_vector(N-1  downto 0);
	i_nextpc	: in std_logic_vector(N-1 downto 0);
        i_inst       	: in std_logic_vector(N-1  downto 0);
        i_signExt    	: in std_logic_vector(N-1  downto 0);
	i_regwriteaddr  : in std_logic_vector(5-1 downto 0);
        i_CLK        	: in std_logic;
        i_RST        	: in std_logic;

        o_WBSig      	: out std_logic_vector(2 downto 0);
        o_MEMSig     	: out std_logic_vector(2 downto 0);
        o_EX	     	: out std_logic_vector(5 downto 0);
	o_reg1out    	: out std_logic_vector(N-1 downto 0);
	o_reg2out    	: out std_logic_vector(N-1 downto 0);
        o_RegRs      	: out std_logic_vector(5-1  downto 0);
	o_nextpc	: out std_logic_vector(N-1 downto 0);
        o_RegRt     	: out std_logic_vector(5-1  downto 0);
        o_signExt       : out std_logic_vector(N-1 downto 0);
        o_RegRd      	: out std_logic_vector(5-1  downto 0);
	o_regwriteaddr  : out std_logic_vector(5-1 downto 0);
	o_inst       	: out std_logic_vector(N-1  downto 0);
        o_halt		: out std_logic);
end component;
-- ADDING COMPONENTS FOR MULTICYCLE
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
             addr => s_DMemAddr(11 downto 2), --s_exmemaluout,
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 
--JR MUX
with s_jr select s_jrmux_out <=
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
		i_op => s_ifidinst(31 downto 26),
		i_func => s_ifidinst(5 downto 0),
		aluControl => s_aluControl,
		b => s_b,
		j => s_j,
		jr => s_jr,
		jal => s_jal,
		memRead => s_memRead,
	        memToReg => s_memToReg,
 	        memWrite => s_temp_DMemWr, --
	        aluSrc   => s_aluSrc,
	        regWrite => s_temp_RegWr, --
	        sign_ext => s_sign_ext,
       		regDst   => s_regDst,
		vsig 	 => s_vsig,
		halt 	 => s_temp_Halt
);
--CONTROL UNIT
--REGISTER FILE
Regs: regFile port map(
		i_CLK => iCLK,
		i_RST => iRST,
		i_we => s_memwbwb(1),
		i_input => s_RegWrData,
		i_write => s_RegWrAddr,
		i_read1 => s_ifidinst(25 downto 21), --rs
		i_read2 => s_ifidinst(20 downto 16), --rt
		o_read1 => s_regout1, --R[rs]
		o_read2 => s_regout2); --R[rt]

--s_DMemData <= s_regout2;
--REGISTER FILE
--RAMMUX FOR JAL
with s_memwbwb(2) select s_tempram <=
	s_memwbaluout	when '0',
	s_memwbnextpc    when '1',
	s_memwbaluout	when others;
--RAMMUX FOR JAL
--RAM MUX
rammux: mux2t1_N port map(
		i_D0 => s_tempram,--s_memwbdmem,
		i_D1 => s_memwbdmem,--s_memwbaluout,
		i_S => s_memwbwb(0),
		o_O => s_RegWrData
);
--RAM MUX
--ALU
alu0: alu port map(
		aluop => s_idexex(3 downto 0), --was aluControl
		ALUSrc => s_idexex(4),
		v_sig => s_vsig,
		i_D0 => s_idexreg1, --R[rs]
		i_D1 => s_idexreg2, --R[rt]
		imm => s_idexsignext,--s_Inst(15 downto 0),
		i_repl => s_idexinst(23 downto 16), --TODO: CHANGE THESE TO BE FROM THE PIPELINE REG
		shamt => s_idexinst(10 downto 6),--TODO: CHANGE THESE TO BE FROM THE PIPELINE REG
		o_Sum =>  s_aluout,
		aluzero	=> s_aluzero,
		o_v => s_Ovfl,
		o_Cout => open);

--s_DMemAddr <= s_aluout;
oALUOut <= s_aluout;

--ALU
--BitExt
ext: bitext port map(
		i_in => s_ifidinst(15 downto 0),
		i_ext => s_sign_ext,
		o_O =>  s_extended
);
--BitExt
--MUX FOR JAL
with s_jal select s_tempwrite <=
	s_ifidinst(20 downto 16)	when '0',
	"11111"	when others;
--MUX FOR JAL
--MUX BEFORE WRITE REG
writeMux: mux2t1_N 
		generic map(bits => 5)
		port map(
		i_D0 => s_tempwrite,
		i_D1 => s_ifidinst(15 downto 11),
		i_S => s_regDst,
		o_O => s_WriteMuxOut
);
--MUX BEFORE WRITE REG
--AND WITH ZERO AND BRANCH
s_andout <= s_exmemmem(2) and s_exmemzero;
--AND WITH ZERO AND BRANCH
--SHIFT FOR BRANCH
s_branchshift_out <=  s_extended(29 downto 0) & "00";
--SHIFT FOR BRANCH
--ADDER FOR BRANCH
branchAdder: RippleAdder 
    port map(
        i_D0    => s_ifidnextpc,	            
        i_D1	=> s_branchshift_out,	           
        i_Cin 	=> '0',
        o_Sum 	=> s_branchadder_out,	            
        o_Cout 	=> s_Carry	 
  );
--ADDER FOR BRANCH
--BRANCH MUX
branchmux: mux2t1_N port map(
		i_D0 => s_ifidnextpc,
		i_D1 => s_branchadder_out,
		i_S => s_regequal,
		o_O => s_branchmux_out
);
--BRANCH MUX
--JUMP SHIFTER
s_jumpshift_out <= s_ifidnextpc(31 downto 28) & (s_ifidinst(25 downto 0) & "00");
--s_jumpshift_out(31 downto 28) <= s_newpc(31 downto 28) & x"00";
--JUMP SHIFTER
--JUMP MUX
jumpmux: mux2t1_N port map(
	i_D0 => s_branchmux_out,
	i_D1 => s_jumpshift_out,
	i_S => s_j,
	o_O => s_jumpmux_out);
--JUMP MUX
--IF/ID Reg
ifid: r_IFID port map(
       i_inst => s_Inst,
       i_CLK => iCLK,
       i_RST => iRST,
       i_nextPC => s_newpc,
       o_inst => s_ifidinst,
       o_nextPC => s_ifidnextpc);
--IF/ID Reg
--MEM/WB
memwb: r_MEMWB port map(i_dmem => s_DMemOut,
       i_forward => s_exmemforward,
       i_aluout  => s_exmemaluout,
       i_nextpc => s_exmemnextpc,
       i_rdrtmux => s_exmemrdrtmux,
       i_halt => s_exmemhalt,
       i_CLK => iCLK,
       i_RST => iRST,
       i_WB => s_exmemwb,
       o_dmem => s_memwbdmem,
       o_forward => s_memwbforward,
       o_aluout => s_memwbaluout,
       o_nextpc => s_memwbnextpc,
       o_rdrtmux => s_RegWrAddr,
       o_WB => s_memwbwb,
       o_halt => s_Halt);

s_RegWr <= s_memwbwb(1);
--MEM/WB
--EX/MEM
exmem: r_EXMEM port map(
       i_alu => s_aluout,
       i_CLK => iCLK,
       i_RST => iRST,
       i_WB => s_idexwb,
       i_M => s_idexmem,
       i_halt => s_idexhalt,
       i_ExMemMUX => s_idexreg2,
       i_rdrtMUX => s_temp_RegWrAddr,
       i_nextpc => s_idexnextpc,
       i_Zero => s_aluzero,
       o_ExMemMUX => s_exmemmux,
       o_rdrtMUX => s_exmemrdrtmux,
       o_nextpc => s_exmemnextpc,
       o_WB => s_exmemwb,
       o_M => s_exmemmem,
       o_Zero => s_exmemzero,
       o_alu => s_exmemaluout,
       o_halt => s_exmemhalt);
s_DMemWr <= s_exmemmem(1);
s_DMemData <= s_exmemmux;
s_DMemAddr <= s_exmemaluout;
--EX/MEM
--ID/EX

s_regequal <= '1' when ((s_regout1 = s_regout2) and (s_ifidinst(31 downto 26) = "000100")) or (not(s_regout1 = s_regout2) and (s_ifidinst(31 downto 26) = "000101")) else '0';

idex: r_IDEX port map(
        i_WB => s_jal&s_temp_RegWr&s_memToReg,
        i_MEM => s_b&s_temp_DMemWr&s_memRead, --Remove all s_b stuff
        i_EX => s_regDst&s_aluSrc&s_aluControl,
        i_halt => s_temp_Halt,
        i_reg1out => s_regout1,
        i_reg2out => s_regout2,
	i_nextpc => s_ifidnextpc, --fill in
        i_inst => s_ifidinst,
        i_signExt => s_extended,
	i_regwriteaddr => s_WriteMuxOut,
        i_CLK => iCLK,
        i_RST => iRST,
        o_WBSig => s_idexwb,
        o_MEMSig => s_idexmem,
        o_EX => s_idexex,
	o_reg1out => s_idexreg1,
	o_reg2out => s_idexreg2,
        o_RegRs => s_idexrs,
	o_nextpc => s_idexnextpc,
        o_RegRt => s_idexrt,
        o_signExt => s_idexsignext,
        o_RegRd => s_idexrd,
	o_inst  => s_idexinst,
	o_regwriteaddr => s_temp_RegWrAddr,
        o_halt => s_idexhalt);
--ID/EX
--MUX before PC
beforepcmux: mux2t1_N port map(
		i_D0 => s_newpc,
		i_D1 => s_jrmux_out,
		i_S => s_j or s_b or s_jr,--s_regequal,
		o_O => s_finalpc
);
--MUX before PC
end structure;

