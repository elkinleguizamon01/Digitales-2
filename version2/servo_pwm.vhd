library ieee;
use ieee.std_logic_1164.all;

entity servo_pwm is
    generic (
        PWM_PERIOD_CYCLES       : positive := 1000000;
        MIN_ANGLE               : integer  := 0;
        MAX_ANGLE               : integer  := 180;
        BASE_PULSE_CYCLES       : positive := 50000;
        PULSE_CYCLES_PER_DEGREE : positive := 278
    );
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        angle : in  integer range 0 to 180;
        pwm   : out std_logic
    );
end entity servo_pwm;

architecture rtl of servo_pwm is

    signal counter     : integer range 0 to PWM_PERIOD_CYCLES - 1 := 0;
    signal pulse_width : integer range 0 to PWM_PERIOD_CYCLES - 1 := BASE_PULSE_CYCLES;

    function angle_to_pulse(a : integer) return integer is
        variable result : integer;
    begin
        result := BASE_PULSE_CYCLES;
        for i in 1 to 180 loop
            if i <= a then
                result := result + PULSE_CYCLES_PER_DEGREE;
            end if;
        end loop;
        return result;
    end function;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter <= 0;
                pulse_width <= angle_to_pulse(MIN_ANGLE);
                pwm <= '0';
            else
                if counter = 0 then
                    pulse_width <= angle_to_pulse(angle);
                end if;

                if counter = PWM_PERIOD_CYCLES - 1 then
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;

                if counter < pulse_width then
                    pwm <= '1';
                else
                    pwm <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture rtl;