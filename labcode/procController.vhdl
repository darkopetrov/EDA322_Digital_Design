library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.all;

entity procController is
	Port ( master_load_enable: in STD_LOGIC;
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
end procController;

architecture boss of procController is

type State_type is (FE, DE1, DE2, EX, ME);
signal curr_state , next_state : State_type;




BEGIN

	process(CLK,ARESETN)
		
	begin
	
	
	
	
	if(ARESETN='0') then
		curr_state<=FE;
	else
	if (CLK = '1' AND CLK'event and master_load_enable='1')THEN
		curr_state<=next_state;
	end if;
	end if;
	end process;
	
	
	
	
	
	
	
	process(curr_state,opcode,eq,neq)
		variable FE_DE1, DE1_DE2, DE2_EX,DE1_EX,DE2_ME,DE1_ME,EX_ME:STD_LOGIC;
		variable a,b,c,d,na,nb,nc,nd : STD_LOGIC;
	begin
	a:=opcode(3);
	b:=opcode(2);
	c:=opcode(1);
	d:=opcode(0);
	na:=not a;
	nb:=not b;
	nc:=not c;
	nd:=not d;
	FE_DE1:= '1';
	DE1_DE2:= (na and c and  d) or (na and b and nc and nd);
	DE2_EX:=(na and c and d);
	DE1_EX:=(a and nb) or (nb and nc) or (a and c and d) or (na and b and c and nd);
	DE2_ME:=((na and b) and (nc and nd));
	DE1_ME:=((na and nb) and (c and nd));
	EX_ME:='0';
	
	
			


	
	
	case curr_state is 
		when FE =>
		if FE_DE1='1'then
			next_state<=DE1;
		else
			next_state<=FE;
		end if;
		pcSel<='0';
		pcLd<='0';
		instrLd<='1';
		addrMd<='0';
		dmWr<='0';
		dataLd<='0';
		flagLd<='0';
		accSel<='0';
		accLd<='0';
		im2bus<=((a and b and nc) or (a and b and nd));--0
		dmRd<='0';
		acc2bus<=((na and nb and c and nd) or (na and b and nc and nd));--0
		ext2bus<=(na and b and nc and d);--0
		dispLd<='0';

		
		
		
		
		
		when DE1 =>
		--pcSel<=(((a and b) and nc) or ((a and b) and (c and nd)));
		if (DE1_DE2='1')then
			next_state <= DE2;
		elsif(DE1_EX='1')then
			next_state <= EX;
		elsif(DE1_ME='1')then
			next_state <= ME;
		else 
			next_state <=FE;
		end if;
		
		
		if ( (a and b and nc and d)='1') then 
			pcSel<=eq;--0
		elsif((a and b and c and nd)='1')then
			pcSel<=neq;
		else
			pcSel<=(a and b and nc and nd);
		end if;
		
		
		
		pcLd<=((a and b and nd)or(b and nc and d));--0
		instrLd<='1';
		addrMd<='0';
		dmWr<=(na and b and nc and d);--0
		dataLd<=((a and nb)or(na and nc and nd)or(na and nb and d)or(na and b and c));--1
		flagLd<='0';
		accSel<='0';
		accLd<='0';
		im2bus<=((a and b and nc) or (a and b and nd));--0
		dmRd<='0';
		acc2bus<=((na and nb and c and nd) or (na and b and nc and nd));--0
		ext2bus<=(na and b and nc and d);--0
		dispLd<='0';
if(((na and nb and nc and nd) or (na and b and nc and d) or (na and b and c and d) or (na and b and c and nd) or (a and b and c and d))='1') then 
					aluMd<="00";
				elsif((a and nb and nc and nd)='1') then
					aluMd<="01";
				elsif((a and nb and c and nd)='1') then
					aluMd<="10";
				else
					aluMd<="11";
			end if;
		
		
		
		
		
			
		when DE2 =>
		if(DE2_EX='1')then
			next_state <= EX;
		elsif(DE2_ME='1')then
			next_state <= ME;
		else 
			next_state <=FE;
		end if;
		
		pcSel<='0';
		pcLd<='0';
		instrLd<='1';
		addrMd<=(na and c and d);
		dmWr<='0';
		dataLd<=((na and b and c)or(na and nb and c and d));
		flagLd<='0';
		accSel<='0';
		accLd<='0';
		im2bus<=((a and b and nc) or (a and b and nd));
		dmRd<='0';
		acc2bus<=((na and nb and c and nd) or (na and b and nc and nd));
		ext2bus<=(na and b and nc and d);
		dispLd<='0';
if(((na and nb and nc and nd) or (na and b and nc and d) or (na and b and c and d) or (na and b and c and nd) or (a and b and c and d))='1') then 
					aluMd<="00";
				elsif((a and nb and nc and nd)='1') then
					aluMd<="01";
				elsif((a and nb and c and nd)='1') then
					aluMd<="10";
				else
					aluMd<="11";
			end if;
		
		
		
		
		
		
		when EX =>
		if(EX_ME='1')then
			next_state <= ME;
		else 
			next_state <=FE;
			end if;
			
		pcSel<='0';
		pcLd<=((a and nb) or (c and d) or (na and nb and nc) or (na and b and c));
		instrLd<='1';
		addrMd<='0';
		dmWr<='0';
		dataLd<='0';
		flagLd<=((a and nb)or(nb and nc and nd)or(na and b and c));
		accSel<=(na and nb and d);
		accLd<=((nb and nc)or(na and c and d)or(na and b and c)or(a and nb and nd));
		im2bus<=((a and b and nc) or (a and b and nd));
		dmRd<=((nb and nc)or(a and nb)or(na and b and c)or(na and c and d));
		acc2bus<=((na and nb and c and nd) or (na and b and nc and nd));
		ext2bus<=(na and b and nc and d);
		dispLd<=(a and b and c and d);
if(((na and nb and nc and nd) or (na and b and nc and d) or (na and b and c and d) or (na and b and c and nd) or (a and b and c and d))='1') then 
					aluMd<="00";
				elsif((a and nb and nc and nd)='1') then
					aluMd<="01";
				elsif((a and nb and c and nd)='1') then
					aluMd<="10";
				else
					aluMd<="11";
			end if;
			
			
			
			
			
			
			
		when ME => 
		next_state<=FE;
		
		pcSel<='0';
		pcLd<=((na and nb and c and nd)or(na and b and nc and nd));
		instrLd<='1';
		addrMd<=(na and b and nc and nd);
		dmWr<=((na and nb and c and nd)or(na and b and nc and nd));
		dataLd<='0';
		flagLd<='0';
		accSel<='0';
		accLd<='0';
		im2bus<=((a and b and nc) or (a and b and nd));
		dmRd<='0';
		acc2bus<=((na and nb and c and nd) or (na and b and nc and nd));
		ext2bus<=(na and b and nc and d);
		dispLd<='0';
if(((na and nb and nc and nd) or (na and b and nc and d) or (na and b and c and d) or (na and b and c and nd) or (a and b and c and d))='1') then 
					aluMd<="00";
				elsif((a and nb and nc and nd)='1') then
					aluMd<="01";
				elsif((a and nb and c and nd)='1') then
					aluMd<="10";
				else
					aluMd<="11";
			end if;
		
		
		
	end case;
	
	
	
	

--	end if;
--	end if;
	
	
	
	
	end process;


end boss;