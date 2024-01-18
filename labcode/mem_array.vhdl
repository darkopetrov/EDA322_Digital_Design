library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.all;

entity mem_array is
 generic (
DATA_WIDTH: integer := 8;
ADDR_WIDTH: integer := 8;
INIT_FILE: string := "data_mem.mif"
);
Port (ADDR : in STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
DATAIN : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
CLK : in STD_LOGIC;
WE : in STD_LOGIC;
OUTPUT : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0));
end mem_array;

ARCHITECTURE behavioral OF mem_array IS
constant MEM_DEPTH: integer:= 2**ADDR_WIDTH;
Type MEMORY_ARRAY is ARRAY (0 to MEM_DEPTH-1) of STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

impure function init_memory_wfile(mif_file_name : in string) return MEMORY_ARRAY is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : MEMORY_ARRAY;
begin
    for i in MEMORY_ARRAY'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;
signal memArr : MEMORY_ARRAY:= init_memory_wfile(INIT_FILE);
BEGIN
    process(CLK)
    begin
        if(CLK'EVENT AND CLK = '1') then
            if (WE='1') then
                memArr(to_integer(unsigned(ADDR))) <= DATAIN;
            end if;
			
        end if;
    end process;
OUTPUT <= memArr(to_integer(unsigned(ADDR)));

END behavioral;