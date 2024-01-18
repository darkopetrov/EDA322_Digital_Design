LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regn4 IS
    PORT(    D        :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Enable, Clock    :IN STD_LOGIC;
        Q        :OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END regn4;

ARCHITECTURE behavioral OF regn4 IS
signal QTEMP : STD_LOGIC_VECTOR(3 downto 0);
BEGIN
    PROCESS(Clock)
    BEGIN
        IF(Clock'EVENT AND Clock = '1') THEN
            IF Enable = '1' Then
                QTEMP <= D;
            END IF;
        END IF;
    END PROCESS;
	Q<=QTEMP;
END behavioral;