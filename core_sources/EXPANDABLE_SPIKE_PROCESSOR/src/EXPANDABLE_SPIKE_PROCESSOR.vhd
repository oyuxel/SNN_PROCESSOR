library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

-- N ROW 4 COLUMN SPIKE PROCESSOR

entity EXPANDABLE_SPIKE_PROCESSOR is
    Generic(
            CROSSBAR_ROW_WIDTH : integer := 32;
            SYNAPSE_MEM_DEPTH  : integer := 2048;
            NEURAL_MEM_DEPTH   : integer := 1024            );
    Port ( 
            RST                               : in  std_logic;
            CLK                               : in  std_logic;
            NEW_TIMESTEP                      : in  std_logic_vector(3 downto 0);
            TIMESTEP_UPDATE                   : out std_logic_vector(3 downto 0);
            SPIKEVECTOR_IN                    : in  std_logic_vector(CROSSBAR_ROW_WIDTH-1 downto 0); 
            SPIKEVECTOR_VLD_IN                : in  std_logic;                        
            SPIKEVECTOR_OUT                   : out std_logic_vector(CROSSBAR_ROW_WIDTH-1 downto 0); 
            SPIKEVECTOR_VLD_OUT               : out std_logic;
            -- SPIKE SOURCE
            MAIN_SPIKE_BUFFER                 : out std_logic;
            AUXILLARY_SPIKE_BUFFER            : out std_logic;
            -- EVENT ACCEPTANCE
            EVENT_ACCEPT                      : out std_logic;
            -- STREAMING INTERFACES (RAM - NOT FIFO)
            SYNAPSE_ROUTE                     : in  std_logic_vector(1  downto 0); -- 00: Recycle, 01: In, 10: Out
            -- SYNAPTIC MEMORY 0
            SYNAPTIC_MEM_0_DIN                : in  std_logic_vector(15 downto 0);
            SYNAPTIC_MEM_0_DADDR              : in  std_logic_vector(31 downto 0);
            SYNAPTIC_MEM_0_EN                 : in  std_logic;
            SYNAPTIC_MEM_0_WREN               : in  std_logic;
            SYNAPTIC_MEM_0_RDEN               : in  std_logic;
            SYNAPTIC_MEM_0_DOUT               : out std_logic_vector(15 downto 0);
            -- SYNAPTIC MEMORY 1
            SYNAPTIC_MEM_1_DIN                : in  std_logic_vector(15 downto 0);
            SYNAPTIC_MEM_1_DADDR              : in  std_logic_vector(31 downto 0);
            SYNAPTIC_MEM_1_EN                 : in  std_logic;
            SYNAPTIC_MEM_1_WREN               : in  std_logic;
            SYNAPTIC_MEM_1_RDEN               : in  std_logic;
            SYNAPTIC_MEM_1_DOUT               : out std_logic_vector(15 downto 0);
            -- SYNAPTIC MEMORY 2
            SYNAPTIC_MEM_2_DIN                : in  std_logic_vector(15 downto 0);
            SYNAPTIC_MEM_2_DADDR              : in  std_logic_vector(31 downto 0);
            SYNAPTIC_MEM_2_EN                 : in  std_logic;
            SYNAPTIC_MEM_2_WREN               : in  std_logic;
            SYNAPTIC_MEM_2_RDEN               : in  std_logic;
            SYNAPTIC_MEM_2_DOUT               : out std_logic_vector(15 downto 0);
            -- SYNAPTIC MEMORY 3
            SYNAPTIC_MEM_3_DIN                : in  std_logic_vector(15 downto 0);
            SYNAPTIC_MEM_3_DADDR              : in  std_logic_vector(31 downto 0);
            SYNAPTIC_MEM_3_EN                 : in  std_logic;
            SYNAPTIC_MEM_3_WREN               : in  std_logic;
            SYNAPTIC_MEM_3_RDEN               : in  std_logic;
            SYNAPTIC_MEM_3_DOUT               : out std_logic_vector(15 downto 0);
            -- NMC REGS
            NMC_XNEVER_BASE                   : in  std_logic_vector(9 downto 0);
            NMC_XNEVER_HIGH                   : in  std_logic_vector(9 downto 0);
            -- NMC STATUS REGS
            NMC0_MATH_ERROR                   : out std_logic;
            NMC0_MEMORY_VIOLATION             : out std_logic;
            NMC1_MATH_ERROR                   : out std_logic;
            NMC1_MEMORY_VIOLATION             : out std_logic;
            NMC2_MATH_ERROR                   : out std_logic;
            NMC2_MEMORY_VIOLATION             : out std_logic;
            NMC3_MATH_ERROR                   : out std_logic;
            NMC3_MEMORY_VIOLATION             : out std_logic;            
            -- NMC PROGRAMMING INTERFACES
            NMC_PMODE_SWITCH                  : in  STD_LOGIC_VECTOR(1 DOWNTO 0);  -- 00 : NMC Memory ports are tied to Neural Memory Ports, 01 : NMC Memory External Access
            -- NMC 0
            NMC_NPARAM_DATA                   : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
            NMC_NPARAM_ADDR                   : in  STD_LOGIC_VECTOR(9  DOWNTO 0);
            NMC_PROG_MEM_PORTA_EN             : in  STD_LOGIC;
            NMC_PROG_MEM_PORTA_WEN            : in  STD_LOGIC;
            -- NMC SPIKE OUTPUTS
            NMC_0_NMODEL_SPIKE_OUT            : out std_logic; 
            NMC_0_NMODEL_SPIKE_VLD            : out std_logic;   
            NMC_1_NMODEL_SPIKE_OUT            : out std_logic; 
            NMC_1_NMODEL_SPIKE_VLD            : out std_logic;  
            NMC_2_NMODEL_SPIKE_OUT            : out std_logic; 
            NMC_2_NMODEL_SPIKE_VLD            : out std_logic;  
            NMC_3_NMODEL_SPIKE_OUT            : out std_logic; 
            NMC_3_NMODEL_SPIKE_VLD            : out std_logic; 
            NMC_0_W_AUX_BUFFER                : out std_logic;
            NMC_0_W_OUT_BUFFER                : out std_logic;
            NMC_1_W_AUX_BUFFER                : out std_logic;
            NMC_1_W_OUT_BUFFER                : out std_logic;
            NMC_2_W_AUX_BUFFER                : out std_logic;
            NMC_2_W_OUT_BUFFER                : out std_logic; 
            NMC_3_W_AUX_BUFFER                : out std_logic;
            NMC_3_W_OUT_BUFFER                : out std_logic;
            -- AXI4 LITE INTERFACE PORT
            LEARN_LUT_DIN                     : in  std_logic_vector(7 downto 0);
            LEARN_LUT_ADDR                    : in  std_logic_vector(7 downto 0);
            LEARN_LUT_EN                      : in  std_logic;
            -- NEURAL MEMORY INTERFACES
            NMC_0_NMEM_ADDR                   : in  std_logic_vector(31 downto 0);
            NMC_0_NMEM_DIN                    : in  std_logic_vector(31 downto 0);	
            NMC_0_NMEM_DOUT                   : out std_logic_vector(31 downto 0);
            NMC_0_EN                          : in  std_logic; 
            NMC_0_WREN                        : in  std_logic; 
            NMC_0_RST                         : in  std_logic;
            NMC_1_NMEM_ADDR                   : in  std_logic_vector(31 downto 0);
            NMC_1_NMEM_DIN                    : in  std_logic_vector(31 downto 0);	
            NMC_1_NMEM_DOUT                   : out std_logic_vector(31 downto 0);
            NMC_1_EN                          : in  std_logic; 
            NMC_1_WREN                        : in  std_logic; 
            NMC_1_RST                         : in  std_logic; 
            NMC_2_NMEM_ADDR                   : in  std_logic_vector(31 downto 0);
            NMC_2_NMEM_DIN                    : in  std_logic_vector(31 downto 0);	
            NMC_2_NMEM_DOUT                   : out std_logic_vector(31 downto 0);
            NMC_2_EN                          : in  std_logic; 
            NMC_2_WREN                        : in  std_logic; 
            NMC_2_RST                         : in  std_logic; 
            NMC_3_NMEM_ADDR                   : in  std_logic_vector(31 downto 0);
            NMC_3_NMEM_DIN                    : in  std_logic_vector(31 downto 0);	
            NMC_3_NMEM_DOUT                   : out std_logic_vector(31 downto 0);
            NMC_3_EN                          : in  std_logic; 
            NMC_3_WREN                        : in  std_logic; 
            NMC_3_RST                         : in  std_logic 
        );
end EXPANDABLE_SPIKE_PROCESSOR;

architecture hole_in_the_sky of EXPANDABLE_SPIKE_PROCESSOR is

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

component NMC is
    Port ( 
            NMC_CLK                     : in   std_logic;  -- SYNCHRONOUS SOFT RESET
            NMC_STATE_RST               : in   std_logic;  -- RESETS THE NMC STATES, FP16MAC and REGISTERS
            FMAC_EXTERN_RST             : in   std_logic;
            NMC_HARD_RST                : in   std_logic;  -- SYNCHRONOUS HARD RESET (RESETS THE WHOLE IP! INCLUDING MEMORY)
            --  IP CONTROLS
            NMC_COLD_START              : in   std_logic;  -- START PROGRAM FLOW REGARDLESS OF THE STATE OF THE INPUT CURRENT
            PARTIAL_CURRENT_RDY         : in   std_logic;
            -- NMC AXI4LITE REGISTERS
            NMC_XNEVER_REGION_BASEADDR  : in   std_logic_vector(9 downto 0);
            NMC_XNEVER_REGION_HIGHADDR  : in   std_logic_vector(9 downto 0);
            -- FROM DISTRIBUTOR
            NMODEL_LAST_SPIKE_TIME      : in   STD_LOGIC_VECTOR(7  DOWNTO 0); 
            NMODEL_SYN_QFACTOR          : in   STD_LOGIC_VECTOR(15 DOWNTO 0); 
            NMODEL_PF_LOW_ADDR          : in   STD_LOGIC_VECTOR(9  DOWNTO 0); 
            NMODEL_NPARAM_DATA          : in   STD_LOGIC_VECTOR(15 DOWNTO 0);
            NMODEL_NPARAM_ADDR          : in   STD_LOGIC_VECTOR(9  DOWNTO 0);
            NMODEL_REFRACTORY_DUR       : in   std_logic_vector(7  downto 0);
            NMODEL_PROG_MEM_PORTA_EN    : in   STD_LOGIC;
            NMODEL_PROG_MEM_PORTA_WEN   : in   STD_LOGIC;
            -- FROM HYPERCOLUMNS
            NMC_NMODEL_PSUM_IN          : in   std_logic_vector(15 downto 0);
            -- TO AXON HANDLER
            NMC_NMODEL_SPIKE_OUT        : out  std_logic; 
            NMC_NMODEL_SPIKE_VLD        : out  std_logic;
            -- TO REDISTRIBUTOR
            R_NNMODEL_NEW_SPIKE_TIME    : out  std_logic_vector(7  downto 0);
            R_NMODEL_NPARAM_DATAOUT     : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
            R_NMODEL_REFRACTORY_DUR     : OUT  std_logic_vector(7  downto 0);
            REDIST_NMODEL_PORTB_TKOVER  : in   std_logic;
            REDIST_NMODEL_DADDR         : in   std_logic_vector(9 downto 0);
            -- IP STATUS FLAGS
            NMC_NMODEL_FINISHED         : out std_logic;
            -- ERROR FLAGS
            NMC_MATH_ERROR              : out std_logic;
            NMC_MEMORY_VIOLATION        : out std_logic
    );
end component NMC;


component ULEARN_SINGLE is
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
end component ULEARN_SINGLE;

component AUTO_RAM_INSTANCE is
generic (
    RAM_WIDTH       : integer := 32;                
    RAM_DEPTH       : integer := 2048  ;            
    RAM_PERFORMANCE : string  := "LOW_LATENCY"      
    );
port (
        addra : in std_logic_vector((clogb2(RAM_DEPTH)-1) downto 0);    
        addrb : in std_logic_vector((clogb2(RAM_DEPTH)-1) downto 0);    
        dina  : in std_logic_vector(RAM_WIDTH-1 downto 0);		        
        dinb  : in std_logic_vector(RAM_WIDTH-1 downto 0);		        
        clka  : in std_logic;                       			        
        clkb  : in std_logic;                       			        
        wea   : in std_logic;                       			        
        web   : in std_logic;                       			        
        ena   : in std_logic;                       			        
        enb   : in std_logic;                       			        
        rsta  : in std_logic;                       			        
        rstb  : in std_logic;                       			        
        regcea: in std_logic;                       			        
        regceb: in std_logic;                       			        
        douta : out std_logic_vector(RAM_WIDTH-1 downto 0);   			      
        doutb : out std_logic_vector(RAM_WIDTH-1 downto 0)  
    );
end component AUTO_RAM_INSTANCE;

component HYPERCOLUMN is
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
end component HYPERCOLUMN;

component SYNAPTIC_FIFO is
   generic(
            SYNAPTIC_FIFO_DEPTH : integer := 2048) ;
    Port ( 
            SYN_FIFO_ALMOSTEMPTY : out std_logic; 
            SYN_FIFO_ALMOSTFULL  : out std_logic; 
            SYN_FIFO_DO          : out std_logic_vector(15 downto 0); 
            SYN_FIFO_EMPTY       : out std_logic; 
            SYN_FIFO_FULL        : out std_logic; 
            SYN_FIFO_RDCOUNT     : out std_logic_vector(11 downto 0);
            SYN_FIFO_RDERR       : out std_logic; 
            SYN_FIFO_WRCOUNT     : out std_logic_vector(11 downto 0); 
            SYN_FIFO_WRERR       : out std_logic; 
            SYN_FIFO_DI          : in  std_logic_vector(15 downto 0); 
            SYN_FIFO_RDCLK       : in  std_logic; 
            SYN_FIFO_RDEN        : in  std_logic; 
            SYN_FIFO_RST         : in  std_logic; 
            SYN_FIFO_WRCLK       : in  std_logic; 
            SYN_FIFO_WREN        : in  std_logic 
        );
end component SYNAPTIC_FIFO;


component BRIDGE is
    Generic (
        NEURAL_MEM_DEPTH  : integer := 2048;    
        SYNAPSE_MEM_DEPTH : integer := 2048;
        ROW               : integer := 16           
        );
    Port(
        BRIDGE_CLK                 : in  std_logic;
        BRIDGE_RST                 : in  std_logic;
        -- TIMESTEP UPDATE        
        CYCLE_COMPLETED            : out std_logic;
        -- BRIDGE CONTROLS
        EVENT_DETECT               : in  std_logic;
        -- EVENT ACCEPTANCE
        EVENT_ACCEPTANCE           : out std_logic;
        -- SPIKE SOURCE
        MAIN_SPIKE_BUFFER          : out std_logic;
        AUXILLARY_SPIKE_BUFFER     : out std_logic;
        -- SPIKE DESTINATION
        OUTBUFFER                  : out std_logic;
        AUXBUFFER                  : out std_logic;
        -- SYNAPTIC MEMORY CONTROLS (PORT B)
        SYNAPTIC_MEM_RDADDR        : out std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        SYNAPTIC_MEM_ENABLE        : out std_logic;
        SYNAPTIC_MEM_WRADDR        : out std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        SYNAPTIC_MEM_WREN          : out std_logic;
        -- HYPERCOLUMN CONTROL
        HALT_HYPERCOLUMN           : out std_logic;
        PRE_SYN_DATA_PULL          : out std_logic;
        -- NMC CONTRO
        NMC_STATE_RST              : out std_logic; 
        NMC_FMAC_RST               : out std_logic; 
        NMC_COLD_START             : out std_logic; 
        NMODEL_LAST_SPIKE_TIME     : out STD_LOGIC_VECTOR(7  DOWNTO 0); 
        NMODEL_SYN_QFACTOR         : out STD_LOGIC_VECTOR(15 DOWNTO 0); 
        NMODEL_PF_LOW_ADDR         : out STD_LOGIC_VECTOR(9  DOWNTO 0); 
        NMODEL_NPARAM_DATA         : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        NMODEL_NPARAM_ADDR         : out STD_LOGIC_VECTOR(9  DOWNTO 0);
        NMODEL_REFRACTORY_DUR      : out std_logic_vector(7  downto 0);
        NMODEL_PROG_MEM_PORTA_EN   : out STD_LOGIC;
        NMODEL_PROG_MEM_PORTA_WEN  : out STD_LOGIC;
        R_NNMODEL_NEW_SPIKE_TIME   : in  std_logic_vector(7  downto 0);
        R_NMODEL_NPARAM_DATAOUT    : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        R_NMODEL_REFRACTORY_DUR    : in  std_logic_vector(7  downto 0);
        REDIST_NMODEL_PORTB_TKOVER : out std_logic;
        REDIST_NMODEL_DADDR        : out std_logic_vector(9 downto 0);
        NMC_NMODEL_FINISHED        : in  std_logic;
        -- SYNAPTIC RAM MANAGEMENT
        SYNMEM_PORTA_MUX           : out std_logic;
        -- ULEARN CONTROLS
        ACTVATE_LENGINE            : out std_logic;
        LEARN_RST                  : out std_logic;
        SYNAPSE_PRUN               : out std_logic;
        PRUN_THRESH                : out std_logic_vector(7 downto 0);
        IGNORE_ZEROS               : out std_logic; 
        IGNORE_SOFTLIM             : out std_logic;  
        NEURON_WMAX                : out std_logic_vector(7 downto 0);
        NEURON_WMIN                : out std_logic_vector(7 downto 0);
        NEURON_SPK_TIME            : out std_logic_vector(7 downto 0);
        -- NEURAL MEMORY INTERFACE
        addra                      : out std_logic_vector((clogb2(NEURAL_MEM_DEPTH)-1) downto 0); 
        wea                        : out std_logic;	                
        ena                        : out std_logic;                       			     
        rsta                       : out std_logic;                       			     
        douta                      : in  std_logic_vector(31 downto 0);            
        dina                       : out std_logic_vector(31 downto 0)            

        );
end component BRIDGE;

        signal COLUMN_0_SYNMEM_DOUT                  : std_logic_vector(15 downto 0);
        signal COLUMN_1_SYNMEM_DOUT                  : std_logic_vector(15 downto 0);
        signal COLUMN_2_SYNMEM_DOUT                  : std_logic_vector(15 downto 0);
        signal COLUMN_3_SYNMEM_DOUT                  : std_logic_vector(15 downto 0);
        signal DATA_PULL                             : std_logic_vector(3 downto 0);
        signal COLN_0_SYN_SUM                        : std_logic_vector(15 downto 0);
        signal COLN_1_SYN_SUM                        : std_logic_vector(15 downto 0);
        signal COLN_2_SYN_SUM                        : std_logic_vector(15 downto 0);
        signal COLN_3_SYN_SUM                        : std_logic_vector(15 downto 0);
        signal COLN_VEC_SUM_VALID                    : std_logic_vector(3 downto 0);
        signal COLUMN_0_SYNMEM_DIN                   : std_logic_vector(15 downto 0);
        signal COLUMN_1_SYNMEM_DIN                   : std_logic_vector(15 downto 0);
        signal COLUMN_2_SYNMEM_DIN                   : std_logic_vector(15 downto 0);
        signal COLUMN_3_SYNMEM_DIN                   : std_logic_vector(15 downto 0);
        signal COLUMN_0_SYNMEM_WREN                  : std_logic;
        signal COLUMN_1_SYNMEM_WREN                  : std_logic;
        signal COLUMN_2_SYNMEM_WREN                  : std_logic;
        signal COLUMN_3_SYNMEM_WREN                  : std_logic;
        
        signal COLUMN_0_HP_DIN                       : std_logic_vector(15 downto 0);
        signal COLUMN_1_HP_DIN                       : std_logic_vector(15 downto 0);
        signal COLUMN_2_HP_DIN                       : std_logic_vector(15 downto 0);
        signal COLUMN_3_HP_DIN                       : std_logic_vector(15 downto 0);
        signal COLUMN_0_HP_DPULL                     : std_logic;
        signal COLUMN_1_HP_DPULL                     : std_logic;
        signal COLUMN_2_HP_DPULL                     : std_logic;
        signal COLUMN_3_HP_DPULL                     : std_logic;
        signal COLUMN_0_HP_DOUT                      : std_logic_vector(15 downto 0);
        signal COLUMN_1_HP_DOUT                      : std_logic_vector(15 downto 0);
        signal COLUMN_2_HP_DOUT                      : std_logic_vector(15 downto 0);
        signal COLUMN_3_HP_DOUT                      : std_logic_vector(15 downto 0);
        signal COLUMN_0_HP_DPUSH                     : std_logic;
        signal COLUMN_1_HP_DPUSH                     : std_logic;
        signal COLUMN_2_HP_DPUSH                     : std_logic;
        signal COLUMN_3_HP_DPUSH                     : std_logic;
        
        signal DLY_COLUMN_0_HP_DIN                   : std_logic_vector(15 downto 0);
        signal DLY_COLUMN_1_HP_DIN                   : std_logic_vector(15 downto 0);
        signal DLY_COLUMN_2_HP_DIN                   : std_logic_vector(15 downto 0);
        signal DLY_COLUMN_3_HP_DIN                   : std_logic_vector(15 downto 0);
        signal DLY_COLUMN_0_HP_DPULL                 : std_logic;
        signal DLY_COLUMN_1_HP_DPULL                 : std_logic;
        signal DLY_COLUMN_2_HP_DPULL                 : std_logic;
        signal DLY_COLUMN_3_HP_DPULL                 : std_logic;
        signal DLY_COLUMN_0_HP_DOUT                  : std_logic_vector(15 downto 0);
        signal DLY_COLUMN_1_HP_DOUT                  : std_logic_vector(15 downto 0);
        signal DLY_COLUMN_2_HP_DOUT                  : std_logic_vector(15 downto 0);
        signal DLY_COLUMN_3_HP_DOUT                  : std_logic_vector(15 downto 0);
        signal DLY_COLUMN_0_HP_DPUSH                 : std_logic;
        signal DLY_COLUMN_1_HP_DPUSH                 : std_logic;
        signal DLY_COLUMN_2_HP_DPUSH                 : std_logic;
        signal DLY_COLUMN_3_HP_DPUSH                 : std_logic;
     
        signal BR0_MAIN_SPIKE_BUFFER                 : std_logic;
        signal BR0_AUXILLARY_SPIKE_BUFFER            : std_logic;
        signal BR0_PRE_SYN_DATA_PULL                 : std_logic;
        signal NMC0_NMC_STATE_RST                    : std_logic;  
        signal NMC0_NMC_COLD_START                   : std_logic; 
        signal NMC0_NMODEL_LAST_SPIKE_TIME           : STD_LOGIC_VECTOR(7  DOWNTO 0); 
        signal NMC0_NMODEL_SYN_QFACTOR               : STD_LOGIC_VECTOR(15 DOWNTO 0); 
        signal NMC0_NMODEL_PF_LOW_ADDR               : STD_LOGIC_VECTOR(9  DOWNTO 0); 
        signal BR0_2_NMC0_NMODEL_NPARAM_DATA         : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal BR0_2_NMC0_NMODEL_NPARAM_ADDR         : STD_LOGIC_VECTOR(9  DOWNTO 0);
        signal NMC0_NMODEL_REFRACTORY_DUR            : std_logic_vector(7  downto 0);
        signal BR0_2_NMC0_NMODEL_PROG_MEM_PORTA_EN   : STD_LOGIC;
        signal BR0_2_NMC0_NMODEL_PROG_MEM_PORTA_WEN  : STD_LOGIC;
        signal NMC0_R_NNMODEL_NEW_SPIKE_TIME         : std_logic_vector(7  downto 0);
        signal NMC0_R_NMODEL_SYN_QFACTOR             : STD_LOGIC_VECTOR(15 DOWNTO 0); 
        signal NMC0_R_NMODEL_PF_LOW_ADDR             : STD_LOGIC_VECTOR(9  DOWNTO 0); 
        signal NMC0_R_NMODEL_NPARAM_DATAOUT          : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal NMC0_R_NMODEL_REFRACTORY_DUR          : std_logic_vector(7  downto 0);
        signal NMC0_REDIST_NMODEL_PORTB_TKOVER       : std_logic;
        signal NMC0_REDIST_NMODEL_DADDR              : std_logic_vector(9 downto 0);
        signal NMC0_NMC_NMODEL_FINISHED              : std_logic;
        signal BR0_NEURON_LAST_SPIKE_TIME            : std_logic_vector(7 downto 0);
        signal BR0_NEURON_SYNAPSE_COUNT              : std_logic_vector(16 downto 0);
        signal BR0_addra                             : std_logic_vector((clogb2(NEURAL_MEM_DEPTH)-1) downto 0); 
        signal BR0_wea                               : std_logic;	                
        signal BR0_ena                               : std_logic;                       			     
        signal BR0_rsta                              : std_logic;                       			     
        signal BR0_douta                             : std_logic_vector(31 downto 0);            
        signal BR0_dina                              : std_logic_vector(31 downto 0); 
  
        signal BR1_MAIN_SPIKE_BUFFER                 : std_logic;
        signal BR1_AUXILLARY_SPIKE_BUFFER            : std_logic;
        signal BR1_PRE_SYN_DATA_PULL                 : std_logic;
        signal NMC1_NMC_STATE_RST                    : std_logic;  
        signal NMC1_NMC_COLD_START                   : std_logic; 
        signal NMC1_NMODEL_LAST_SPIKE_TIME           : STD_LOGIC_VECTOR(7  DOWNTO 0); 
        signal NMC1_NMODEL_SYN_QFACTOR               : STD_LOGIC_VECTOR(15 DOWNTO 0); 
        signal NMC1_NMODEL_PF_LOW_ADDR               : STD_LOGIC_VECTOR(9  DOWNTO 0); 
        signal BR1_2_NMC1_NMODEL_NPARAM_DATA         : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal BR1_2_NMC1_NMODEL_NPARAM_ADDR         : STD_LOGIC_VECTOR(9  DOWNTO 0);
        signal NMC1_NMODEL_REFRACTORY_DUR            : std_logic_vector(7  downto 0);
        signal BR1_2_NMC1_NMODEL_PROG_MEM_PORTA_EN   : STD_LOGIC;
        signal BR1_2_NMC1_NMODEL_PROG_MEM_PORTA_WEN  : STD_LOGIC;
        signal NMC1_R_NNMODEL_NEW_SPIKE_TIME         : std_logic_vector(7  downto 0);
        signal NMC1_R_NMODEL_SYN_QFACTOR             : STD_LOGIC_VECTOR(15 DOWNTO 0); 
        signal NMC1_R_NMODEL_PF_LOW_ADDR             : STD_LOGIC_VECTOR(9  DOWNTO 0); 
        signal NMC1_R_NMODEL_NPARAM_DATAOUT          : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal NMC1_R_NMODEL_REFRACTORY_DUR          : std_logic_vector(7  downto 0);
        signal NMC1_REDIST_NMODEL_PORTB_TKOVER       : std_logic;
        signal NMC1_REDIST_NMODEL_DADDR              : std_logic_vector(9 downto 0);
        signal NMC1_NMC_NMODEL_FINISHED              : std_logic;
        signal BR1_NEURON_LAST_SPIKE_TIME            : std_logic_vector(7 downto 0);
        signal BR1_NEURON_SYNAPSE_COUNT              : std_logic_vector(16 downto 0);
        signal BR1_addra                             : std_logic_vector((clogb2(NEURAL_MEM_DEPTH)-1) downto 0); 
        signal BR1_wea                               : std_logic;	                
        signal BR1_ena                               : std_logic;                       			     
        signal BR1_rsta                              : std_logic;                       			     
        signal BR1_douta                             : std_logic_vector(31 downto 0);            
        signal BR1_dina                              : std_logic_vector(31 downto 0); 
                    
        signal BR2_MAIN_SPIKE_BUFFER                 : std_logic;
        signal BR2_AUXILLARY_SPIKE_BUFFER            : std_logic;
        signal BR2_PRE_SYN_DATA_PULL                 : std_logic;
        signal NMC2_NMC_STATE_RST                    : std_logic;  
        signal NMC2_NMC_COLD_START                   : std_logic; 
        signal NMC2_NMODEL_LAST_SPIKE_TIME           : STD_LOGIC_VECTOR(7  DOWNTO 0); 
        signal NMC2_NMODEL_SYN_QFACTOR               : STD_LOGIC_VECTOR(15 DOWNTO 0); 
        signal NMC2_NMODEL_PF_LOW_ADDR               : STD_LOGIC_VECTOR(9  DOWNTO 0); 
        signal BR2_2_NMC2_NMODEL_NPARAM_DATA         : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal BR2_2_NMC2_NMODEL_NPARAM_ADDR         : STD_LOGIC_VECTOR(9  DOWNTO 0);
        signal NMC2_NMODEL_REFRACTORY_DUR            : std_logic_vector(7  downto 0);
        signal BR2_2_NMC2_NMODEL_PROG_MEM_PORTA_EN   : STD_LOGIC;
        signal BR2_2_NMC2_NMODEL_PROG_MEM_PORTA_WEN  : STD_LOGIC;
        signal NMC2_R_NNMODEL_NEW_SPIKE_TIME         : std_logic_vector(7  downto 0);
        signal NMC2_R_NMODEL_SYN_QFACTOR             : STD_LOGIC_VECTOR(15 DOWNTO 0); 
        signal NMC2_R_NMODEL_PF_LOW_ADDR             : STD_LOGIC_VECTOR(9  DOWNTO 0); 
        signal NMC2_R_NMODEL_NPARAM_DATAOUT          : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal NMC2_R_NMODEL_REFRACTORY_DUR          : std_logic_vector(7  downto 0);
        signal NMC2_REDIST_NMODEL_PORTB_TKOVER       : std_logic;
        signal NMC2_REDIST_NMODEL_DADDR              : std_logic_vector(9 downto 0);
        signal NMC2_NMC_NMODEL_FINISHED              : std_logic;
        signal BR2_NEURON_LAST_SPIKE_TIME            : std_logic_vector(7 downto 0);
        signal BR2_NEURON_SYNAPSE_COUNT              : std_logic_vector(16 downto 0);
        signal BR2_addra                             : std_logic_vector((clogb2(NEURAL_MEM_DEPTH)-1) downto 0); 
        signal BR2_wea                               : std_logic;	                
        signal BR2_ena                               : std_logic;                       			     
        signal BR2_rsta                              : std_logic;                       			     
        signal BR2_douta                             : std_logic_vector(31 downto 0);            
        signal BR2_dina                              : std_logic_vector(31 downto 0); 
            
        signal BR3_MAIN_SPIKE_BUFFER                 : std_logic;
        signal BR3_AUXILLARY_SPIKE_BUFFER            : std_logic;
        signal BR3_PRE_SYN_DATA_PULL                 : std_logic;
        signal NMC3_NMC_STATE_RST                    : std_logic;  
        signal NMC3_NMC_COLD_START                   : std_logic; 
        signal NMC3_NMODEL_LAST_SPIKE_TIME           : STD_LOGIC_VECTOR(7  DOWNTO 0); 
        signal NMC3_NMODEL_SYN_QFACTOR               : STD_LOGIC_VECTOR(15 DOWNTO 0); 
        signal NMC3_NMODEL_PF_LOW_ADDR               : STD_LOGIC_VECTOR(9  DOWNTO 0); 
        signal BR3_2_NMC3_NMODEL_NPARAM_DATA         : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal BR3_2_NMC3_NMODEL_NPARAM_ADDR         : STD_LOGIC_VECTOR(9  DOWNTO 0);
        signal NMC3_NMODEL_REFRACTORY_DUR            : std_logic_vector(7  downto 0);
        signal BR3_2_NMC3_NMODEL_PROG_MEM_PORTA_EN   : STD_LOGIC;
        signal BR3_2_NMC3_NMODEL_PROG_MEM_PORTA_WEN  : STD_LOGIC;
        signal NMC3_R_NNMODEL_NEW_SPIKE_TIME         : std_logic_vector(7  downto 0);
        signal NMC3_R_NMODEL_SYN_QFACTOR             : STD_LOGIC_VECTOR(15 DOWNTO 0); 
        signal NMC3_R_NMODEL_PF_LOW_ADDR             : STD_LOGIC_VECTOR(9  DOWNTO 0); 
        signal NMC3_R_NMODEL_NPARAM_DATAOUT          : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal NMC3_R_NMODEL_REFRACTORY_DUR          : std_logic_vector(7  downto 0);
        signal NMC3_REDIST_NMODEL_PORTB_TKOVER       : std_logic;
        signal NMC3_REDIST_NMODEL_DADDR              : std_logic_vector(9 downto 0);
        signal NMC3_NMC_NMODEL_FINISHED              : std_logic;
        signal BR3_NEURON_LAST_SPIKE_TIME            : std_logic_vector(7 downto 0);
        signal BR3_NEURON_SYNAPSE_COUNT              : std_logic_vector(16 downto 0);
        signal BR3_addra                             : std_logic_vector((clogb2(NEURAL_MEM_DEPTH)-1) downto 0); 
        signal BR3_wea                               : std_logic;	                
        signal BR3_ena                               : std_logic;                       			     
        signal BR3_rsta                              : std_logic;                       			     
        signal BR3_douta                             : std_logic_vector(31 downto 0);            
        signal BR3_dina                              : std_logic_vector(31 downto 0); 
        
        signal BR0_HALT_HP                           : std_logic; 
        signal BR1_HALT_HP                           : std_logic; 
        signal BR2_HALT_HP                           : std_logic; 
        signal BR3_HALT_HP                           : std_logic; 
        
        signal HYPERCOLUMN_RESET                     : std_logic;
        
        signal NMC0_NMODEL_NPARAM_DATA               : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal NMC0_NMODEL_NPARAM_ADDR               : STD_LOGIC_VECTOR(9  DOWNTO 0);
        signal NMC0_NMODEL_PROG_MEM_PORTA_EN         : STD_LOGIC;
        signal NMC0_NMODEL_PROG_MEM_PORTA_WEN        : STD_LOGIC;
        signal NMC1_NMODEL_NPARAM_DATA               : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal NMC1_NMODEL_NPARAM_ADDR               : STD_LOGIC_VECTOR(9  DOWNTO 0);
        signal NMC1_NMODEL_PROG_MEM_PORTA_EN         : STD_LOGIC;
        signal NMC1_NMODEL_PROG_MEM_PORTA_WEN        : STD_LOGIC;
        signal NMC2_NMODEL_NPARAM_DATA               : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal NMC2_NMODEL_NPARAM_ADDR               : STD_LOGIC_VECTOR(9  DOWNTO 0);
        signal NMC2_NMODEL_PROG_MEM_PORTA_EN         : STD_LOGIC;
        signal NMC2_NMODEL_PROG_MEM_PORTA_WEN        : STD_LOGIC;
        signal NMC3_NMODEL_NPARAM_DATA               : STD_LOGIC_VECTOR(15 DOWNTO 0);
        signal NMC3_NMODEL_NPARAM_ADDR               : STD_LOGIC_VECTOR(9  DOWNTO 0);
        signal NMC3_NMODEL_PROG_MEM_PORTA_EN         : STD_LOGIC;
        signal NMC3_NMODEL_PROG_MEM_PORTA_WEN        : STD_LOGIC;
        
        signal COLUMN_0_SYNMEM_FULL                  : std_logic; 
        signal COLUMN_1_SYNMEM_FULL                  : std_logic; 
        signal COLUMN_2_SYNMEM_FULL                  : std_logic; 
        signal COLUMN_3_SYNMEM_FULL                  : std_logic; 
        
        signal NMC0_FMAC_EXTERN_RST                  : std_logic; 
        signal NMC1_FMAC_EXTERN_RST                  : std_logic; 
        signal NMC2_FMAC_EXTERN_RST                  : std_logic; 
        signal NMC3_FMAC_EXTERN_RST                  : std_logic; 
        
        signal DLY_SYNAPSE_STREAM_RECV               : std_logic_vector(3 downto 0);
        signal DLY_1_SYNAPSE_STREAM_RECV             : std_logic_vector(3 downto 0);
        
        signal ULEARN0_RST                           : std_logic;
        signal ULEARN0_SYN_DATA_IN                   : std_logic_vector(15 downto 0);
        signal ULEARN0_SYN_DIN_VLD                   : std_logic;
        signal ULEARN0_SYN_DATA_OUT                  : std_logic_vector(15 downto 0);
        signal ULEARN0_SYN_DOUT_VLD                  : std_logic;
        signal ULEARN0_SYNAPSE_PRUNING               : std_logic;
        signal ULEARN0_PRUN_THRESHOLD                : std_logic_vector(7 downto 0);
        signal ULEARN0_IGNORE_ZERO_SYNAPSES          : std_logic;
        signal ULEARN0_IGNORE_SOFTLIMITS             : std_logic;
        signal ULEARN0_NMODEL_WMAX                   : std_logic_vector(7 downto 0);
        signal ULEARN0_NMODEL_WMIN                   : std_logic_vector(7 downto 0);
        signal ULEARN0_NMODEL_SPIKE_TIME             : std_logic_vector(7 downto 0);
        
        signal ULEARN1_RST                           : std_logic;
        signal ULEARN1_SYN_DATA_IN                   : std_logic_vector(15 downto 0);
        signal ULEARN1_SYN_DIN_VLD                   : std_logic;
        signal ULEARN1_SYN_DATA_OUT                  : std_logic_vector(15 downto 0);
        signal ULEARN1_SYN_DOUT_VLD                  : std_logic;
        signal ULEARN1_SYNAPSE_PRUNING               : std_logic;
        signal ULEARN1_PRUN_THRESHOLD                : std_logic_vector(7 downto 0);
        signal ULEARN1_IGNORE_ZERO_SYNAPSES          : std_logic;
        signal ULEARN1_IGNORE_SOFTLIMITS             : std_logic;
        signal ULEARN1_NMODEL_WMAX                   : std_logic_vector(7 downto 0);
        signal ULEARN1_NMODEL_WMIN                   : std_logic_vector(7 downto 0);
        signal ULEARN1_NMODEL_SPIKE_TIME             : std_logic_vector(7 downto 0);        
        
        signal ULEARN2_RST                           : std_logic;
        signal ULEARN2_SYN_DATA_IN                   : std_logic_vector(15 downto 0);
        signal ULEARN2_SYN_DIN_VLD                   : std_logic;
        signal ULEARN2_SYN_DATA_OUT                  : std_logic_vector(15 downto 0);
        signal ULEARN2_SYN_DOUT_VLD                  : std_logic;
        signal ULEARN2_SYNAPSE_PRUNING               : std_logic;
        signal ULEARN2_PRUN_THRESHOLD                : std_logic_vector(7 downto 0);
        signal ULEARN2_IGNORE_ZERO_SYNAPSES          : std_logic;
        signal ULEARN2_IGNORE_SOFTLIMITS             : std_logic;
        signal ULEARN2_NMODEL_WMAX                   : std_logic_vector(7 downto 0);
        signal ULEARN2_NMODEL_WMIN                   : std_logic_vector(7 downto 0);
        signal ULEARN2_NMODEL_SPIKE_TIME             : std_logic_vector(7 downto 0);
        
        signal ULEARN3_RST                           : std_logic;
        signal ULEARN3_SYN_DATA_IN                   : std_logic_vector(15 downto 0);
        signal ULEARN3_SYN_DIN_VLD                   : std_logic;
        signal ULEARN3_SYN_DATA_OUT                  : std_logic_vector(15 downto 0);
        signal ULEARN3_SYN_DOUT_VLD                  : std_logic;
        signal ULEARN3_SYNAPSE_PRUNING               : std_logic;
        signal ULEARN3_PRUN_THRESHOLD                : std_logic_vector(7 downto 0);
        signal ULEARN3_IGNORE_ZERO_SYNAPSES          : std_logic;
        signal ULEARN3_IGNORE_SOFTLIMITS             : std_logic;
        signal ULEARN3_NMODEL_WMAX                   : std_logic_vector(7 downto 0);
        signal ULEARN3_NMODEL_WMIN                   : std_logic_vector(7 downto 0);
        signal ULEARN3_NMODEL_SPIKE_TIME             : std_logic_vector(7 downto 0);        
            
        signal ULEARN0_SYNAPSE_WRITE_ADDRESS         : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal ULEARN1_SYNAPSE_WRITE_ADDRESS         : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal ULEARN2_SYNAPSE_WRITE_ADDRESS         : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal ULEARN3_SYNAPSE_WRITE_ADDRESS         : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        
        signal BR0_SYNAPTIC_MEM_0_RDADDR             : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal BR0_SYNAPTIC_MEM_0_ENABLE             : std_logic;
    
        signal BR1_SYNAPTIC_MEM_1_RDADDR             : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal BR1_SYNAPTIC_MEM_1_ENABLE             : std_logic;
    
        signal BR2_SYNAPTIC_MEM_2_RDADDR             : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal BR2_SYNAPTIC_MEM_2_ENABLE             : std_logic;
    
        signal BR3_SYNAPTIC_MEM_3_RDADDR             : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal BR3_SYNAPTIC_MEM_3_ENABLE             : std_logic;
            
        signal BR0_SYNAPTIC_MEM_0_WRADDR             : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal BR0_SYNAPTIC_MEM_0_WRENABLE             : std_logic;
    
        signal BR1_SYNAPTIC_MEM_1_WRADDR             : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal BR1_SYNAPTIC_MEM_1_WRENABLE             : std_logic;
    
        signal BR2_SYNAPTIC_MEM_2_WRADDR             : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal BR2_SYNAPTIC_MEM_2_WRENABLE             : std_logic;
    
        signal BR3_SYNAPTIC_MEM_3_WRADDR             : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal BR3_SYNAPTIC_MEM_3_WRENABLE             : std_logic;
                
        signal SYNMEM_0_addra                        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_0_dina                         : std_logic_vector(15 downto 0);		        
        signal SYNMEM_0_wea                          : std_logic;                       			        
        signal SYNMEM_0_ena                          : std_logic;                       			        
        signal SYNMEM_0_rsta                         : std_logic;                       			        
        signal SYNMEM_0_douta                        : std_logic_vector(15 downto 0);   			      
      
        signal SYNMEM_1_addra                        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_1_dina                         : std_logic_vector(15 downto 0);		        
        signal SYNMEM_1_wea                          : std_logic;                       			        
        signal SYNMEM_1_ena                          : std_logic;                       			        
        signal SYNMEM_1_rsta                         : std_logic;                       			        
        signal SYNMEM_1_douta                        : std_logic_vector(15 downto 0);   
      
        signal SYNMEM_2_addra                        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_2_dina                         : std_logic_vector(15 downto 0);		        
        signal SYNMEM_2_wea                          : std_logic;                       			        
        signal SYNMEM_2_ena                          : std_logic;                       			        
        signal SYNMEM_2_rsta                         : std_logic;                       			        
        signal SYNMEM_2_douta                        : std_logic_vector(15 downto 0);   
      
        signal SYNMEM_3_addra                        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_3_dina                         : std_logic_vector(15 downto 0);		        
        signal SYNMEM_3_wea                          : std_logic;                       			        
        signal SYNMEM_3_ena                          : std_logic;                       			        
        signal SYNMEM_3_rsta                         : std_logic;                       			        
        signal SYNMEM_3_douta                        : std_logic_vector(15 downto 0);           
       
        signal SYNMEM_0_addrb                        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_0_dinb                         : std_logic_vector(15 downto 0);		        
        signal SYNMEM_0_web                          : std_logic;                       			        
        signal SYNMEM_0_enb                          : std_logic;                       			        
        signal SYNMEM_0_rstb                         : std_logic;                       			        
        signal SYNMEM_0_doutb                        : std_logic_vector(15 downto 0);   			      
      
        signal SYNMEM_1_addrb                        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_1_dinb                         : std_logic_vector(15 downto 0);		        
        signal SYNMEM_1_web                          : std_logic;                       			        
        signal SYNMEM_1_enb                          : std_logic;                       			        
        signal SYNMEM_1_rstb                         : std_logic;                       			        
        signal SYNMEM_1_doutb                        : std_logic_vector(15 downto 0);   
      
        signal SYNMEM_2_addrb                        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_2_dinb                         : std_logic_vector(15 downto 0);		        
        signal SYNMEM_2_web                          : std_logic;                       			        
        signal SYNMEM_2_enb                          : std_logic;                       			        
        signal SYNMEM_2_rstb                         : std_logic;                       			        
        signal SYNMEM_2_doutb                        : std_logic_vector(15 downto 0);   
      
        signal SYNMEM_3_addrb                        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_3_dinb                         : std_logic_vector(15 downto 0);		        
        signal SYNMEM_3_web                          : std_logic;                       			        
        signal SYNMEM_3_enb                          : std_logic;                       			        
        signal SYNMEM_3_rstb                         : std_logic;                       			        
        signal SYNMEM_3_doutb                        : std_logic_vector(15 downto 0);              
        
        signal BR0_SYNMEM_PORTA_MUX                  : std_logic; 
        signal BR1_SYNMEM_PORTA_MUX                  : std_logic; 
        signal BR2_SYNMEM_PORTA_MUX                  : std_logic; 
        signal BR3_SYNMEM_PORTA_MUX                  : std_logic; 
         
        signal SYNMEM_0_MUXOUT_addra                 : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_0_MUXOUT_dina                  : std_logic_vector(15 downto 0);		        
        signal SYNMEM_0_MUXOUT_wea                   : std_logic;                       			        
        signal SYNMEM_0_MUXOUT_ena                   : std_logic;                       			        
        signal SYNMEM_0_MUXOUT_rsta                  : std_logic;                       			         			      
      
        signal SYNMEM_1_MUXOUT_addra                 : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_1_MUXOUT_dina                  : std_logic_vector(15 downto 0);		        
        signal SYNMEM_1_MUXOUT_wea                   : std_logic;                       			        
        signal SYNMEM_1_MUXOUT_ena                   : std_logic;                       			        
        signal SYNMEM_1_MUXOUT_rsta                  : std_logic;                       			        
     
        signal SYNMEM_2_MUXOUT_addra                 : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_2_MUXOUT_dina                  : std_logic_vector(15 downto 0);		        
        signal SYNMEM_2_MUXOUT_wea                   : std_logic;                       			        
        signal SYNMEM_2_MUXOUT_ena                   : std_logic;                       			        
        signal SYNMEM_2_MUXOUT_rsta                  : std_logic;                       			        
     
        signal SYNMEM_3_MUXOUT_addra                 : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        signal SYNMEM_3_MUXOUT_dina                  : std_logic_vector(15 downto 0);		        
        signal SYNMEM_3_MUXOUT_wea                   : std_logic;                       			        
        signal SYNMEM_3_MUXOUT_ena                   : std_logic;                       			        
        signal SYNMEM_3_MUXOUT_rsta                  : std_logic;    
                           			        
        signal BR0_EVENT_ACCEPTANCE                  : std_logic;                       			        
        signal BR1_EVENT_ACCEPTANCE                  : std_logic;                       			        
        signal BR2_EVENT_ACCEPTANCE                  : std_logic;                       			        
        signal BR3_EVENT_ACCEPTANCE                  : std_logic;                       			        

        signal HP_SYNMEM_0_SYNAPSE_WR_ADDRESS        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal HP_SYNMEM_1_SYNAPSE_WR_ADDRESS        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal HP_SYNMEM_2_SYNAPSE_WR_ADDRESS        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);
        signal HP_SYNMEM_3_SYNAPSE_WR_ADDRESS        : std_logic_vector((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0);    
        
        
begin

        SYNMEM_0_rsta <= RST or NEW_TIMESTEP(2);
        SYNMEM_0_rstb <= RST or NEW_TIMESTEP(2);
        
        SYNMEM_1_rsta <= RST or NEW_TIMESTEP(2);
        SYNMEM_1_rstb <= RST or NEW_TIMESTEP(2);
        
        SYNMEM_2_rsta <= RST or NEW_TIMESTEP(1);
        SYNMEM_2_rstb <= RST or NEW_TIMESTEP(1);
        
        SYNMEM_3_rsta <= RST or NEW_TIMESTEP(0);
        SYNMEM_3_rstb <= RST or NEW_TIMESTEP(0);
        
        EVENT_ACCEPT <= BR0_EVENT_ACCEPTANCE or BR1_EVENT_ACCEPTANCE or BR2_EVENT_ACCEPTANCE or BR3_EVENT_ACCEPTANCE;
        
SYNAPSE_MEMORY_ROUTING : process(clk)

                         begin
                         
                            if(rising_edge(CLK)) then
                            
                                case SYNAPSE_ROUTE is
                                
                                    when "00" => -- RECYCLE MODE
                                    
                                        -- SYNAPTIC MEMORY 0
                                        SYNMEM_0_dina  <=  SYNMEM_0_MUXOUT_dina  ;
                                        SYNMEM_0_addra <=  SYNMEM_0_MUXOUT_addra ;        
                                        SYNMEM_0_ena   <=  SYNMEM_0_MUXOUT_ena   ;
                                        SYNMEM_0_wea   <=  SYNMEM_0_MUXOUT_wea   ;
                                        -- SYNAPTIC MEMORY 1              
                                        SYNMEM_1_dina  <=  SYNMEM_1_MUXOUT_dina  ;
                                        SYNMEM_1_addra <=  SYNMEM_1_MUXOUT_addra ;          
                                        SYNMEM_1_ena   <=  SYNMEM_1_MUXOUT_ena   ;
                                        SYNMEM_1_wea   <=  SYNMEM_1_MUXOUT_wea   ;
                                        -- SYNAPTIC MEMORY 2              
                                        SYNMEM_2_dina  <=  SYNMEM_2_MUXOUT_dina  ;
                                        SYNMEM_2_addra <=  SYNMEM_2_MUXOUT_addra ;            
                                        SYNMEM_2_ena   <=  SYNMEM_2_MUXOUT_ena   ;
                                        SYNMEM_2_wea   <=  SYNMEM_2_MUXOUT_wea   ;
                                        -- SYNAPTIC MEMORY 3              
                                        SYNMEM_3_dina  <=  SYNMEM_3_MUXOUT_dina  ;
                                        SYNMEM_3_addra <=  SYNMEM_3_MUXOUT_addra ;           
                                        SYNMEM_3_ena   <=  SYNMEM_3_MUXOUT_ena   ;
                                        SYNMEM_3_wea   <=  SYNMEM_3_MUXOUT_wea   ;
                                        
                                        COLUMN_0_HP_DIN <= SYNMEM_0_doutb;       
                                        COLUMN_1_HP_DIN <= SYNMEM_1_doutb;       
                                        COLUMN_2_HP_DIN <= SYNMEM_2_doutb;       
                                        COLUMN_3_HP_DIN <= SYNMEM_3_doutb;    
                                        
                                        SYNMEM_0_addrb  <= BR0_SYNAPTIC_MEM_0_RDADDR;   
                                        SYNMEM_0_enb    <= BR0_SYNAPTIC_MEM_0_ENABLE;
                                                               
                                        SYNMEM_1_addrb  <= BR1_SYNAPTIC_MEM_1_RDADDR;   
                                        SYNMEM_1_enb    <= BR1_SYNAPTIC_MEM_1_ENABLE;
                                                            
                                        SYNMEM_2_addrb  <= BR2_SYNAPTIC_MEM_2_RDADDR;   
                                        SYNMEM_2_enb    <= BR2_SYNAPTIC_MEM_2_ENABLE;
                                                                 
                                        SYNMEM_3_addrb  <= BR3_SYNAPTIC_MEM_3_RDADDR;   
                                        SYNMEM_3_enb    <= BR3_SYNAPTIC_MEM_3_ENABLE;
                                    
                                    when "01" => -- INPUT / OUTPUT EXTERNAL ACCESS
                                          
                                        -- SYNAPTIC MEMORY 0
                                        SYNMEM_0_dina  <= SYNAPTIC_MEM_0_DIN     ;            
                                        SYNMEM_0_addra <= SYNAPTIC_MEM_0_DADDR((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0)  ;            
                                        SYNMEM_0_ena   <= SYNAPTIC_MEM_0_EN      ;            
                                        SYNMEM_0_wea   <= SYNAPTIC_MEM_0_WREN    ;                        
                                        -- SYNAPTIC MEMORY    
                                        SYNMEM_1_dina  <= SYNAPTIC_MEM_1_DIN     ;            
                                        SYNMEM_1_addra <= SYNAPTIC_MEM_1_DADDR((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0)  ;            
                                        SYNMEM_1_ena   <= SYNAPTIC_MEM_1_EN      ;            
                                        SYNMEM_1_wea   <= SYNAPTIC_MEM_1_WREN    ;                        
                                        -- SYNAPTIC MEMORY    
                                        SYNMEM_2_dina  <= SYNAPTIC_MEM_2_DIN     ;            
                                        SYNMEM_2_addra <= SYNAPTIC_MEM_2_DADDR((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0)  ;            
                                        SYNMEM_2_ena   <= SYNAPTIC_MEM_2_EN      ;            
                                        SYNMEM_2_wea   <= SYNAPTIC_MEM_2_WREN    ;                              
                                        -- SYNAPTIC MEMORY    
                                        SYNMEM_3_dina  <= SYNAPTIC_MEM_3_DIN     ;            
                                        SYNMEM_3_addra <= SYNAPTIC_MEM_3_DADDR((clogb2(SYNAPSE_MEM_DEPTH)-1) downto 0)  ;            
                                        SYNMEM_3_ena   <= SYNAPTIC_MEM_3_EN      ;            
                                        SYNMEM_3_wea   <= SYNAPTIC_MEM_3_WREN    ;   
                                        
                                        SYNMEM_0_enb   <= '0'     ;            
                                        SYNMEM_1_enb   <= '0'     ;            
                                        SYNMEM_2_enb   <= '0'     ;            
                                        SYNMEM_3_enb   <= '0'     ;            
         
                                  
                                    when others =>
                                                NULL;
                                end case;
                           
                            end if;
                        
end process SYNAPSE_MEMORY_ROUTING;

--SYNAPTIC_MEM_PORTA_CNTROLS


NMC_PROG_MEM_CNTROLS :  process(CLK)

                    begin
                        
                        if(rising_edge(CLK)) then

                            case NMC_PMODE_SWITCH is
                            
                                when "00"=> -- NMC Memory <-> Neural Memory
                    
                                    -- NMC 0
                                    NMC0_NMODEL_NPARAM_DATA         <= BR0_2_NMC0_NMODEL_NPARAM_DATA        ;
                                    NMC0_NMODEL_NPARAM_ADDR         <= BR0_2_NMC0_NMODEL_NPARAM_ADDR        ;
                                    NMC0_NMODEL_PROG_MEM_PORTA_EN   <= BR0_2_NMC0_NMODEL_PROG_MEM_PORTA_EN  ;
                                    NMC0_NMODEL_PROG_MEM_PORTA_WEN  <= BR0_2_NMC0_NMODEL_PROG_MEM_PORTA_WEN ;
                                    -- NMC                          
                                    NMC1_NMODEL_NPARAM_DATA         <= BR1_2_NMC1_NMODEL_NPARAM_DATA        ;
                                    NMC1_NMODEL_NPARAM_ADDR         <= BR1_2_NMC1_NMODEL_NPARAM_ADDR        ;
                                    NMC1_NMODEL_PROG_MEM_PORTA_EN   <= BR1_2_NMC1_NMODEL_PROG_MEM_PORTA_EN  ;
                                    NMC1_NMODEL_PROG_MEM_PORTA_WEN  <= BR1_2_NMC1_NMODEL_PROG_MEM_PORTA_WEN ;
                                    -- NMC                          
                                    NMC2_NMODEL_NPARAM_DATA         <= BR2_2_NMC2_NMODEL_NPARAM_DATA        ;
                                    NMC2_NMODEL_NPARAM_ADDR         <= BR2_2_NMC2_NMODEL_NPARAM_ADDR        ;
                                    NMC2_NMODEL_PROG_MEM_PORTA_EN   <= BR2_2_NMC2_NMODEL_PROG_MEM_PORTA_EN  ;
                                    NMC2_NMODEL_PROG_MEM_PORTA_WEN  <= BR2_2_NMC2_NMODEL_PROG_MEM_PORTA_WEN ;
                                    -- NMC                          
                                    NMC3_NMODEL_NPARAM_DATA         <= BR3_2_NMC3_NMODEL_NPARAM_DATA        ;
                                    NMC3_NMODEL_NPARAM_ADDR         <= BR3_2_NMC3_NMODEL_NPARAM_ADDR        ;
                                    NMC3_NMODEL_PROG_MEM_PORTA_EN   <= BR3_2_NMC3_NMODEL_PROG_MEM_PORTA_EN  ;
                                    NMC3_NMODEL_PROG_MEM_PORTA_WEN  <= BR3_2_NMC3_NMODEL_PROG_MEM_PORTA_WEN ;
                                                                   
                                when "01"=> -- NMC Memory External Access
                                
                                    -- NMC 0
                                    NMC0_NMODEL_NPARAM_DATA         <= NMC_NPARAM_DATA         ;
                                    NMC0_NMODEL_NPARAM_ADDR         <= NMC_NPARAM_ADDR         ;
                                    NMC0_NMODEL_PROG_MEM_PORTA_EN   <= NMC_PROG_MEM_PORTA_EN   ;
                                    NMC0_NMODEL_PROG_MEM_PORTA_WEN  <= NMC_PROG_MEM_PORTA_WEN  ;
                                    -- NMC                           
                                    NMC1_NMODEL_NPARAM_DATA         <= NMC_NPARAM_DATA         ;
                                    NMC1_NMODEL_NPARAM_ADDR         <= NMC_NPARAM_ADDR         ;
                                    NMC1_NMODEL_PROG_MEM_PORTA_EN   <= NMC_PROG_MEM_PORTA_EN   ;
                                    NMC1_NMODEL_PROG_MEM_PORTA_WEN  <= NMC_PROG_MEM_PORTA_WEN  ;
                                    -- NMC                           
                                    NMC2_NMODEL_NPARAM_DATA         <= NMC_NPARAM_DATA         ;
                                    NMC2_NMODEL_NPARAM_ADDR         <= NMC_NPARAM_ADDR         ;
                                    NMC2_NMODEL_PROG_MEM_PORTA_EN   <= NMC_PROG_MEM_PORTA_EN   ;
                                    NMC2_NMODEL_PROG_MEM_PORTA_WEN  <= NMC_PROG_MEM_PORTA_WEN  ;
                                    -- NMC                           
                                    NMC3_NMODEL_NPARAM_DATA         <= NMC_NPARAM_DATA        ;
                                    NMC3_NMODEL_NPARAM_ADDR         <= NMC_NPARAM_ADDR        ;
                                    NMC3_NMODEL_PROG_MEM_PORTA_EN   <= NMC_PROG_MEM_PORTA_EN  ;
                                    NMC3_NMODEL_PROG_MEM_PORTA_WEN  <= NMC_PROG_MEM_PORTA_WEN ;                               
                               
                                when others => 
                                        NULL;
                        
                            end case;
                        end if;

end process NMC_PROG_MEM_CNTROLS;
       
 HYPERCOLUMN_RESET <= NEW_TIMESTEP(0) or NEW_TIMESTEP(1) or NEW_TIMESTEP(2) or NEW_TIMESTEP(3) or RST or BR0_HALT_HP or BR1_HALT_HP or BR2_HALT_HP or BR3_HALT_HP;

 SYNAPTIC_MEM_0_DOUT <= SYNMEM_0_douta ;
 SYNAPTIC_MEM_1_DOUT <= SYNMEM_1_douta ;
 SYNAPTIC_MEM_2_DOUT <= SYNMEM_2_douta ;
 SYNAPTIC_MEM_3_DOUT <= SYNMEM_3_douta ;
 
 ULEARN0_SYN_DATA_IN <= SYNMEM_0_doutb ;
 ULEARN1_SYN_DATA_IN <= SYNMEM_1_doutb ;
 ULEARN2_SYN_DATA_IN <= SYNMEM_2_doutb ;
 ULEARN3_SYN_DATA_IN <= SYNMEM_3_doutb ;
                  			     
 SYNAPTIC_MEMORY_0: AUTO_RAM_INSTANCE 
    generic map (
        RAM_WIDTH       => 16,                
        RAM_DEPTH       => SYNAPSE_MEM_DEPTH, 
        RAM_PERFORMANCE => "LOW_LATENCY"   
        )
    port map(
            addra  => SYNMEM_0_addra,
            addrb  => SYNMEM_0_addrb ,
            dina   => SYNMEM_0_dina,
            dinb   => SYNMEM_0_dinb,
            clka   => CLK ,
            clkb   => CLK ,
            wea    => SYNMEM_0_wea,
            web    => SYNMEM_0_web,
            ena    => SYNMEM_0_ena,
            enb    => SYNMEM_0_enb ,
            rsta   => SYNMEM_0_rsta,
            rstb   => SYNMEM_0_rstb,
            regcea => '1',
            regceb => '1',
            douta  => SYNMEM_0_douta,
            doutb  => SYNMEM_0_doutb
        );       
            			     
 SYNAPTIC_MEMORY_1: AUTO_RAM_INSTANCE 
    generic map (
        RAM_WIDTH       => 16,                
        RAM_DEPTH       => SYNAPSE_MEM_DEPTH, 
        RAM_PERFORMANCE => "LOW_LATENCY"   
        )
    port map(
            addra  =>  SYNMEM_1_addra, 
            addrb  =>  SYNMEM_1_addrb ,
            dina   =>  SYNMEM_1_dina,  
            dinb   =>  SYNMEM_1_dinb,  
            clka   =>  CLK ,           
            clkb   =>  CLK ,           
            wea    =>  SYNMEM_1_wea,   
            web    =>  SYNMEM_1_web,   
            ena    =>  SYNMEM_1_ena,   
            enb    =>  SYNMEM_1_enb ,  
            rsta   =>  SYNMEM_1_rsta,  
            rstb   =>  SYNMEM_1_rstb,  
            regcea =>  '1',            
            regceb =>  '1',            
            douta  =>  SYNMEM_1_douta, 
            doutb  =>  SYNMEM_1_doutb  
        );          
             			     
 SYNAPTIC_MEMORY_2: AUTO_RAM_INSTANCE 
    generic map (
        RAM_WIDTH       => 16,                
        RAM_DEPTH       => SYNAPSE_MEM_DEPTH, 
        RAM_PERFORMANCE => "LOW_LATENCY"   
        )
    port map(
            addra  =>  SYNMEM_2_addra, 
            addrb  =>  SYNMEM_2_addrb ,
            dina   =>  SYNMEM_2_dina,  
            dinb   =>  SYNMEM_2_dinb,  
            clka   =>  CLK ,           
            clkb   =>  CLK ,           
            wea    =>  SYNMEM_2_wea,   
            web    =>  SYNMEM_2_web,   
            ena    =>  SYNMEM_2_ena,   
            enb    =>  SYNMEM_2_enb ,  
            rsta   =>  SYNMEM_2_rsta,  
            rstb   =>  SYNMEM_2_rstb,  
            regcea =>  '1',            
            regceb =>  '1',            
            douta  =>  SYNMEM_2_douta, 
            doutb  =>  SYNMEM_2_doutb  
        );   
             			     
 SYNAPTIC_MEMORY_3: AUTO_RAM_INSTANCE 
    generic map (
        RAM_WIDTH       => 16,                
        RAM_DEPTH       => SYNAPSE_MEM_DEPTH, 
        RAM_PERFORMANCE => "LOW_LATENCY"   
        )
    port map(
            addra  => SYNMEM_3_addra, 
            addrb  => SYNMEM_3_addrb ,
            dina   => SYNMEM_3_dina,  
            dinb   => SYNMEM_3_dinb,  
            clka   => CLK ,           
            clkb   => CLK ,           
            wea    => SYNMEM_3_wea,   
            web    => SYNMEM_3_web,   
            ena    => SYNMEM_3_ena,   
            enb    => SYNMEM_3_enb ,  
            rsta   => SYNMEM_3_rsta,  
            rstb   => SYNMEM_3_rstb,  
            regcea => '1',            
            regceb => '1',            
            douta  => SYNMEM_3_douta, 
            doutb  => SYNMEM_3_doutb  
        );         
        
        
                                        
            SYNMEM_0_MUXOUT_dina <= COLUMN_0_HP_DOUT when BR0_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN0_SYN_DATA_OUT;
                                        
            SYNMEM_0_MUXOUT_addra <= HP_SYNMEM_0_SYNAPSE_WR_ADDRESS when BR0_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN0_SYNAPSE_WRITE_ADDRESS;            
                                        
            SYNMEM_0_MUXOUT_wea <= COLUMN_0_HP_DPUSH when BR0_SYNMEM_PORTA_MUX = '0' else
                                     ULEARN0_SYN_DOUT_VLD;   
                                    
            SYNMEM_0_MUXOUT_ena <= '1';
                                        
                                        
            SYNMEM_1_MUXOUT_dina <= COLUMN_1_HP_DOUT when BR1_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN1_SYN_DATA_OUT;
                                        
            SYNMEM_1_MUXOUT_addra <= HP_SYNMEM_1_SYNAPSE_WR_ADDRESS when BR1_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN1_SYNAPSE_WRITE_ADDRESS;            
                                        
            SYNMEM_1_MUXOUT_wea <= COLUMN_1_HP_DPUSH when BR1_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN1_SYN_DOUT_VLD;   
                                    
            SYNMEM_1_MUXOUT_ena <= '1';

                                        
            SYNMEM_2_MUXOUT_dina <= COLUMN_2_HP_DOUT when BR2_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN2_SYN_DATA_OUT;
                                        
            SYNMEM_2_MUXOUT_addra <= HP_SYNMEM_2_SYNAPSE_WR_ADDRESS when BR2_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN2_SYNAPSE_WRITE_ADDRESS;            
                                        
            SYNMEM_2_MUXOUT_wea <= COLUMN_2_HP_DPUSH when BR2_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN2_SYN_DOUT_VLD;   
                                    
            SYNMEM_2_MUXOUT_ena <= '1';

                       
            SYNMEM_3_MUXOUT_dina <= COLUMN_3_HP_DOUT when BR3_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN3_SYN_DATA_OUT;
                                        
            SYNMEM_3_MUXOUT_addra <= HP_SYNMEM_3_SYNAPSE_WR_ADDRESS when BR3_SYNMEM_PORTA_MUX = '0' else
                                     ULEARN3_SYNAPSE_WRITE_ADDRESS;            
                                        
            SYNMEM_3_MUXOUT_wea <= COLUMN_3_HP_DPUSH when BR3_SYNMEM_PORTA_MUX = '0' else
                                    ULEARN3_SYN_DOUT_VLD;   
                                    
            SYNMEM_3_MUXOUT_ena <= '1';
                                                                        
                                    
        
 CROSSBAR_INIT : HYPERCOLUMN 
    Generic Map(
            ROW => CROSSBAR_ROW_WIDTH ,
            SYNAPSE_MEM_DEPTH  => SYNAPSE_MEM_DEPTH
            )
    Port Map(
            HP_CLK                          => CLK                  ,
            HP_RST                          => HYPERCOLUMN_RESET    ,
            SPIKE_IN                        => SPIKEVECTOR_IN       ,
            SPIKE_VLD                       => SPIKEVECTOR_VLD_IN   ,
            SPIKE_OUT                       => SPIKEVECTOR_OUT      ,
            SPIKE_VLD_OUT                   => SPIKEVECTOR_VLD_OUT  ,
            COLUMN_0_PRE_SYNAPTIC_DIN       => COLUMN_0_HP_DIN      ,
            COLUMN_1_PRE_SYNAPTIC_DIN       => COLUMN_1_HP_DIN      ,
            COLUMN_2_PRE_SYNAPTIC_DIN       => COLUMN_2_HP_DIN      ,
            COLUMN_3_PRE_SYNAPTIC_DIN       => COLUMN_3_HP_DIN      ,
            COLUMN_0_SYNAPSE_START_ADDRESS  => BR0_SYNAPTIC_MEM_0_WRADDR ,
            COLUMN_1_SYNAPSE_START_ADDRESS  => BR1_SYNAPTIC_MEM_1_WRADDR ,
            COLUMN_2_SYNAPSE_START_ADDRESS  => BR2_SYNAPTIC_MEM_2_WRADDR ,
            COLUMN_3_SYNAPSE_START_ADDRESS  => BR3_SYNAPTIC_MEM_3_WRADDR ,
            PRE_SYN_DATA_PULL               => DATA_PULL            ,
            COLN_0_SYN_SUM_OUT              => COLN_0_SYN_SUM       ,
            COLN_1_SYN_SUM_OUT              => COLN_1_SYN_SUM       ,
            COLN_2_SYN_SUM_OUT              => COLN_2_SYN_SUM       ,
            COLN_3_SYN_SUM_OUT              => COLN_3_SYN_SUM       ,
            COLN_VECTOR_SYN_SUM_VALID       => COLN_VEC_SUM_VALID   , 
            COLUMN_0_POST_SYNAPTIC_DOUT     => COLUMN_0_HP_DOUT     ,
            COLUMN_1_POST_SYNAPTIC_DOUT     => COLUMN_1_HP_DOUT     ,
            COLUMN_2_POST_SYNAPTIC_DOUT     => COLUMN_2_HP_DOUT     ,
            COLUMN_3_POST_SYNAPTIC_DOUT     => COLUMN_3_HP_DOUT     ,
            COLUMN_0_SYNAPSE_WR_ADDRESS     => HP_SYNMEM_0_SYNAPSE_WR_ADDRESS , 
            COLUMN_1_SYNAPSE_WR_ADDRESS     => HP_SYNMEM_1_SYNAPSE_WR_ADDRESS , 
            COLUMN_2_SYNAPSE_WR_ADDRESS     => HP_SYNMEM_2_SYNAPSE_WR_ADDRESS , 
            COLUMN_3_SYNAPSE_WR_ADDRESS     => HP_SYNMEM_3_SYNAPSE_WR_ADDRESS , 
            COLUMN_0_POST_SYNAPTIC_WREN     => COLUMN_0_HP_DPUSH    ,
            COLUMN_1_POST_SYNAPTIC_WREN     => COLUMN_1_HP_DPUSH    ,
            COLUMN_2_POST_SYNAPTIC_WREN     => COLUMN_2_HP_DPUSH    ,
            COLUMN_3_POST_SYNAPTIC_WREN     => COLUMN_3_HP_DPUSH     
     ); 
                    			     
    NMC0_NEURAL_MEMORY: AUTO_RAM_INSTANCE 
    generic map (
        RAM_WIDTH       => 32,                
        RAM_DEPTH       => NEURAL_MEM_DEPTH, 
        RAM_PERFORMANCE => "LOW_LATENCY"   
        )
    port map(
            addra  => BR0_addra,
            addrb  => NMC_0_NMEM_ADDR((clogb2(NEURAL_MEM_DEPTH)-1) downto 0) ,
            dina   => BR0_dina,
            dinb   => NMC_0_NMEM_DIN,
            clka   => CLK ,
            clkb   => CLK ,
            wea    => BR0_wea,
            web    => NMC_0_WREN,
            ena    => BR0_ena,
            enb    => NMC_0_EN,
            rsta   => BR0_rsta,
            rstb   => NMC_0_RST,
            regcea => '1',
            regceb => '1',
            douta  => BR0_douta,
            doutb  => NMC_0_NMEM_DOUT
        );
     
    NMC1_NEURAL_MEMORY: AUTO_RAM_INSTANCE 
    generic map (
        RAM_WIDTH       => 32,                
        RAM_DEPTH       => NEURAL_MEM_DEPTH, 
        RAM_PERFORMANCE => "LOW_LATENCY"   
        )
    port map(
            addra  => BR1_addra,
            addrb  => NMC_1_NMEM_ADDR((clogb2(NEURAL_MEM_DEPTH)-1) downto 0) ,
            dina   => BR1_dina,
            dinb   => NMC_1_NMEM_DIN,
            clka   => CLK ,
            clkb   => CLK ,
            wea    => BR1_wea,
            web    => NMC_1_WREN,
            ena    => BR1_ena,
            enb    => NMC_1_EN,
            rsta   => BR1_rsta,
            rstb   => NMC_1_RST,
            regcea => '1',
            regceb => '1',
            douta  => BR1_douta,
            doutb  => NMC_1_NMEM_DOUT
        );
     
    NMC2_NEURAL_MEMORY: AUTO_RAM_INSTANCE 
    generic map (
        RAM_WIDTH       => 32,                
        RAM_DEPTH       => NEURAL_MEM_DEPTH, 
        RAM_PERFORMANCE => "LOW_LATENCY"   
        )
    port map(
            addra  => BR2_addra,
            addrb  => NMC_2_NMEM_ADDR((clogb2(NEURAL_MEM_DEPTH)-1) downto 0) ,
            dina   => BR2_dina,
            dinb   => NMC_2_NMEM_DIN,
            clka   => CLK ,
            clkb   => CLK ,
            wea    => BR2_wea,
            web    => NMC_2_WREN,
            ena    => BR2_ena,
            enb    => NMC_2_EN,
            rsta   => BR2_rsta,
            rstb   => NMC_2_RST,
            regcea => '1',
            regceb => '1',
            douta  => BR2_douta,
            doutb  => NMC_2_NMEM_DOUT
        );
     
    NMC3_NEURAL_MEMORY: AUTO_RAM_INSTANCE 
    generic map (
        RAM_WIDTH       => 32,                
        RAM_DEPTH       => NEURAL_MEM_DEPTH, 
        RAM_PERFORMANCE => "LOW_LATENCY"   
        )
    port map(
            addra  => BR3_addra,
            addrb  => NMC_3_NMEM_ADDR((clogb2(NEURAL_MEM_DEPTH)-1) downto 0) ,
            dina   => BR3_dina,
            dinb   => NMC_3_NMEM_DIN,
            clka   => CLK ,
            clkb   => CLK ,
            wea    => BR3_wea,
            web    => NMC_3_WREN,
            ena    => BR3_ena,
            enb    => NMC_3_EN,
            rsta   => BR3_rsta,
            rstb   => NMC_3_RST,
            regcea => '1',
            regceb => '1',
            douta  => BR3_douta,
            doutb  => NMC_3_NMEM_DOUT
        );
        
    DATA_PULL <= BR0_PRE_SYN_DATA_PULL & BR1_PRE_SYN_DATA_PULL & BR2_PRE_SYN_DATA_PULL & BR3_PRE_SYN_DATA_PULL;
    
    MAIN_SPIKE_BUFFER      <= BR0_MAIN_SPIKE_BUFFER      or BR1_MAIN_SPIKE_BUFFER      or BR2_MAIN_SPIKE_BUFFER      or BR3_MAIN_SPIKE_BUFFER      ;
    AUXILLARY_SPIKE_BUFFER <= BR0_AUXILLARY_SPIKE_BUFFER or BR1_AUXILLARY_SPIKE_BUFFER or BR2_AUXILLARY_SPIKE_BUFFER or BR3_AUXILLARY_SPIKE_BUFFER ;
    
    NMC0_BRIDGE: BRIDGE
        Generic Map (
            NEURAL_MEM_DEPTH  => NEURAL_MEM_DEPTH,    
            SYNAPSE_MEM_DEPTH => SYNAPSE_MEM_DEPTH,    
            ROW               => CROSSBAR_ROW_WIDTH           
            )
        Port Map(
            BRIDGE_CLK                 => CLK                             ,
            BRIDGE_RST                 => NEW_TIMESTEP(3)                 ,
            CYCLE_COMPLETED            => TIMESTEP_UPDATE(3)                 ,
            EVENT_DETECT               => SPIKEVECTOR_VLD_IN              ,
            EVENT_ACCEPTANCE           => BR0_EVENT_ACCEPTANCE            ,
            MAIN_SPIKE_BUFFER          => BR0_MAIN_SPIKE_BUFFER           ,
            AUXILLARY_SPIKE_BUFFER     => BR0_AUXILLARY_SPIKE_BUFFER      ,
            OUTBUFFER                  => NMC_0_W_AUX_BUFFER              ,
            AUXBUFFER                  => NMC_0_W_OUT_BUFFER              ,
            SYNAPTIC_MEM_RDADDR        => BR0_SYNAPTIC_MEM_0_RDADDR  ,
            SYNAPTIC_MEM_ENABLE        => BR0_SYNAPTIC_MEM_0_ENABLE  ,
            SYNAPTIC_MEM_WRADDR        => BR0_SYNAPTIC_MEM_0_WRADDR    ,
            SYNAPTIC_MEM_WREN          => BR0_SYNAPTIC_MEM_0_WRENABLE  ,
            HALT_HYPERCOLUMN           => BR0_HALT_HP                     ,
            PRE_SYN_DATA_PULL          => BR0_PRE_SYN_DATA_PULL           ,
            NMC_STATE_RST              => NMC0_NMC_STATE_RST              ,
            NMC_FMAC_RST               => NMC0_FMAC_EXTERN_RST            ,
            NMC_COLD_START             => NMC0_NMC_COLD_START             ,
            NMODEL_LAST_SPIKE_TIME     => NMC0_NMODEL_LAST_SPIKE_TIME     , 
            NMODEL_SYN_QFACTOR         => NMC0_NMODEL_SYN_QFACTOR         , 
            NMODEL_PF_LOW_ADDR         => NMC0_NMODEL_PF_LOW_ADDR         , 
            NMODEL_NPARAM_DATA         => BR0_2_NMC0_NMODEL_NPARAM_DATA         ,
            NMODEL_NPARAM_ADDR         => BR0_2_NMC0_NMODEL_NPARAM_ADDR         ,
            NMODEL_REFRACTORY_DUR      => NMC0_NMODEL_REFRACTORY_DUR      ,
            NMODEL_PROG_MEM_PORTA_EN   => BR0_2_NMC0_NMODEL_PROG_MEM_PORTA_EN   ,
            NMODEL_PROG_MEM_PORTA_WEN  => BR0_2_NMC0_NMODEL_PROG_MEM_PORTA_WEN  ,
            R_NNMODEL_NEW_SPIKE_TIME   => NMC0_R_NNMODEL_NEW_SPIKE_TIME   ,
            R_NMODEL_NPARAM_DATAOUT    => NMC0_R_NMODEL_NPARAM_DATAOUT    ,
            R_NMODEL_REFRACTORY_DUR    => NMC0_R_NMODEL_REFRACTORY_DUR    ,
            REDIST_NMODEL_PORTB_TKOVER => NMC0_REDIST_NMODEL_PORTB_TKOVER ,
            REDIST_NMODEL_DADDR        => NMC0_REDIST_NMODEL_DADDR        ,
            NMC_NMODEL_FINISHED        => NMC0_NMC_NMODEL_FINISHED        ,
            -- SYNAPTIC RAM MANAGEMENT
            SYNMEM_PORTA_MUX           => BR0_SYNMEM_PORTA_MUX            ,
            -- ULEARN CONTROLS
            ACTVATE_LENGINE            => ULEARN0_SYN_DIN_VLD             ,
            LEARN_RST                  => ULEARN0_RST                     ,
            SYNAPSE_PRUN               => ULEARN0_SYNAPSE_PRUNING         ,
            PRUN_THRESH                => ULEARN0_PRUN_THRESHOLD          ,
            IGNORE_ZEROS               => ULEARN0_IGNORE_ZERO_SYNAPSES    ,
            IGNORE_SOFTLIM             => ULEARN0_IGNORE_SOFTLIMITS       ,
            NEURON_WMAX                => ULEARN0_NMODEL_WMAX             ,
            NEURON_WMIN                => ULEARN0_NMODEL_WMIN             ,
            NEURON_SPK_TIME            => ULEARN0_NMODEL_SPIKE_TIME       ,
            -- NEURAL MEMORY INTERFACE                                    
            addra                      => BR0_addra                       ,
            wea                        => BR0_wea                         ,
            ena                        => BR0_ena                         ,
            rsta                       => BR0_rsta                        ,
            douta                      => BR0_douta                       ,
            dina                       => BR0_dina 
            ); 
    
    NMC1_BRIDGE: BRIDGE
        Generic Map (
            NEURAL_MEM_DEPTH  => NEURAL_MEM_DEPTH,    
            SYNAPSE_MEM_DEPTH => SYNAPSE_MEM_DEPTH,    
            ROW               => CROSSBAR_ROW_WIDTH               
            )
        Port Map(
            BRIDGE_CLK                 => CLK                             ,
            BRIDGE_RST                 => NEW_TIMESTEP(2)                 ,
            CYCLE_COMPLETED            => TIMESTEP_UPDATE(2)                 ,
            EVENT_DETECT               => SPIKEVECTOR_VLD_IN              ,
            EVENT_ACCEPTANCE           => BR1_EVENT_ACCEPTANCE            ,
            MAIN_SPIKE_BUFFER          => BR1_MAIN_SPIKE_BUFFER           ,
            AUXILLARY_SPIKE_BUFFER     => BR1_AUXILLARY_SPIKE_BUFFER      ,
            OUTBUFFER                  => NMC_1_W_AUX_BUFFER  ,
            AUXBUFFER                  => NMC_1_W_OUT_BUFFER  ,
            SYNAPTIC_MEM_RDADDR        => BR1_SYNAPTIC_MEM_1_RDADDR  ,
            SYNAPTIC_MEM_ENABLE        => BR1_SYNAPTIC_MEM_1_ENABLE  ,
            SYNAPTIC_MEM_WRADDR        => BR1_SYNAPTIC_MEM_1_WRADDR   ,
            SYNAPTIC_MEM_WREN          => BR1_SYNAPTIC_MEM_1_WRENABLE ,
            HALT_HYPERCOLUMN           => BR1_HALT_HP                     ,
            PRE_SYN_DATA_PULL          => BR1_PRE_SYN_DATA_PULL           ,
            NMC_STATE_RST              => NMC1_NMC_STATE_RST              ,
            NMC_FMAC_RST               => NMC1_FMAC_EXTERN_RST           ,
            NMC_COLD_START             => NMC1_NMC_COLD_START             ,
            NMODEL_LAST_SPIKE_TIME     => NMC1_NMODEL_LAST_SPIKE_TIME     , 
            NMODEL_SYN_QFACTOR         => NMC1_NMODEL_SYN_QFACTOR         , 
            NMODEL_PF_LOW_ADDR         => NMC1_NMODEL_PF_LOW_ADDR         , 
            NMODEL_NPARAM_DATA         => BR1_2_NMC1_NMODEL_NPARAM_DATA         ,
            NMODEL_NPARAM_ADDR         => BR1_2_NMC1_NMODEL_NPARAM_ADDR         ,
            NMODEL_REFRACTORY_DUR      => NMC1_NMODEL_REFRACTORY_DUR      ,
            NMODEL_PROG_MEM_PORTA_EN   => BR1_2_NMC1_NMODEL_PROG_MEM_PORTA_EN   ,
            NMODEL_PROG_MEM_PORTA_WEN  => BR1_2_NMC1_NMODEL_PROG_MEM_PORTA_WEN  ,
            R_NNMODEL_NEW_SPIKE_TIME   => NMC1_R_NNMODEL_NEW_SPIKE_TIME   ,
            R_NMODEL_NPARAM_DATAOUT    => NMC1_R_NMODEL_NPARAM_DATAOUT    ,
            R_NMODEL_REFRACTORY_DUR    => NMC1_R_NMODEL_REFRACTORY_DUR    ,
            REDIST_NMODEL_PORTB_TKOVER => NMC1_REDIST_NMODEL_PORTB_TKOVER ,
            REDIST_NMODEL_DADDR        => NMC1_REDIST_NMODEL_DADDR        ,
            NMC_NMODEL_FINISHED        => NMC1_NMC_NMODEL_FINISHED        ,
            -- SYNAPTIC RAM MANAGEMENT
            SYNMEM_PORTA_MUX           => BR1_SYNMEM_PORTA_MUX            ,
            -- ULEARN CONTROLS
            ACTVATE_LENGINE            => ULEARN1_SYN_DIN_VLD             ,
            LEARN_RST                  => ULEARN1_RST                     ,
            SYNAPSE_PRUN               => ULEARN1_SYNAPSE_PRUNING         ,
            PRUN_THRESH                => ULEARN1_PRUN_THRESHOLD          ,
            IGNORE_ZEROS               => ULEARN1_IGNORE_ZERO_SYNAPSES    ,
            IGNORE_SOFTLIM             => ULEARN1_IGNORE_SOFTLIMITS       ,
            NEURON_WMAX                => ULEARN1_NMODEL_WMAX             ,
            NEURON_WMIN                => ULEARN1_NMODEL_WMIN             ,
            NEURON_SPK_TIME            => ULEARN1_NMODEL_SPIKE_TIME       ,
            -- NEURAL MEMORY INTERFACE                                    
            addra                      => BR1_addra                       ,
            wea                        => BR1_wea                         ,
            ena                        => BR1_ena                         ,
            rsta                       => BR1_rsta                        ,
            douta                      => BR1_douta                       ,
            dina                       => BR1_dina 
            );
            
    
    NMC2_BRIDGE: BRIDGE
        Generic Map (
            NEURAL_MEM_DEPTH  => NEURAL_MEM_DEPTH,    
            SYNAPSE_MEM_DEPTH => SYNAPSE_MEM_DEPTH,    
            ROW               => CROSSBAR_ROW_WIDTH             
            )
        Port Map(
            BRIDGE_CLK                 => CLK                             ,
            BRIDGE_RST                 => NEW_TIMESTEP(1)                 ,
            CYCLE_COMPLETED            => TIMESTEP_UPDATE(1)                 ,
            EVENT_DETECT               => SPIKEVECTOR_VLD_IN              ,
            EVENT_ACCEPTANCE           => BR2_EVENT_ACCEPTANCE            ,
            MAIN_SPIKE_BUFFER          => BR2_MAIN_SPIKE_BUFFER           ,
            AUXILLARY_SPIKE_BUFFER     => BR2_AUXILLARY_SPIKE_BUFFER      ,
            OUTBUFFER                  => NMC_2_W_AUX_BUFFER              ,
            AUXBUFFER                  => NMC_2_W_OUT_BUFFER              ,
            SYNAPTIC_MEM_RDADDR        => BR2_SYNAPTIC_MEM_2_RDADDR  ,
            SYNAPTIC_MEM_ENABLE        => BR2_SYNAPTIC_MEM_2_ENABLE  ,
            SYNAPTIC_MEM_WRADDR        => BR2_SYNAPTIC_MEM_2_WRADDR   ,
            SYNAPTIC_MEM_WREN          => BR2_SYNAPTIC_MEM_2_WRENABLE ,
            HALT_HYPERCOLUMN           => BR2_HALT_HP                     ,
            PRE_SYN_DATA_PULL          => BR2_PRE_SYN_DATA_PULL           ,
            NMC_STATE_RST              => NMC2_NMC_STATE_RST              ,
            NMC_FMAC_RST               => NMC2_FMAC_EXTERN_RST           ,
            NMC_COLD_START             => NMC2_NMC_COLD_START             ,
            NMODEL_LAST_SPIKE_TIME     => NMC2_NMODEL_LAST_SPIKE_TIME     , 
            NMODEL_SYN_QFACTOR         => NMC2_NMODEL_SYN_QFACTOR         , 
            NMODEL_PF_LOW_ADDR         => NMC2_NMODEL_PF_LOW_ADDR         , 
            NMODEL_NPARAM_DATA         => BR2_2_NMC2_NMODEL_NPARAM_DATA         ,
            NMODEL_NPARAM_ADDR         => BR2_2_NMC2_NMODEL_NPARAM_ADDR         ,
            NMODEL_REFRACTORY_DUR      => NMC2_NMODEL_REFRACTORY_DUR      ,
            NMODEL_PROG_MEM_PORTA_EN   => BR2_2_NMC2_NMODEL_PROG_MEM_PORTA_EN   ,
            NMODEL_PROG_MEM_PORTA_WEN  => BR2_2_NMC2_NMODEL_PROG_MEM_PORTA_WEN  ,
            R_NNMODEL_NEW_SPIKE_TIME   => NMC2_R_NNMODEL_NEW_SPIKE_TIME   ,
            R_NMODEL_NPARAM_DATAOUT    => NMC2_R_NMODEL_NPARAM_DATAOUT    ,
            R_NMODEL_REFRACTORY_DUR    => NMC2_R_NMODEL_REFRACTORY_DUR    ,
            REDIST_NMODEL_PORTB_TKOVER => NMC2_REDIST_NMODEL_PORTB_TKOVER ,
            REDIST_NMODEL_DADDR        => NMC2_REDIST_NMODEL_DADDR        ,
            NMC_NMODEL_FINISHED        => NMC2_NMC_NMODEL_FINISHED        ,
             -- SYNAPTIC RAM MANAGEMENT
            SYNMEM_PORTA_MUX           => BR2_SYNMEM_PORTA_MUX            ,
            -- ULEARN CONTROLS
            ACTVATE_LENGINE            => ULEARN2_SYN_DIN_VLD             ,
            LEARN_RST                  => ULEARN2_RST                     ,
            SYNAPSE_PRUN               => ULEARN2_SYNAPSE_PRUNING         ,
            PRUN_THRESH                => ULEARN2_PRUN_THRESHOLD          ,
            IGNORE_ZEROS               => ULEARN2_IGNORE_ZERO_SYNAPSES    ,
            IGNORE_SOFTLIM             => ULEARN2_IGNORE_SOFTLIMITS       ,
            NEURON_WMAX                => ULEARN2_NMODEL_WMAX             ,
            NEURON_WMIN                => ULEARN2_NMODEL_WMIN             ,
            NEURON_SPK_TIME            => ULEARN2_NMODEL_SPIKE_TIME       ,
            -- NEURAL MEMORY INTERFACE                                    
            addra                      => BR2_addra                       ,
            wea                        => BR2_wea                         ,
            ena                        => BR2_ena                         ,
            rsta                       => BR2_rsta                        ,
            douta                      => BR2_douta                       ,
            dina                       => BR2_dina 
            );
     
    NMC3_BRIDGE: BRIDGE
        Generic Map (
            NEURAL_MEM_DEPTH  => NEURAL_MEM_DEPTH,    
            SYNAPSE_MEM_DEPTH => SYNAPSE_MEM_DEPTH,    
            ROW               => CROSSBAR_ROW_WIDTH             
            )
        Port Map(
            BRIDGE_CLK                 => CLK                                   ,
            BRIDGE_RST                 => NEW_TIMESTEP(0)                       ,
            CYCLE_COMPLETED            => TIMESTEP_UPDATE(0)                 ,
            EVENT_DETECT               => SPIKEVECTOR_VLD_IN                    ,
            EVENT_ACCEPTANCE           => BR3_EVENT_ACCEPTANCE            ,
            MAIN_SPIKE_BUFFER          => BR3_MAIN_SPIKE_BUFFER                 ,
            AUXILLARY_SPIKE_BUFFER     => BR3_AUXILLARY_SPIKE_BUFFER            ,
            OUTBUFFER                  => NMC_3_W_AUX_BUFFER                    ,
            AUXBUFFER                  => NMC_3_W_OUT_BUFFER                    ,
            SYNAPTIC_MEM_RDADDR        => BR3_SYNAPTIC_MEM_3_RDADDR ,
            SYNAPTIC_MEM_ENABLE        => BR3_SYNAPTIC_MEM_3_ENABLE ,
            SYNAPTIC_MEM_WRADDR        => BR3_SYNAPTIC_MEM_3_WRADDR   ,
            SYNAPTIC_MEM_WREN          => BR3_SYNAPTIC_MEM_3_WRENABLE ,
            HALT_HYPERCOLUMN           => BR3_HALT_HP                     ,
            PRE_SYN_DATA_PULL          => BR3_PRE_SYN_DATA_PULL                 ,
            NMC_STATE_RST              => NMC3_NMC_STATE_RST                    ,
            NMC_FMAC_RST               => NMC3_FMAC_EXTERN_RST                  ,
            NMC_COLD_START             => NMC3_NMC_COLD_START                   ,
            NMODEL_LAST_SPIKE_TIME     => NMC3_NMODEL_LAST_SPIKE_TIME           , 
            NMODEL_SYN_QFACTOR         => NMC3_NMODEL_SYN_QFACTOR               , 
            NMODEL_PF_LOW_ADDR         => NMC3_NMODEL_PF_LOW_ADDR               , 
            NMODEL_NPARAM_DATA         => BR3_2_NMC3_NMODEL_NPARAM_DATA         ,
            NMODEL_NPARAM_ADDR         => BR3_2_NMC3_NMODEL_NPARAM_ADDR         ,
            NMODEL_REFRACTORY_DUR      => NMC3_NMODEL_REFRACTORY_DUR            ,
            NMODEL_PROG_MEM_PORTA_EN   => BR3_2_NMC3_NMODEL_PROG_MEM_PORTA_EN   ,
            NMODEL_PROG_MEM_PORTA_WEN  => BR3_2_NMC3_NMODEL_PROG_MEM_PORTA_WEN  ,
            R_NNMODEL_NEW_SPIKE_TIME   => NMC3_R_NNMODEL_NEW_SPIKE_TIME         ,
            R_NMODEL_NPARAM_DATAOUT    => NMC3_R_NMODEL_NPARAM_DATAOUT          ,
            R_NMODEL_REFRACTORY_DUR    => NMC3_R_NMODEL_REFRACTORY_DUR          ,
            REDIST_NMODEL_PORTB_TKOVER => NMC3_REDIST_NMODEL_PORTB_TKOVER       ,
            REDIST_NMODEL_DADDR        => NMC3_REDIST_NMODEL_DADDR              ,
            NMC_NMODEL_FINISHED        => NMC3_NMC_NMODEL_FINISHED              ,
            -- SYNAPTIC RAM MANAGEMENT
            SYNMEM_PORTA_MUX           => BR3_SYNMEM_PORTA_MUX            ,
            -- ULEARN CONTROLS
            ACTVATE_LENGINE            => ULEARN3_SYN_DIN_VLD             ,
            LEARN_RST                  => ULEARN3_RST                     ,
            SYNAPSE_PRUN               => ULEARN3_SYNAPSE_PRUNING         ,
            PRUN_THRESH                => ULEARN3_PRUN_THRESHOLD          ,
            IGNORE_ZEROS               => ULEARN3_IGNORE_ZERO_SYNAPSES    ,
            IGNORE_SOFTLIM             => ULEARN3_IGNORE_SOFTLIMITS       ,
            NEURON_WMAX                => ULEARN3_NMODEL_WMAX             ,
            NEURON_WMIN                => ULEARN3_NMODEL_WMIN             ,
            NEURON_SPK_TIME            => ULEARN3_NMODEL_SPIKE_TIME       ,
            -- NEURAL MEMORY INTERFACE                                    
            addra                      => BR3_addra                             ,
            wea                        => BR3_wea                               ,
            ena                        => BR3_ena                               ,
            rsta                       => BR3_rsta                              ,
            douta                      => BR3_douta                             ,
            dina                       => BR3_dina 
            );              
            
            
    NMC0 : NMC 
        Port Map( 
                NMC_CLK                     => CLK                            ,
                NMC_STATE_RST               => NMC0_NMC_STATE_RST             ,
                NMC_HARD_RST                => RST                            ,
                FMAC_EXTERN_RST             => NMC0_FMAC_EXTERN_RST           ,
                --  IP CONTROLS
                NMC_COLD_START              => NMC0_NMC_COLD_START            ,
                PARTIAL_CURRENT_RDY         => COLN_VEC_SUM_VALID(0)          ,
                -- NMC AXI4LITE REGISTERS
                NMC_XNEVER_REGION_BASEADDR  => NMC_XNEVER_BASE                ,
                NMC_XNEVER_REGION_HIGHADDR  => NMC_XNEVER_HIGH                ,
                -- FROM DISTRIBUTOR
                NMODEL_LAST_SPIKE_TIME      => NMC0_NMODEL_LAST_SPIKE_TIME    ,
                NMODEL_SYN_QFACTOR          => NMC0_NMODEL_SYN_QFACTOR        ,
                NMODEL_PF_LOW_ADDR          => NMC0_NMODEL_PF_LOW_ADDR        ,
                NMODEL_NPARAM_DATA          => NMC0_NMODEL_NPARAM_DATA        ,
                NMODEL_NPARAM_ADDR          => NMC0_NMODEL_NPARAM_ADDR        ,
                NMODEL_REFRACTORY_DUR       => NMC0_NMODEL_REFRACTORY_DUR     ,
                NMODEL_PROG_MEM_PORTA_EN    => NMC0_NMODEL_PROG_MEM_PORTA_EN  ,
                NMODEL_PROG_MEM_PORTA_WEN   => NMC0_NMODEL_PROG_MEM_PORTA_WEN ,
                -- FROM HYPERCOLUMNS
                NMC_NMODEL_PSUM_IN          => COLN_0_SYN_SUM                 ,
                -- TO AXON HANDLER
                NMC_NMODEL_SPIKE_OUT        => NMC_0_NMODEL_SPIKE_OUT   ,
                NMC_NMODEL_SPIKE_VLD        => NMC_0_NMODEL_SPIKE_VLD   ,
                -- TO REDISTRIBUTOR
                R_NNMODEL_NEW_SPIKE_TIME    => NMC0_R_NNMODEL_NEW_SPIKE_TIME   ,
                R_NMODEL_NPARAM_DATAOUT     => NMC0_R_NMODEL_NPARAM_DATAOUT    ,
                R_NMODEL_REFRACTORY_DUR     => NMC0_R_NMODEL_REFRACTORY_DUR    ,
                REDIST_NMODEL_PORTB_TKOVER  => NMC0_REDIST_NMODEL_PORTB_TKOVER ,  
                REDIST_NMODEL_DADDR         => NMC0_REDIST_NMODEL_DADDR        ,  
                -- IP STATUS FLAGS
                NMC_NMODEL_FINISHED         => NMC0_NMC_NMODEL_FINISHED ,
                -- ERROR FLAGS
                NMC_MATH_ERROR              => NMC0_MATH_ERROR            ,
                NMC_MEMORY_VIOLATION        => NMC0_MEMORY_VIOLATION      
        );        
     
            
            
    NMC1 : NMC 
        Port Map( 
                NMC_CLK                     => CLK                            ,
                NMC_STATE_RST               => NMC1_NMC_STATE_RST             ,
                FMAC_EXTERN_RST             => NMC1_FMAC_EXTERN_RST           ,
                NMC_HARD_RST                => RST                            ,
                --  IP CONTROLS
                NMC_COLD_START              => NMC1_NMC_COLD_START            ,
                PARTIAL_CURRENT_RDY         => COLN_VEC_SUM_VALID(1)          ,
                -- NMC AXI4LITE REGISTERS
                NMC_XNEVER_REGION_BASEADDR  => NMC_XNEVER_BASE                ,
                NMC_XNEVER_REGION_HIGHADDR  => NMC_XNEVER_HIGH                ,
                -- FROM DISTRIBUTOR
                NMODEL_LAST_SPIKE_TIME      => NMC1_NMODEL_LAST_SPIKE_TIME    ,
                NMODEL_SYN_QFACTOR          => NMC1_NMODEL_SYN_QFACTOR        ,
                NMODEL_PF_LOW_ADDR          => NMC1_NMODEL_PF_LOW_ADDR        ,
                NMODEL_NPARAM_DATA          => NMC1_NMODEL_NPARAM_DATA        ,
                NMODEL_NPARAM_ADDR          => NMC1_NMODEL_NPARAM_ADDR        ,
                NMODEL_REFRACTORY_DUR       => NMC1_NMODEL_REFRACTORY_DUR     ,
                NMODEL_PROG_MEM_PORTA_EN    => NMC1_NMODEL_PROG_MEM_PORTA_EN  ,
                NMODEL_PROG_MEM_PORTA_WEN   => NMC1_NMODEL_PROG_MEM_PORTA_WEN ,
                -- FROM HYPERCOLUMNS
                NMC_NMODEL_PSUM_IN          => COLN_1_SYN_SUM                 ,
                -- TO AXON HANDLER
                NMC_NMODEL_SPIKE_OUT        => NMC_1_NMODEL_SPIKE_OUT   ,
                NMC_NMODEL_SPIKE_VLD        => NMC_1_NMODEL_SPIKE_VLD   ,
                -- TO REDISTRIBUTOR
                R_NNMODEL_NEW_SPIKE_TIME    => NMC1_R_NNMODEL_NEW_SPIKE_TIME   ,
                R_NMODEL_NPARAM_DATAOUT     => NMC1_R_NMODEL_NPARAM_DATAOUT    ,
                R_NMODEL_REFRACTORY_DUR     => NMC1_R_NMODEL_REFRACTORY_DUR    ,
                REDIST_NMODEL_PORTB_TKOVER  => NMC1_REDIST_NMODEL_PORTB_TKOVER ,  
                REDIST_NMODEL_DADDR         => NMC1_REDIST_NMODEL_DADDR        ,  
                -- IP STATUS FLAGS
                NMC_NMODEL_FINISHED         => NMC1_NMC_NMODEL_FINISHED ,
                -- ERROR FLAGS
                NMC_MATH_ERROR              => NMC1_MATH_ERROR            ,
                NMC_MEMORY_VIOLATION        => NMC1_MEMORY_VIOLATION      
        );        
             
            
    NMC2 : NMC 
        Port Map( 
                NMC_CLK                     => CLK                            ,
                NMC_STATE_RST               => NMC2_NMC_STATE_RST             ,
                FMAC_EXTERN_RST             => NMC2_FMAC_EXTERN_RST           ,
                NMC_HARD_RST                => RST                            ,
                --  IP CONTROLS
                NMC_COLD_START              => NMC2_NMC_COLD_START            ,
                PARTIAL_CURRENT_RDY         => COLN_VEC_SUM_VALID(2)          ,
                -- NMC AXI4LITE REGISTERS
                NMC_XNEVER_REGION_BASEADDR  => NMC_XNEVER_BASE                ,
                NMC_XNEVER_REGION_HIGHADDR  => NMC_XNEVER_HIGH                ,
                -- FROM DISTRIBUTOR
                NMODEL_LAST_SPIKE_TIME      => NMC2_NMODEL_LAST_SPIKE_TIME    ,
                NMODEL_SYN_QFACTOR          => NMC2_NMODEL_SYN_QFACTOR        ,
                NMODEL_PF_LOW_ADDR          => NMC2_NMODEL_PF_LOW_ADDR        ,
                NMODEL_NPARAM_DATA          => NMC2_NMODEL_NPARAM_DATA        ,
                NMODEL_NPARAM_ADDR          => NMC2_NMODEL_NPARAM_ADDR        ,
                NMODEL_REFRACTORY_DUR       => NMC2_NMODEL_REFRACTORY_DUR     ,
                NMODEL_PROG_MEM_PORTA_EN    => NMC2_NMODEL_PROG_MEM_PORTA_EN  ,
                NMODEL_PROG_MEM_PORTA_WEN   => NMC2_NMODEL_PROG_MEM_PORTA_WEN ,
                -- FROM HYPERCOLUMNS
                NMC_NMODEL_PSUM_IN          => COLN_2_SYN_SUM                 ,
                -- TO AXON HANDLER
                NMC_NMODEL_SPIKE_OUT        => NMC_2_NMODEL_SPIKE_OUT   ,
                NMC_NMODEL_SPIKE_VLD        => NMC_2_NMODEL_SPIKE_VLD   ,
                -- TO REDISTRIBUTOR
                R_NNMODEL_NEW_SPIKE_TIME    => NMC2_R_NNMODEL_NEW_SPIKE_TIME   ,
                R_NMODEL_NPARAM_DATAOUT     => NMC2_R_NMODEL_NPARAM_DATAOUT    ,
                R_NMODEL_REFRACTORY_DUR     => NMC2_R_NMODEL_REFRACTORY_DUR    ,
                REDIST_NMODEL_PORTB_TKOVER  => NMC2_REDIST_NMODEL_PORTB_TKOVER ,  
                REDIST_NMODEL_DADDR         => NMC2_REDIST_NMODEL_DADDR        ,  
                -- IP STATUS FLAGS
                NMC_NMODEL_FINISHED         => NMC2_NMC_NMODEL_FINISHED ,
                -- ERROR FLAGS
                NMC_MATH_ERROR              => NMC2_MATH_ERROR            ,
                NMC_MEMORY_VIOLATION        => NMC2_MEMORY_VIOLATION      
        );   
            
            
            
    NMC3 : NMC 
        Port Map( 
                NMC_CLK                     => CLK                            ,
                NMC_STATE_RST               => NMC3_NMC_STATE_RST             ,
                FMAC_EXTERN_RST             => NMC3_FMAC_EXTERN_RST           ,
                NMC_HARD_RST                => RST                            ,
                --  IP CONTROLS
                NMC_COLD_START              => NMC3_NMC_COLD_START            ,
                PARTIAL_CURRENT_RDY         => COLN_VEC_SUM_VALID(3)          ,
                -- NMC AXI4LITE REGISTERS
                NMC_XNEVER_REGION_BASEADDR  => NMC_XNEVER_BASE                ,
                NMC_XNEVER_REGION_HIGHADDR  => NMC_XNEVER_HIGH                ,
                -- FROM DISTRIBUTOR
                NMODEL_LAST_SPIKE_TIME      => NMC3_NMODEL_LAST_SPIKE_TIME    ,
                NMODEL_SYN_QFACTOR          => NMC3_NMODEL_SYN_QFACTOR        ,
                NMODEL_PF_LOW_ADDR          => NMC3_NMODEL_PF_LOW_ADDR        ,
                NMODEL_NPARAM_DATA          => NMC3_NMODEL_NPARAM_DATA        ,
                NMODEL_NPARAM_ADDR          => NMC3_NMODEL_NPARAM_ADDR        ,
                NMODEL_REFRACTORY_DUR       => NMC3_NMODEL_REFRACTORY_DUR     ,
                NMODEL_PROG_MEM_PORTA_EN    => NMC3_NMODEL_PROG_MEM_PORTA_EN  ,
                NMODEL_PROG_MEM_PORTA_WEN   => NMC3_NMODEL_PROG_MEM_PORTA_WEN ,
                -- FROM HYPERCOLUMNS
                NMC_NMODEL_PSUM_IN          => COLN_3_SYN_SUM                 ,
                -- TO AXON HANDLER
                NMC_NMODEL_SPIKE_OUT        => NMC_3_NMODEL_SPIKE_OUT   ,
                NMC_NMODEL_SPIKE_VLD        => NMC_3_NMODEL_SPIKE_VLD   ,
                -- TO REDISTRIBUTOR
                R_NNMODEL_NEW_SPIKE_TIME    => NMC3_R_NNMODEL_NEW_SPIKE_TIME   ,
                R_NMODEL_NPARAM_DATAOUT     => NMC3_R_NMODEL_NPARAM_DATAOUT    ,
                R_NMODEL_REFRACTORY_DUR     => NMC3_R_NMODEL_REFRACTORY_DUR    ,
                REDIST_NMODEL_PORTB_TKOVER  => NMC3_REDIST_NMODEL_PORTB_TKOVER ,  
                REDIST_NMODEL_DADDR         => NMC3_REDIST_NMODEL_DADDR        ,  
                -- IP STATUS FLAGS
                NMC_NMODEL_FINISHED         => NMC3_NMC_NMODEL_FINISHED ,
                -- ERROR FLAGS
                NMC_MATH_ERROR              => NMC3_MATH_ERROR            ,
                NMC_MEMORY_VIOLATION        => NMC3_MEMORY_VIOLATION      
        );           
    
        
    ULEARN0 : ULEARN_SINGLE
        Generic Map(
                LUT_TYPE => "distributed"        ,
                SYNAPSE_MEM_DEPTH => SYNAPSE_MEM_DEPTH       
                )
        Port Map 
        ( 
            ULEARN_RST            => ULEARN0_RST                  ,
            ULEARN_CLK            => CLK                          ,
            SYN_DATA_IN           => ULEARN0_SYN_DATA_IN          ,
            SYN_DIN_VLD           => ULEARN0_SYN_DIN_VLD          ,
            SYNAPSE_START_ADDRESS => BR0_SYNAPTIC_MEM_0_WRADDR    ,
            SYN_DATA_OUT          => ULEARN0_SYN_DATA_OUT         ,
            SYN_DOUT_VLD          => ULEARN0_SYN_DOUT_VLD         ,
            SYNAPSE_WRITE_ADDRESS => ULEARN0_SYNAPSE_WRITE_ADDRESS,
            SYNAPSE_PRUNING       => ULEARN0_SYNAPSE_PRUNING      ,
            PRUN_THRESHOLD        => ULEARN0_PRUN_THRESHOLD       ,
            IGNORE_ZERO_SYNAPSES  => ULEARN0_IGNORE_ZERO_SYNAPSES ,
            IGNORE_SOFTLIMITS     => ULEARN0_IGNORE_SOFTLIMITS    ,
            ULEARN_LUT_DIN        => LEARN_LUT_DIN                ,
            ULEARN_LUT_ADDR       => LEARN_LUT_ADDR               ,
            ULEARN_LUT_EN         => LEARN_LUT_EN                 ,
            NMODEL_WMAX           => ULEARN0_NMODEL_WMAX          ,
            NMODEL_WMIN           => ULEARN0_NMODEL_WMIN          ,
            NMODEL_SPIKE_TIME     => ULEARN0_NMODEL_SPIKE_TIME    
        );
    
    ULEARN1 : ULEARN_SINGLE
        Generic Map(
                LUT_TYPE => "distributed"        ,
                SYNAPSE_MEM_DEPTH => SYNAPSE_MEM_DEPTH             
                )
        Port Map 
        ( 
            ULEARN_RST            => ULEARN1_RST                  ,
            ULEARN_CLK            => CLK                          ,
            SYN_DATA_IN           => ULEARN1_SYN_DATA_IN          ,
            SYN_DIN_VLD           => ULEARN1_SYN_DIN_VLD          ,
            SYNAPSE_START_ADDRESS => BR1_SYNAPTIC_MEM_1_WRADDR    ,
            SYN_DATA_OUT          => ULEARN1_SYN_DATA_OUT         ,
            SYN_DOUT_VLD          => ULEARN1_SYN_DOUT_VLD         ,
            SYNAPSE_WRITE_ADDRESS => ULEARN1_SYNAPSE_WRITE_ADDRESS,
            SYNAPSE_PRUNING       => ULEARN1_SYNAPSE_PRUNING      ,
            PRUN_THRESHOLD        => ULEARN1_PRUN_THRESHOLD       ,
            IGNORE_ZERO_SYNAPSES  => ULEARN1_IGNORE_ZERO_SYNAPSES ,
            IGNORE_SOFTLIMITS     => ULEARN1_IGNORE_SOFTLIMITS    ,
            ULEARN_LUT_DIN        => LEARN_LUT_DIN                ,
            ULEARN_LUT_ADDR       => LEARN_LUT_ADDR               ,
            ULEARN_LUT_EN         => LEARN_LUT_EN                 ,
            NMODEL_WMAX           => ULEARN1_NMODEL_WMAX          ,
            NMODEL_WMIN           => ULEARN1_NMODEL_WMIN          ,
            NMODEL_SPIKE_TIME     => ULEARN1_NMODEL_SPIKE_TIME     
        );
        
    ULEARN2 : ULEARN_SINGLE
        Generic Map(
                LUT_TYPE => "distributed"        ,
                SYNAPSE_MEM_DEPTH => SYNAPSE_MEM_DEPTH               
                )
        Port Map 
        ( 
            ULEARN_RST            => ULEARN2_RST                  , 
            ULEARN_CLK            => CLK                          , 
            SYN_DATA_IN           => ULEARN2_SYN_DATA_IN          , 
            SYN_DIN_VLD           => ULEARN2_SYN_DIN_VLD          , 
            SYNAPSE_START_ADDRESS => BR2_SYNAPTIC_MEM_2_WRADDR    ,
            SYN_DATA_OUT          => ULEARN2_SYN_DATA_OUT         , 
            SYN_DOUT_VLD          => ULEARN2_SYN_DOUT_VLD         , 
            SYNAPSE_WRITE_ADDRESS => ULEARN1_SYNAPSE_WRITE_ADDRESS,
            SYNAPSE_PRUNING       => ULEARN2_SYNAPSE_PRUNING      , 
            PRUN_THRESHOLD        => ULEARN2_PRUN_THRESHOLD       , 
            IGNORE_ZERO_SYNAPSES  => ULEARN2_IGNORE_ZERO_SYNAPSES , 
            IGNORE_SOFTLIMITS     => ULEARN2_IGNORE_SOFTLIMITS    , 
            ULEARN_LUT_DIN        => LEARN_LUT_DIN                , 
            ULEARN_LUT_ADDR       => LEARN_LUT_ADDR               , 
            ULEARN_LUT_EN         => LEARN_LUT_EN                 , 
            NMODEL_WMAX           => ULEARN2_NMODEL_WMAX          , 
            NMODEL_WMIN           => ULEARN2_NMODEL_WMIN          , 
            NMODEL_SPIKE_TIME     => ULEARN2_NMODEL_SPIKE_TIME      
        );
    
    ULEARN3 : ULEARN_SINGLE
        Generic Map(
                LUT_TYPE => "distributed"        ,
                SYNAPSE_MEM_DEPTH => SYNAPSE_MEM_DEPTH               
                )
        Port Map 
        ( 
            ULEARN_RST            => ULEARN3_RST                  , 
            ULEARN_CLK            => CLK                          , 
            SYN_DATA_IN           => ULEARN3_SYN_DATA_IN          , 
            SYN_DIN_VLD           => ULEARN3_SYN_DIN_VLD          , 
            SYNAPSE_START_ADDRESS => BR3_SYNAPTIC_MEM_3_WRADDR    ,
            SYN_DATA_OUT          => ULEARN3_SYN_DATA_OUT         , 
            SYN_DOUT_VLD          => ULEARN3_SYN_DOUT_VLD         , 
            SYNAPSE_WRITE_ADDRESS => ULEARN3_SYNAPSE_WRITE_ADDRESS,
            SYNAPSE_PRUNING       => ULEARN3_SYNAPSE_PRUNING      , 
            PRUN_THRESHOLD        => ULEARN3_PRUN_THRESHOLD       , 
            IGNORE_ZERO_SYNAPSES  => ULEARN3_IGNORE_ZERO_SYNAPSES , 
            IGNORE_SOFTLIMITS     => ULEARN3_IGNORE_SOFTLIMITS    , 
            ULEARN_LUT_DIN        => LEARN_LUT_DIN                , 
            ULEARN_LUT_ADDR       => LEARN_LUT_ADDR               , 
            ULEARN_LUT_EN         => LEARN_LUT_EN                 , 
            NMODEL_WMAX           => ULEARN3_NMODEL_WMAX          , 
            NMODEL_WMIN           => ULEARN3_NMODEL_WMIN          , 
            NMODEL_SPIKE_TIME     => ULEARN3_NMODEL_SPIKE_TIME      
        );
    
    
 end hole_in_the_sky;   