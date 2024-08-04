library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HYPERCOLUMN_tb is
        Generic(
            ROW              : integer := 64
        );
end entity HYPERCOLUMN_tb;

architecture Behavioral of HYPERCOLUMN_tb is

    component HYPERCOLUMN
        Generic(
            ROW              : integer := 2
        );
        Port (
            HP_CLK                          : in  std_logic;
            HP_RST                          : in  std_logic;
            SPIKE_IN                        : in  std_logic_vector(ROW-1 downto 0);
            SPIKE_VLD                       : in  std_logic;
            SPIKE_OUT                       : out std_logic_vector(ROW-1 downto 0);
            SPIKE_VLD_OUT                   : out std_logic;
            COLUMN_0_PRE_SYNAPTIC_DIN       : in  std_logic_vector(15 downto 0);
            COLUMN_1_PRE_SYNAPTIC_DIN       : in  std_logic_vector(15 downto 0);
            COLUMN_2_PRE_SYNAPTIC_DIN       : in  std_logic_vector(15 downto 0);
            COLUMN_3_PRE_SYNAPTIC_DIN       : in  std_logic_vector(15 downto 0);
            COLUMN_0_PRE_SYNAPTIC_RDEN      : out std_logic;
            COLUMN_1_PRE_SYNAPTIC_RDEN      : out std_logic;
            COLUMN_2_PRE_SYNAPTIC_RDEN      : out std_logic;
            COLUMN_3_PRE_SYNAPTIC_RDEN      : out std_logic;
            PRE_SYN_DATA_PULL               : in  std_logic;
            COLN_0_SYN_SUM_OUT              : out std_logic_vector(15 downto 0);
            COLN_1_SYN_SUM_OUT              : out std_logic_vector(15 downto 0);
            COLN_2_SYN_SUM_OUT              : out std_logic_vector(15 downto 0);
            COLN_3_SYN_SUM_OUT              : out std_logic_vector(15 downto 0);
            COLN_VECTOR_SYN_SUM_VALID       : out std_logic_vector(3 downto 0);
            COLUMN_0_POST_SYNAPTIC_DOUT     : out std_logic_vector(15 downto 0);
            COLUMN_1_POST_SYNAPTIC_DOUT     : out std_logic_vector(15 downto 0);
            COLUMN_2_POST_SYNAPTIC_DOUT     : out std_logic_vector(15 downto 0);
            COLUMN_3_POST_SYNAPTIC_DOUT     : out std_logic_vector(15 downto 0);
            COLUMN_0_POST_SYNAPTIC_WREN     : out std_logic;
            COLUMN_1_POST_SYNAPTIC_WREN     : out std_logic;
            COLUMN_2_POST_SYNAPTIC_WREN     : out std_logic;
            COLUMN_3_POST_SYNAPTIC_WREN     : out std_logic
        );
    end component;

    -- Testbench signals
    signal HP_CLK                        : std_logic := '0';
    signal HP_RST                        : std_logic := '1';
    signal SPIKE_IN                      : std_logic_vector(ROW-1 downto 0) := (others => '0');
    signal SPIKE_VLD                     : std_logic;
    signal SPIKE_OUT                     : std_logic_vector(ROW-1 downto 0);
    signal SPIKE_VLD_OUT                 : std_logic;
    signal COLUMN_0_PRE_SYNAPTIC_DIN     : std_logic_vector(15 downto 0) := (others => '0');
    signal COLUMN_1_PRE_SYNAPTIC_DIN     : std_logic_vector(15 downto 0) := (others => '0');
    signal COLUMN_2_PRE_SYNAPTIC_DIN     : std_logic_vector(15 downto 0) := (others => '0');
    signal COLUMN_3_PRE_SYNAPTIC_DIN     : std_logic_vector(15 downto 0) := (others => '0');
    signal COLUMN_0_PRE_SYNAPTIC_RDEN    : std_logic;
    signal COLUMN_1_PRE_SYNAPTIC_RDEN    : std_logic;
    signal COLUMN_2_PRE_SYNAPTIC_RDEN    : std_logic;
    signal COLUMN_3_PRE_SYNAPTIC_RDEN    : std_logic;
    signal PRE_SYN_DATA_PULL             : std_logic := '0';
    signal COLN_0_SYN_SUM_OUT            : std_logic_vector(15 downto 0);
    signal COLN_1_SYN_SUM_OUT            : std_logic_vector(15 downto 0);
    signal COLN_2_SYN_SUM_OUT            : std_logic_vector(15 downto 0);
    signal COLN_3_SYN_SUM_OUT            : std_logic_vector(15 downto 0);
    signal COLN_VECTOR_SYN_SUM_VALID     : std_logic_vector(3 downto 0);
    signal COLUMN_0_POST_SYNAPTIC_DOUT   : std_logic_vector(15 downto 0) := (others => '0');
    signal COLUMN_1_POST_SYNAPTIC_DOUT   : std_logic_vector(15 downto 0) := (others => '0');
    signal COLUMN_2_POST_SYNAPTIC_DOUT   : std_logic_vector(15 downto 0) := (others => '0');
    signal COLUMN_3_POST_SYNAPTIC_DOUT   : std_logic_vector(15 downto 0) := (others => '0');
    signal COLUMN_0_POST_SYNAPTIC_WREN   : std_logic;
    signal COLUMN_1_POST_SYNAPTIC_WREN   : std_logic;
    signal COLUMN_2_POST_SYNAPTIC_WREN   : std_logic;
    signal COLUMN_3_POST_SYNAPTIC_WREN   : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: HYPERCOLUMN
        generic map (
            ROW => ROW
        )
        port map (
            HP_CLK                          => HP_CLK,
            HP_RST                          => HP_RST,
            SPIKE_IN                        => SPIKE_IN,
            SPIKE_VLD                       => SPIKE_VLD,
            SPIKE_OUT                       => SPIKE_OUT        ,
            SPIKE_VLD_OUT                   => SPIKE_VLD_OUT    ,
            COLUMN_0_PRE_SYNAPTIC_DIN       => COLUMN_0_PRE_SYNAPTIC_DIN,
            COLUMN_1_PRE_SYNAPTIC_DIN       => COLUMN_1_PRE_SYNAPTIC_DIN,
            COLUMN_2_PRE_SYNAPTIC_DIN       => COLUMN_2_PRE_SYNAPTIC_DIN,
            COLUMN_3_PRE_SYNAPTIC_DIN       => COLUMN_3_PRE_SYNAPTIC_DIN,
            COLUMN_0_PRE_SYNAPTIC_RDEN      => COLUMN_0_PRE_SYNAPTIC_RDEN,
            COLUMN_1_PRE_SYNAPTIC_RDEN      => COLUMN_1_PRE_SYNAPTIC_RDEN,
            COLUMN_2_PRE_SYNAPTIC_RDEN      => COLUMN_2_PRE_SYNAPTIC_RDEN,
            COLUMN_3_PRE_SYNAPTIC_RDEN      => COLUMN_3_PRE_SYNAPTIC_RDEN,
            PRE_SYN_DATA_PULL               => PRE_SYN_DATA_PULL,
            COLN_0_SYN_SUM_OUT              => COLN_0_SYN_SUM_OUT,
            COLN_1_SYN_SUM_OUT              => COLN_1_SYN_SUM_OUT,
            COLN_2_SYN_SUM_OUT              => COLN_2_SYN_SUM_OUT,
            COLN_3_SYN_SUM_OUT              => COLN_3_SYN_SUM_OUT,
            COLN_VECTOR_SYN_SUM_VALID       => COLN_VECTOR_SYN_SUM_VALID,
            COLUMN_0_POST_SYNAPTIC_DOUT     => COLUMN_0_POST_SYNAPTIC_DOUT,
            COLUMN_1_POST_SYNAPTIC_DOUT     => COLUMN_1_POST_SYNAPTIC_DOUT,
            COLUMN_2_POST_SYNAPTIC_DOUT     => COLUMN_2_POST_SYNAPTIC_DOUT,
            COLUMN_3_POST_SYNAPTIC_DOUT     => COLUMN_3_POST_SYNAPTIC_DOUT,
            COLUMN_0_POST_SYNAPTIC_WREN     => COLUMN_0_POST_SYNAPTIC_WREN,
            COLUMN_1_POST_SYNAPTIC_WREN     => COLUMN_1_POST_SYNAPTIC_WREN,
            COLUMN_2_POST_SYNAPTIC_WREN     => COLUMN_2_POST_SYNAPTIC_WREN,
            COLUMN_3_POST_SYNAPTIC_WREN     => COLUMN_3_POST_SYNAPTIC_WREN
        );

    clk_process : process
    begin
        HP_CLK <= '1';
        wait for CLK_PERIOD/2;
        HP_CLK <= '0';
        wait for CLK_PERIOD/2;
    end process clk_process;

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
       wait for 100 ns;  
       HP_RST <= '0';
       wait for 100 ns;

       COLUMN_0_PRE_SYNAPTIC_DIN <= (others=>'0');
       COLUMN_1_PRE_SYNAPTIC_DIN <= (others=>'0');
       COLUMN_2_PRE_SYNAPTIC_DIN <= (others=>'0');
       COLUMN_3_PRE_SYNAPTIC_DIN <= (others=>'0');
        
       wait for CLK_PERIOD;

       wait for CLK_PERIOD;
       PRE_SYN_DATA_PULL <= '1';
         
       wait until COLUMN_0_PRE_SYNAPTIC_RDEN = '1' and COLUMN_1_PRE_SYNAPTIC_RDEN = '1' and COLUMN_2_PRE_SYNAPTIC_RDEN = '1' and COLUMN_3_PRE_SYNAPTIC_RDEN = '1';
       wait for CLK_PERIOD;
        
       for i in 0 to ROW-1 loop
       
           COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           
           COLUMN_0_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
       
           wait for CLK_PERIOD;
       
       end loop;
                              
       PRE_SYN_DATA_PULL <= '0';
        
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'1');
       SPIKE_VLD <= '1';
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'0');
       SPIKE_VLD <= '0';
       wait for CLK_PERIOD;
       PRE_SYN_DATA_PULL <= '1';        
       wait until COLUMN_0_PRE_SYNAPTIC_RDEN = '1' and COLUMN_1_PRE_SYNAPTIC_RDEN = '1' and COLUMN_2_PRE_SYNAPTIC_RDEN = '1' and COLUMN_3_PRE_SYNAPTIC_RDEN = '1';
       wait for CLK_PERIOD;
       
       for i in 0 to ROW-1 loop
       
           COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           
           COLUMN_0_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
       
           wait for CLK_PERIOD;
       
       end loop;
                              
       PRE_SYN_DATA_PULL <= '0';
        
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'1');
       SPIKE_VLD <= '1';
       wait for CLK_PERIOD;        
       SPIKE_IN <= (others=>'0');
       SPIKE_VLD <= '0';
       
        wait for CLK_PERIOD;
       PRE_SYN_DATA_PULL <= '1';
         
       wait until COLUMN_0_PRE_SYNAPTIC_RDEN = '1' and COLUMN_1_PRE_SYNAPTIC_RDEN = '1' and COLUMN_2_PRE_SYNAPTIC_RDEN = '1' and COLUMN_3_PRE_SYNAPTIC_RDEN = '1';
       wait for CLK_PERIOD;
        
       for i in 0 to ROW-1 loop
       
           COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           
           COLUMN_0_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
       
           wait for CLK_PERIOD;
       
       end loop;
                              
       PRE_SYN_DATA_PULL <= '0';
        
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'1');
       SPIKE_VLD <= '1';
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'0');
       SPIKE_VLD <= '0';
       wait for CLK_PERIOD;
       PRE_SYN_DATA_PULL <= '1';        
       wait until COLUMN_0_PRE_SYNAPTIC_RDEN = '1' and COLUMN_1_PRE_SYNAPTIC_RDEN = '1' and COLUMN_2_PRE_SYNAPTIC_RDEN = '1' and COLUMN_3_PRE_SYNAPTIC_RDEN = '1';
       wait for CLK_PERIOD;
       
       for i in 0 to ROW-1 loop
       
           COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           
           COLUMN_0_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
       
           wait for CLK_PERIOD;
       
       end loop;
                              
       PRE_SYN_DATA_PULL <= '0';
        
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'1');
       SPIKE_VLD <= '1';
       wait for CLK_PERIOD;        
       SPIKE_IN <= (others=>'0');
       SPIKE_VLD <= '0';
       
              wait for CLK_PERIOD;
       PRE_SYN_DATA_PULL <= '1';
         
       wait until COLUMN_0_PRE_SYNAPTIC_RDEN = '1' and COLUMN_1_PRE_SYNAPTIC_RDEN = '1' and COLUMN_2_PRE_SYNAPTIC_RDEN = '1' and COLUMN_3_PRE_SYNAPTIC_RDEN = '1';
       wait for CLK_PERIOD;
        
       for i in 0 to ROW-1 loop
       
           COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(i+1,8));
           
           COLUMN_0_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(i+1,8));
       
           wait for CLK_PERIOD;
       
       end loop;
                              
       PRE_SYN_DATA_PULL <= '0';
        
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'1');
       SPIKE_VLD <= '1';
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'0');
       SPIKE_VLD <= '0';
       wait for CLK_PERIOD;
       PRE_SYN_DATA_PULL <= '1';        
       wait until COLUMN_0_PRE_SYNAPTIC_RDEN = '1' and COLUMN_1_PRE_SYNAPTIC_RDEN = '1' and COLUMN_2_PRE_SYNAPTIC_RDEN = '1' and COLUMN_3_PRE_SYNAPTIC_RDEN = '1';
       wait for CLK_PERIOD;
       
       for i in 0 to ROW-1 loop
       
           COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8) <= std_logic_vector(to_signed(16*i+1,8));
           
           COLUMN_0_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_1_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_2_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
           COLUMN_3_PRE_SYNAPTIC_DIN(7 downto 0) <= std_logic_vector(to_signed(16*i+1,8));
       
           wait for CLK_PERIOD;
       
       end loop;
                              
       PRE_SYN_DATA_PULL <= '0';
        
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'0');
       SPIKE_VLD <= '1';
       wait for CLK_PERIOD;
       SPIKE_IN <= (others=>'0');
       SPIKE_VLD <= '0';
             
       wait for CLK_PERIOD;     
       wait for 100*CLK_PERIOD;
        
       assert false report "Test: OK" severity failure;
        
    end process;

end architecture Behavioral;
