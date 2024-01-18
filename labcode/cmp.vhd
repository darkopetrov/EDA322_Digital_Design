LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.all;

entity cmp is 
	port(
		a : in STD_LOGIC_VECTOR(7 downto 0);
		b : in STD_LOGIC_VECTOR(7 downto 0);
		EQ : out STD_LOGIC;
		NEQ : out STD_LOGIC
	);
end cmp;


ARCHITECTURE DataFlow of cmp is 
	signal chek : STD_LOGIC;
	signal chekinv : STD_LOGIC;
	
begin
	
	
	chek <= '1' WHEN A=B ELSE '0';
	EQ <= chek;
	chekinv <= not chek;
	NEQ <= chekinv;

end DataFlow;