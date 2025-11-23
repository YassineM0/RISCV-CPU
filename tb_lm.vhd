library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LM is
end entity;

architecture sim of tb_LM is
    signal loadData : std_logic_vector(31 downto 0);
    signal funct3   : std_logic_vector(2 downto 0);
    signal LM_out   : std_logic_vector(31 downto 0);
begin
    LM_inst : entity work.LM
        port map(
            loadData => loadData,
            funct3   => funct3,
            LM_out   => LM_out
        );

    stim_proc : process
    begin
        -- Test LB signed
        loadData <= x"00000080"; -- -128
        funct3 <= "000";
        wait for 10 ns;

        -- Test LH signed
        loadData <= x"00008000"; -- -32768
        funct3 <= "001";
        wait for 10 ns;

        -- Test LW
        loadData <= x"12345678";
        funct3 <= "010";
        wait for 10 ns;

        -- Test LBU
        loadData <= x"00000080"; -- 0x80 = 128
        funct3 <= "100";
        wait for 10 ns;

        -- Test LHU
        loadData <= x"00008000"; -- 0x8000 = 32768
        funct3 <= "101";
        wait for 10 ns;

        wait;
    end process;
end architecture;
