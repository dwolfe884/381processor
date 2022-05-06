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


entity mux2t1 is

  port(i_D0 		            : in std_logic;
       i_D1		            : in std_logic;
       i_S 		            : in std_logic;
       o_O 		            : out std_logic);

end mux2t1;

architecture structure of mux2t1 is
  
  -- Describe the component entities as defined in Adder.vhd, Reg.vhd,
  -- Multiplier.vhd, RegLd.vhd (not strictly necessary).
  component andg2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component invg
    port(i_A             : in std_logic;
         o_F             : out std_logic);
  end component;

  component org2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;


  -- Signal to carry the inversted signal
  signal s_S         : std_logic;
  -- Signals to carry the results of AND1 and AND2
  signal s_X1, s_X2   : std_logic;

begin

  ---------------------------------------------------------------------------
  -- Level 0: Conditionally load new W
  ---------------------------------------------------------------------------
  myNot: invg
    port MAP(i_A               => i_S,
             o_F               => s_S); 
  and1: andg2
    port MAP(i_A               => i_D0,
             i_B               => s_S,
             o_F               => s_X1);


  ---------------------------------------------------------------------------
  -- Level 1: Delay X and Y, calculate W*X
  ---------------------------------------------------------------------------
  and2: andg2
    port MAP(i_A               => i_D1,
             i_B               => i_S,
             o_F               => s_X2);
  
  myOr: org2
    port MAP(i_A               => s_X1,
             i_B               => s_X2,
             o_F               => o_O);



  end structure;
