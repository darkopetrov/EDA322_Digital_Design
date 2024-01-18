LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.all;

ENTITY RCA IS
	PORT( 	A:	IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B:	IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		CIN:	IN STD_LOGIC;
		COUT:	OUT STD_LOGIC;
		S:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end RCA;
ARCHITECTURE dataflow OF RCA IS
	SIGNAL Ctemp: STD_LOGIC_VECTOR(7 DOWNTO 1);


	component FA
	port(
		a : in STD_LOGIC;
		b : in STD_LOGIC;
		s : out STD_LOGIC;
		cin : in STD_LOGIC;
		cout : OUT STD_LOGIC);
	end component;
BEGIN
	adder0 : FA port map (
		a => A(0),
		b => B(0),
		s => S(0),
		CIN => cin,
		COUT => Ctemp(1)
	);
	adder1 : FA port map (
		a => A(1),
		b => B(1),
		s => S(1),
		CIN => Ctemp(1),
		COUT => Ctemp(2)
	);
	adder2 : FA port map (
		a => A(2),
		b => B(2),
		s => S(2),
		CIN => Ctemp(2),
		COUT => Ctemp(3)
	);
	adder3 : FA port map (
		a => A(3),
		b => B(3),
		s => S(3),
		CIN => Ctemp(3),
		COUT => Ctemp(4)
	);
	adder4 : FA port map (
		a => A(4),
		b => B(4),
		s => S(4),
		CIN => Ctemp(4),
		COUT => Ctemp(5)
	);
	adder5 : FA port map (
		a => A(5),
		b => B(5),
		s => S(5),
		CIN => Ctemp(5),
		COUT => Ctemp(6)
	);
	adder6 : FA port map (
		a => A(6),
		b => B(6),
		s => S(6),
		CIN => Ctemp(6),
		COUT => Ctemp(7)
	);
	adder7 : FA port map (
		a => A(7),
		b => B(7),
		s => S(7),
		CIN => Ctemp(7),
		COUT => cout
	);

END dataflow;