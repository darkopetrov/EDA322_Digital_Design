library ieee;
use ieee.std_logic_1164.all;
entity prep is
port( a, b, c: in std_logic;
 out_1, out_2, out_3: out std_logic);
end prep;
architecture behave of prep is
 signal temp_s: std_logic;
begin
 proccess: process(a,b,c)
 variable temp_v: std_logic;
 begin

temp_v := a and b;
out_1 <= temp_v xor c;
temp_s <= a and b;
out_2 <= temp_s xor c;
 end process;

out_3 <= temp_s xor c;
end behave;