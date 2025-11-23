library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor is
    generic (
        INIT_FILE : string := "program.txt"
    );
    port(
        clk          : in  std_logic;
        reset        : in  std_logic;
        pc_out       : out std_logic_vector(31 downto 0);
        instruction  : out std_logic_vector(31 downto 0);
        busA         : out std_logic_vector(31 downto 0);
        busB         : out std_logic_vector(31 downto 0);
        alu_result   : out std_logic_vector(31 downto 0);
        write_enable : out std_logic;
        aluOp        : out std_logic_vector(3 downto 0);
        load         : out std_logic;
        wrMem        : out std_logic_vector(3 downto 0);
        storeData    : out std_logic_vector(31 downto 0)
    );
end entity;

architecture structural of Processor is

    component PC
        port(
            clk  : in  std_logic;
            reset : in  std_logic;  
            load : in  std_logic;
            dout : out std_logic_vector(31 downto 0)
        );
    end component;

    component IMEM
        generic (
            DATA_WIDTH  : natural := 32;
            ADDR_WIDTH  : natural := 8;
            MEM_DEPTH   : natural := 200;
            INIT_FILE   : string
        );
        port(
            address  : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
            Data_Out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
    end component;

    component REGFILE
        port(
            clk  : in  std_logic;
            reset : in  std_logic;
            ra   : in  std_logic_vector(4 downto 0);
            rb   : in  std_logic_vector(4 downto 0);
            rw   : in  std_logic_vector(4 downto 0);
            din  : in  std_logic_vector(31 downto 0);
            we   : in  std_logic;
            busa : out std_logic_vector(31 downto 0);
            busb : out std_logic_vector(31 downto 0)
        );
    end component;

    component ALU
        port(
            a       : in  std_logic_vector(31 downto 0);
            b       : in  std_logic_vector(31 downto 0);
            aluOp   : in  std_logic_vector(3 downto 0);
            result  : out std_logic_vector(31 downto 0)
        );
    end component;

  
    component controleur
        port(
            instr       : in  std_logic_vector(31 downto 0);
            reset : in  std_logic;
            writeEnable : out std_logic;
            aluOp       : out std_logic_vector(3 downto 0);
            RI_sel      : out std_logic;
            load        : out std_logic;
            wrMem       : out std_logic_vector(3 downto 0);
            res_lsb     : in  std_logic_vector(1 downto 0)
        );
    end component;

    component Imm_ext
        port(
            instr    : in  std_logic_vector(31 downto 0);
            instType : in  std_logic_vector(6 downto 0);
            immExt   : out std_logic_vector(31 downto 0)
        );
    end component;


    component SM
        port(
            writeData : in  std_logic_vector(31 downto 0);
            addr      : in  std_logic_vector(1 downto 0);
            funct3    : in  std_logic_vector(2 downto 0);
            memIn     : in  std_logic_vector(31 downto 0);
            storeData : out std_logic_vector(31 downto 0)
        );
    end component;

 
    component DM
        port(
            clk      : in  std_logic;
            addr     : in  std_logic_vector(31 downto 0);
            data  : in  std_logic_vector(31 downto 0);
            wrMem    : in  std_logic_vector(3 downto 0);
            q        : out std_logic_vector(31 downto 0)
        );
    end component;


    signal pc_sig        : std_logic_vector(31 downto 0) := (others => '0');
    signal instr_sig     : std_logic_vector(31 downto 0) := (others => '0');
    signal busA_sig      : std_logic_vector(31 downto 0) := (others => '0');
    signal busB_sig      : std_logic_vector(31 downto 0) := (others => '0');
    signal alu_result_sig: std_logic_vector(31 downto 0) := (others => '0');
    signal immExt_sig    : std_logic_vector(31 downto 0) := (others => '0');

    signal write_enable_sig : std_logic := '0';
    signal RI_sel_sig       : std_logic := '0';
    signal load_sig         : std_logic := '0';
    signal wrMem_sig        : std_logic_vector(3 downto 0) := (others => '0');

    signal aluOp_sig        : std_logic_vector(3 downto 0) := (others => '0');

    signal aluB_sig         : std_logic_vector(31 downto 0) := (others => '0');
    signal storeData_sig    : std_logic_vector(31 downto 0) := (others => '0');
    signal dm_read_sig      : std_logic_vector(31 downto 0) := (others => '0');

    signal rs1, rs2, rd     : std_logic_vector(4 downto 0);
    signal load_pc          : std_logic;
    signal imem_addr        : std_logic_vector(7 downto 0);

    signal regfile_input_sig: std_logic_vector(31 downto 0) := (others => '0');

begin


    rs1 <= instr_sig(19 downto 15);
    rs2 <= instr_sig(24 downto 20);
    rd  <= instr_sig(11 downto 7);

 
    load_pc <= not reset;

    imem_addr <= pc_sig(9 downto 2);


    pc_inst : PC
        port map(
            clk  => clk,
            reset => reset,
            load => load_pc,
            dout => pc_sig
        );


    imem_inst : IMEM
        generic map(
            DATA_WIDTH => 32,
            ADDR_WIDTH => 8,
            MEM_DEPTH  => 200,
            INIT_FILE  => INIT_FILE
        )
        port map(
            address  => imem_addr,
            Data_Out => instr_sig
        );


    regfile_inst : REGFILE
        port map(
            clk  => clk,
            reset => reset,
            ra   => rs1,
            rb   => rs2,
            rw   => rd,
            din  => regfile_input_sig,
            we   => write_enable_sig,
            busa => busA_sig,
            busb => busB_sig
        );


    regfile_input_sig <= dm_read_sig when load_sig = '1' else alu_result_sig;


    imm_ext_inst : Imm_ext
        port map(
            instr    => instr_sig,
            instType => instr_sig(6 downto 0),
            immExt   => immExt_sig
        );

    process(RI_sel_sig, load_sig, wrMem_sig, busB_sig, immExt_sig)
    begin
        if (RI_sel_sig = '1') or (load_sig = '1') or (wrMem_sig /= "0000") then
            aluB_sig <= immExt_sig;
        else
            aluB_sig <= busB_sig;
        end if;
    end process;


    alu_inst : ALU
        port map(
            a      => busA_sig,
            b      => aluB_sig,
            aluOp  => aluOp_sig,
            result => alu_result_sig
        );

    SM_inst : SM
        port map(
            writeData => busB_sig,
            addr      => alu_result_sig(1 downto 0),
            funct3    => instr_sig(14 downto 12),
            memIn     => dm_read_sig,
            storeData => storeData_sig
        );


    dm_inst : DM
        port map(
            clk     => clk,
            addr    => alu_result_sig,
            data => storeData_sig,
            wrMem   => wrMem_sig,
            q       => dm_read_sig
        );


    controller_inst : controleur
        port map(
            instr       => instr_sig,
            reset       => reset,   
            writeEnable => write_enable_sig,
            aluOp       => aluOp_sig,
            RI_sel      => RI_sel_sig,
            load        => load_sig,
            wrMem       => wrMem_sig,
            res_lsb     => alu_result_sig(1 downto 0)
        );


    pc_out       <= pc_sig;
    instruction  <= instr_sig;
    busA         <= busA_sig;
    busB         <= busB_sig;
    alu_result   <= alu_result_sig;
    write_enable <= write_enable_sig;
    aluOp        <= aluOp_sig;
    load         <= load_sig;
    wrMem        <= wrMem_sig;
    storeData    <= storeData_sig;

end architecture;
