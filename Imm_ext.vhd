library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Imm_ext is
    port(
        instr    : in  std_logic_vector(31 downto 0);
        instType : in  std_logic_vector(6 downto 0);
        immExt   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behavioral of Imm_ext is
    signal imm12 : std_logic_vector(11 downto 0);
begin
    process(instr, instType)
    begin
        if instType = "0000011" or instType = "0010011" then  -- type i
            imm12 <= instr(31 downto 20);
        elsif instType = "0100011" then  -- type s
            imm12 <= instr(31 downto 25) & instr(11 downto 7);
        else
            imm12 <= (others => '0');
        end if;

        if imm12(11) = '1' then
            immExt <= (19 downto 0 => '1') & imm12;
        else
            immExt <= (19 downto 0 => '0') & imm12;
        end if;
    end process;
end architecture;
