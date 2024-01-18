library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;
 

entity alu_wRCA is
	port(
		ALU_inA: in std_logic_vector(7 downto 0);
		ALU_inB: in std_logic_vector(7 downto 0);
		Operation: in std_logic_vector(1 downto 0);
		ALU_out: out std_logic_vector(7 downto 0);
		Carry: out std_logic;
		NotEq: out std_logic;
		Eq: out std_logic;
		isOutZero: out std_logic
	);
end alu_wRCA;

architecture meh of alu_wRCA is 
	
	signal AndOp : STD_LOGIC_VECTOR(7 downto 0);
	signal NotOp : STD_LOGIC_VECTOR(7 downto 0);
	signal Binv : STD_LOGIC_VECTOR(7 downto 0);
	signal SumPos : STD_LOGIC_VECTOR(7 downto 0);
	signal SumNeg : STD_LOGIC_VECTOR(7 downto 0);
	signal SumB : STD_LOGIC_VECTOR(7 downto 0);
	signal carrypos : STD_LOGIC;
	signal carryneg : STD_LOGIC;
	signal isZero : STD_LOGIC_VECTOR(7 downto 0);
	signal z0 : STD_LOGIC;
	signal car : STD_LOGIC;
	
	
	component RCA 
		PORT( 	A:	IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B:	IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		CIN:	IN STD_LOGIC;
		COUT:	OUT STD_LOGIC;
		S:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	
	component mux4to1
		port( 	w0, w1, w2, w3 :in STD_LOGIC_VECTOR(7 downto 0);
		s              :IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		f              :OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	component cmp
		port(
		a : in STD_LOGIC_VECTOR(7 downto 0);
		b : in STD_LOGIC_VECTOR(7 downto 0);
		EQ : out STD_LOGIC;
		NEQ : out STD_LOGIC
	);
	end component;
begin
	
	equal : cmp port map (
		a => ALU_inA,
		b => ALU_inB,
		EQ =>Eq,
		NEQ =>NotEq
	); 
	
	
	AndOp <= (ALU_inA and ALU_inB);
	NotOp <= (not ALU_inA);
	Binv <= (not ALU_inB);
	
									
					
	adderpos : RCA port map (
		A => ALU_inA,
		B => ALU_inB,
		CIN => '0',
		COUT => carrypos,
		S => SumPos
	);
	
	adderneg : RCA port map (
		A => ALU_inA,
		B => Binv,
		CIN => '1',
		COUT => carryneg,
		S => SumNeg
	);
	
	with Operation select 
		Carry <= 	carrypos when "00",
				carryneg when "01",
				'0' when others;
	
	
	
	
	Oper : mux4to1 port map(
		w0 => SumPos,
		w1 => SumNeg,
		w2 => AndOp,
		w3 => NotOp,
		s => Operation,
		f => isZero
		
	); 
	
	with isZero select
		isOutZero <= 	'1' when "00000000",
						'0' when others;

	ALU_out <= isZero;
end meh;