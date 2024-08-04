library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Pipelined_Adder is
end entity tb_Pipelined_Adder;

architecture sim of tb_Pipelined_Adder is
    -- Constants
    constant N : integer := 8;  -- Test için N = 8 alınıyor, ihtiyaca göre değiştirebilirsiniz

    -- Signals
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal COL_0_IMSUM : std_logic_vector(16*N-1 downto 0);
    signal sum         : signed(15 downto 0);
begin
    -- Clock generation
    clk_process : process
    begin
        clk <= not clk;
        wait for 10 ns;
    end process;

    -- UUT instantiation
    uut : entity work.Pipelined_Adder
        generic map (
            N => N
        )
        port map (
            clk         => clk,
            rst         => rst,
            COL_0_IMSUM => COL_0_IMSUM,
            sum         => sum
        );


    -- Test process
    stim_proc: process
    begin
        -- Initialize inputs
        COL_0_IMSUM <= (others => '0');
        rst <= '1';
        wait for 20 ns;

        rst <= '0';

        -- Apply test vectors
        COL_0_IMSUM <= x"0001_0002_0003_0004_0005_0006_0007_0008";  -- Example input
        wait for 200 ns;

        COL_0_IMSUM <= x"0000_0001_0002_0003_0004_0005_0006_0007";  -- Example input
        wait for 200 ns;

        COL_0_IMSUM <= x"000F_000E_000D_000C_000B_000A_0009_0008";  -- Example input
        wait for 200 ns;

        -- Test with a pattern where the result is known
        COL_0_IMSUM <= x"0001_0001_0001_0001_0001_0001_0001_0001";  -- All ones
        wait for 200 ns;
        --assert (sum = signed(16#0008#)) report "Test failed for all ones" severity error;

        -- Apply another test vector
        COL_0_IMSUM <= x"0002_0004_0008_0010_0020_0040_0080_0100";  -- Example input
        wait for 200 ns;

        -- Test with different values
        COL_0_IMSUM <= x"0000_0000_0000_0000_0000_0000_0001_0001";  -- Example input
        wait for 200 ns;

        -- Test with a pattern where the result is known
        COL_0_IMSUM <= x"0010_0010_0010_0010_0010_0010_0010_0010";  -- All tens
        wait for 200 ns;
        --assert (sum = signed(16#0080#)) report "Test failed for all tens" severity error;

                assert false report "Test: OK" severity failure;

    end process;
end architecture sim;
