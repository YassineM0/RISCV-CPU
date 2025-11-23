library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_dm is
end entity;

architecture sim of tb_dm is

    signal clk       : std_logic := '0';
    signal addr      : std_logic_vector(31 downto 0) := (others => '0');
    signal data      : std_logic_vector(31 downto 0) := (others => '0');
    signal wrMem     : std_logic_vector(3 downto 0) := (others => '0');
    signal q         : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin


    DM_inst : entity work.dm
        port map(
            clk    => clk,
            addr   => addr,
            data   => data,
            wrMem  => wrMem,
            q      => q
        );


    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;


    stim_proc : process
    begin
        wait for CLK_PERIOD;

        -- 1) SW -> mot complet
        addr <= x"00000000"; data <= x"12345678"; wrMem <= "1111";
        wait for CLK_PERIOD;

        -- 2) SW -> mot complet à une autre adresse
        addr <= x"00000004"; data <= x"AABBCCDD"; wrMem <= "1111";
        wait for CLK_PERIOD;

        -- 3) SH bas -> demi-mot bas
        addr <= x"00000008"; data <= x"00001234"; wrMem <= "0011";
        wait for CLK_PERIOD;

        -- 4) SH haut -> demi-mot haut
        addr <= x"0000000C"; data <= x"56780000"; wrMem <= "1100";
        wait for CLK_PERIOD;

        -- 5) SB -> octet addr+0
        addr <= x"00000010"; data <= x"000000AB"; wrMem <= "0001";
        wait for CLK_PERIOD;

        -- 6) SB -> octet addr+1
        addr <= x"00000014"; data <= x"0000CD00"; wrMem <= "0010";
        wait for CLK_PERIOD;

        -- 7) SB -> octet addr+2
        addr <= x"00000018"; data <= x"00EF0000"; wrMem <= "0100";
        wait for CLK_PERIOD;

        -- 8) SB -> octet addr+3
        addr <= x"0000001C"; data <= x"12000000"; wrMem <= "1000";
        wait for CLK_PERIOD;

        -- 9) SW -> mot complet pour vérifier lecture
        addr <= x"00000020"; data <= x"DEADBEEF"; wrMem <= "1111";
        wait for CLK_PERIOD;

        -- 10) SH haut sur mot existant
        addr <= x"00000020"; data <= x"FEED0000"; wrMem <= "1100";
        wait for CLK_PERIOD;

        -- Fin simulation
        wait for 5*CLK_PERIOD;
        wait;
    end process;

end architecture;
