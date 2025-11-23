library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_processor is
end entity;

architecture testbench of tb_processor is

    component Processor
        generic(INIT_FILE : string := "program.txt");
        port(
            clk          : in  std_logic;
            reset        : in  std_logic;
            pc_out       : out std_logic_vector(31 downto 0);
            instruction  : out std_logic_vector(31 downto 0);
            busA         : out std_logic_vector(31 downto 0);
            busB         : out std_logic_vector(31 downto 0);
            alu_result   : out std_logic_vector(31 downto 0);
            write_enable : out std_logic;
            aluOp        : out std_logic_vector(3 downto 0);
            load         : out std_logic;
            wrMem        : out std_logic_vector(3 downto 0);
            storeData    : out std_logic_vector(31 downto 0)
        );
    end component;

    constant CLK_PERIOD : time := 10 ns;

    signal clk, reset : std_logic := '0';
    signal pc_out, instruction, busA, busB, alu_result, storeData : std_logic_vector(31 downto 0);
    signal write_enable : std_logic;
    signal aluOp : std_logic_vector(3 downto 0);
    signal load : std_logic;
    signal wrMem : std_logic_vector(3 downto 0);

    signal sim_done : boolean := false;

begin


    DUT_inst : Processor
        generic map(INIT_FILE => "program.txt")
        port map(
            clk          => clk,
            reset        => reset,
            pc_out       => pc_out,
            instruction  => instruction,
            busA         => busA,
            busB         => busB,
            alu_result   => alu_result,
            write_enable => write_enable,
            aluOp        => aluOp,
            load         => load,
            wrMem        => wrMem,
            storeData    => storeData
        );


    clk_process : process
    begin
        while not sim_done loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;


    stim_proc : process
    begin
     
        reset <= '1';
        wait for 3*CLK_PERIOD;
        reset <= '0';


        wait for 500 ns;

        sim_done <= true;
        report "Simulation finished" severity note;
        wait;
    end process;

end architecture;
