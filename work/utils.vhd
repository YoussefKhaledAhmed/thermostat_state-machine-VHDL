library ieee;
use ieee.std_logic_1164.all;


--> package header:
PACKAGE utils is
------------------------------------------------------------
--| name: CONV_VECTOR_TO_DSTRING
--| arguments: data -> std_logic_vector
--| return: string
--| description: it converts std_logic_vector to string. 
------------------------------------------------------------
function CONV_VECTOR_TO_DSTRING (data : std_logic_vector) RETURN string;
end utils;


PACKAGE BODY utils is
 
  ------------------------------------------------------------
  --| name: CONV_VECTOR_TO_DSTRING
  --| arguments: data -> std_logic_vector
  --| return: string
  --| description: it converts std_logic_vector to string. 
  ------------------------------------------------------------
  function CONV_VECTOR_TO_DSTRING (data : std_logic_vector) RETURN string is
    --> variable to hold the result of the conversion.
    variable temp_string : string(data'length downto 1);
  begin
    --> for loop to loop over the std_logic_vector
    --> to convert each bit to the corresponding 
    --> character and save it to the string.
    for i in 1 to (data'length) loop
      case data(i-1) is
        --> if the bit is '0' then save '0' 
        --> to its corresponding iteration 
        --> of the string.
        when '0' => temp_string(i) := '0';
        --> if the bit is '1' then save '1' 
        --> to its corresponding iteration 
        --> of the string.
        when '1' => temp_string(i) := '1';
        --> if the bit is any other value
        --> of the possible ones then save '0' 
        --> to its corresponding iteration 
        --> of the string.
        when others => temp_string(i) := 'x';
      end case;
    end loop;
    --> return the converted string.
    return temp_string;
  end CONV_VECTOR_TO_DSTRING;

end utils;