library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.utils.all;


entity T_TEMPMUX is

end T_TEMPMUX;


architecture test of T_TEMPMUX is

component THERMOSTAT is
port (

-->  IN signals:
      CLK            : in std_logic;
      RESET          : in std_logic;
      current_temp   : in std_logic_vector(6 downto 0);
      desired_temp   : in std_logic_vector(6 downto 0);
      display_select : in std_logic;
      COOL           : in std_logic;
      HEAT           : in std_logic;
      furnace_hot    : in std_logic;
      AC_ready       : in std_logic;
--> OUT signals:
      temp_display   : out std_logic_vector(6 downto 0);
      A_C_ON         : out std_logic;
      FURNACE_ON     : out std_logic;
      FAN_ON         : out std_logic);

end component;

signal current_temp , desired_temp , temp_display : std_logic_vector(6 downto 0);
signal display_select , COOL , HEAT , furnace_hot , AC_ready : std_logic;
signal A_C_ON , FURNACE_ON , FAN_ON : std_logic;

signal CLK : std_logic := '1';
signal RESET : std_logic := '0';

begin 

UUT : THERMOSTAT port map ( CLK => CLK,
			    RESET => RESET,
                            current_temp => current_temp,
                            desired_temp => desired_temp,
		            display_select => display_select,
		            temp_display => temp_display,
			    COOL => COOL,
			    HEAT => HEAT,
			    furnace_hot => furnace_hot,
			    AC_ready => AC_ready,
			    A_C_ON => A_C_ON,
			    FURNACE_ON => FURNACE_ON,
			    FAN_ON => FAN_ON);


CLK <= not CLK after 5ns;
RESET <= '1' , '0' after 10ns;




--> test functionality:
--> a. testing the temp_display.
--> b. testing the A/C.
--> c. testing the FURNACE.

TEST_PROC : process

  --> procedure to set the current and desired temp where it takes 
  --> integers and it converts them to logic vectors.
  procedure SET_TEMP (current , desired : in integer) is
  begin
  
  current_temp <= std_logic_vector(to_unsigned(current , current_temp'length));
  desired_temp <= std_logic_vector(to_unsigned(desired , desired_temp'length));

  end;

begin 

--> a. resetting all the input signals first:

  COOL <= '0';
  HEAT <= '0';
  furnace_hot <= '0';
  AC_ready <= '0';


--> b. testing the temp_display:

  --> 1. assign the current_temp and the desired_temp with different values
  -->    a. using the SET_TEMP procedure
  SET_TEMP(current => 85 , desired => 42);
  -->    b. manually
  --current_temp <= "1010101";
  --desired_temp <= "0101010";

  --> 2. assign display_select with '0'
  display_select <= '0';

  --> 3. wait for 10 ns
  wait for 15 ns;

----> self checking the temp_display if it isn't equal to desired_temp then this report will
----> be displayed.
  assert temp_display = desired_temp report "temp display value isn't correct it should be" & CONV_VECTOR_TO_DSTRING(desired_temp) 
    severity error;

  --> 4. assign display_select with '1'
  display_select <= '1';

  --> 5. wait for 10 ns
  wait for 15 ns;

----> self checking the temp_display if it isn't equal to current_temp then this report will
----> be displayed.
  assert temp_display = current_temp report "temp display value isn't correct it should be" & CONV_VECTOR_TO_DSTRING(current_temp) 
    severity error;

-----------------------------------------------------------------------------------

--> c. testing the A/C and the FAN:

  --> 1. setting the COOL bit
  COOL <= '1';
  
  --> 2. assign the desired_temp with value greater than the current_temp -> A/C = OFF
  -->    a. using the SET_TEMP procedure
  SET_TEMP(current => 1 , desired => 3);
  -->    b. manually
  --desired_temp <= "0000111";
  --current_temp <= "0000001";  

  
  --> 3. wait 10 ns
  wait for 10 ns;

------> self checking the A_C_ON if it isn't equal to '0' then this report will
------> be displayed.
  assert A_C_ON = '0' report "the A_C should be OFF not ON" 
    severity error;
  
  --> 4. assign the current_temp with value greater than the desired_temp -> A/C = ON
  -->    a. using the SET_TEMP procedure
  SET_TEMP(current => 3 , desired => 1);
  -->    b. manually
  --desired_temp <= "0000001";
  --current_temp <= "0000111";
  
  --> 5. wait until the AC is ON
  wait until A_C_ON = '1';
  
  --> 6. setting the AC_ready bit
  AC_ready <= '1';
  
  --> 7. wait until the FAN is ON
  wait until FAN_ON = '1';
  
  --> 8. resetting the COOL bit -> A/C = OFF
  COOL <= '0';
  
  --> 9. wait until the AC is OFF
  wait until A_C_ON = '0';
  
  --> 10. resetting the AC_ready bit
  AC_ready <= '0';
  
  --> 11. wait until the FAN is OFF
  wait until FAN_ON = '0';

-----------------------------------------------------------------------------------
--> d. testing the FURNACE and the FAN:

  --> 1. setting the HEAT bit
  HEAT <= '1';

  --> 2. assign the desired_temp with value less than the current_temp -> FURNACE = OFF
  -->    a. using the SET_TEMP procedure
  SET_TEMP(current => 3 , desired => 1);
  -->    b. manually
  --desired_temp <= "0000001";
  --current_temp <= "0000111";

  --> 3. wait for 10 ns
  wait for 10 ns;

------> self checking the FURNACE_ON if it isn't equal to '0' then this report will
------> be displayed.
  assert FURNACE_ON = '0' report "the FURNACE should be OFF not ON" 
    severity error;

  --> 4. assign the current_temp with value less than the desired_temp -> FURNACE = ON
  -->    a. using the SET_TEMP procedure
  SET_TEMP(current => 1 , desired => 3);
  -->    b. manually
  --desired_temp <= "0000111";
  --current_temp <= "0000001";

  --> 5. wait until the furnace is ON
  wait until FURNACE_ON = '1';

  --> 6. setting the furnace_hot bit
  furnace_hot <= '1';

  --> 7. wait until the FAN is ON
  wait until FAN_ON = '1';

  --> 8. resetting the HEAT bit -> FURNACE = OFF
  HEAT <= '0';

  --> 9. wait until the furnace is OFF
  wait until FURNACE_ON = '0';

  --> 10. resetting the furnace_hot bit
  furnace_hot <= '0';

  --> 11. wait until the FAN is OFF
  wait until FAN_ON = '0';

end process TEST_PROC;


end test;