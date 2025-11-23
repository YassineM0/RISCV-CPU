library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        a       : in  std_logic_vector(31 downto 0);
        b       : in  std_logic_vector(31 downto 0);
        aluOp   : in  std_logic_vector(3 downto 0);
        result  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of ALU is
begin
    process(a, b, aluOp)
    begin
        case aluOp is
            when "0000" => result <= std_logic_vector(signed(a) + signed(b));
            when "0001" => result <= std_logic_vector(signed(a) - signed(b)); 
            when "0010" => result <= a and b; 
            when "0011" => result <= a or b;  
            when "0100" => 
                if signed(a) < signed(b) then
                    result <= (31 downto 1 => '0') & '1';
                else
                    result <= (others => '0');
                end if;
            when others =>
                result <= (others => '0');
        end case;
    end process;
end architecture;
