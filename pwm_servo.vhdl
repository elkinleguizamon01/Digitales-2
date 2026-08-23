-- Quartus II VHDL Template

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pwm_servo is 
	generic(F_CLK     : integer := 50_000_000;
			  T_TRAMA   : integer := 1_000_000;
			  ANCHO_MIN : integer :=   50_000;
			  ANCHO_MAX : integer :=  100_000
			  );		  
	port   (clk       : in  std_logic;
			  rst       : in  std_logic;
			  angulo    : in  std_logic_vector(7 downto 0);
			  confirmar : in  std_logic;
			  pwm_out   : out std_logic
			  );	  
end entity pwm_servo;

architecture rtl of pwm_servo is 
	constant K : integer := (ANCHO_MAX-ANCHO_MIN)/180; 
	signal cnt  : integer range 0 to T_TRAMA-1 := 0;
	signal ancho: integer range 0 to ANCHO_MAX := ANCHO_MIN;
	signal angulo_reg: std_logic_vector(7 downto 0) := (others => '0');
	signal angulo_sat: integer range 0 to 180 := 0;
	signal btn_sync1, btn_sync2, btn_prev: std_logic := '0';

begin 
	angulo_sat <= 180 when (to_integer(unsigned(angulo_reg)) > 180)
	              else to_integer(unsigned(angulo_reg));
	ancho <= ANCHO_MIN + angulo_sat*K;
	process(clk)
	begin
		if rising_edge(clk) then
			btn_sync1 <= confirmar;
			btn_sync2 <= btn_sync1;
			btn_prev  <= btn_sync2;

			if rst = '1' then
				angulo_reg <= (others => '0');
			elsif (btn_sync2 = '1' and btn_prev = '0') then
				angulo_reg <= angulo;
			end if;
		end if;
	end process;

	process(clk)
	begin 
		if rising_edge(clk) then 
			if rst='1' or cnt=T_TRAMA-1 then 
				cnt <= 0;
			else 
				cnt <= cnt + 1; 
			end if;
		end if;
	end process;
	pwm_out <= '1' when cnt < ancho else '0';
end architecture rtl;
