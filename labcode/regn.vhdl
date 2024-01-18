LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regn IS
    PORT(    D        :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Enable, Clock    :IN STD_LOGIC;
        Q        :OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END regn;

ARCHITECTURE behavioral OF regn IS
signal qtemp : STD_LOGIC_VECTOR(7 downto 0) :="00000000";
BEGIN
    PROCESS(Clock)
    BEGIN
        IF(Clock'EVENT AND Clock = '1') THEN
            IF Enable = '1' Then
                qtemp <= D;
            END IF;
        END IF;
    END PROCESS;
	Q <= qtemp;
END behavioral;