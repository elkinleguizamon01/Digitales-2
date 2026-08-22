entity pwm_servo is 
	generic (F_CLK     : integer := 50_000_000;
			 T_TRAMA   : integer := 1_000_000;
			 ANCHO_MIN : integer :=   50_000;
			 ANCHO_MAX : integer :=  100_000;)
	port (  clk    : in std_logic;
			rst    : in std_logic;
			angulo  : in std_logic_vector ( 7 downto 0);
			pwm_out : out std_logic);
end entity pwm_servo;

architecture rtl pf pwm_servo is 
	constant K : integer := (ANCHO_MAX-ANCHO_MIN)/180; 
	signal cnt : integer range 0 to T_TRAMA-1 :=0;
	signal ancho : integer range 0 to T_TRAMA := ANCHO_MIN;
begin 
	ancho  <= ANCHO_MIN + to_integer(unsigned(angulo))*K;
	process(clk)
	begin 
		if rising_edge(clk) then 
			if rst='1' or cnt=T_TRAMA-1 then cnt <= 0;
			else cnt <= cnt + 1; end if;
		end if;
	end process;
	pwm_out <= '1' when cnt < ancho else '0';
end architecture rtl;
