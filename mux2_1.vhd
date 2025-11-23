library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is
    generic(WIDTH: natural := 32);
    port(
        a   : in  std_logic_vector(WIDTH-1 downto 0);
        b   : in  std_logic_vector(WIDTH-1 downto 0);
        sel : in  std_logic;
        y   : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture rtl of mux2_1 is
begin
    y <= a when sel = '0' else b;
end architecture;
