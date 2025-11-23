library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGFILE is
    port(
        clk   : in  std_logic;
        reset : in  std_logic;
        ra    : in  std_logic_vector(4 downto 0);
        rb    : in  std_logic_vector(4 downto 0);
        rw    : in  std_logic_vector(4 downto 0);
        din   : in  std_logic_vector(31 downto 0);
        we    : in  std_logic;
        busa  : out std_logic_vector(31 downto 0);
        busb  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of REGFILE is
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin
    busa <= regs(to_integer(unsigned(ra)));
    busb <= regs(to_integer(unsigned(rb)));

    process(clk, reset)
    begin
        if reset = '1' then

            for i in 0 to 31 loop
                regs(i) <= std_logic_vector(to_unsigned(i, 32));
            end loop;

        elsif rising_edge(clk) then
            if we = '1' and rw /= "00000" then
                regs(to_integer(unsigned(rw))) <= din;
            end if;
            regs(0) <= (others => '0'); 
        end if;
    end process;
end architecture;
