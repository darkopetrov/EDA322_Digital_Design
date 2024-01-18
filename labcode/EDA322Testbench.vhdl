library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.all;

entity EDA322Testbench is
	port(
		disp2seg : out STD_LOGIC_VECTOR(7 downto 0); --Display register
		acc2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Accumulator
		pc2seg : out STD_LOGIC_VECTOR (7 downto 0); -- PC
		dMemOut2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Data memory output
		flag2seg : out STD_LOGIC_VECTOR (3 downto 0) -- Flags
	);
end EDA322Testbench;

architecture examenor of EDA322Testbench is 

	Signal disp2segtemp :  STD_LOGIC_VECTOR(7 downto 0); --Display register
	signal	acc2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- Accumulator
	signal	pc2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- PC
	signal	dMemOut2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- Data memory output
	signal	flag2segtemp : STD_LOGIC_VECTOR (3 downto 0); -- Flags

signal test_time_step : integer := 0;
signal CLK:  std_logic := '0';
signal ARESETN:  std_logic := '0';
signal master_load_enable:  std_logic := '0';



signal addr2seg: std_logic_vector(7 downto 0);
signal instr2seg: std_logic_vector(11 downto 0);
signal aluOut2seg: std_logic_vector(7 downto 0);
signal busOut2seg: std_logic_vector(7 downto 0);
signal errSig2seg: std_logic;
signal ovf: std_logic;
signal zero: std_logic;




component EDA322_processor is
    Port ( externalIn : in  STD_LOGIC_VECTOR (7 downto 0);
			CLK : in STD_LOGIC;
			master_load_enable: in STD_LOGIC;
			ARESETN : in STD_LOGIC;
			pc2seg : out  STD_LOGIC_VECTOR (7 downto 0);
			instr2seg : out  STD_LOGIC_VECTOR (11 downto 0);
			Addr2seg : out  STD_LOGIC_VECTOR (7 downto 0);
			dMemOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
			aluOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
			acc2seg : out  STD_LOGIC_VECTOR (7 downto 0);
			flag2seg : out  STD_LOGIC_VECTOR (3 downto 0);
			busOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);
			disp2seg: out STD_LOGIC_VECTOR(7 downto 0);
			errSig2seg : out STD_LOGIC;
			ovf : out STD_LOGIC;
			zero : out STD_LOGIC);
end component;


type acctrace_CRATE is ARRAY (1 to 30) of STD_LOGIC_VECTOR(7 DOWNTO 0);
impure function init_acctrace_wfile(mif_file_name : in string) return acctrace_CRATE is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(7 downto 0);
    variable temp_mem : acctrace_CRATE;
	begin
    for i in acctrace_CRATE'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;
signal acctrace : acctrace_CRATE:= init_acctrace_wfile("acctrace.txt");


type dMemOuttrace_CRATE is ARRAY (1 to 20) of STD_LOGIC_VECTOR(7 DOWNTO 0);
impure function init_dMemOuttrace_wfile(mif_file_name : in string) return dMemOuttrace_CRATE is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(7 downto 0);
    variable temp_mem : dMemOuttrace_CRATE;
	begin
    for i in dMemOuttrace_CRATE'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;
signal dMemOuttrace : dMemOuttrace_CRATE:= init_dMemOuttrace_wfile("dMemOuttrace.txt");






type flagtrace_CRATE is ARRAY (1 to 20) of STD_LOGIC_VECTOR(7 DOWNTO 0);
impure function init_flagtrace_wfile(mif_file_name : in string) return flagtrace_CRATE is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(7 downto 0);
    variable temp_mem : flagtrace_CRATE;
	begin
    for i in flagtrace_CRATE'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;
signal flagtrace : flagtrace_CRATE:= init_flagtrace_wfile("flagtrace.txt");


type pctrace_CRATE is ARRAY (1 to 66) of STD_LOGIC_VECTOR(7 DOWNTO 0);
impure function init_pctrace_wfile(mif_file_name : in string) return pctrace_CRATE is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(7 downto 0);
    variable temp_mem : pctrace_CRATE;
	begin
    for i in pctrace_CRATE'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;
signal pctrace : pctrace_CRATE:= init_pctrace_wfile("pctrace.txt");


type disptrace_CRATE is ARRAY (1 to 10) of STD_LOGIC_VECTOR(7 DOWNTO 0);
impure function init_disptrace_wfile(mif_file_name : in string) return disptrace_CRATE is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(7 downto 0);
    variable temp_mem : disptrace_CRATE;
	begin
    for i in disptrace_CRATE'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;
signal disptrace : disptrace_CRATE:= init_disptrace_wfile("disptrace.txt");



--signal a, b, c, d, e: integer :=1;
--signal pctrace_chek : integer :=1;
--signal testpc : STD_LOGIC_VECTOR(7 downto 0);
--signal test_passed : STD_LOGIC:='0';
signal zeroes : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal flag8seg : STD_LOGIC_VECTOR(7 downto 0);


begin


CLK <= not CLK after 5 ns; -- CLK with period of 10ns
process (CLK)
begin
	if rising_edge(CLK) then
		test_time_step <= test_time_step + 1;
		master_load_enable <= not master_load_enable;
	else
		master_load_enable <= not master_load_enable;
	end if;
	if test_time_step = 2 then
		ARESETN <= '1'; -- release reset
	end if;
end process;

EDA322_dut : EDA322_processor port map (
           externalIn => "00000000",
	   CLK => CLK,
	   master_load_enable => master_load_enable, -- flipflop load enables for single step mode
	   ARESETN =>ARESETN,
           pc2seg => pc2segtemp, -- 8 bit
           instr2seg => instr2seg, -- 12 bit
           Addr2seg => addr2seg, --8 bit
           dMemOut2seg => dMemOut2segtemp, -- 8 bit
           aluOut2seg => aluOut2seg, -- 8 bit
           acc2seg => acc2segtemp, --8 bit
           flag2seg => flag2segtemp, -- 4bit
           busOut2seg => busOut2seg, -- 8 bit
	   disp2seg => disp2segtemp, -- 8 bit
	   errSig2seg => errSig2seg, -- 1 bit -- to LED
	   ovf => ovf, --1 bit -- to LED
	   zero => zero -- 1 bit -- to LED
	  );



	process(disp2segtemp)
		variable a: integer:=1;
	begin
		if(ARESETN='1') then
				--a1:=a;
				--if(a/=10)then
				assert(disp2segtemp=disptrace(a)) report "Test failed" severity failure;
				
					a:=a+1;
				--end if;
				assert(disp2segtemp/="10010000") report "Test passed" severity failure;
				
		end if;
	end process;
	
	process(pc2segtemp)
		variable b:integer:=1;
		begin
		if(ARESETN='1')then
		
			assert(pc2segtemp=pctrace(b)) report "Test failed" severity failure;
			
				b:=b+1;
		end if;
	end process;
	
	process(dMemOut2segtemp)
		variable c:integer:=1;
		begin
		if(ARESETN='1')then
			assert(dMemOut2segtemp=dMemOuttrace(c)) report "Test failed" severity failure;
				c:=c+1;
		end if;
	end process;
	
	process(acc2segtemp)
		variable d:integer:=1;
		begin
		if(ARESETN='1')then
			assert(acc2segtemp=acctrace(d)) report "Test failed" severity failure;
			
				d:=d+1;
		end if;
	end process;
	flag8seg<= zeroes & flag2segtemp;
	process(flag8seg)
		variable e:integer:=1;
		begin
		if(ARESETN='1')then
			assert(flag8seg=flagtrace(e)) report "Test failed" severity failure;
			
				e:=e+1;
		end if;
	end process;






disp2seg<=disp2segtemp;
pc2seg <=pc2segtemp;
dMemOut2seg <= dMemOut2segtemp;
acc2seg <= acc2segtemp;
flag2seg<=flag2segtemp;

end examenor;