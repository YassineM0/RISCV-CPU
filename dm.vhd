

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dm is
    Port (
        clk     : in  STD_LOGIC;
        addr    : in  STD_LOGIC_VECTOR(31 downto 0);  
        data    : in  STD_LOGIC_VECTOR(31 downto 0);  
        wrMem   : in  STD_LOGIC_VECTOR(3 downto 0);   
        q       : out STD_LOGIC_VECTOR(31 downto 0)   
    );
end dm;

architecture arch of dm is

    type mem_array is array (0 to 1023) of STD_LOGIC_VECTOR(7 downto 0);
    signal memory : mem_array := (others => (others => '0'));

    signal aligned_addr : unsigned(31 downto 0);

    signal byte_addr : integer range 0 to 1023;

begin

    aligned_addr <= unsigned(addr(31 downto 2)) & "00";



    byte_addr <= to_integer(aligned_addr(9 downto 0));


    process(clk)
    begin
        if rising_edge(clk) then

            if byte_addr <= 1020 then

                if wrMem(0) = '1' then
                    memory(byte_addr) <= data(7 downto 0);
                end if;


                if wrMem(1) = '1' then
                    memory(byte_addr + 1) <= data(15 downto 8);
                end if;

        
                if wrMem(2) = '1' then
                    memory(byte_addr + 2) <= data(23 downto 16);
                end if;

                if wrMem(3) = '1' then
                    memory(byte_addr + 3) <= data(31 downto 24);
                end if;

            end if; 

        end if; 
    end process;

 
    q <= (others => '0') when (byte_addr > 1020) else
         memory(byte_addr + 3) &
         memory(byte_addr + 2) &
         memory(byte_addr + 1) &
         memory(byte_addr);

end arch;


