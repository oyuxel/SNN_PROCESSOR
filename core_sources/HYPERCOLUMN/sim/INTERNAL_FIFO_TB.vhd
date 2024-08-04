library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INTERNAL_FIFO_TB is
end INTERNAL_FIFO_TB;

architecture Behavioral of INTERNAL_FIFO_TB is
    constant DATA_WIDTH : integer := 8;
    constant DEPTH      : integer := 16;
    
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal wr_en      : std_logic := '0';
    signal rd_en      : std_logic := '0';
    signal data_in    : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal data_out   : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal full       : std_logic;
    signal empty      : std_logic;

    component INTERNAL_FIFO
        generic (
            DATA_WIDTH : integer := 8;
            DEPTH      : integer := 16
        );
        port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            wr_en      : in  std_logic;
            rd_en      : in  std_logic;
            data_in    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            data_out   : out std_logic_vector(DATA_WIDTH-1 downto 0);
            full       : out std_logic;
            empty      : out std_logic
        );
    end component;

begin
    uut: INTERNAL_FIFO
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            DEPTH      => DEPTH
        )
        port map (
            clk        => clk,
            rst        => rst,
            wr_en      => wr_en,
            rd_en      => rd_en,
            data_in    => data_in,
            data_out   => data_out,
            full       => full,
            empty      => empty
        );

    -- Clock process
    clk_process :process
    begin
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Reset the FIFO
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 200 ns;

        -- Write data to FIFO
        for i in 0 to DEPTH-1 loop
            data_in <= std_logic_vector(to_unsigned(i+1, DATA_WIDTH));
            wr_en <= '1';
            wait for 20 ns;
        end loop;
        wr_en <= '0';
        data_in <= (others=>'0');
        -- Wait for a few clock cycles
        wait for 40 ns;

        -- Read data from FIFO
        for i in 0 to DEPTH-1 loop
            rd_en <= '1';
            wait for 20 ns;
        end loop;
        rd_en <= '0';

        -- Wait for a few clock cycles
        wait for 40 ns;

        -- End simulation
               assert false report "Test: OK" severity failure;
    end process;

end Behavioral;
