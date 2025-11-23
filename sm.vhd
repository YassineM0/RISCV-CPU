library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SM is
    port(
        writeData : in  std_logic_vector(31 downto 0);
        addr      : in  std_logic_vector(1 downto 0);  
        funct3    : in  std_logic_vector(2 downto 0);
        memIn     : in  std_logic_vector(31 downto 0); 
        storeData : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behavioral of SM is
begin
    process(writeData, addr, funct3, memIn)
        variable temp : std_logic_vector(31 downto 0);
    begin
        temp := memIn;
        case funct3 is
            when "010" =>  
                temp := writeData;
            when "001" =>  
                case addr(1) is
                    when '0' =>
                        temp(15 downto 0) := writeData(15 downto 0);
                    when '1' =>
                        temp(31 downto 16) := writeData(15 downto 0);
                    when others =>
                        null;
                end case;
            when "000" => 
                case addr is
                    when "00" =>
                        temp(7 downto 0)   := writeData(7 downto 0);
                    when "01" =>
                        temp(15 downto 8)  := writeData(7 downto 0);
                    when "10" =>
                        temp(23 downto 16) := writeData(7 downto 0);
                    when "11" =>
                        temp(31 downto 24) := writeData(7 downto 0);
                    when others =>
                        null;
                end case;
            when others =>
                temp := writeData; 
        end case;
        storeData <= temp;
    end process;
end architecture;
