-- Librerías básicas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity principal is
    Port ( 
    bcd_in : in std_logic;
    seg_out : out std_logic_vector(6 downto 0)
    );

end principal;

architecture Behavioral of principal is
    signal salida : std_logic_vector(6 downto 0);
begin 

    process(bcd_in)
    begin
        case bcd_in is
            when '0' => seg_out <= "1100111"; -- 0
            when '1' => seg_out <= "0001111"; -- 1
				when others => seg_out <= "0000000";
        end case;
		  
    end process;

end Behavioral;
