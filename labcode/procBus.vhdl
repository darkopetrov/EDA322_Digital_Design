library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.all;


entity procBus is
    Port (  INSTRUCTION : in  STD_LOGIC_VECTOR (7 downto 0);
            DATA :in  STD_LOGIC_VECTOR (7 downto 0);
            ACC : in  STD_LOGIC_VECTOR (7 downto 0);
            EXTDATA : in  STD_LOGIC_VECTOR (7 downto 0);
            OUTPUT : out  STD_LOGIC_VECTOR (7 downto 0);
            ERR : out  STD_LOGIC;
            instrSEL : in  STD_LOGIC;
            dataSEL : in  STD_LOGIC;
            accSEL : in  STD_LOGIC;
            extdataSEL : in  STD_LOGIC
        );
end procBus;

ARCHITECTURE behavioral OF procBus IS
signal temp : STD_LOGIC;
signal Operation : STD_LOGIC_VECTOR(1 downto 0);
signal sel : STD_LOGIC_VECTOR(3 downto 0);
signal fow : STD_LOGIC_VECTOR(7 downto 0);

component mux4to1
        port(     w0, w1, w2, w3 :in STD_LOGIC_VECTOR(7 downto 0);
        s              :IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        f              :OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

BEGIN

    temp <= ((instrSEL AND dataSEL) OR (instrSEL AND accSEL) OR (instrSEL AND extdataSEL) OR (dataSEL AND accSEL) OR (dataSEL AND extdataSEL) OR (accSEL AND extdataSEL));
    ERR <= temp;
   sel<= instrSEL & dataSEL & accSEL & extdataSEL;
   with sel select 
   Operation<=	"00" when "1000",
				"01" when "0100",
				"10" when "0010",
				"11" when others;
			--	"--" when others;
  

Oper : mux4to1 port map(
        w0 => INSTRUCTION,
        w1 => DATA,
        w2 => ACC,
        w3 => EXTDATA,
        s => Operation,
        f => fow

    );
	
	OUTPUT <= fow;
END behavioral;