library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity command_parser is
    generic (
        PAN_INITIAL_ANGLE  : integer := 90;
        PAN_MIN_ANGLE      : integer := 0;
        PAN_MAX_ANGLE      : integer := 180;

        TILT_INITIAL_ANGLE : integer := 90;
        TILT_MIN_ANGLE     : integer := 50;
        TILT_MAX_ANGLE     : integer := 130
    );
    port (
        clk   : in  std_logic;
        reset : in  std_logic;

        rx_data  : in  std_logic_vector(7 downto 0);
        rx_valid : in  std_logic;

        pan_angle     : out integer range 0 to 180;
        tilt_angle    : out integer range 0 to 180;
        selected_axis : out std_logic
    );
end entity command_parser;

architecture rtl of command_parser is

    type state_type is (WAIT_AXIS, WAIT_DIGIT1, WAIT_DIGIT2, WAIT_DIGIT3, WAIT_ENTER);
    signal state : state_type := WAIT_AXIS;

    signal axis_reg : std_logic := '0';

    signal digit1 : integer range 0 to 9 := 0;
    signal digit2 : integer range 0 to 9 := 0;
    signal digit3 : integer range 0 to 9 := 0;

    signal pan_reg  : integer range 0 to 180 := PAN_INITIAL_ANGLE;
    signal tilt_reg : integer range 0 to 180 := TILT_INITIAL_ANGLE;

begin

    pan_angle     <= pan_reg;
    tilt_angle    <= tilt_reg;
    selected_axis <= axis_reg;

    process(clk)
        variable digit1_value : integer range 0 to 900;
        variable digit2_value : integer range 0 to 90;
        variable digit3_value : integer range 0 to 9;
        variable angle_value  : integer range 0 to 999;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= WAIT_AXIS;
                axis_reg <= '0';
                digit1 <= 0;
                digit2 <= 0;
                digit3 <= 0;
                pan_reg  <= PAN_INITIAL_ANGLE;
                tilt_reg <= TILT_INITIAL_ANGLE;
            else
                if rx_valid = '1' then
                    case state is

                        when WAIT_AXIS =>
                            if rx_data = x"50" then
                                axis_reg <= '0';
                                state <= WAIT_DIGIT1;
                            elsif rx_data = x"54" then
                                axis_reg <= '1';
                                state <= WAIT_DIGIT1;
                            end if;

                        when WAIT_DIGIT1 =>
                            case rx_data is
                                when x"30" => digit1 <= 0; state <= WAIT_DIGIT2;
                                when x"31" => digit1 <= 1; state <= WAIT_DIGIT2;
                                when x"32" => digit1 <= 2; state <= WAIT_DIGIT2;
                                when x"33" => digit1 <= 3; state <= WAIT_DIGIT2;
                                when x"34" => digit1 <= 4; state <= WAIT_DIGIT2;
                                when x"35" => digit1 <= 5; state <= WAIT_DIGIT2;
                                when x"36" => digit1 <= 6; state <= WAIT_DIGIT2;
                                when x"37" => digit1 <= 7; state <= WAIT_DIGIT2;
                                when x"38" => digit1 <= 8; state <= WAIT_DIGIT2;
                                when x"39" => digit1 <= 9; state <= WAIT_DIGIT2;
                                when others => state <= WAIT_AXIS;
                            end case;

                        when WAIT_DIGIT2 =>
                            case rx_data is
                                when x"30" => digit2 <= 0; state <= WAIT_DIGIT3;
                                when x"31" => digit2 <= 1; state <= WAIT_DIGIT3;
                                when x"32" => digit2 <= 2; state <= WAIT_DIGIT3;
                                when x"33" => digit2 <= 3; state <= WAIT_DIGIT3;
                                when x"34" => digit2 <= 4; state <= WAIT_DIGIT3;
                                when x"35" => digit2 <= 5; state <= WAIT_DIGIT3;
                                when x"36" => digit2 <= 6; state <= WAIT_DIGIT3;
                                when x"37" => digit2 <= 7; state <= WAIT_DIGIT3;
                                when x"38" => digit2 <= 8; state <= WAIT_DIGIT3;
                                when x"39" => digit2 <= 9; state <= WAIT_DIGIT3;
                                when others => state <= WAIT_AXIS;
                            end case;

                        when WAIT_DIGIT3 =>
                            case rx_data is
                                when x"30" => digit3 <= 0; state <= WAIT_ENTER;
                                when x"31" => digit3 <= 1; state <= WAIT_ENTER;
                                when x"32" => digit3 <= 2; state <= WAIT_ENTER;
                                when x"33" => digit3 <= 3; state <= WAIT_ENTER;
                                when x"34" => digit3 <= 4; state <= WAIT_ENTER;
                                when x"35" => digit3 <= 5; state <= WAIT_ENTER;
                                when x"36" => digit3 <= 6; state <= WAIT_ENTER;
                                when x"37" => digit3 <= 7; state <= WAIT_ENTER;
                                when x"38" => digit3 <= 8; state <= WAIT_ENTER;
                                when x"39" => digit3 <= 9; state <= WAIT_ENTER;
                                when others => state <= WAIT_AXIS;
                            end case;

                        when WAIT_ENTER =>
                            if (rx_data = x"0D") or (rx_data = x"0A") then

                                case digit1 is
                                    when 0 => digit1_value := 0;
                                    when 1 => digit1_value := 100;
                                    when 2 => digit1_value := 200;
                                    when 3 => digit1_value := 300;
                                    when 4 => digit1_value := 400;
                                    when 5 => digit1_value := 500;
                                    when 6 => digit1_value := 600;
                                    when 7 => digit1_value := 700;
                                    when 8 => digit1_value := 800;
                                    when 9 => digit1_value := 900;
                                    when others => digit1_value := 0;
                                end case;

                                case digit2 is
                                    when 0 => digit2_value := 0;
                                    when 1 => digit2_value := 10;
                                    when 2 => digit2_value := 20;
                                    when 3 => digit2_value := 30;
                                    when 4 => digit2_value := 40;
                                    when 5 => digit2_value := 50;
                                    when 6 => digit2_value := 60;
                                    when 7 => digit2_value := 70;
                                    when 8 => digit2_value := 80;
                                    when 9 => digit2_value := 90;
                                    when others => digit2_value := 0;
                                end case;

                                digit3_value := digit3;

                                angle_value := digit1_value + digit2_value + digit3_value;

                                if axis_reg = '0' then
                                    if (angle_value >= PAN_MIN_ANGLE) and (angle_value <= PAN_MAX_ANGLE) then
                                        pan_reg <= angle_value;
                                    end if;
                                else
                                    if (angle_value >= TILT_MIN_ANGLE) and (angle_value <= TILT_MAX_ANGLE) then
                                        tilt_reg <= angle_value;
                                    end if;
                                end if;

                                state <= WAIT_AXIS;
                            end if;

                    end case;
                end if;
            end if;
        end if;
    end process;

end architecture rtl;