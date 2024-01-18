LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regn12 IS
    PORT(    D        :IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        Enable, Clock    :IN STD_LOGIC;
        Q        :OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
END regn12;

ARCHITECTURE behavioral OF regn12 IS
BEGIN
    PROCESS(Clock)
    BEGIN
        IF(Clock'EVENT AND Clock = '1') THEN
            IF Enable = '1' Then
                Q <= D;
            END IF;
        END IF;
    END PROCESS;
END behavioral;