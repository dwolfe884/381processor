library IEEE;
use IEEE.std_logic_1164.all;

entity regFile is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_we	    : in std_logic;
       i_input        : in std_logic_vector(31 downto 0);
       i_write	    : in std_logic_vector(4 downto 0);
       i_read1	    : in std_logic_vector(4 downto 0);
       i_read2	    : in std_logic_vector(4 downto 0);
       o_read1          : out std_logic_vector(N-1  downto 0);
       o_read2          : out std_logic_vector(N-1  downto 0));

end regFile;

architecture structural of regFile is

  component decoder is
    port(i_in          : in std_logic_vector(4 downto 0); 
       o_0          : out std_logic;
       o_1          : out std_logic; 
       o_2          : out std_logic;
       o_3          : out std_logic;
       o_4          : out std_logic;
       o_5          : out std_logic;
       o_6          : out std_logic;
       o_7          : out std_logic;
       o_8          : out std_logic;
       o_9          : out std_logic;
       o_10          : out std_logic;
       o_11          : out std_logic;
       o_12          : out std_logic;
       o_13          : out std_logic;
       o_14          : out std_logic;
       o_15          : out std_logic;
       o_16          : out std_logic;
       o_17          : out std_logic;
       o_18          : out std_logic;
       o_19          : out std_logic;
       o_20          : out std_logic;
       o_21          : out std_logic;
       o_22          : out std_logic;
       o_23          : out std_logic;
       o_24          : out std_logic;
       o_25          : out std_logic;
       o_26          : out std_logic;
       o_27          : out std_logic;
       o_28          : out std_logic;
       o_29          : out std_logic;
       o_30          : out std_logic;
       o_31          : out std_logic);

  end component;
  component mux31t1 is
    port(i_0          : in std_logic_vector(31 downto 0);
       i_1          : in std_logic_vector(31 downto 0); 
       i_2          : in std_logic_vector(31 downto 0);
       i_3          : in std_logic_vector(31 downto 0);
       i_4          : in std_logic_vector(31 downto 0);
       i_5          : in std_logic_vector(31 downto 0);
       i_6          : in std_logic_vector(31 downto 0);
       i_7          : in std_logic_vector(31 downto 0);
       i_8          : in std_logic_vector(31 downto 0);
       i_9          : in std_logic_vector(31 downto 0);
       i_10          : in std_logic_vector(31 downto 0);
       i_11          : in std_logic_vector(31 downto 0);
       i_12          : in std_logic_vector(31 downto 0);
       i_13          : in std_logic_vector(31 downto 0);
       i_14          : in std_logic_vector(31 downto 0);
       i_15          : in std_logic_vector(31 downto 0);
       i_16          : in std_logic_vector(31 downto 0);
       i_17          : in std_logic_vector(31 downto 0);
       i_18          : in std_logic_vector(31 downto 0);
       i_19          : in std_logic_vector(31 downto 0);
       i_20          : in std_logic_vector(31 downto 0);
       i_21          : in std_logic_vector(31 downto 0);
       i_22          : in std_logic_vector(31 downto 0);
       i_23          : in std_logic_vector(31 downto 0);
       i_24          : in std_logic_vector(31 downto 0);
       i_25          : in std_logic_vector(31 downto 0);
       i_26          : in std_logic_vector(31 downto 0);
       i_27          : in std_logic_vector(31 downto 0);
       i_28          : in std_logic_vector(31 downto 0);
       i_29          : in std_logic_vector(31 downto 0);
       i_30          : in std_logic_vector(31 downto 0);
       i_31          : in std_logic_vector(31 downto 0);
       i_s	     : in std_logic_vector(4 downto 0);
       o_out         : out std_logic_vector(31 downto 0));

  end component;
  component register_n is
    port(i_D          : in std_logic_vector(N-1  downto 0);
       i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_WE	    : in std_logic;
       o_Q          : out std_logic_vector(N-1  downto 0));

  end component;
 
  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_en : std_logic_vector(31 downto 0);
  signal s_en0,s_en1,s_en2,s_en3,s_en4,s_en5,s_en6,s_en7,s_en8,s_en9,s_en10,s_en11,s_en12,s_en13,s_en14,s_en15,s_en16,s_en17,s_en18,s_en19,s_en20,s_en21,s_en22,s_en23,s_en24,s_en25,s_en26,s_en27,s_en28,s_en29,s_en30,s_en31 : std_logic;
  signal s_reg0,s_reg1,s_reg2,s_reg3,s_reg4,s_reg5,s_reg6,s_reg7,s_reg8,s_reg9,s_reg10,s_reg11,s_reg12,s_reg13,s_reg14,s_reg15,s_reg16,s_reg17,s_reg18,s_reg19,s_reg20,s_reg21,s_reg22,s_reg23,s_reg24,s_reg25,s_reg26,s_reg27,s_reg28,s_reg29,s_reg30,s_reg31 : std_logic_vector(31 downto 0);
  signal s_input : std_logic_vector(31 downto 0);
  signal s_D : std_logic_vector(N-1 downto 0):= x"00000000"; 
  signal s_Q : std_logic_vector(N-1 downto 0);
 
begin

  -- Instantiate N mux instances.

writeDecode: decoder port map(
			i_in => i_write,
                        o_0 => s_en0,
		        o_1 => s_en1,
		        o_2 => s_en2,
		        o_3 => s_en3,
		        o_4 => s_en4,
		        o_5 => s_en5,
		        o_6 => s_en6,
		        o_7 => s_en7,
		        o_8 => s_en8,
		        o_9 => s_en9,
		        o_10 => s_en10,
		        o_11 => s_en11,
		        o_12 => s_en12,
		        o_13 => s_en13,
		        o_14 => s_en14,
		        o_15 => s_en15,
		        o_16 => s_en16,
		        o_17 => s_en17,
		        o_18 => s_en18,
		        o_19 => s_en19,
		        o_20 => s_en20,
		        o_21 => s_en21,
		        o_22 => s_en22,
		        o_23 => s_en23,
		        o_24 => s_en24,
		        o_25 => s_en25,
		        o_26 => s_en26,
		        o_27 => s_en27,
		        o_28 => s_en28,
		        o_29 => s_en29,
		        o_30 => s_en30,
		        o_31 => s_en31);

reg0: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => '1',
			i_WE =>  s_en0 and i_we,
			o_Q => s_reg0);
reg1: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en1 and i_we,
			o_Q => s_reg1);
reg2: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en2 and i_we,
			o_Q => s_reg2);

reg3: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en3 and i_we,
			o_Q => s_reg3);

reg4: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en4 and i_we,
			o_Q => s_reg4);

reg5: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en5 and i_we,
			o_Q => s_reg5);

reg6: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en6 and i_we,
			o_Q => s_reg6);

reg7: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en7 and i_we,
			o_Q => s_reg7);

reg8: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en8 and i_we,
			o_Q => s_reg8);

reg9: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en9 and i_we,
			o_Q => s_reg9);

reg10: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en10 and i_we,
			o_Q => s_reg10);

reg11: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en11 and i_we,
			o_Q => s_reg11);

reg12: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en12 and i_we,
			o_Q => s_reg12);

reg13: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en13 and i_we,
			o_Q => s_reg13);

reg14: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en14 and i_we,
			o_Q => s_reg14);

reg15: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en15 and i_we,
			o_Q => s_reg15);

reg16: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en16 and i_we,
			o_Q => s_reg16);

reg17: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en17 and i_we,
			o_Q => s_reg17);

reg18: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en18 and i_we,
			o_Q => s_reg18);

reg19: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en19 and i_we,
			o_Q => s_reg19);

reg20: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en20 and i_we,
			o_Q => s_reg20);

reg21: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en21 and i_we,
			o_Q => s_reg21);

reg22: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en22 and i_we,
			o_Q => s_reg22);

reg23: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en23 and i_we,
			o_Q => s_reg23);

reg24: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en24 and i_we,
			o_Q => s_reg24);

reg25: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en25 and i_we,
			o_Q => s_reg25);

reg26: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en26 and i_we,
			o_Q => s_reg26);

reg27: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en27 and i_we,
			o_Q => s_reg27);

reg28: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en28 and i_we,
			o_Q => s_reg28);

reg29: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en29 and i_we,
			o_Q => s_reg29);

reg30: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en30 and i_we,
			o_Q => s_reg30);

reg31: register_n port map(i_D => i_input,
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE =>  s_en31 and i_we,
			o_Q => s_reg31);


read1: mux31t1 port map(i_0 => s_reg0,
       i_1 => s_reg1, 
       i_2 => s_reg2,
       i_3 => s_reg3,
       i_4 => s_reg4,
       i_5 => s_reg5,
       i_6 => s_reg6,
       i_7 => s_reg7,
       i_8 => s_reg8,
       i_9 => s_reg9,
       i_10 => s_reg10,
       i_11 => s_reg11,
       i_12 => s_reg12,
       i_13 => s_reg13,
       i_14 => s_reg14,
       i_15 => s_reg15,
       i_16  => s_reg16,
       i_17 => s_reg17,
       i_18 => s_reg18,
       i_19 => s_reg19,
       i_20 => s_reg20,
       i_21 => s_reg21,
       i_22 => s_reg22,
       i_23 => s_reg23,
       i_24 => s_reg24,
       i_25 => s_reg25,
       i_26 => s_reg26,
       i_27 => s_reg27,
       i_28 => s_reg28,
       i_29 => s_reg29,
       i_30 => s_reg30,
       i_31 => s_reg31,
       i_s => i_read1,
       o_out => o_read1);

read2: mux31t1 port map(i_0 => s_reg0,
       i_1 => s_reg1, 
       i_2 => s_reg2,
       i_3 => s_reg3,
       i_4 => s_reg4,
       i_5 => s_reg5,
       i_6 => s_reg6,
       i_7 => s_reg7,
       i_8 => s_reg8,
       i_9 => s_reg9,
       i_10 => s_reg10,
       i_11 => s_reg11,
       i_12 => s_reg12,
       i_13 => s_reg13,
       i_14 => s_reg14,
       i_15 => s_reg15,
       i_16  => s_reg16,
       i_17 => s_reg17,
       i_18 => s_reg18,
       i_19 => s_reg19,
       i_20 => s_reg20,
       i_21 => s_reg21,
       i_22 => s_reg22,
       i_23 => s_reg23,
       i_24 => s_reg24,
       i_25 => s_reg25,
       i_26 => s_reg26,
       i_27 => s_reg27,
       i_28 => s_reg28,
       i_29 => s_reg29,
       i_30 => s_reg30,
       i_31 => s_reg31,
       i_s => i_read2,
       o_out => o_read2);

 
end structural;