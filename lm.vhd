library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity LM is
    port(
        loadData : in  std_logic_vector(31 downto 0);
        funct3   : in  std_logic_vector(2 downto 0); 
        LM_out   : out std_logic_vector(31 downto 0)  
    );
end entity;

architecture rtl of LM is
begin
    process(loadData, funct3)
        variable tmp8  : signed(7 downto 0);
        variable tmp16 : signed(15 downto 0);
    begin
        case funct3 is
            when "000" => 
                tmp8 := signed(loadData(7 downto 0));
                LM_out <= std_logic_vector(resize(tmp8, 32));
            when "001" =>  
                tmp16 := signed(loadData(15 downto 0));
                LM_out <= std_logic_vector(resize(tmp16, 32));
            when "010" =>  
                LM_out <= loadData;
            when "100" => 
                LM_out <= (31 downto 8 => '0') & loadData(7 downto 0);
            when "101" =>  
                LM_out <= (31 downto 16 => '0') & loadData(15 downto 0);
            when others =>
                LM_out <= (others => '0');
        end case;
    end process;
end architecture;
