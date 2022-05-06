library IEEE;
use IEEE.std_logic_1164.all;

entity tb_pipelineRegs is
  generic(N : integer := 32;
          gCLK_HPER   : time := 50 ns);
end tb_pipelineRegs;

architecture behavior of tb_pipelineRegs is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component r_IFID
   generic(N : integer := 32);
    port(i_inst       : in std_logic_vector(N-1  downto 0);
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_nextPC	    : in std_logic_vector(N-1 downto 0);
       i_flush      : in std_logic;
       i_stall	    : in std_logic;
       o_inst       : out std_logic_vector(N-1  downto 0);
       o_nextPC     : out std_logic_vector(N-1  downto 0)
);
    end component;

  component r_IDEX
   generic(Ns : integer := 32);
    port(
        i_WB		: in std_logic_vector(3 downto 0);
        i_MEM		: in std_logic_vector(2 downto 0);
        i_EX	        : in std_logic_vector(5 downto 0);
        i_halt		: in std_logic;
	i_flush		: in std_logic;
	i_stall		: in std_logic;
        i_reg1out    	: in std_logic_vector(Ns-1  downto 0);
        i_reg2out    	: in std_logic_vector(Ns-1  downto 0);
	i_nextpc	: in std_logic_vector(Ns-1 downto 0);
        i_inst       	: in std_logic_vector(Ns-1  downto 0);
        i_signExt    	: in std_logic_vector(Ns-1  downto 0);
	i_regwriteaddr  : in std_logic_vector(5-1 downto 0);
	i_jrmuxout	: in std_logic_vector(Ns-1 downto 0);
	i_memreadwrite  : in std_logic;
        i_CLK        	: in std_logic;
        i_RST        	: in std_logic;

        o_WBSig      	: out std_logic_vector(3 downto 0);
        o_MEMSig     	: out std_logic_vector(2 downto 0);
        o_EX	     	: out std_logic_vector(5 downto 0);
	o_reg1out    	: out std_logic_vector(Ns-1 downto 0);
	o_reg2out    	: out std_logic_vector(Ns-1 downto 0);
        o_RegRs      	: out std_logic_vector(5-1  downto 0);
	o_nextpc	: out std_logic_vector(Ns-1 downto 0);
        o_RegRt     	: out std_logic_vector(5-1  downto 0);
        o_signExt       : out std_logic_vector(Ns-1 downto 0);
        o_RegRd      	: out std_logic_vector(5-1  downto 0);
	o_regwriteaddr  : out std_logic_vector(5-1 downto 0);
        o_inst       	: out std_logic_vector(Ns-1  downto 0);
	o_jrmuxout	: out std_logic_vector(Ns-1 downto 0);
	o_memreadwrite  : out std_logic;
        o_halt		: out std_logic
);
    end component;

  component r_EXMEM
   generic(N : integer := 32);
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
       o_halt	    : out std_logic
);
    end component;

  component r_MEMWB
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
       o_halt	    : out std_logic
);
    end component;


  -- Temporary signals to connect to the dff component.
  signal s_stall_MEMWB, s_flush_MEMWB, s_stall_EXMEM, s_flush_EXMEM, s_stall_IDEX, s_flush_IDEX, s_halt_IDEX, s_halt_EXMEM, s_halt_MEMWB, so_halt_IDEX, so_halt_EXMEM, so_halt_MEMWB, s_Zero_EXMEM, so_Zero_EXMEM, s_flush_IFID, s_stall_IFID, s_memreadwrite_IDEX, so_memreadwrite_IDEX, s_memreadwrite_EXMEM, so_memreadwrite_EXMEM, s_memreadwrite_MEMWB, so_memwreadwrite_MEMWB : std_logic;
  signal s_inst_IFID, s_inst_IDEX, s_nextPC_IFID, s_nextPC_IDEX, s_nextPC_EXMEM, s_nextPC_MEMWB, s_reg1out_IDEX, s_reg2out_IDEX, s_signExt_IDEX, so_reg1out_IDEX, so_reg2out_IDEX, so_signExt_IDEX, s_alu_EXMEM, s_ExMemMUX_EXMEM, so_alu_EXmEM, so_ExMemMUX_EXMEM, s_dmem_MEMWB, s_aluout_MEMWB, so_dmem_MEMWB, so_aluout_MEMWB, s_jrmuxout_IDEX, so_jrmuxout_IDEX : std_logic_vector(31 downto 0);
  signal so_inst_IFID, so_inst_IDEX, so_nextPC_IFID, so_nextPC_IDEX, so_nextPC_EXMEM, so_nextPC_MEMWB, s_jrmuxout_EXMEM, so_jrmuxout_EXMEM, s_jrmuxout_MEMWB, so_jrmuxout_MEMWB : std_logic_vector(31 downto 0);
  signal s_MEM_IDEX, s_M_EXMEM, so_MEMSig_IDEX, so_M_EXMEM : std_logic_vector(2 downto 0);
  signal s_EX_IDEX, so_EX_IDEX : std_logic_vector(5 downto 0);
  signal s_regwriteadder_IDEX, so_RegRs_IDEX, so_RegRt_IDEX, so_RegRd_IDEX, so_regwriteaddr_IDEX, s_rdrtMUX_EXMEM, s_rd_EXMEM, so_rdrtMUX_EXMEM, so_rd_EXMEM, s_rdrtmux_MEMWB, s_rd_MEMWB, so_rdrtmux_MEMWB, so_rd_MEMWB : std_logic_vector(4 downto 0);
  signal s_WB_IDEX, so_WBSig_IDEX, s_WB_EXMEM, s_WB_MEMWB, so_WB_EXMEM, so_WB_MEMWB : std_logic_vector(3 downto 0);
  signal s_CLK, s_RST  : std_logic := '0';

begin

  DUT0: r_IFID 
  port map(i_inst  => s_inst_IFID,
       i_CLK       => s_CLK,
       i_RST       => s_RST,
       i_nextPC	   => s_nextPC_IFID,
       i_flush     => s_flush_IFID,
       i_stall	   => s_stall_IFID,
       o_inst      => so_inst_IFID,
       o_nextPC    => so_nextPC_IFID);

  DUT1: r_IDEX 
  port map(i_WB		=> s_WB_IDEX,
        i_MEM		=> s_MEM_IDEX,
        i_EX	        => s_EX_IDEX,
        i_halt		=> s_halt_IDEX,
	i_flush		=> s_flush_IDEX,
	i_stall		=> s_stall_IDEX,
        i_reg1out    	=> s_reg1out_IDEX,
        i_reg2out    	=> s_reg2out_IDEX,
	i_nextpc	=> s_nextPC_IDEX,
        i_inst       	=> s_inst_IDEX,
        i_signExt    	=> s_signExt_IDEX,
	i_regwriteaddr  => s_regwriteadder_IDEX,
	i_jrmuxout	=> s_jrmuxout_IDEX,
	i_memreadwrite  => s_memreadwrite_IDEX,
        i_CLK        	=> s_CLK,
        i_RST        	=> s_RST,

        o_WBSig      	=> so_WBSig_IDEX,
        o_MEMSig     	=> so_MEMSig_IDEX,
        o_EX	     	=> so_EX_IDEX,
	o_reg1out    	=> so_reg1out_IDEX,
	o_reg2out    	=> so_reg2out_IDEX,
        o_RegRs      	=> so_RegRs_IDEX,
	o_nextpc	=> so_nextpc_IDEX,
        o_RegRt     	=> so_RegRt_IDEX,
        o_signExt       => so_signExt_IDEX,
        o_RegRd      	=> so_RegRd_IDEX,
	o_regwriteaddr  => so_regwriteaddr_IDEX,
        o_inst       	=> so_inst_IDEX,
	o_jrmuxout	=> so_jrmuxout_IDEX,
	o_memreadwrite  => so_memreadwrite_IDEX,
        o_halt		=> so_halt_IDEX);

  DUT2: r_EXMEM 
  port map(i_alu    => s_alu_EXMEM,
       i_CLK        => s_CLK,
       i_RST        => s_RST,
       i_flush      => s_flush_EXMEM,
       i_stall      => s_stall_EXMEM,
       i_WB	    => s_WB_EXMEM,
       i_M	    => s_M_EXMEM,
       i_halt	    => s_halt_EXMEM,
       i_ExMemMUX   => s_ExMemMUX_EXMEM,
       i_rdrtMUX    => s_rdrtMUX_EXMEM,
       i_nextpc	    => s_nextpc_EXMEM,
       i_jrmuxout   => s_jrmuxout_EXMEM,
       i_memreadwrite => s_memreadwrite_EXMEM,
       i_Zero	    => s_Zero_EXMEM,
       i_rd	    => s_rd_EXMEM,
       o_WB	    => so_WB_EXMEM,
       o_M	    => so_M_EXMEM,
       o_Zero	    => so_Zero_EXMEM,
       o_alu        => so_alu_EXMEM,
       o_ExMemMUX   => so_ExMemMUX_EXMEM,
       o_rdrtMUX    => so_rdrtMUX_EXMEM,
       o_nextpc	    => so_nextpc_EXMEM,
       o_rd	    => so_rd_EXMEM,
       o_jrmuxout   => so_jrmuxout_EXMEM,
       o_memreadwrite => so_memreadwrite_EXMEM,
       o_halt	    => so_halt_EXMEM);

  DUT3: r_MEMWB 
  port map(i_dmem   => s_dmem_MEMWB,
       i_aluout	    => s_aluout_MEMWB,
       i_nextpc     => s_nextpc_MEMWB,
       i_rdrtmux    => s_rdrtmux_MEMWB,
       i_flush	    => s_flush_MEMWB,
       i_stall      => s_stall_MEMWB,
       i_halt	    => s_halt_MEMWB,
       i_CLK        => s_CLK,
       i_RST        => s_RST,
       i_rd	    => s_rd_MEMWB,
       i_WB	    => s_WB_MEMWB,
       i_jrmuxout   => s_jrmuxout_MEMWB,
       i_memreadwrite => s_memreadwrite_MEMWB,
       o_dmem       => so_dmem_MEMWB,
       o_aluout	    => so_aluout_MEMWB,
       o_nextpc     => so_nextpc_MEMWB,
       o_rdrtmux    => so_rdrtmux_MEMWB,
       o_WB	    => so_WB_MEMWB,
       o_rd	    => so_rd_MEMWB,
       o_jrmuxout   => so_jrmuxout_MEMWB,
       o_memreadwrite => so_memwreadwrite_MEMWB,
       o_halt	    => so_halt_MEMWB);

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
	--IFID REGISTER
	--s_inst_IFID <= x"11110000";
	s_flush_IFID <= '1';
	s_stall_IFID <= '1';
       	s_nextPC_IFID <= x"00001111";
	wait for 100 ns;

	--IDEX REGISTER
	s_nextPC_IFID <= x"12340000";
	--s_WB_IDEX <= "0000";
        --s_MEM_IDEX <= "000";
        --s_EX_IDEX <= "000000";
        --s_halt_IDEX <= '0';
	s_flush_IDEX <= '1';
	s_stall_IDEX <= '1';
        --s_reg1out_IDEX <= x"00001234";
        --s_reg2out_IDEX <= x"12340000";
	s_nextPC_IDEX <= so_nextPC_IFID;
        --s_inst_IDEX <= so_inst_IFID;
	--s_jrmuxout_IDEX <= x"44445555";
	--s_memreadwrite_IDEX <= '0';
        --s_signExt_IDEX <= x"10101010";
	--s_regwriteadder_IDEX <= "00000";
	wait for cCLK_PER;
	
	--EXMEM REGISTER
	--s_alu_EXMEM <= x"33334444";
	s_nextPC_IFID <= x"ABABABAB";
	s_nextPC_IDEX <= so_nextPC_IFID;
	s_flush_EXMEM <= '1';
	s_stall_EXMEM <= '1';
        --s_WB_EXMEM <= so_WBSig_IDEX;
        --s_M_EXMEM <= so_MEMSig_IDEX;
        --s_halt_EXMEM <= so_halt_IDEX;
	--s_jrmuxout_EXMEM <= so_jrmuxout_IDEX;
	--s_memreadwrite_EXMEM <= so_memreadwrite_IDEX;
        --ExMemMUX_EXMEM <= so_reg2out_IDEX; --Not sure what this is
        --s_rdrtMUX_EXMEM <= "00011";
        s_nextpc_EXMEM <= so_nextPC_IDEX;
        --s_Zero_EXMEM <= '1';
        --s_rd_EXMEM <= "00101";
	wait for cCLK_PER;
	
	--MEMWB REGISTER
	s_nextPC_IFID <= x"EFEFEFEF";
        s_nextpc_EXMEM <= so_nextPC_IDEX;
	s_nextPC_IDEX <= so_nextPC_IFID;
	--s_dmem_MEMWB <= so_alu_EXMEM;
	s_flush_MEMWB <= '1';
	s_stall_MEMWB <= '1';
        --s_aluout_MEMWB <= so_alu_EXMEM;
        s_nextpc_MEMWB <= so_nextpc_EXMEM;
        --s_rdrtmux_MEMWB <= so_rdrtMUX_EXMEM;
        --s_halt_MEMWB <= so_halt_EXMEM;
	--s_jrmuxout_MEMWB <= so_jrmuxout_EXMEM;
	--s_memreadwrite_MEMWB <= so_memreadwrite_EXMEM;
        --s_rd_MEMWB <= so_rd_EXMEM;
        --s_WB_MEMWB <= so_WB_EXMEM;
	wait for cCLK_PER;

--FLUSH
	--IFID REGISTER
	s_inst_IFID <= x"11110000";
        s_nextpc_MEMWB <= so_nextpc_EXMEM;
	s_nextPC_IDEX <= so_nextPC_IFID;
        s_nextpc_EXMEM <= so_nextPC_IDEX;
	s_stall_IFID <= '0';
	s_stall_IDEX <= '0';
	s_stall_EXMEM <= '0';
	s_stall_MEMWB <= '0';
	wait for cCLK_PER;

	--IDEX REGISTER
        s_nextpc_MEMWB <= so_nextpc_EXMEM;
        s_nextpc_EXMEM <= so_nextPC_IDEX;
	s_stall_IFID <= '1';
	s_stall_IDEX <= '1';
	s_stall_EXMEM <= '1';
	s_stall_MEMWB <= '1';
	s_WB_IDEX <= "0000";
        s_MEM_IDEX <= "000";
        s_EX_IDEX <= "000000";
        s_halt_IDEX <= '0';
        s_reg1out_IDEX <= x"00001234";
        s_reg2out_IDEX <= x"12340000";
	s_nextPC_IDEX <= so_nextPC_IFID;
        s_inst_IDEX <= so_inst_IFID;
	s_jrmuxout_IDEX <= x"44445555";
	s_memreadwrite_IDEX <= '0';
        s_signExt_IDEX <= x"10101010";
	s_regwriteadder_IDEX <= "00000";
	wait for cCLK_PER;
	
	--EXMEM REGISTER
        s_nextpc_MEMWB <= so_nextpc_EXMEM;
	s_alu_EXMEM <= x"33334444";
        s_WB_EXMEM <= so_WBSig_IDEX;
        s_M_EXMEM <= so_MEMSig_IDEX;
        s_halt_EXMEM <= so_halt_IDEX;
	s_jrmuxout_EXMEM <= so_jrmuxout_IDEX;
	s_memreadwrite_EXMEM <= so_memreadwrite_IDEX;
        s_ExMemMUX_EXMEM <= so_reg2out_IDEX; --Not sure what this is
        s_rdrtMUX_EXMEM <= "00011";
        s_nextpc_EXMEM <= so_nextPC_IDEX;
        s_Zero_EXMEM <= '1';
        s_rd_EXMEM <= "00101";
	wait for cCLK_PER;
	
	--MEMWB REGISTER
	s_dmem_MEMWB <= so_alu_EXMEM;
	s_flush_MEMWB <= '0';
	s_flush_IFID <= '0';
	s_flush_IDEX <= '0';
	s_flush_EXMEM <= '0';
        s_aluout_MEMWB <= so_alu_EXMEM;
        s_nextpc_MEMWB <= so_nextpc_EXMEM;
        s_rdrtmux_MEMWB <= so_rdrtMUX_EXMEM;
        s_halt_MEMWB <= so_halt_EXMEM;
	s_jrmuxout_MEMWB <= so_jrmuxout_EXMEM;
	s_memreadwrite_MEMWB <= so_memreadwrite_EXMEM;
        s_rd_MEMWB <= so_rd_EXMEM;
        s_WB_MEMWB <= so_WB_EXMEM;
	wait for cCLK_PER;

  end process;
  
end behavior;
