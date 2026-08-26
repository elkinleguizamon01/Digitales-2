library ieee;
use ieee.std_logic_1164.all;

entity bcd_sfun is
	port (
		bin_in :in  std_logic_vector(10 downto 0);
      uni:out std_logic_vector(3 downto 0);
      dec:out std_logic_vector(3 downto 0);
      cen:out std_logic_vector(3 downto 0);
      mil:out std_logic_vector(3 downto 0)
	);
end bcd_sfun;

architecture Behavioral of bcd_sfun is
begin
	process(bin_in)
		variable var: std_logic_vector(12 downto 0);
      variable m:std_logic_vector(12 downto 0);
      variable c:std_logic_vector(12 downto 0);
      variable d:std_logic_vector(12 downto 0);
      variable r:std_logic_vector(12 downto 0);
      variable b:std_logic_vector(12 downto 0);
      variable carry: std_logic;
      variable ge: std_logic;
	begin
		var:= "00" & bin_in;
      m:=(others => '0');
      c:=(others => '0');
      d:=(others => '0');

      b := not "0001111101000";
      carry := '1';
      for j in 0 to 12 loop
			r(j) := var(j) xor b(j) xor carry;
         carry := (var(j) and b(j)) or (carry and (var(j) xor b(j)));
      end loop;
      ge := carry;
		if ge = '1' then
         b := not "0001111101000";
         carry := '1';
         for j in 0 to 12 loop
				r(j):= var(j) xor b(j) xor carry;
				carry:=(var(j) and b(j)) or (carry and (var(j) xor b(j)));
         end loop;
         var:= r;
         b := "0000000000001";
         carry := '0';
         for j in 0 to 12 loop
            r(j) := m(j) xor b(j) xor carry;
				carry := (m(j) and b(j)) or (carry and (m(j) xor b(j)));
         end loop;
			m := r;
		end if;

      for i in 1 to 9 loop
          b := not "0000001100100";
          carry := '1';
          for j in 0 to 12 loop
				r(j) := var(j) xor b(j) xor carry;
             carry := (var(j) and b(j)) or (carry and (var(j) xor b(j)));
          end loop;
          ge:= carry;
          if ge= '1' then
             b := not "0000001100100";
             carry := '1';
             for j in 0 to 12 loop
                r(j) := var(j) xor b(j) xor carry;
                carry := (var(j) and b(j)) or (carry and (var(j) xor b(j)));
             end loop;
             var:= r;
             b:= "0000000000001";
             carry := '0';
             for j in 0 to 12 loop
                r(j):= c(j) xor b(j) xor carry;
                carry := (c(j) and b(j)) or (carry and (c(j) xor b(j)));
             end loop;
             c := r;
          end if;
		end loop;
		
      for i in 1 to 9 loop
			b := not "0000000001010";
         carry := '1';
         for j in 0 to 12 loop
            r(j) := var(j) xor b(j) xor carry;
            carry := (var(j) and b(j)) or (carry and (var(j) xor b(j)));
         end loop;
         ge := carry;
         if ge = '1' then
            b := not "0000000001010";
            carry := '1';
            for j in 0 to 12 loop
               r(j):= var(j) xor b(j) xor carry;
               carry:= (var(j) and b(j)) or (carry and (var(j) xor b(j)));
            end loop;
            var:= r;
            b :="0000000000001";
            carry:='0';
            for j in 0 to 12 loop
               r(j) := d(j) xor b(j) xor carry;
               carry := (d(j) and b(j)) or (carry and (d(j) xor b(j)));
            end loop;
            d := r;
         end if;
      end loop;

      uni <= var(3 downto 0);
      dec <= d(3 downto 0);
      cen <= c(3 downto 0);
      mil <= m(3 downto 0);
	end process;
end Behavioral;