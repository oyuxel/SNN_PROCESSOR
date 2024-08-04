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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nmemportdef.all;

-- New fully pipelined architecture.

entity ULEARN_SINGLE is
    Generic(
            LUT_TYPE : string := "distributed" ;
            SYNAPSE_MEM_DEPTH  : integer := 2048           
            );
    Port 
    ( 
        ULEARN_RST             : in  std_logic;
        ULEARN_CLK             : in  std_logic;
        -- SYNAPTIC FIFO PORT  
        SYN_DATA_IN            : in  std_logic_vector(15 downto 0);
        SYN_DIN_VLD            : in  std_logic;
        SYNAPSE_START_ADDRESS  : in  std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);  
        SYN_DATA_OUT           : out std_logic_vector(15 downto 0);
        SYN_DOUT_VLD           : out std_logic;
        SYNAPSE_WRITE_ADDRESS  : out std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);  
        -- CONTROL SIGNAL
        SYNAPSE_PRUNING        : in  std_logic;
        PRUN_THRESHOLD         : in  std_logic_vector(7 downto 0);
        IGNORE_ZERO_SYNAPSES   : in  std_logic;  -- EXPERIMENTAL, CAREFUL WITH THIS.
        IGNORE_SOFTLIMITS      : in  std_logic;  -- EXPERIMENTAL, CAREFUL WITH THIS.
        -- AXI4 LITE INTERFACE PORTS
        ULEARN_LUT_DIN         : in  std_logic_vector(7 downto 0);
        ULEARN_LUT_ADDR        : in  std_logic_vector(7 downto 0);
        ULEARN_LUT_EN          : in  std_logic;
        -- PARAMETER
        NMODEL_WMAX            : in  std_logic_vector(7 downto 0);
        NMODEL_WMIN            : in  std_logic_vector(7 downto 0);
        -- NMC PORT
        NMODEL_SPIKE_TIME      : in  std_logic_vector(7 downto 0)

    );
end ULEARN_SINGLE;

architecture society of ULEARN_SINGLE is				

    type RAM is array (255 downto 0) of std_logic_vector(7 downto 0);
    signal ULEARN_LUT : RAM;
    
    attribute ram_style : string;
    attribute ram_style of ULEARN_LUT : signal is LUT_TYPE;

    signal SKIP_SYNAPSE_P0 : std_logic;

    signal SKIP_EVENT_P0 : std_logic;

    signal PRE_SYN_P0 : std_logic;
    
    signal POST_SYN_P0 : std_logic;
    
    signal VLD_DLY_1  : std_logic;
    signal VLD_DLY_2  : std_logic;
    signal VLD_DLY_3  : std_logic;
    signal VLD_DLY_4  : std_logic;
    signal VLD_DLY_5  : std_logic;
    signal VLD_DLY_6  : std_logic;
    signal VLD_DLY_7  : std_logic;
    signal VLD_DLY_8  : std_logic;
    signal VLD_DLY_9  : std_logic;
    signal VLD_DLY_10 : std_logic;
    signal VLD_DLY_11 : std_logic;
    signal VLD_DLY_12 : std_logic;

    signal EVNT    : std_logic;
    signal EVNT_1    : std_logic;

    signal SYN_P0 : std_logic_vector(7 downto 0);
    signal TMP_P0 : std_logic_vector(7 downto 0);

    signal SYN_P1 : std_logic_vector(7 downto 0);
    signal TMP_P1 : std_logic_vector(7 downto 0);
    
    signal SYN_P2 : std_logic_vector(7 downto 0);
    signal TMP_P2 : std_logic_vector(7 downto 0);

    signal SYN_P3 : std_logic_vector(7 downto 0);
    signal TMP_P3 : std_logic_vector(7 downto 0);
    
    signal SYN_P4 : std_logic_vector(7 downto 0);
    signal TMP_P4 : std_logic_vector(7 downto 0);

    signal SYN_P5 : std_logic_vector(7 downto 0);
    signal TMP_P5 : std_logic_vector(7 downto 0);

    signal SYN_P6 : std_logic_vector(7 downto 0);
    signal TMP_P6 : std_logic_vector(7 downto 0);

    signal SYN_P7 : std_logic_vector(7 downto 0);
    signal TMP_P7 : std_logic_vector(7 downto 0);
    
    signal SYN_P8 : std_logic_vector(7 downto 0);
    signal TMP_P8 : std_logic_vector(7 downto 0);

    signal SYN_P9 : std_logic_vector(7 downto 0);
    signal TMP_P9 : std_logic_vector(7 downto 0);

    signal SYN_P10 : std_logic_vector(7 downto 0);
    signal TMP_P10 : std_logic_vector(7 downto 0);
        
    signal LOC : std_logic_vector(7 downto 0);
    
    signal COEFF   : signed(7 downto 0);
    
    signal WMAX : signed(8 downto 0);
    signal WMIN : signed(8 downto 0);
    
    signal PTRESH : signed(7 downto 0);
                
    signal WRADDRSTART : integer range 0 to SYNAPSE_MEM_DEPTH-1;          


begin

    SYNAPSE_WRITE_ADDRESS <= std_logic_vector(to_unsigned(WRADDRSTART,SYNAPSE_WRITE_ADDRESS'length));

    WRADDRCNTRLS : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    WRADDRSTART <= 0;
                
                else
                      
                    if(VLD_DLY_1 = '1' and VLD_DLY_2 = '0') then
                        WRADDRSTART <= to_integer(unsigned(SYNAPSE_START_ADDRESS));
                    end if;
                    
                    if(VLD_DLY_12 = '1') then
                        WRADDRSTART <= WRADDRSTART + 1;
                    --else
                    --    WRADDRSTART <=  WRADDRSTART;
                    end if;

                end if;
            
            end if;
    end process WRADDRCNTRLS;

    LIMITS : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    WMAX    <= (others=>'0');
                    WMIN    <= (others=>'0');
                    PTRESH  <= (others=>'0');
                
                else
                        
                    WMAX   <= signed(NMODEL_WMAX(7)&NMODEL_WMAX);
                    WMIN   <= signed(NMODEL_WMIN(7)&NMODEL_WMIN);
                    PTRESH <= signed(PRUN_THRESHOLD);
                end if;
            
            end if;
    end process LIMITS;
    
    VLD_DLY : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then
                     VLD_DLY_1  <= '0';
                     VLD_DLY_2  <= '0';
                     VLD_DLY_3  <= '0';
                     VLD_DLY_4  <= '0';
                     VLD_DLY_5  <= '0';
                     VLD_DLY_6  <= '0';
                     VLD_DLY_7  <= '0';
                     VLD_DLY_8  <= '0';
                     VLD_DLY_9  <= '0';
                     VLD_DLY_10 <= '0';
                     VLD_DLY_11 <= '0';
                     VLD_DLY_11 <= '0';
                     SYN_DOUT_VLD <= '0';
                else
                
                     VLD_DLY_1  <= SYN_DIN_VLD;
                     VLD_DLY_2  <= VLD_DLY_1 ;
                     VLD_DLY_3  <= VLD_DLY_2 ;
                     VLD_DLY_4  <= VLD_DLY_3 ;
                     VLD_DLY_5  <= VLD_DLY_4 ;
                     VLD_DLY_6  <= VLD_DLY_5 ;
                     VLD_DLY_7  <= VLD_DLY_6 ;
                     VLD_DLY_8  <= VLD_DLY_7 ;
                     VLD_DLY_9  <= VLD_DLY_8 ;
                     VLD_DLY_10 <= VLD_DLY_9 ;
                     VLD_DLY_11 <= VLD_DLY_10;
                     VLD_DLY_12 <= VLD_DLY_11;
                     SYN_DOUT_VLD <= VLD_DLY_11;

                end if;
            
            end if;
    end process VLD_DLY;

    INPUT_PP : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    SYN_P0 <= (others=>'0');
                    TMP_P0 <= (others=>'0');
                
                else
                        
                    SYN_P0 <= SYN_DATA_IN(15 downto  8);
                    TMP_P0 <= SYN_DATA_IN(7  downto  0);
                    
                end if;
            
            end if;
    end process INPUT_PP;
    
    SOFTLIMPRECHECK : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    SYN_P1 <= (others=>'0');
                    TMP_P1 <= (others=>'0');

                else

                    if(IGNORE_SOFTLIMITS='0') then
                    
                        if(signed(SYN_P0) < WMIN(7 downto 0)) then
                        
                            SYN_P1 <= std_logic_vector(WMIN(7 downto 0));
                            TMP_P1 <= TMP_P0;

                        elsif(signed(SYN_P0) > WMAX(7 downto 0)) then
                        
                            SYN_P1 <= std_logic_vector(WMAX(7 downto 0));
                            TMP_P1 <= TMP_P0;
                        else
                        
                            SYN_P1 <= SYN_P0;
                            TMP_P1 <= TMP_P0;

                        end if;
                        
                    else
                        SYN_P1 <= SYN_P0;
                        TMP_P1 <= TMP_P0;
                    end if;
          
                end if;
                            
            end if;
    end process SOFTLIMPRECHECK;
    
    PRUNING : process(ULEARN_CLK)
    
            begin
        
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                   SYN_P2 <= (others=>'0');
                   TMP_P2 <= (others=>'0');
                
                else
                        
                    if(SYNAPSE_PRUNING = '1') then
                    
                        if(signed(SYN_P1) < PTRESH) then
                        
                            SYN_P2 <= (others=>'0');
                            TMP_P2 <= (others=>'0');
                            
                        else
                        
                            SYN_P2 <= SYN_P1;
                            TMP_P2 <= TMP_P1;
                            
                        end if;                    
                        
                    
                    else
                    
                        SYN_P2 <= SYN_P1;
                        TMP_P2 <= TMP_P1;

                    end if;
                    
                end if;
            
            end if;
    end process PRUNING;

    SYNAPSE_CHECK : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then
                
                    SKIP_SYNAPSE_P0 <= '0';
                
                else

                    if(IGNORE_ZERO_SYNAPSES='1') then
                    
                        SKIP_SYNAPSE_P0 <= '0';
                        
                    else
                    
                        if(SYN_P2 = "00000000") then
                            SKIP_SYNAPSE_P0 <= '1';
                        else
                            SKIP_SYNAPSE_P0 <= '0';
                        end if;
                        
                    end if;
 
                end if;
            
            end if;
    end process SYNAPSE_CHECK;  

    TIME_CHECK : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then
                    
                    SKIP_EVENT_P0 <= '0';
                
                else
                        
                    if(TMP_P2 = "00000000") then
                        SKIP_EVENT_P0 <= '0';
                    else
                        SKIP_EVENT_P0 <= '1';
                    end if;
 
                end if;
            
            end if;
    end process TIME_CHECK; 
    
    MID_PP_STAGES : process(ULEARN_CLK)
            
            begin
            
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    SYN_P3 <= (others=>'0');
                    TMP_P3 <= (others=>'0');

                    SYN_P4 <= (others=>'0');
                    TMP_P4 <= (others=>'0');
                    
                    SYN_P5 <= (others=>'0');
                    TMP_P5 <= (others=>'0');
                    
                    SYN_P6 <= (others=>'0');
                    TMP_P6 <= (others=>'0');

                    SYN_P6 <= (others=>'0');
                    TMP_P6 <= (others=>'0');

                    SYN_P7 <= (others=>'0');
                    TMP_P7 <= (others=>'0');
                                                
                    TMP_P8 <= (others=>'0');  
                                               
                    TMP_P9 <= (others=>'0');                             
                                                            
                else

                    SYN_P3 <= SYN_P2;
                    TMP_P3 <= TMP_P2; 
                                          
                    SYN_P4 <= SYN_P3;
                    TMP_P4 <= TMP_P3;                       
                                          
                    SYN_P5 <= SYN_P4;
                    TMP_P5 <= TMP_P4;  
                                             
                    SYN_P6 <= SYN_P5;
                    TMP_P6 <= TMP_P5;  
                    
                    SYN_P7 <= SYN_P6;
                    TMP_P7 <= TMP_P6;
                    
                    TMP_P8 <= TMP_P7;
                    
                    TMP_P9 <= TMP_P8;
                                          
                end if;
            
            end if;
            
    end process MID_PP_STAGES;

    
    PRE_SYNAPTIC_CHECK : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    PRE_SYN_P0 <= '0';
                
                
                else

                    PRE_SYN_P0 <= not(SKIP_SYNAPSE_P0 or SKIP_EVENT_P0);
                       
 
                end if;
            
            end if;
    end process PRE_SYNAPTIC_CHECK; 
    
    POST_SYNAPTIC_CHECK : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then
                
                    POST_SYN_P0 <= '0';
        
                else
                
                    if(NMODEL_SPIKE_TIME = B"0000_0000") then
                        POST_SYN_P0 <= '1';
                    else
                        POST_SYN_P0 <= '0';
                    end if;
 
                end if;
            
            end if;
    end process POST_SYNAPTIC_CHECK; 
    
    
    EVENT_CHECK : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    EVNT <= '0';
                    EVNT_1 <= '0';
                
                else

                    EVNT <= POST_SYN_P0 or PRE_SYN_P0;
                    EVNT_1 <= EVNT;
                    
                end if;
            
            end if;
    end process EVENT_CHECK;


    LUT_LOC : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    LOC <= (others=>'0');
                
                else
                        
                    LOC <= std_logic_vector(signed(TMP_P5)-signed(NMODEL_SPIKE_TIME));
                    
                end if;
            
            end if;
    end process LUT_LOC;
    
    LUT_FETCH : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then
                
                    COEFF   <= (others=>'0');

                else
                        
                    if(EVNT_1 = '0') then
                        COEFF <= (others=>'0');
                    else
                        COEFF <= signed(ULEARN_LUT(to_integer(unsigned(LOC))));
                    end if;
                        
                end if;
                

            end if;
    end process LUT_FETCH;
  
    WEIGHT_CHANGE : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    SYN_P8 <= (others=>'0');
                
                else
                
                    SYN_P8 <= std_logic_vector(signed(SYN_P7)+COEFF);
          
                end if;
            
            end if;
    end process WEIGHT_CHANGE;

    POSTSOFTLIMCHECK : process(ULEARN_CLK)
    
        begin
            
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    SYN_P9 <= (others=>'0');

                else

                    if(IGNORE_SOFTLIMITS='0') then
                    
                        if(signed(SYN_P8) < WMIN(7 downto 0)) then
                        
                            SYN_P9 <= std_logic_vector(WMIN(7 downto 0));

                        elsif(signed(SYN_P8) > WMAX(7 downto 0)) then
                        
                            SYN_P9 <= std_logic_vector(WMAX(7 downto 0));
                        else
                        
                            SYN_P9 <= SYN_P8;

                        end if;
                        
                    else
                    
                        SYN_P9 <= SYN_P8;
                        
                    end if;
          
                end if;
                            
            end if;            
            
            
    end process POSTSOFTLIMCHECK;    
    
    TIME_INCREMENT : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then

                    SYN_P10 <= (others=>'0');
                    TMP_P10 <= (others=>'0');
                
                else
                
                    SYN_P10 <= SYN_P9;
                
                    if(TMP_P9 = X"7F") then
                        TMP_P10 <= X"7F";
                    else
                        TMP_P10 <= std_logic_vector(unsigned(TMP_P9)+1);
                    end if;
          
                end if;
            
            end if;
    end process TIME_INCREMENT;
    
    OUTPUT_PP : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
            
                if(ULEARN_RST = '1') then
                
                    SYN_DATA_OUT <= (others=>'0');
                
                else
                
                    if(VLD_DLY_11 = '1') then
           
                        SYN_DATA_OUT(15 downto  8) <= SYN_P10;
                        SYN_DATA_OUT(7  downto  0) <= TMP_P10;
                    else
                        SYN_DATA_OUT <= (others=>'0');
                    end if;
                    
                end if;
            
            end if;
    end process OUTPUT_PP;
    
    ULEARN_LUT_INIT : process(ULEARN_CLK)
        begin
            if(rising_edge(ULEARN_CLK)) then
                if(ULEARN_LUT_EN = '1') then
                    ULEARN_LUT(to_integer(unsigned(ULEARN_LUT_ADDR))) <= ULEARN_LUT_DIN;
                end if;
            end if;
    end process ULEARN_LUT_INIT;
    
    
end society;