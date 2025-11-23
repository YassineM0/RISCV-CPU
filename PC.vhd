library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk   : in  std_logic;
        reset : in  std_logic;
        load  : in  std_logic;               
        dout  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of PC is
    signal pc_reg : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');

        elsif rising_edge(clk) then
            if load = '1' then
                pc_reg <= std_logic_vector(unsigned(pc_reg) + 4);
            end if;
        end if;
    end process;

    dout <= pc_reg;
end architecture;
