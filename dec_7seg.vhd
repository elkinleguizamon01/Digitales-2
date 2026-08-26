library ieee;
use ieee.std_logic_1164.all;

entity dec_7seg is
    port (
        bcd_in : in  std_logic_vector(3 downto 0);
        seg_out : out std_logic_vector(6 downto 0)
    );
end dec_7seg;

architecture behavioral of dec_7seg is
    signal seg_temp : std_logic_vector(6 downto 0);
begin

	process(bcd_in)
   begin
      case bcd_in is
         when "0000" => seg_temp <= "0111111";
         when "0001" => seg_temp <= "0000110";
         when "0010" => seg_temp <= "1011011";
         when "0011" => seg_temp <= "1001111";
         when "0100" => seg_temp <= "1100110";
         when "0101" => seg_temp <= "1101101";
         when "0110" => seg_temp <= "1111101";
         when "0111" => seg_temp <= "0000111";
         when "1000" => seg_temp <= "1111111";
         when "1001" => seg_temp <= "1101111";
         when others => seg_temp <= "0000000";
      end case;
   end process;

   seg_out <= not seg_temp;

end behavioral;