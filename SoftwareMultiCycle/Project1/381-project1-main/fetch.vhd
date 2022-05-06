library IEEE;
use IEEE.std_logic_1164.all;

entity fetch is
    generic(N : integer := 32;
	ADDR_WIDTH : natural := 10);
    port(
        i_clock             : in std_logic;
        i_reset             : in std_logic;
        o_Instr             : out std_logic_vector(31 downto 0));

end fetch;

architecture structural of fetch is
    component mem is
        port(clk	: in std_logic;
         addr	    	: in std_logic_vector((ADDR_WIDTH-1) downto 0);
         data	    	: in std_logic_vector(31 downto 0);
         we	        : in std_logic := '1';
         q	        : out std_logic_vector(31 downto 0));
    end component;

    component register_n is
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
            o_Cout 		            : out std_logic);
    end component;

    --signal s_PC     : std_logic_vector((ADDR_WIDTH-1) downto 0);
    signal s_PC     : std_logic_vector(N-1 downto 0) := x"00000000";
    signal s_Sum    : std_logic_vector(N-1 downto 0) := x"00000000";
    signal s_Carry  : std_logic;
    signal s_write  : std_logic;

begin

    i_mem: mem 
    port map(
        clk     => i_clock,
        addr    => s_PC(9 downto 0),
        data    => x"00000000",
        we      => '0',
        q       =>  o_Instr
    );

    pc_reg: register_n 
    port map(
        i_D     => s_Sum,       
        i_CLK   => i_clock,
        i_RST   => i_reset,
        i_WE    => '1',
        o_Q     => s_PC
    );

    adder: RippleAdder 
    port map(
        i_D0    => s_PC,	            
        i_D1	=> x"00000001",	           
        i_Cin 	=> '0',       
        o_Sum 	=> s_Sum,	            
        o_Cout 	=> s_Carry	 
    );

end structural;