LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FA IS
	PORT( 	a:	IN STD_LOGIC;
		b:	IN STD_LOGIC;
		cin:	IN STD_LOGIC;
		cout:	OUT STD_LOGIC;
		s:	OUT STD_LOGIC);
end FA;

ARCHITECTURE dataflow OF FA IS
BEGIN
	s <= cin XOR (a XOR b);
	cout <= (cin and (a XOR b)) or (A and B);
END dataflow;