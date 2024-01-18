library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

entity mux2to1 is
port( 	w0, w1			:in STD_LOGIC_VECTOR(7 downto 0);
		s              :IN STD_LOGIC;
		f              :OUT STD_LOGIC_VECTOR(7 downto 0)
		);
end mux2to1;

architecture DataFlow of mux2to1 is 
begin
	
			with s select
				f <= 	w0 when '0',
					w1 when others;
	--				"--------" when others;
end dataflow;