-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
--ring rc
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RingRc is
port (
  Clk,  Ri:   in    std_logic;
  Ro:         out   std_logic;
  led:        out   unsigned  (3 downto 0)
  );
end RingRc;

architecture behavioral of RingRc is
signal  iCnt: unsigned  (21 downto 0)  :=  (others  =>'0');
signal  iLed: unsigned  (3 downto 0)  :=  x"0";
signal  iRin: std_logic               :=  '0';

begin
  Led <=iLed;
  process (Clk)
    begin
    if  rising_edge (Clk) then
      iRin  <= not Ri;
      iCnt  <= iCnt+1;
      if  ( iCnt  =(others =>'0'))  then    --4M /50M =0.1Sec
        Ro  <=  iLed(0);
        iLed  <=  (iRi  & iLed ( 3 downto 1));
      end if;
    end if;
  end process;
end behavioral;

--pin (Ro)   ---R (10k)--    |   ----- pin (Rin)
--                       C (47uF)
--                        GND          T=0.1Sec
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
 --soft start      
entity SftSta is
port	(
	Clk, Zc:	in	std_logic	:=	'0';
	Gt:			out	std_logic	:=	'0'
		);
end SftSta;

architecture	Behavioral of SftSta is
	signal	iCnt:	unsigned (13 downto 0);
	signal	iPwm:	unsigned (7  downto 0);
	signal	iCmp:	unsigned (7  downto 0)	:= to_unsigned(120,8);
	signal	iZcv:	unsigned (7  downto 0);
	signal	iZc:	std_logic;

begin
	process ( Clk)
	begin
		if	rising_edge	( Clk) then
			iCnt	<=iCnt+1;
			iZc		<=Zc;
			iZc	<=Zc(6 downto 0)	&iZc;
			
			if	( iCnt ( 5 downto 0)	="000000") then	--each 1us
				if	( iCnt 	=to_unsigned(50000,13)) then	--each 1us
					iCnt	<=(others =>'0');
					iPwm	<=iPwm+1;
					if	( iCmp	>0)	then
						iCmp	<=iCmp-1;
					else
						Gt	<='0';
					end if;
				end if;
			end if;
			
			if ( ( iZc	=x"0f") or ( iZc	=x"f0")) then
				iPwm	<=(others =>'0');				
			end if;	
			if	( iCmp	<=iPwm)	then
				Gt	<='0';
			else
				Gt	<='1';
			end if;
		end if;
	end process;
end Behavioral;
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
--zc sitch for toggle switch      
entity Sw is
port	(
	Clk, Zc,	Pls:	in	std_logic	:=	'0';
	Gt:					out	std_logic	:=	'0'
		);
end Sw;

architecture	Behavioral of Sw is
	signal	iPlsEdge:	unsigned (7  downto 0);
	signal	iCnt:	unsigned (13 downto 0);
	signal	iEdge:	std_logic;	
	signal	iPls:	std_logic;
	signal	iZc:	std_logic;
	signal	iOut:	std_logic;

begin
	Gt	<=iOut;
	process ( Clk)
	begin
		if	rising_edge	( Clk) then
			if	iEdge	='1'	then
				iCnt	<=iCnt+1;
			end if;
			
			if	( iCnt 	=to_unsigned(50000,13)) then	--each 1us
				iEdge	<='0';
			end if;
			
			iPlsEdge	<= iPlsEdge(5 downto 1)	&Pls	&iEdge;
			if ( iPlsEdge	=x"ff") then
				iOut	<=not iOut;
			end if;
			
			iPlsEdge	<= iPlsEdge(6 downto 0)	&zc;
			if ( ( iPlsEdge	=x"0f") or ( iPlsEdge	=x"f0")) then
				iEdge	<='1';
			end if;
		end if;
	end process;
end Behavioral;
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
--debounce push button
entity PbDbnc is
port	(
	i_Clk, i_Pb:	in	std_logic	:=	'0'
		);
end PbDbnc;

architecture	Behavioral of PbDbnc is
	signal	s_Cnt:		unsigned (17 downto 0);
	signal	s_CntPb:	unsigned (3  downto 0);
	signal	s_Pb_int:	std_logic;	
	signal	s_PbDbnc:	std_logic;

begin
	process ( Clk)
	begin
		if	rising_edge	( Clk) then
			s_Pb_int	<=i_Pb;
			s_Cnt	<=s_Cnt+1;			
			
			if	( s_Cnt 	=(others=>'0')) then	--each 5.2ms
				if	( s_Pb_int	='1')	then	--sw is open
					if ( s_CntPb(3)	='0')	then
						s_CntPb	<=s_CntPb+1;
					end if;
				else	--sw is close
					if ( s_CntPb	>(others=>'0'))	then
						s_CntPb	<=s_CntPb-1;
				end if;
			end if;
			
			if ( s_CntPb(3)	='1')	then
				s_PbDbnc	<='0';	--sw is open
			elsif ( s_CntPb	=(others=>'0'))	then
				s_PbDbnc	<='1';	--sw is close
			
			
			iPlsEdge	<= iPlsEdge(5 downto 1)	&Pls	&iEdge;
			if ( iPlsEdge	=x"ff") then
				iOut	<=not iOut;
			end if;
			
			iPlsEdge	<= iPlsEdge(6 downto 0)	&zc;
			if ( ( iPlsEdge	=x"0f") or ( iPlsEdge	=x"f0")) then
				iEdge	<='1';
			end if;
		end if;
	end process;
end Behavioral;
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

