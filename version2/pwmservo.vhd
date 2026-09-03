library ieee;
use ieee.std_logic_1164.all;

entity pwmservo is

    generic (

        ------------------------------------------------
        -- UART
        ------------------------------------------------

        CLKS_PER_BIT : positive := 10417;


        ------------------------------------------------
        -- PAN
        ------------------------------------------------

        PAN_INITIAL_ANGLE : integer := 90;

        PAN_MIN_ANGLE : integer := 0;

        PAN_MAX_ANGLE : integer := 180;


        ------------------------------------------------
        -- TILT
        ------------------------------------------------

        TILT_INITIAL_ANGLE : integer := 90;

        TILT_MIN_ANGLE : integer := 50;

        TILT_MAX_ANGLE : integer := 130;


        ------------------------------------------------
        -- PWM
        ------------------------------------------------

        PWM_PERIOD_CYCLES : positive := 1000000;

        SERVO_MIN_PULSE_CYCLES : positive := 50000;

        PAN_PULSE_CYCLES_PER_DEGREE : positive := 278;

        TILT_PULSE_CYCLES_PER_DEGREE : positive := 625

    );

    port (

        ------------------------------------------------
        -- RELOJ DE 50 MHz
        ------------------------------------------------

        CLOCK_50 : in std_logic;


        ------------------------------------------------
        -- BOTÓN KEY0
        ------------------------------------------------

        KEY0 : in std_logic;


        ------------------------------------------------
        -- UART
        ------------------------------------------------

        UART_RX : in std_logic;


        ------------------------------------------------
        -- SALIDAS PWM
        ------------------------------------------------

        SERVO_PAN : out std_logic;

        SERVO_TILT : out std_logic;


        ------------------------------------------------
        -- DISPLAYS
        ------------------------------------------------

        HEX0 : out std_logic_vector(6 downto 0);

        HEX1 : out std_logic_vector(6 downto 0);

        HEX2 : out std_logic_vector(6 downto 0);

        HEX3 : out std_logic_vector(6 downto 0)

    );

end entity pwmservo;


architecture structural of pwmservo is


    ------------------------------------------------
    -- RESET INTERNO
    ------------------------------------------------

    signal reset_int : std_logic;


    ------------------------------------------------
    -- UART
    ------------------------------------------------

    signal rx_data :
        std_logic_vector(7 downto 0);

    signal rx_valid :
        std_logic;


    ------------------------------------------------
    -- ÁNGULOS
    ------------------------------------------------

    signal pan_angle :
        integer range 0 to 180;

    signal tilt_angle :
        integer range 0 to 180;


    ------------------------------------------------
    -- EJE SELECCIONADO
    ------------------------------------------------

    signal selected_axis :
        std_logic;


    ------------------------------------------------
    -- ÁNGULO PARA DISPLAY
    ------------------------------------------------

    signal selected_angle :
        integer range 0 to 180;

begin


    ------------------------------------------------
    -- KEY0 ES ACTIVO EN LOW
    ------------------------------------------------

    reset_int <= not KEY0;


    ------------------------------------------------
    -- SELECCIÓN DEL ÁNGULO PARA DISPLAY
    ------------------------------------------------

    selected_angle <=

        pan_angle
        when selected_axis = '0'
        else tilt_angle;


    ------------------------------------------------
    -- UART
    ------------------------------------------------

    UART_RECEIVER : entity work.uart_rx

        generic map (

            CLKS_PER_BIT => CLKS_PER_BIT,

            DATA_BITS => 8

        )

        port map (

            clk => CLOCK_50,

            reset => reset_int,

            rx => UART_RX,

            data_out => rx_data,

            data_valid => rx_valid

        );


    ------------------------------------------------
    -- PARSER DE COMANDOS
    ------------------------------------------------

    COMMAND_DECODER : entity work.command_parser

        generic map (

            PAN_INITIAL_ANGLE => PAN_INITIAL_ANGLE,

            PAN_MIN_ANGLE => PAN_MIN_ANGLE,

            PAN_MAX_ANGLE => PAN_MAX_ANGLE,

            TILT_INITIAL_ANGLE => TILT_INITIAL_ANGLE,

            TILT_MIN_ANGLE => TILT_MIN_ANGLE,

            TILT_MAX_ANGLE => TILT_MAX_ANGLE

        )

        port map (

            clk => CLOCK_50,

            reset => reset_int,

            rx_data => rx_data,

            rx_valid => rx_valid,

            pan_angle => pan_angle,

            tilt_angle => tilt_angle,

            selected_axis => selected_axis

        );


    ------------------------------------------------
    -- PWM PAN
    ------------------------------------------------

    PAN_SERVO : entity work.servo_pwm

        generic map (

            PWM_PERIOD_CYCLES =>
                PWM_PERIOD_CYCLES,

            MIN_ANGLE =>
                PAN_MIN_ANGLE,

            MAX_ANGLE =>
                PAN_MAX_ANGLE,

            BASE_PULSE_CYCLES =>
                SERVO_MIN_PULSE_CYCLES,

            PULSE_CYCLES_PER_DEGREE =>
                PAN_PULSE_CYCLES_PER_DEGREE

        )

        port map (

            clk => CLOCK_50,

            reset => reset_int,

            angle => pan_angle,

            pwm => SERVO_PAN

        );


    ------------------------------------------------
    -- PWM TILT
    ------------------------------------------------

    TILT_SERVO : entity work.servo_pwm

        generic map (

            PWM_PERIOD_CYCLES =>
                PWM_PERIOD_CYCLES,

            MIN_ANGLE =>
                TILT_MIN_ANGLE,

            MAX_ANGLE =>
                TILT_MAX_ANGLE,

            BASE_PULSE_CYCLES =>
                SERVO_MIN_PULSE_CYCLES,

            PULSE_CYCLES_PER_DEGREE =>
                TILT_PULSE_CYCLES_PER_DEGREE

        )

        port map (

            clk => CLOCK_50,

            reset => reset_int,

            angle => tilt_angle,

            pwm => SERVO_TILT

        );


    ------------------------------------------------
    -- DISPLAY
    ------------------------------------------------

    DISPLAY_CONTROLLER : entity work.display_ctrl

        port map (

            axis => selected_axis,

            angle => selected_angle,

            hex0 => HEX0,

            hex1 => HEX1,

            hex2 => HEX2,

            hex3 => HEX3

        );

end architecture structural;