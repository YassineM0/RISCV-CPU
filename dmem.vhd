library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMEM is
    generic(
        DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 8
    );
    port(
        clk    : in  std_logic;
        addr   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        wrData : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        wrEn   : in  std_logic;
        rdData : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of DMEM is
    type mem_t is array(0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mem : mem_t := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if wrEn = '1' then
                mem(to_integer(unsigned(addr))) <= wrData;
            end if;
            rdData <= mem(to_integer(unsigned(addr)));
        end if;
    end process;
end architecture;
