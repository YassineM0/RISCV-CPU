library ieee;
use ieee.std_logic_1164.all;

entity controleur is
    port(
        instr       : in  std_logic_vector(31 downto 0);
        reset       : in  std_logic;
        writeEnable : out std_logic;
        aluOp       : out std_logic_vector(3 downto 0);
        RI_sel      : out std_logic;       
        load        : out std_logic;       
        wrMem       : out std_logic_vector(3 downto 0);  
        res_lsb     : in  std_logic_vector(1 downto 0)   
    );
end entity;

architecture rtl of controleur is
    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
begin
    opcode <= instr(6 downto 0);
    funct3 <= instr(14 downto 12);
    funct7 <= instr(31 downto 25);

    process(opcode, funct3, funct7, instr, res_lsb, reset)
    begin
        if reset = '1' then
            writeEnable <= '0';
            RI_sel <= '0';
            aluOp <= "0000";
            load <= '0';
            wrMem <= "0000";

        else
  
            writeEnable <= '0';
            RI_sel      <= '0';
            aluOp       <= "0000";
            load        <= '0';
            wrMem       <= "0000";

            case opcode is
                when "0110011" =>  
                    RI_sel <= '0';
                    writeEnable <= '1';
                    case funct3 is
                        when "000" =>
                            if funct7 = "0000000" then
                                aluOp <= "0000";
                            elsif funct7 = "0100000" then
                                aluOp <= "0001";
                            end if;
                        when "111" => aluOp <= "0010";
                        when "110" => aluOp <= "0011";
                        when "010" => aluOp <= "0100";
                        when others => null;
                    end case;

                when "0010011" =>
                    RI_sel <= '1';
                    writeEnable <= '1';
                    aluOp <= "0000";

                when "0000011" =>
                    RI_sel <= '1';
                    writeEnable <= '1';
                    load <= '1';

                when "0100011" =>
                    RI_sel <= '1';
                    case funct3 is
                        when "010" => wrMem <= "1111";
                        when "001" =>
                            if res_lsb(1)='0' then wrMem <= "0011";
                            else wrMem <= "1100"; end if;
                        when "000" =>
                            case res_lsb is
                                when "00" => wrMem <= "0001";
                                when "01" => wrMem <= "0010";
                                when "10" => wrMem <= "0100";
                                when "11" => wrMem <= "1000";
                                when others => wrMem <= "0000";
                            end case;
                        when others => wrMem <= "0000";
                    end case;

                when others =>
                    null;
            end case;
        end if;

    end process;

end architecture;
