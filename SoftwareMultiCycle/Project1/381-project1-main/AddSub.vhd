-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity AddSub is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(n_Add_Sub    : in std_logic;
       ALUSrc	    : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       imm	    : in std_logic_vector(N-1 downto 0);
       o_Sum        : out std_logic_vector(N-1 downto 0);
       o_v	    : out std_logic;
       o_Cout       : out std_logic);

end AddSub;

architecture structural of AddSub is

  component mux2t1_N is
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));

  end component;
  
  component invg_N is
    port(i_A                  : in std_logic_vector(N-1 downto 0);
         o_F                  : out std_logic_vector(N-1 downto 0));
  end component;

  component RippleAdder is
    port(i_D0 		            : in std_logic_vector(N-1 downto 0);
         i_D1		            : in std_logic_vector(N-1 downto 0);
         i_Cin 		            : in std_logic;
         o_Sum 		            : out std_logic_vector(N-1 downto 0);
	 o_v			    : out std_logic;
         o_Cout 		    : out std_logic);
  end component;

signal s_mux : std_logic_vector(N-1 downto 0);
signal s_not, s_src : std_logic_vector(N-1 downto 0);
begin

  -- Instantiate N mux instances.
  muxSrc: mux2t1_N port map(
	      i_S      => ALUSrc,
              i_D0     => i_D0,
              i_D1     => imm,
              o_O      => s_src);
  muxI: mux2t1_N port map(
              i_S      => n_Add_Sub,
              i_D0     => i_D1,
              i_D1     => s_not,
              o_O      => s_mux);

  notI: invg_N port map(
              i_A      => i_D1,        
              o_F      => s_not);
  
  adderI: RippleAdder port map(
              i_D0     => s_src,
              i_D1     => s_mux,
              i_Cin    => n_Add_Sub,
              o_Sum    => o_Sum,
	      o_v      => o_v,
              o_Cout   => o_Cout);
  
end structural;
