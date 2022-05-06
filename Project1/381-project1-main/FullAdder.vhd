-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- TPU_MV_Element.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a processing
-- element for the systolic matrix-vector multiplication array inspired 
-- by Google's TPU.
--
--
-- NOTES:
-- 1/14/19 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity FullAdder is

  port(i_D0 		            : in std_logic;
       i_D1		            : in std_logic;
       i_Cin 		            : in std_logic;
       o_Sum 		            : out std_logic;
       o_Cout 		            : out std_logic);

end FullAdder;

architecture structure of FullAdder is
  
  -- Describe the component entities as defined in Adder.vhd, Reg.vhd,
  -- Multiplier.vhd, RegLd.vhd (not strictly necessary).
  component andg2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component xorg2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component org2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;


  -- Signal to carry the first xor
  signal s_xor         : std_logic;
  -- Signals to carry the results of AND1 and AND2
  signal s_and1, s_and2  : std_logic;

begin

  ---------------------------------------------------------------------------
  -- Level 0: Conditionally load new W
  ---------------------------------------------------------------------------
  myXor: xorg2
    port MAP(i_A               => i_D0,
	     i_B	       => i_D1,
             o_F               => s_xor); 
  and1: andg2
    port MAP(i_A               => i_Cin,
             i_B               => s_xor,
             o_F               => s_and1);


  ---------------------------------------------------------------------------
  -- Level 1: Delay X and Y, calculate W*X
  ---------------------------------------------------------------------------
  and2: andg2
    port MAP(i_A               => i_D0,
             i_B               => i_D1,
             o_F               => s_and2);
  
  myOr: org2
    port MAP(i_A               => s_and1,
             i_B               => s_and2,
             o_F               => o_Cout);

  myXor2: xorg2
    port MAP(i_A               => s_xor,
             i_B               => i_Cin,
             o_F               => o_Sum);



  end structure;
