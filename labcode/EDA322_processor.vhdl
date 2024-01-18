library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.all;

entity EDA322_processor is
	Port ( externalIn : in STD_LOGIC_VECTOR (7 downto 0); -- “extIn” in Figure 1
		CLK : in STD_LOGIC;
		master_load_enable: in STD_LOGIC;
		ARESETN : in STD_LOGIC;
		pc2seg : out STD_LOGIC_VECTOR (7 downto 0); -- PC
		instr2seg : out STD_LOGIC_VECTOR (11 downto 0); -- Instruction register
		Addr2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Address register
		dMemOut2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Data memory output
		aluOut2seg : out STD_LOGIC_VECTOR (7 downto 0); -- ALU output
		acc2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Accumulator
		flag2seg : out STD_LOGIC_VECTOR (3 downto 0); -- Flags
		busOut2seg : out STD_LOGIC_VECTOR (7 downto 0); -- Value on the bus
		disp2seg: out STD_LOGIC_VECTOR(7 downto 0); --Display register
		errSig2seg : out STD_LOGIC; -- Bus Error signal
		ovf : out STD_LOGIC; -- Overflow
		zero : out STD_LOGIC); -- Zero
end EDA322_processor;

architecture mysteri of EDA322_processor is 
	signal pc2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- PC
	signal instr2segtemp : STD_LOGIC_VECTOR (11 downto 0); -- Instruction register
	signal Addr2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- Address register
	signal dMemOut2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- Data memory output
	signal aluOut2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- ALU output
	signal acc2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- Accumulator
	signal flag2segtemp : STD_LOGIC_VECTOR (3 downto 0); -- Flags
	signal busOut2segtemp : STD_LOGIC_VECTOR (7 downto 0); -- Value on the bus
	signal disp2segtemp : STD_LOGIC_VECTOR(7 downto 0); --Display register
	signal errSig2segtemp : STD_LOGIC; -- Bus Error signal
	signal ovftemp : STD_LOGIC; -- Overflow
	signal zerotemp : STD_LOGIC; -- Zero



	--signal accSELECT : STD_LOGIC;
	signal accLdtemp : STD_LOGIC;
	signal accIn : STD_LOGIC_VECTOR(7 downto 0);
	
	signal dispLdtemp : STD_LOGIC;
	signal DataMemOut : STD_LOGIC_VECTOR(7 downto 0);
	signal insrMemOut : STD_LOGIC_VECTOR(11 downto 0);
	signal open1 : STD_LOGIC_VECTOR(11 downto 0);
	signal open2 : STD_LOGIC;
	signal PcIncrOut : STD_LOGIC_VECTOR(7 downto 0);
	signal nxtpc : STD_LOGIC_VECTOR(7 downto 0);
	signal tempStore: STD_LOGIC;
	signal InternalBus : STD_LOGIC_VECTOR(7 downto 0);
	signal im2bustemp : STD_LOGIC;
	signal dmRdtemp : STD_LOGIC;
	signal acc2bustemp : STD_LOGIC;
	signal ext2bustemp : STD_LOGIC;
	signal flag2segtemptemp : STD_LOGIC_VECTOR (3 downto 0);
	signal instrafseg : STD_LOGIC_VECTOR(7 downto 0);



	signal opcodetemp : STD_LOGIC_VECTOR(3 downto 0);
	signal carr, note, equ, zer : STD_LOGIC;
	signal pcSeltemp : STD_LOGIC;
	signal pcLdtemp : STD_LOGIC;
	signal instrLdtemp : STD_LOGIC;
	signal addrMdtemp : STD_LOGIC;
	signal dmWrtemp : STD_LOGIC;
	signal dataLdtemp : STD_LOGIC;
	signal accSELtemp : STD_LOGIC;
	signal aluMdtemp : STD_LOGIC_VECTOR(1 downto 0);
	signal flagLdtemp : STD_LOGIC;
	
	signal flagEQ : STD_LOGIC; 
	signal flagNEQ : STD_LOGIC;

	
	
	
	
	
	component regn is port(
		D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Enable, Clock : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	
	component regn12 is port (
		D : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        Enable, Clock : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
	end component;
	
	component regn4 is port (
		D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Enable, Clock : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	end component;
	
	component alu_wRCA is port (
		ALU_inA: in std_logic_vector(7 downto 0);
		ALU_inB: in std_logic_vector(7 downto 0);
		Operation: in std_logic_vector(1 downto 0);
		ALU_out: out std_logic_vector(7 downto 0);
		Carry: out std_logic;
		NotEq: out std_logic;
		Eq: out std_logic;
		isOutZero: out std_logic);
	end component;
	
	component procBus is port (
		INSTRUCTION : in  STD_LOGIC_VECTOR (7 downto 0);
        DATA :in  STD_LOGIC_VECTOR (7 downto 0);
        ACC : in  STD_LOGIC_VECTOR (7 downto 0);
        EXTDATA : in  STD_LOGIC_VECTOR (7 downto 0);
        OUTPUT : out  STD_LOGIC_VECTOR (7 downto 0);
        ERR : out  STD_LOGIC;
        instrSEL : in  STD_LOGIC;
        dataSEL : in  STD_LOGIC;
        accSEL : in  STD_LOGIC;
        extdataSEL : in  STD_LOGIC);
	end component;
	
	component mem_array is 
		 generic (
			DATA_WIDTH: integer := 12;
			ADDR_WIDTH: integer := 8;
			INIT_FILE: string := "inst_mem.mif"
		);
		Port (ADDR : in STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
			DATAIN : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			CLK : in STD_LOGIC;
			WE : in STD_LOGIC;
			OUTPUT : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0));
	end component;
	
	component mux2to1 is port (
		w0, w1			:in STD_LOGIC_VECTOR(7 downto 0);
		s              :IN STD_LOGIC;
		f              :OUT STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component RCA is port (
    A:    IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    B:    IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    CIN:    IN STD_LOGIC;
    COUT:    OUT STD_LOGIC;
    S:    OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

	component procController is Port ( master_load_enable: in STD_LOGIC;
		opcode : in STD_LOGIC_VECTOR (3 downto 0);
		neq : in STD_LOGIC;
		eq : in STD_LOGIC;
		CLK : in STD_LOGIC;
		ARESETN : in STD_LOGIC;
		pcSel : out STD_LOGIC;
		pcLd : out STD_LOGIC;
		instrLd : out STD_LOGIC;
		addrMd : out STD_LOGIC;
		dmWr : out STD_LOGIC;
		dataLd : out STD_LOGIC;
		flagLd : out STD_LOGIC;
		accSel : out STD_LOGIC;
		accLd : out STD_LOGIC;
		im2bus : out STD_LOGIC;
		dmRd : out STD_LOGIC;
		acc2bus : out STD_LOGIC;
		ext2bus : out STD_LOGIC;
		dispLd: out STD_LOGIC;
		aluMd : out STD_LOGIC_VECTOR(1 downto 0));
	end component;
	

begin
--	pc2segtemp <="00000000";
--	PcIncrOut <="00000000";
--	nxtPc <="00000000";
	

	Mastermind : procController port map (
		master_load_enable => master_load_enable,
		opcode => opcodetemp,
		neq => flagNEQ,
		eq => flagEQ,
		CLK => CLK,
		ARESETN => ARESETN,
		pcSel => pcSeltemp,
		pcLd => pcLdtemp,
		instrLd => instrLdtemp,
		addrMd => addrMdtemp,
		dmWr => dmWrtemp,
		dataLd => dataLdtemp,
		flagLd => flagLdtemp,
		accSel => accSELtemp,
		accLd => accLdtemp,
		im2bus => im2bustemp,
		dmRd => dmRdtemp,
		acc2bus => acc2bustemp,
		ext2bus => ext2bustemp,
		dispLd => dispLdtemp,
		aluMd => aluMdtemp
		
	);




	Internal_Bus : procBus port map (
		INSTRUCTION => instrafseg,
        DATA => dMemOut2segtemp,
        ACC => acc2segtemp,
        EXTDATA => externalIn,
        OUTPUT => InternalBus,
        ERR => errSig2segtemp,
        instrSEL => im2bustemp,
        dataSEL => dmRdtemp,
        accSEL => acc2bustemp,
        extdataSEL => ext2bustemp
	);
		
	alusel : mux2to1 port map (
		w0 =>aluOut2segtemp,
		w1 =>InternalBus,
		s =>accSELtemp,
		f =>accIn
	);


	ACC : regn port map (
		D => accIn,
		Enable => accLdtemp, 
		Clock =>CLK, 
		Q =>acc2segtemp
	);
	
	ALU : alu_wRCA port map (
		ALU_inA =>acc2segtemp,
		ALU_inB =>InternalBus,
		Operation =>aluMdtemp,
		ALU_out =>aluOut2segtemp,
		Carry =>carr,
		NotEq =>note,
		Eq =>equ,
		isOutZero =>zer
	);
	flag2segtemptemp <= carr & note & equ & zer;
	
	FReg : regn4 port map(
		D => flag2segtemptemp,
		Enable => flagLdtemp, 
		Clock =>CLK, 
		Q =>flag2segtemp
	);
	flagEQ<=flag2segtemp(1);
	flagNEQ<=flag2segtemp(2);
	ovftemp <=flag2segtemp(3);
	zerotemp <=flag2segtemp(0);

	Dysplay : regn port map(
		D => acc2segtemp,
		Enable => dispLdtemp, 
		Clock =>CLK, 
		Q =>disp2segtemp
	);
	
	Data_Mem : mem_array 
	generic map (
		DATA_WIDTH => 8,
		ADDR_WIDTH => 8,
		INIT_FILE => "data_mem.mif"
	)
	port map (
		ADDR =>Addr2segtemp,
		DATAIN =>InternalBus,
		CLK =>CLK,
		WE =>dmWrtemp,
		OUTPUT =>DataMemOut
	);
	
	InsrMemAddr : mem_array 
	generic map (
		DATA_WIDTH => 12,
		ADDR_WIDTH => 8,
		INIT_FILE => "inst_mem.mif"
	)
	port map (
		ADDR => pc2segtemp,
		DATAIN =>open1,
		CLK =>CLK,
		WE =>open2,
		OUTPUT => insrMemOut
	);
	
	PcMux: mux2to1 port map(
        w0 => PCIncrOut,
        w1 => InternalBus,
        s => pcSeltemp,
        f => nxtPc
    ); 	

    PCincr_gen: RCA port map(
        A        =>pc2segtemp,
        B        =>"00000001",
        CIN        =>'0',
        COUT    =>tempStore,
        S         =>PCIncrOut
    );
	
	FE : Regn port map (
		D => nxtPc,
		Enable => pcLdtemp, 
		Clock =>CLK, 
		Q => pc2segtemp
	);
	
	
	
	
	FE_DE : regn12 port map (
		D => insrMemOut,
		Enable => instrLdtemp, 
		Clock =>CLK, 
		Q => instr2segtemp
	);
	opcodetemp <= instr2segtemp(11 downto 8);
	instrafseg <= instr2segtemp(7 downto 0);
	
	addrMdS : mux2to1 port map (
		w0 =>instrafseg,
		w1 =>dMemOut2segtemp,
		s =>addrMdtemp,
		f =>Addr2segtemp
	);
	
	
	DE_DX : Regn port map (
		D => DataMemOut,
		Enable => dataLdtemp, 
		Clock =>CLK, 
		Q => dMemOut2segtemp
	);

	










	pc2seg <= pc2segtemp;
	instr2seg <= instr2segtemp;
	Addr2seg <= Addr2segtemp;
	dMemOut2seg <= dMemOut2segtemp;
	aluOut2seg <= aluOut2segtemp;
	acc2seg <= acc2segtemp;
	flag2seg <= flag2segtemp;
	busOut2seg <= InternalBus;
	disp2seg<= disp2segtemp;
	errSig2seg <= errSig2segtemp;
	ovf <= ovftemp;
	zero <= zerotemp;

 


end mysteri;