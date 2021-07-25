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
