library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

entity mux4to1 is
port( 	w0, w1, w2, w3 :in STD_LOGIC_VECTOR(7 downto 0);
		s              :IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		f              :OUT STD_LOGIC_VECTOR(7 downto 0)
		);
end mux4to1;

architecture DataFlow of mux4to1 is 
begin
	
			with s select
				f <= 	w0 when "00",
					w1 when "01",
					w2 when "10",
					w3 when "11",
					"--------" when others;
		

end dataflow;