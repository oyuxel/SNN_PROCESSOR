library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package nmemportdef is
    function clogb2 (depth: in natural) return integer;
end nmemportdef;

package body nmemportdef is

function clogb2( depth : natural) return integer is
variable temp    : integer := depth;
variable ret_val : integer := 0;
begin
    while temp > 1 loop
        ret_val := ret_val + 1;
        temp    := temp / 2;
    end loop;
    return ret_val;
end function;

end package body nmemportdef;


library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.nmemportdef.all;


entity HYPERCOLUMN is
    Generic(
            ROW              : integer := 64   ;
            SYNAPSE_MEM_DEPTH  : integer := 2048

            );
    Port (
            HP_CLK                          : in  std_logic;
            HP_RST                          : in  std_logic;
            SPIKE_IN                        : in  std_logic_vector(ROW-1 downto 0);
            SPIKE_VLD                       : in  std_logic;
            SPIKE_OUT                       : out std_logic_vector(ROW-1 downto 0);
            SPIKE_VLD_OUT                   : out std_logic;
            -- COLUMN DATA INPUTS
            COLUMN_0_PRE_SYNAPTIC_DIN       : in  std_logic_vector(15 downto 0);
            COLUMN_1_PRE_SYNAPTIC_DIN       : in  std_logic_vector(15 downto 0);
            COLUMN_2_PRE_SYNAPTIC_DIN       : in  std_logic_vector(15 downto 0);
            COLUMN_3_PRE_SYNAPTIC_DIN       : in  std_logic_vector(15 downto 0);
            COLUMN_0_SYNAPSE_START_ADDRESS  : in  std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
            COLUMN_1_SYNAPSE_START_ADDRESS  : in  std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
            COLUMN_2_SYNAPSE_START_ADDRESS  : in  std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
            COLUMN_3_SYNAPSE_START_ADDRESS  : in  std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
            -- COLUMN DATA LATCHES ENABLE INPUTS
            PRE_SYN_DATA_PULL               : in  std_logic_vector(3 downto 0);
            -- COLUMNS PRE-SYNAPTIC SUM OUTPUTS
            COLN_0_SYN_SUM_OUT              : out std_logic_vector(15 downto 0);
            COLN_1_SYN_SUM_OUT              : out std_logic_vector(15 downto 0);
            COLN_2_SYN_SUM_OUT              : out std_logic_vector(15 downto 0);
            COLN_3_SYN_SUM_OUT              : out std_logic_vector(15 downto 0);
            COLN_VECTOR_SYN_SUM_VALID       : out std_logic_vector(3 downto 0);
            -- POST SYNAPTIC DATA OUTPUTS 
            COLUMN_0_POST_SYNAPTIC_DOUT     : out std_logic_vector(15 downto 0);
            COLUMN_1_POST_SYNAPTIC_DOUT     : out std_logic_vector(15 downto 0);
            COLUMN_2_POST_SYNAPTIC_DOUT     : out std_logic_vector(15 downto 0);
            COLUMN_3_POST_SYNAPTIC_DOUT     : out std_logic_vector(15 downto 0);
            COLUMN_0_SYNAPSE_WR_ADDRESS     : out std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
            COLUMN_1_SYNAPSE_WR_ADDRESS     : out std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
            COLUMN_2_SYNAPSE_WR_ADDRESS     : out std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
            COLUMN_3_SYNAPSE_WR_ADDRESS     : out std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
            COLUMN_0_POST_SYNAPTIC_WREN     : out std_logic;
            COLUMN_1_POST_SYNAPTIC_WREN     : out std_logic;
            COLUMN_2_POST_SYNAPTIC_WREN     : out std_logic;
            COLUMN_3_POST_SYNAPTIC_WREN     : out std_logic

     );
end HYPERCOLUMN;

architecture last_ship_sails of HYPERCOLUMN is

    component XBAR_PRIMITIVE_2x4 is
      Generic(
              SPIKE_PIPELINE_REGS  : integer range 0 to 1:= 1;
              OUTPUT_PIPELINE_REGS : integer range 0 to 1:= 1;
              ROW_1_PIPELINE_REGS  : integer range 0 to 1:= 1;
              ROW_2_PIPELINE_REGS  : integer range 0 to 1:= 1
            );
      Port ( 
            XBAR_CLK     : in  std_logic;
            XBAR_CLR     : in  std_logic;
            SPIKE_IN_0   : in  std_logic;
            SPIKE_IN_1   : in  std_logic;
            ROW0_CE      : in  std_logic;
            ROW1_CE      : in  std_logic;
            W00          : in  std_logic_vector(7  downto 0);
            W01          : in  std_logic_vector(7  downto 0);
            W02          : in  std_logic_vector(7  downto 0);
            W03          : in  std_logic_vector(7  downto 0);
            W10          : in  std_logic_vector(7  downto 0);
            W11          : in  std_logic_vector(7  downto 0);
            W12          : in  std_logic_vector(7  downto 0);
            W13          : in  std_logic_vector(7  downto 0);
            PE_OUT_0     : out std_logic_vector(15  downto 0);
            PE_OUT_1     : out std_logic_vector(15  downto 0);
            PE_OUT_2     : out std_logic_vector(15  downto 0);
            PE_OUT_3     : out std_logic_vector(15  downto 0)
            );
    end component XBAR_PRIMITIVE_2x4;
    
    component INTERNAL_FIFO is
    generic (
        DEPTH : integer := 16;
        WIDTH : integer := 16 
        );
    port (
        clk        : in  std_logic;                    
        rst        : in  std_logic;                    
        wr_en      : in  std_logic;                    
        rd_en      : in  std_logic;                      
        data_in    : in  std_logic_vector(WIDTH-1 downto 0);  
        data_out   : out std_logic_vector(WIDTH-1 downto 0);  
        full       : out std_logic;                      
        empty      : out std_logic                     
        );
    end component INTERNAL_FIFO;
    
    component Pipeline_Adder is
    generic (
        N : integer := 8 
        );
    port (
        CLK    : in  std_logic;
        RST    : in  std_logic;
        INPUT  : in  std_logic_vector(16*N-1 downto 0); 
        OUTPUT : out std_logic_vector(15 downto 0)
        );
    end component Pipeline_Adder;

    function XBARCount(rows : integer) return integer is
        variable result : integer;
    begin
        assert rows >= 2
            report "Error: Input rows must be 2 or greater."
            severity failure;
    
        assert rows mod 2 = 0
            report "Error: Input rows must be a multiple of 2."
            severity failure;
        result := rows / 2;
        return result;
    end function;
    
    function clogb2(depth : natural) return integer is
        variable temp    : integer := depth;
        variable ret_val : integer := 0;
    begin
        while temp > 1 loop
            ret_val := ret_val + 1;
            temp    := temp / 2;
        end loop;
        return ret_val;
    end function;
    
    function log2(n : integer) return integer is
        variable result : integer := 0;
        variable value : integer := n;
    begin
        while value > 1 loop
            value := value / 2;
            result := result + 1;
        end loop;
        return result;
    end function;

    
    type XBAR_RES is array (natural range <>) of std_logic_vector(15 downto 0);
    signal COL_0_RES : XBAR_RES(0 to XBARCount(ROW)-1);
    signal COL_1_RES : XBAR_RES(0 to XBARCount(ROW)-1);
    signal COL_2_RES : XBAR_RES(0 to XBARCount(ROW)-1);
    signal COL_3_RES : XBAR_RES(0 to XBARCount(ROW)-1);
    
    signal COL_0     : std_logic_vector(16*XBARCount(ROW)-1 downto 0);
    signal COL_1     : std_logic_vector(16*XBARCount(ROW)-1 downto 0);
    signal COL_2     : std_logic_vector(16*XBARCount(ROW)-1 downto 0);
    signal COL_3     : std_logic_vector(16*XBARCount(ROW)-1 downto 0);
    
    signal ROWLOCKSHREG : std_logic_vector(0 to ROW-1);

    constant SPIKECYCLELIM : integer := ROW;
    
    signal SPIKECYCLE : integer;
    
    type SUM_PP_STAGE is array (natural range <>,natural range <>) of signed(15 downto 0);

    signal COLUMN_0_INTERNAL_FIFO_WREN_DLY1   : std_logic;
    signal COLUMN_1_INTERNAL_FIFO_WREN_DLY1   : std_logic;
    signal COLUMN_2_INTERNAL_FIFO_WREN_DLY1   : std_logic;
    signal COLUMN_3_INTERNAL_FIFO_WREN_DLY1   : std_logic;
    
    signal COLUMN_0_INTERNAL_FIFO_WREN_DLY2   : std_logic;
    signal COLUMN_1_INTERNAL_FIFO_WREN_DLY2   : std_logic;
    signal COLUMN_2_INTERNAL_FIFO_WREN_DLY2   : std_logic;
    signal COLUMN_3_INTERNAL_FIFO_WREN_DLY2   : std_logic;
    
    signal COLUMN_0_INTERNAL_FIFO_WREN_DLY3   : std_logic;
    signal COLUMN_1_INTERNAL_FIFO_WREN_DLY3   : std_logic;
    signal COLUMN_2_INTERNAL_FIFO_WREN_DLY3   : std_logic;
    signal COLUMN_3_INTERNAL_FIFO_WREN_DLY3   : std_logic;
    
    signal COLUMN_0_POST_SYNAPTIC_WREN_REG   : std_logic;
    signal COLUMN_1_POST_SYNAPTIC_WREN_REG   : std_logic;
    signal COLUMN_2_POST_SYNAPTIC_WREN_REG   : std_logic;
    signal COLUMN_3_POST_SYNAPTIC_WREN_REG   : std_logic;
            
    signal COLUMN_0_INTERNAL_FIFO_RDEN   : std_logic;
    signal COLUMN_1_INTERNAL_FIFO_RDEN   : std_logic;
    signal COLUMN_2_INTERNAL_FIFO_RDEN   : std_logic;
    signal COLUMN_3_INTERNAL_FIFO_RDEN   : std_logic;
    
    signal COLUMN_0_INTERNAL_FIFO_DOUT     : std_logic_vector(15 downto 0);
    signal COLUMN_1_INTERNAL_FIFO_DOUT     : std_logic_vector(15 downto 0);
    signal COLUMN_2_INTERNAL_FIFO_DOUT     : std_logic_vector(15 downto 0);
    signal COLUMN_3_INTERNAL_FIFO_DOUT     : std_logic_vector(15 downto 0);
            
    signal SPIKEDATA : std_logic_vector(ROW-1 downto 0);
    signal SYNAPSE_COUNTER : integer;
    signal SYNAPSE_COUNTER_LIM : integer;
    signal SYNAPSE_COUNTER_LIM_1 : integer;
    
    signal COL_0_ADDR: integer range 0 to SYNAPSE_MEM_DEPTH - 1;
    signal COL_1_ADDR: integer range 0 to SYNAPSE_MEM_DEPTH - 1;
    signal COL_2_ADDR: integer range 0 to SYNAPSE_MEM_DEPTH - 1;
    signal COL_3_ADDR: integer range 0 to SYNAPSE_MEM_DEPTH - 1;
    
    constant SYNAPSELIM : integer := ROW-1;
    signal POSTSYN_COUNT : integer range 0 to ROW-1;
    
    type POST_SYN_STATES is (IDLE,FIFO_RD);
    signal POST_SYN_STATE : POST_SYN_STATES;
    
    type EVENT_CHECK_STATES is (IDLE,TIMESTAMP_UPDATE);
    signal EVENT_CHECK_STATE : EVENT_CHECK_STATES;
    
    signal ROWLOCK : std_logic;
    signal ROWLOCK_DLY1 : std_logic;
    
    constant SUMDELAY : integer := log2(ROW)-1;
    signal DELAYCHAIN : std_logic_vector(0 to SUMDELAY);
    
    signal SPIKE_VLD_D1 : std_logic;
    signal SPIKE_VLD_D2 : std_logic;
    signal SPIKE_VLD_D3 : std_logic;
    
    signal XBAR_GATED_CLR : std_logic;

    
    begin
    
    assert ROW >= 2
    report "Error: ROW must be greater than or equal to 2."
    severity failure;

    assert ROW mod 2 = 0
    report "Error: ROW must be a power of 2."
    severity failure;
    
    XBAR_GATED_CLR <= HP_RST or SPIKE_VLD_D3;
    
    PRIMITIVE_ARRAYGEN : for i in 0 to XBARCount(ROW)-1 generate
    
            FIRST_XBAR: if i=0  generate
    
                XBAR_INST:  XBAR_PRIMITIVE_2x4
                    Generic Map (
                                SPIKE_PIPELINE_REGS  => 1,
                                OUTPUT_PIPELINE_REGS => 1,
                                ROW_1_PIPELINE_REGS  => 1,
                                ROW_2_PIPELINE_REGS  => 1
                                )
                        Port Map( 
                                XBAR_CLK     => HP_CLK,
                                XBAR_CLR     => XBAR_GATED_CLR,
                                SPIKE_IN_0   => SPIKE_IN(ROW-2),
                                SPIKE_IN_1   => SPIKE_IN(ROW-1),
                                ROW0_CE      => ROWLOCKSHREG(ROW-2),
                                ROW1_CE      => ROWLOCKSHREG(ROW-1),
                                W00          => COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8),
                                W01          => COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8),
                                W02          => COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8),
                                W03          => COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8),
                                W10          => COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8),
                                W11          => COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8),
                                W12          => COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8),
                                W13          => COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8),
                                PE_OUT_0     => COL_0_RES(0),
                                PE_OUT_1     => COL_1_RES(0),
                                PE_OUT_2     => COL_2_RES(0),
                                PE_OUT_3     => COL_3_RES(0)
                                );
     
            end generate FIRST_XBAR;
    
            MID_XBAR: if i>0 generate
    
                XBAR_INST:  XBAR_PRIMITIVE_2x4
                    Generic Map (
                                SPIKE_PIPELINE_REGS  => 1,
                                OUTPUT_PIPELINE_REGS => 1,
                                ROW_1_PIPELINE_REGS  => 1,
                                ROW_2_PIPELINE_REGS  => 1
                                )
                        Port Map( 
                                XBAR_CLK     => HP_CLK,
                                XBAR_CLR     => XBAR_GATED_CLR,
                                SPIKE_IN_0   => SPIKE_IN(ROW-2-2*i),
                                SPIKE_IN_1   => SPIKE_IN(ROW-1-2*i),
                                ROW0_CE      => ROWLOCKSHREG(ROW-2-2*i),
                                ROW1_CE      => ROWLOCKSHREG(ROW-1-2*i),
                                W00          => COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8),
                                W01          => COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8),
                                W02          => COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8),
                                W03          => COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8),
                                W10          => COLUMN_0_PRE_SYNAPTIC_DIN(15 downto 8),
                                W11          => COLUMN_1_PRE_SYNAPTIC_DIN(15 downto 8),
                                W12          => COLUMN_2_PRE_SYNAPTIC_DIN(15 downto 8),
                                W13          => COLUMN_3_PRE_SYNAPTIC_DIN(15 downto 8),
                                PE_OUT_0     => COL_0_RES(i),
                                PE_OUT_1     => COL_1_RES(i),
                                PE_OUT_2     => COL_2_RES(i),
                                PE_OUT_3     => COL_3_RES(i)
                                );
     
            end generate MID_XBAR;
    
    end generate PRIMITIVE_ARRAYGEN;
    
    SUMGEN0 : if ROW = 2 generate
    
        SYNAPTIC_SUM : process(HP_CLK)
        
                        begin
                        
                            if(rising_edge(HP_CLK)) then
                            
                                    if(HP_RST = '1') then
                   
                                        COLN_0_SYN_SUM_OUT <= (others=>'0');
                                        COLN_1_SYN_SUM_OUT <= (others=>'0');
                                        COLN_2_SYN_SUM_OUT <= (others=>'0');
                                        COLN_3_SYN_SUM_OUT <= (others=>'0');     
                                        
                                    else
                                    
                                        COLN_0_SYN_SUM_OUT <= COL_0_RES(0);
                                        COLN_1_SYN_SUM_OUT <= COL_1_RES(0);
                                        COLN_2_SYN_SUM_OUT <= COL_2_RES(0);
                                        COLN_3_SYN_SUM_OUT <= COL_3_RES(0); 
                                        
                                    end if;      
    
                            end if;
                        
        end process SYNAPTIC_SUM;
    
    end generate SUMGEN0;
    
    SUMGEN1 : if ROW>2  generate
    
              VEC_GEN : for i in 0 to XBARCount(ROW)-1 generate
    
                    COL_0((i+1)*16-1 downto 16*i) <= COL_0_RES(i);
                    COL_1((i+1)*16-1 downto 16*i) <= COL_1_RES(i);
                    COL_2((i+1)*16-1 downto 16*i) <= COL_2_RES(i);
                    COL_3((i+1)*16-1 downto 16*i) <= COL_3_RES(i);

              end generate VEC_GEN;
    
             COLSUM_0: Pipeline_Adder 
                generic Map(
                             N => ROW /2 
                         )
                 port Map(
                         CLK    => HP_CLK,
                         RST    => HP_RST,
                         INPUT  => COL_0,
                         OUTPUT => COLN_0_SYN_SUM_OUT
                     );
        
              COLSUM_1: Pipeline_Adder 
                generic Map(
                             N => ROW /2 
                         )
                 port Map(
                         CLK    => HP_CLK,
                         RST    => HP_RST,
                         INPUT  => COL_1,
                         OUTPUT => COLN_1_SYN_SUM_OUT
                     );
        
              COLSUM_2: Pipeline_Adder 
                generic Map(
                             N => ROW /2 
                         )
                 port Map(
                         CLK    => HP_CLK,
                         RST    => HP_RST,
                         INPUT  => COL_2,
                         OUTPUT => COLN_2_SYN_SUM_OUT
                     );
        
              COLSUM_3: Pipeline_Adder 
                generic Map(
                             N => ROW /2 
                         )
                 port Map(
                         CLK    => HP_CLK,
                         RST    => HP_RST,
                         INPUT  => COL_3,
                         OUTPUT => COLN_3_SYN_SUM_OUT
                     );
        
        
    end generate SUMGEN1;
    
    SPIKE_PASSTHROUGH : process(HP_CLK)
        
                        begin
                        
                            if(rising_edge(HP_CLK)) then
                            
--                                if(HP_RST = '1') then
--                                
--                                        SPIKE_OUT        <=  (others=>'0');  
--                                        SPIKE_VLD_OUT    <=  '0'; 
--                                
--                                else
                                             
                                        SPIKE_OUT          <=  SPIKE_IN ;  
                                        SPIKE_VLD_OUT      <=  SPIKE_VLD;   
 
                                     
--                                end if;
                            
                            end if;
                   
    end process SPIKE_PASSTHROUGH;
    
    SPIKECYCLES : process(HP_CLK)
        
                        begin
                        
                            if(rising_edge(HP_CLK)) then
                            
                                if(HP_RST = '1') then
                                
                                        SPIKECYCLE <= 0;
                                        ROWLOCKSHREG <= (others => '0');
                                
                                else
                                             
                                        if(ROWLOCK_DLY1 = '1') then
                                                  
                                            if(SPIKECYCLE = 0) then
                      
                                                SPIKECYCLE <= SPIKECYCLE + 1;  

                                                ROWLOCKSHREG(0) <= '1';
                                                                                            
                                            elsif(SPIKECYCLE > 0 and SPIKECYCLE < SPIKECYCLELIM) then
                                            
                                                ROWLOCKSHREG <= '0'&ROWLOCKSHREG(0 to ROW-2);
                                                SPIKECYCLE <= SPIKECYCLE + 1;
                                                
                                            else
                                            
                                                ROWLOCKSHREG <= (others=>'0');
                                                SPIKECYCLE <= 0;
                                            
                                            end if;
                                        
                                        else
                                            
                                            SPIKECYCLE <= 0;
                                            ROWLOCKSHREG <= (others => '0');                                         
                                        
                                        end if;  
                                     
                                end if;
                            
                            end if;
                   
    end process SPIKECYCLES;
    
    
    ROWLOCK <= PRE_SYN_DATA_PULL(3) or PRE_SYN_DATA_PULL(3) or PRE_SYN_DATA_PULL(2) or PRE_SYN_DATA_PULL(1) or PRE_SYN_DATA_PULL(0);
    
    
    DELAY_CHAIN : process(HP_CLK) 
    
                        begin
                        
                            if(rising_edge(HP_CLK)) then
                            
                                if(HP_RST = '1') then
                                
                                    COLN_VECTOR_SYN_SUM_VALID <= (others=>'0');
                                    ROWLOCK_DLY1 <= '0';
                                    
                                    COLUMN_0_INTERNAL_FIFO_WREN_DLY1 <= '0' ;
                                    COLUMN_1_INTERNAL_FIFO_WREN_DLY1 <= '0' ;
                                    COLUMN_2_INTERNAL_FIFO_WREN_DLY1 <= '0' ;
                                    COLUMN_3_INTERNAL_FIFO_WREN_DLY1 <= '0' ;                         
                                                                     
                                    COLUMN_0_INTERNAL_FIFO_WREN_DLY2 <= '0' ;
                                    COLUMN_1_INTERNAL_FIFO_WREN_DLY2 <= '0' ;
                                    COLUMN_2_INTERNAL_FIFO_WREN_DLY2 <= '0' ;
                                    COLUMN_3_INTERNAL_FIFO_WREN_DLY2 <= '0' ; 
                                    
                                else
          
                                     DELAYCHAIN(0) <= SPIKE_VLD;
                                     DELAYCHAIN(1 to SUMDELAY) <= DELAYCHAIN(0 to SUMDELAY-1);
                                     COLN_VECTOR_SYN_SUM_VALID(0) <= DELAYCHAIN(SUMDELAY);
                                     COLN_VECTOR_SYN_SUM_VALID(1) <= DELAYCHAIN(SUMDELAY);
                                     COLN_VECTOR_SYN_SUM_VALID(2) <= DELAYCHAIN(SUMDELAY);
                                     COLN_VECTOR_SYN_SUM_VALID(3) <= DELAYCHAIN(SUMDELAY);       
                                     
                                     COLUMN_0_INTERNAL_FIFO_WREN_DLY1 <= PRE_SYN_DATA_PULL(3);
                                     COLUMN_1_INTERNAL_FIFO_WREN_DLY1 <= PRE_SYN_DATA_PULL(2);
                                     COLUMN_2_INTERNAL_FIFO_WREN_DLY1 <= PRE_SYN_DATA_PULL(1);
                                     COLUMN_3_INTERNAL_FIFO_WREN_DLY1 <= PRE_SYN_DATA_PULL(0);                                      
                                     
                                     COLUMN_0_INTERNAL_FIFO_WREN_DLY2 <= COLUMN_0_INTERNAL_FIFO_WREN_DLY1;
                                     COLUMN_1_INTERNAL_FIFO_WREN_DLY2 <= COLUMN_1_INTERNAL_FIFO_WREN_DLY1;
                                     COLUMN_2_INTERNAL_FIFO_WREN_DLY2 <= COLUMN_2_INTERNAL_FIFO_WREN_DLY1;
                                     COLUMN_3_INTERNAL_FIFO_WREN_DLY2 <= COLUMN_3_INTERNAL_FIFO_WREN_DLY1;  
                                     
                                     COLUMN_0_INTERNAL_FIFO_WREN_DLY3 <= COLUMN_0_INTERNAL_FIFO_WREN_DLY2;
                                     COLUMN_1_INTERNAL_FIFO_WREN_DLY3 <= COLUMN_1_INTERNAL_FIFO_WREN_DLY2;
                                     COLUMN_2_INTERNAL_FIFO_WREN_DLY3 <= COLUMN_2_INTERNAL_FIFO_WREN_DLY2;
                                     COLUMN_3_INTERNAL_FIFO_WREN_DLY3 <= COLUMN_3_INTERNAL_FIFO_WREN_DLY2;  
                                                                          
                                     ROWLOCK_DLY1 <= ROWLOCK;
                                                                     
                                end if;
                            
                            end if;
                    
    end process DELAY_CHAIN;
    
        
    SYNAPSE_COUNT : process(HP_CLK)
    
                    begin
                                      
                        if(rising_edge(HP_CLK)) then
                            
                                if(HP_RST = '1') then
                                
                                    SYNAPSE_COUNTER_LIM   <= 0;
                                    SYNAPSE_COUNTER_LIM_1 <= 0;
                                    
                                else
                                
                                    if(COLUMN_0_INTERNAL_FIFO_WREN_DLY1 = '1' or COLUMN_1_INTERNAL_FIFO_WREN_DLY1 = '1' or COLUMN_2_INTERNAL_FIFO_WREN_DLY1 = '1' or COLUMN_3_INTERNAL_FIFO_WREN_DLY1 = '1') then
                                    
                                        SYNAPSE_COUNTER_LIM   <= 0;
                                        
                                    end if;
                                   
                                    if(COLUMN_0_INTERNAL_FIFO_WREN_DLY2 = '1' or COLUMN_1_INTERNAL_FIFO_WREN_DLY2 = '1' or COLUMN_2_INTERNAL_FIFO_WREN_DLY2 = '1' or COLUMN_3_INTERNAL_FIFO_WREN_DLY2 = '1') then
                                    
                                        SYNAPSE_COUNTER_LIM <= SYNAPSE_COUNTER_LIM + 1;

                                    end if;

                                    if( SPIKE_VLD_D2 = '1') then
                                    
                                        SYNAPSE_COUNTER_LIM_1 <= SYNAPSE_COUNTER_LIM;

                                    end if;
                
                                end if;
                                
                        end if;
                  
    end process SYNAPSE_COUNT;
    
    SPIKE_LATCH : process(HP_CLK)
    
                  begin
                  
                        if(rising_edge(HP_CLK)) then
                            
                                if(HP_RST = '1') then
                                
                                    SPIKEDATA <= (others=>'0');
                                
                                else
          
                                     if(SPIKE_VLD = '1') then
                                     
                                        SPIKEDATA <= SPIKE_IN;
                                                                                                           
                                     else
                                     
                                        SPIKEDATA <= SPIKEDATA;

                                     end if;                                    
                                
                                end if;
                            
                            end if;
                
    end process SPIKE_LATCH;
    
    COLUMN_0_SYNAPSE_WR_ADDRESS <= std_logic_vector(to_unsigned(COL_0_ADDR,COLUMN_0_SYNAPSE_WR_ADDRESS'length));
    COLUMN_1_SYNAPSE_WR_ADDRESS <= std_logic_vector(to_unsigned(COL_1_ADDR,COLUMN_1_SYNAPSE_WR_ADDRESS'length));
    COLUMN_2_SYNAPSE_WR_ADDRESS <= std_logic_vector(to_unsigned(COL_2_ADDR,COLUMN_2_SYNAPSE_WR_ADDRESS'length));
    COLUMN_3_SYNAPSE_WR_ADDRESS <= std_logic_vector(to_unsigned(COL_3_ADDR,COLUMN_3_SYNAPSE_WR_ADDRESS'length));

    POST_SYNAPTIC_OUT : process(HP_CLK)
    
                        begin
                  
                        if(rising_edge(HP_CLK)) then
                            
                                if(HP_RST = '1') then
                                
                                    POST_SYN_STATE <= IDLE;
                                
                                else
                                
                                    case POST_SYN_STATE is
                                 
                                        when IDLE =>
                                        
                                            COLUMN_0_INTERNAL_FIFO_RDEN <= '0';
                                            COLUMN_1_INTERNAL_FIFO_RDEN <= '0';
                                            COLUMN_2_INTERNAL_FIFO_RDEN <= '0';
                                            COLUMN_3_INTERNAL_FIFO_RDEN <= '0';
                                            SYNAPSE_COUNTER <= 0;
                                            
                                            if(SPIKE_VLD = '1') then
                                                POST_SYN_STATE <= FIFO_RD;
                                            else
                                                POST_SYN_STATE <= IDLE;
                                            end if;
                                        
                                        when FIFO_RD=>
                                        
                                        if(SYNAPSE_COUNTER = SYNAPSE_COUNTER_LIM_1-1) then
                                        
                                             POST_SYN_STATE <= IDLE;
                                             
                                        else
                                        
                                            SYNAPSE_COUNTER <= SYNAPSE_COUNTER + 1;
                                            COLUMN_0_INTERNAL_FIFO_RDEN <= '1';
                                            COLUMN_1_INTERNAL_FIFO_RDEN <= '1';
                                            COLUMN_2_INTERNAL_FIFO_RDEN <= '1';
                                            COLUMN_3_INTERNAL_FIFO_RDEN <= '1';
                                            
                                        end if;
                                        
                                        when others => 
                                                    NULL;
                                              
                                    end case;
                                
                                end if;
                            
                            end if;
                
    end process POST_SYNAPTIC_OUT;
    
    VLD_DELAY : process(HP_CLK)
    
                        begin
                        
                            if(rising_edge(HP_CLK)) then
                            
                                if(HP_RST = '1') then
                                
                                    SPIKE_VLD_D1 <= '0';
                                    SPIKE_VLD_D2 <= '0';
                                    SPIKE_VLD_D3 <= '0';
                            
                                else               
                                                            
                                    SPIKE_VLD_D1 <= SPIKE_VLD;
                                    SPIKE_VLD_D2 <= SPIKE_VLD_D1;
                                    SPIKE_VLD_D3 <= SPIKE_VLD_D2;
                                
                                end if;
                            
                            end if;
                       
    end process VLD_DELAY;


    COLUMN_0_POST_SYNAPTIC_WREN <= COLUMN_0_POST_SYNAPTIC_WREN_REG ; 
    COLUMN_1_POST_SYNAPTIC_WREN <= COLUMN_1_POST_SYNAPTIC_WREN_REG ; 
    COLUMN_2_POST_SYNAPTIC_WREN <= COLUMN_2_POST_SYNAPTIC_WREN_REG ; 
    COLUMN_3_POST_SYNAPTIC_WREN <= COLUMN_3_POST_SYNAPTIC_WREN_REG ; 

    EVENT_CHECK : process(HP_CLK)
    
                        begin
                  
                        if(rising_edge(HP_CLK)) then
                            
                                if(HP_RST = '1') then
                                
                                    EVENT_CHECK_STATE <= IDLE;
                                
                                else
                                
                                    case EVENT_CHECK_STATE is
                                 
                                        when IDLE =>
                                       
                                            COLUMN_0_POST_SYNAPTIC_DOUT  <= (others=>'0');
                                            COLUMN_1_POST_SYNAPTIC_DOUT  <= (others=>'0');
                                            COLUMN_2_POST_SYNAPTIC_DOUT  <= (others=>'0');
                                            COLUMN_3_POST_SYNAPTIC_DOUT  <= (others=>'0');
                                            COLUMN_0_POST_SYNAPTIC_WREN_REG  <= '0';
                                            COLUMN_1_POST_SYNAPTIC_WREN_REG  <= '0';
                                            COLUMN_2_POST_SYNAPTIC_WREN_REG  <= '0';
                                            COLUMN_3_POST_SYNAPTIC_WREN_REG  <= '0';
                                            POSTSYN_COUNT <= 0;
                                            
                                            if(SPIKE_VLD_D2 = '1') then
                                                EVENT_CHECK_STATE <= TIMESTAMP_UPDATE;
                                            else
                                                EVENT_CHECK_STATE <= IDLE;
                                            end if;
                                            
                                         if(SPIKE_VLD = '1') then
                                                                          
                                            COL_0_ADDR <= to_integer(unsigned(COLUMN_0_SYNAPSE_START_ADDRESS)) ;
                                            COL_1_ADDR <= to_integer(unsigned(COLUMN_1_SYNAPSE_START_ADDRESS)) ;
                                            COL_2_ADDR <= to_integer(unsigned(COLUMN_2_SYNAPSE_START_ADDRESS)) ;
                                            COL_3_ADDR <= to_integer(unsigned(COLUMN_3_SYNAPSE_START_ADDRESS)) ;                                    
                                                                         
                                         else
                                         
                                            COL_0_ADDR <= COL_0_ADDR ;
                                            COL_1_ADDR <= COL_1_ADDR ;
                                            COL_2_ADDR <= COL_2_ADDR ;
                                            COL_3_ADDR <= COL_3_ADDR ;     

                                         end if;  
                                        
                                        when TIMESTAMP_UPDATE =>
                                                                                    
                                            if(POSTSYN_COUNT = SYNAPSE_COUNTER_LIM_1-1) then
                                            
                                                 EVENT_CHECK_STATE <= IDLE;
                                                 POSTSYN_COUNT   <= 0;
                                            else
                                            
                                                POSTSYN_COUNT <= POSTSYN_COUNT + 1;
                                                EVENT_CHECK_STATE <= TIMESTAMP_UPDATE;
                                                
                                            end if;
                                            
                                            COLUMN_0_POST_SYNAPTIC_WREN_REG  <= '1';
                                            COLUMN_1_POST_SYNAPTIC_WREN_REG  <= '1';
                                            COLUMN_2_POST_SYNAPTIC_WREN_REG  <= '1';
                                            COLUMN_3_POST_SYNAPTIC_WREN_REG  <= '1';
                                            
                                            if(COLUMN_0_POST_SYNAPTIC_WREN_REG  = '1') then
                                            
                                                COL_0_ADDR <= COL_0_ADDR + 1;
                                                
                                            else
                                            
                                                COL_0_ADDR <= COL_0_ADDR;
                                                
                                            end if;
                                            
                                            if(COLUMN_1_POST_SYNAPTIC_WREN_REG  = '1') then
                                            
                                                COL_1_ADDR <= COL_1_ADDR + 1;
                                                
                                            else
                                            
                                                COL_1_ADDR <= COL_1_ADDR;
                                                
                                            end if;
                                            
                                            if(COLUMN_2_POST_SYNAPTIC_WREN_REG  = '1') then
                                            
                                                COL_2_ADDR <= COL_2_ADDR + 1;
                                                
                                            else
                                            
                                                COL_2_ADDR <= COL_2_ADDR;
                                                
                                            end if;                         
                                                                                        
                                            if(COLUMN_3_POST_SYNAPTIC_WREN_REG  = '1') then
                                            
                                                COL_3_ADDR <= COL_3_ADDR + 1;
                                                
                                            else
                                            
                                                COL_3_ADDR <= COL_3_ADDR;
                                                
                                            end if;                                                                                        

                                        
                                            if(SPIKEDATA(POSTSYN_COUNT) = '1') then
                                            
                                                COLUMN_0_POST_SYNAPTIC_DOUT(15 downto 8) <= COLUMN_0_INTERNAL_FIFO_DOUT(15 downto 8);
                                                COLUMN_0_POST_SYNAPTIC_DOUT(7  downto 0) <= (others=>'0');
   
                                                COLUMN_1_POST_SYNAPTIC_DOUT(15 downto 8) <= COLUMN_1_INTERNAL_FIFO_DOUT(15 downto 8);
                                                COLUMN_1_POST_SYNAPTIC_DOUT(7  downto 0) <= (others=>'0');
   
                                                COLUMN_2_POST_SYNAPTIC_DOUT(15 downto 8) <= COLUMN_2_INTERNAL_FIFO_DOUT(15 downto 8);
                                                COLUMN_2_POST_SYNAPTIC_DOUT(7  downto 0) <= (others=>'0');
   
                                                COLUMN_3_POST_SYNAPTIC_DOUT(15 downto 8) <= COLUMN_3_INTERNAL_FIFO_DOUT(15 downto 8);
                                                COLUMN_3_POST_SYNAPTIC_DOUT(7  downto 0) <= (others=>'0');

                                            else
                                            
                                                COLUMN_0_POST_SYNAPTIC_DOUT(15 downto 8) <= COLUMN_0_INTERNAL_FIFO_DOUT(15 downto 8);
                                                COLUMN_0_POST_SYNAPTIC_DOUT(7  downto 0) <= COLUMN_0_INTERNAL_FIFO_DOUT(7  downto 0);  
                                                                                             
                                                COLUMN_1_POST_SYNAPTIC_DOUT(15 downto 8) <= COLUMN_1_INTERNAL_FIFO_DOUT(15 downto 8);
                                                COLUMN_1_POST_SYNAPTIC_DOUT(7  downto 0) <= COLUMN_1_INTERNAL_FIFO_DOUT(7  downto 0);  
                                                                                             
                                                COLUMN_2_POST_SYNAPTIC_DOUT(15 downto 8) <= COLUMN_2_INTERNAL_FIFO_DOUT(15 downto 8);
                                                COLUMN_2_POST_SYNAPTIC_DOUT(7  downto 0) <= COLUMN_2_INTERNAL_FIFO_DOUT(7  downto 0);  
                                                                                             
                                                COLUMN_3_POST_SYNAPTIC_DOUT(15 downto 8) <= COLUMN_3_INTERNAL_FIFO_DOUT(15 downto 8);
                                                COLUMN_3_POST_SYNAPTIC_DOUT(7  downto 0) <= COLUMN_3_INTERNAL_FIFO_DOUT(7  downto 0);                                               
                                                                                            
                                            end if;
                                               
                                        
                                        when others => 
                                                    NULL;
                                              
                                    end case;
                                
                                end if;
                            
                            end if;
                
    end process EVENT_CHECK;

    COL_0_INTERNAL_FIFO : INTERNAL_FIFO 
        generic map (
            WIDTH      => 16,  
            DEPTH      => ROW 
            )
        port map (
            clk        => HP_CLK ,                    
            rst        => HP_RST ,                    
            wr_en      => COLUMN_0_INTERNAL_FIFO_WREN_DLY2,
            rd_en      => COLUMN_0_INTERNAL_FIFO_RDEN,
            data_in    => COLUMN_0_PRE_SYNAPTIC_DIN,
            data_out   => COLUMN_0_INTERNAL_FIFO_DOUT
            --full       => ,
            --empty      => ,
            );

    
    COL_1_INTERNAL_FIFO : INTERNAL_FIFO 
        generic map (
            WIDTH      => 16,  
            DEPTH      => ROW   
            )
        port map (
            clk        => HP_CLK ,                    
            rst        => HP_RST ,                    
            wr_en      => COLUMN_1_INTERNAL_FIFO_WREN_DLY2,
            rd_en      => COLUMN_1_INTERNAL_FIFO_RDEN,
            data_in    => COLUMN_1_PRE_SYNAPTIC_DIN,
            data_out   => COLUMN_1_INTERNAL_FIFO_DOUT
            --full       => ,
            --empty      => ,
            );
            
    
    COL_2_INTERNAL_FIFO : INTERNAL_FIFO 
        generic map (
            WIDTH      => 16,  
            DEPTH      => ROW  
            )
        port map (
            clk        => HP_CLK ,                    
            rst        => HP_RST ,                    
            wr_en      => COLUMN_2_INTERNAL_FIFO_WREN_DLY2,
            rd_en      => COLUMN_2_INTERNAL_FIFO_RDEN,
            data_in    => COLUMN_2_PRE_SYNAPTIC_DIN,
            data_out   => COLUMN_2_INTERNAL_FIFO_DOUT
            --full       => ,
            --empty      => ,
            );
            
    
    COL_3_INTERNAL_FIFO : INTERNAL_FIFO 
        generic map (
            WIDTH      => 16,  
            DEPTH      => ROW 
            )
        port map (
            clk        => HP_CLK ,                    
            rst        => HP_RST ,                    
            wr_en      => COLUMN_3_INTERNAL_FIFO_WREN_DLY2,
            rd_en      => COLUMN_3_INTERNAL_FIFO_RDEN,
            data_in    => COLUMN_3_PRE_SYNAPTIC_DIN,
            data_out   => COLUMN_3_INTERNAL_FIFO_DOUT
            --full       => ,
            --empty      => ,
            );            
                        
end last_ship_sails;
