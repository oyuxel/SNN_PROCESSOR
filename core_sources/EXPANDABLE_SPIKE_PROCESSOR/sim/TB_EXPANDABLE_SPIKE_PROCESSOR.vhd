library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity TB_EXPANDABLE_SPIKE_PROCESSOR is
    Generic(
            CROSSBAR_ROW_WIDTH : integer := 32;
            SYNAPSE_MEM_DEPTH  : integer := 16384;
            NEURAL_MEM_DEPTH   : integer := 2048            );
end entity TB_EXPANDABLE_SPIKE_PROCESSOR;

architecture your_love of TB_EXPANDABLE_SPIKE_PROCESSOR is

component EXPANDABLE_SPIKE_PROCESSOR is
    Generic(
            CROSSBAR_ROW_WIDTH : integer := 32;
            SYNAPSE_MEM_DEPTH  : integer := 4096;
            NEURAL_MEM_DEPTH   : integer := 2048            );
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
            LEARN_LUT_DIN                     : in std_logic_vector(7 downto 0);
            LEARN_LUT_ADDR                    : in std_logic_vector(7 downto 0);
            LEARN_LUT_EN                      : in std_logic;
            -- PARAMETERS
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
end component EXPANDABLE_SPIKE_PROCESSOR;


            signal RST                               : std_logic := '0';
            signal CLK                               : std_logic := '1';
            signal NEW_TIMESTEP                      : std_logic_vector(3 downto 0) := (others=>'0');
            signal TIMESTEP_UPDATE                   : std_logic_vector(3 downto 0) := (others=>'0');
            signal SPIKEVECTOR_IN                    : std_logic_vector(CROSSBAR_ROW_WIDTH-1 downto 0) := (others=>'0'); 
            signal SPIKEVECTOR_VLD_IN                : std_logic := '0';                        
            signal SPIKEVECTOR_OUT                   : std_logic_vector(CROSSBAR_ROW_WIDTH-1 downto 0) := (others=>'0'); 
            signal SPIKEVECTOR_VLD_OUT               : std_logic := '0';
            signal EVENT_ACCEPT                      : std_logic := '0';
            signal MAIN_SPIKE_BUFFER                 : std_logic := '0';
            signal AUXILLARY_SPIKE_BUFFER            : std_logic := '0';
            signal SYNAPSE_ROUTE                     : std_logic_vector(1  downto 0) := (others=>'0'); -- 00: Recycle, 01: In, 10: Out
            signal SYNAPTIC_MEM_0_DIN                : std_logic_vector(15 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_0_DADDR              : std_logic_vector(31 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_0_EN                 : std_logic := '0';
            signal SYNAPTIC_MEM_0_WREN               : std_logic := '0';
            signal SYNAPTIC_MEM_0_RDEN               : std_logic := '0';
            signal SYNAPTIC_MEM_0_DOUT               : std_logic_vector(15 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_1_DIN                : std_logic_vector(15 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_1_DADDR              : std_logic_vector(31 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_1_EN                 : std_logic := '0';
            signal SYNAPTIC_MEM_1_WREN               : std_logic := '0';
            signal SYNAPTIC_MEM_1_RDEN               : std_logic := '0';
            signal SYNAPTIC_MEM_1_DOUT               : std_logic_vector(15 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_2_DIN                : std_logic_vector(15 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_2_DADDR              : std_logic_vector(31 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_2_EN                 : std_logic := '0';
            signal SYNAPTIC_MEM_2_WREN               : std_logic := '0';
            signal SYNAPTIC_MEM_2_RDEN               : std_logic := '0';
            signal SYNAPTIC_MEM_2_DOUT               : std_logic_vector(15 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_3_DIN                : std_logic_vector(15 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_3_DADDR              : std_logic_vector(31 downto 0) := (others=>'0');
            signal SYNAPTIC_MEM_3_EN                 : std_logic := '0';
            signal SYNAPTIC_MEM_3_WREN               : std_logic := '0';
            signal SYNAPTIC_MEM_3_RDEN               : std_logic := '0';
            signal SYNAPTIC_MEM_3_DOUT               : std_logic_vector(15 downto 0);
            signal NMC_XNEVER_BASE                   : std_logic_vector(9 downto 0) := (others=>'0');
            signal NMC_XNEVER_HIGH                   : std_logic_vector(9 downto 0) := (others=>'0');
            signal NMC0_MATH_ERROR                   : std_logic := '0';
            signal NMC0_MEMORY_VIOLATION             : std_logic := '0';
            signal NMC1_MATH_ERROR                   : std_logic := '0';
            signal NMC1_MEMORY_VIOLATION             : std_logic := '0';
            signal NMC2_MATH_ERROR                   : std_logic := '0';
            signal NMC2_MEMORY_VIOLATION             : std_logic := '0';
            signal NMC3_MATH_ERROR                   : std_logic := '0';
            signal NMC3_MEMORY_VIOLATION             : std_logic := '0';            
            signal NMC_PMODE_SWITCH                  : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others=>'0');  
            signal NMC_NPARAM_DATA                   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others=>'0');
            signal NMC_NPARAM_ADDR                   : STD_LOGIC_VECTOR(9  DOWNTO 0) := (others=>'0');
            signal NMC_PROG_MEM_PORTA_EN             : STD_LOGIC := '0';
            signal NMC_PROG_MEM_PORTA_WEN            : STD_LOGIC := '0';  
            signal NMC_0_NMODEL_SPIKE_OUT            : std_logic := '0'; 
            signal NMC_0_NMODEL_SPIKE_VLD            : std_logic := '0';   
            signal NMC_1_NMODEL_SPIKE_OUT            : std_logic := '0'; 
            signal NMC_1_NMODEL_SPIKE_VLD            : std_logic := '0';  
            signal NMC_2_NMODEL_SPIKE_OUT            : std_logic := '0'; 
            signal NMC_2_NMODEL_SPIKE_VLD            : std_logic := '0';  
            signal NMC_3_NMODEL_SPIKE_OUT            : std_logic := '0'; 
            signal NMC_3_NMODEL_SPIKE_VLD            : std_logic := '0';  
            signal NMC_0_W_AUX_BUFFER                : std_logic := '0';
            signal NMC_0_W_OUT_BUFFER                : std_logic := '0';
            signal NMC_1_W_AUX_BUFFER                : std_logic := '0';
            signal NMC_1_W_OUT_BUFFER                : std_logic := '0';
            signal NMC_2_W_AUX_BUFFER                : std_logic := '0';
            signal NMC_2_W_OUT_BUFFER                : std_logic := '0'; 
            signal NMC_3_W_AUX_BUFFER                : std_logic := '0';
            signal NMC_3_W_OUT_BUFFER                : std_logic := '0';
            signal LEARN_SYNAPSE_PRUNING             : std_logic := '0';
            signal LEARN_PRUN_THRESHOLD              : std_logic_vector(7 downto 0) := (others=>'0');
            signal LEARN_IGNORE_ZERO_SYNAPSES        : std_logic := '0';  
            signal LEARN_IGNORE_SOFTLIMITS           : std_logic := '0';  
            signal LEARN_LUT_DIN                     : std_logic_vector(7 downto 0) := (others=>'0');
            signal LEARN_LUT_ADDR                    : std_logic_vector(7 downto 0) := (others=>'0');
            signal LEARN_LUT_EN                      : std_logic := '0';
            signal NMC_0_NMEM_ADDR                   : std_logic_vector(31 downto 0) := (others=>'0');
            signal NMC_0_NMEM_DIN                    : std_logic_vector(31 downto 0) := (others=>'0');	
            signal NMC_0_NMEM_DOUT                   : std_logic_vector(31 downto 0) := (others=>'0');
            signal NMC_0_EN                          : std_logic := '0'; 
            signal NMC_0_WREN                        : std_logic := '0'; 
            signal NMC_0_RST                         : std_logic := '0';
            signal NMC_1_NMEM_ADDR                   : std_logic_vector(31 downto 0) := (others=>'0');
            signal NMC_1_NMEM_DIN                    : std_logic_vector(31 downto 0) := (others=>'0');	
            signal NMC_1_NMEM_DOUT                   : std_logic_vector(31 downto 0) := (others=>'0');
            signal NMC_1_EN                          : std_logic := '0'; 
            signal NMC_1_WREN                        : std_logic := '0'; 
            signal NMC_1_RST                         : std_logic := '0'; 
            signal NMC_2_NMEM_ADDR                   : std_logic_vector(31 downto 0) := (others=>'0');
            signal NMC_2_NMEM_DIN                    : std_logic_vector(31 downto 0) := (others=>'0');	
            signal NMC_2_NMEM_DOUT                   : std_logic_vector(31 downto 0) := (others=>'0');
            signal NMC_2_EN                          : std_logic := '0'; 
            signal NMC_2_WREN                        : std_logic := '0'; 
            signal NMC_2_RST                         : std_logic := '0'; 
            signal NMC_3_NMEM_ADDR                   : std_logic_vector(31 downto 0) := (others=>'0');
            signal NMC_3_NMEM_DIN                    : std_logic_vector(31 downto 0) := (others=>'0');	
            signal NMC_3_NMEM_DOUT                   : std_logic_vector(31 downto 0) := (others=>'0');
            signal NMC_3_EN                          : std_logic := '0'; 
            signal NMC_3_WREN                        : std_logic := '0'; 
            signal NMC_3_RST                         : std_logic := '0'; 
            constant CLKPERIOD                       : time := 10 ns;

            constant SYNLOW                          : std_logic_vector(3 downto 0) := "0001";
            constant SSSDSYNHIGH                     : std_logic_vector(3 downto 0) := "0010";
            constant REFPLST                         : std_logic_vector(3 downto 0) := "0011";
            constant PFLOWSYNQ                       : std_logic_vector(3 downto 0) := "0100";
            constant ULEARNPARAMS                    : std_logic_vector(3 downto 0) := "0101";
            constant NPADDRDATA                      : std_logic_vector(3 downto 0) := "0110";
            constant ENDFLOW                         : std_logic_vector(3 downto 0) := "0111";
            
            constant SPIKES : std_logic := '0';
            
begin

CLK <= not CLK after CLKPERIOD/2;

process begin

    wait for 10*CLKPERIOD;

    RST <= '1';
    
    wait for CLKPERIOD;
    
    RST <= '0';
    
    wait for CLKPERIOD;

    NMC_PMODE_SWITCH <= "01";

    wait for CLKPERIOD;  


    NMC_PROG_MEM_PORTA_EN  <= '1';
    NMC_PROG_MEM_PORTA_WEN <= '1';
    
    NMC_NPARAM_DATA <= "0011001000000000"; --getacc,x1  (LOAD I to x1)
    NMC_NPARAM_ADDR <= std_logic_vector(to_unsigned(542,NMC_NPARAM_ADDR'length));  
    wait for CLKPERIOD;
    NMC_NPARAM_DATA <= "0110000000000000"; --clracc     (CLEAR ACC)
    NMC_NPARAM_ADDR <= std_logic_vector(to_unsigned(543,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;   
    NMC_NPARAM_DATA <= "0001000000110111"; --lw,x2,44   (LOAD v)
    NMC_NPARAM_ADDR <= std_logic_vector(to_unsigned(544,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001010000101100"; --lw,x3,45   (LOAD h)
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(545,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001011000101101"; --lw,x4,46   (LOAD u)
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(546,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001100000101110"; --lw,x5,47   (LOAD 140)
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(547,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001101000101111"; --fmac,x2,x0 (ACC <= v)
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(548,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000010000"; --fmac,x1,x3 (ACC <= v + I*h)
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(549,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000001011"; --smac,x4,x3 (ACC <= v + I*h - h*u)
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(550,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0101000000100011"; --fmac,x5,x3 (ACC <= 140*h - h*u + I*h + v )
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(551,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000101011"; --getacc,x6  ( x6 = 140*h - h*u + I*h + v )
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(552,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011110000000000"; --clracc
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(553,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000"; --fmac,x3,x2 (ACC <= h*v )
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(554,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000011010"; --getacc,x7  ( x7 = h*v )
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(555,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011111000000000"; --clracc
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(556,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000"; --lw,x5,48   (LOAD 5)
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(557,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001101000110000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(558,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000111101";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(559,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000110000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(560,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011110000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(561,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(562,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001101000110001";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(563,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000111101";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(564,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011111000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(565,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(566,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000111010";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(567,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000110000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(568,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011110000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(569,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(570,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001111000110101";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(571,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0111000000110111";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(572,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "1010000000011010";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(573,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0010110000101100";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(574,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001101000110011";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(575,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001110000110100";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(576,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000101110";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(577,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011111000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(578,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(579,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000010011";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(580,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011001000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(581,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(582,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000001111";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(583,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000100000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(584,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011001000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(585,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(586,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000011101";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(587,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011111000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(588,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(589,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000111100";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(590,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011111000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(591,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(592,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000000001";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(593,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0101000000000111";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(594,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011111000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(595,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0110000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(596,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0010111000101110";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(597,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "1101000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(598,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "1011000000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(599,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001111000110010";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(600,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0010111000101100";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(601,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000000100";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(602,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0001010000110110";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(603,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0100000000010000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(604,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0011111000000000";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(605,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA  <= "0010111000101110";
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(606,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA <= "1101000000000000";
    NMC_NPARAM_ADDR <= std_logic_vector(to_unsigned(607,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD;
    NMC_NPARAM_DATA <= X"2E66";  -- h
    NMC_NPARAM_ADDR <= std_logic_vector(to_unsigned(768+45,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA  <= X"5860";  -- 140
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(768+47,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA  <= X"251E";  -- a
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(768+51,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA  <= X"4F80";  -- threshold
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(768+53,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA  <= X"3266";  -- b
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(768+52,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA  <= X"4000";  -- d
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(768+54,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA <= X"3C00";  -- FP16 1.0
    NMC_NPARAM_ADDR <= std_logic_vector(to_unsigned(768+55,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA <= X"D240";  -- c
    NMC_NPARAM_ADDR <= std_logic_vector(to_unsigned(768+50,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA  <= X"291E";  -- 0.04
    NMC_NPARAM_ADDR  <= std_logic_vector(to_unsigned(768+49,NMC_NPARAM_ADDR'length)); 
    wait for CLKPERIOD; 
    NMC_NPARAM_DATA <= X"4500";  -- 5
    NMC_NPARAM_ADDR <= std_logic_vector(to_unsigned(768+48,NMC_NPARAM_ADDR'length)); 
    
    NMC_PMODE_SWITCH <= "00";

    NMC_PROG_MEM_PORTA_EN  <= '0';
    NMC_PROG_MEM_PORTA_WEN <= '0';

    
    wait for CLKPERIOD;  

    wait for CLKPERIOD;
    NMC_XNEVER_BASE   <= std_logic_vector(to_unsigned(768,NMC_XNEVER_BASE'length));
    wait for CLKPERIOD;
    NMC_XNEVER_HIGH   <= std_logic_vector(to_unsigned(1023,NMC_XNEVER_HIGH'length));
    wait for CLKPERIOD;

   for i in 127 downto 0 loop
   
        LEARN_LUT_DIN   <= std_logic_vector(to_unsigned(i,LEARN_LUT_DIN'length));
        LEARN_LUT_ADDR  <= std_logic_vector(to_unsigned(127-i,LEARN_LUT_ADDR'length));
        LEARN_LUT_EN    <= '1';
        wait for CLKPERIOD;
   
   end loop;
   
   for i in 255 downto 128 loop
   
        LEARN_LUT_DIN   <= std_logic_vector(to_unsigned(127-i,LEARN_LUT_DIN'length));
        LEARN_LUT_ADDR  <= std_logic_vector(to_unsigned(i,LEARN_LUT_ADDR'length));
        LEARN_LUT_EN    <= '1';
        wait for CLKPERIOD;
   
   end loop;

        LEARN_LUT_EN    <= '0';

    SYNAPSE_ROUTE              <= "01";
        
        wait for CLKPERIOD;  
        
            SYNAPTIC_MEM_0_EN   <= '0';
            SYNAPTIC_MEM_0_WREN <= '0';
        
            SYNAPTIC_MEM_1_EN   <= '0';
            SYNAPTIC_MEM_1_WREN <= '0';
                    
            SYNAPTIC_MEM_2_EN   <= '0';
            SYNAPTIC_MEM_2_WREN <= '0';
        
            SYNAPTIC_MEM_3_EN   <= '0';
            SYNAPTIC_MEM_3_WREN <= '0';
            
        wait for CLKPERIOD;  
        
        
        
    for m in 0 to 31 loop        
    
        for i in 0 to 127 loop
        
            SYNAPTIC_MEM_0_DIN(15 downto 8)    <= std_logic_vector(to_unsigned(  i,SYNAPTIC_MEM_0_DIN'length/2));
            SYNAPTIC_MEM_0_DIN(7  downto 0)    <= std_logic_vector(to_unsigned(  i,SYNAPTIC_MEM_0_DIN'length/2));
            SYNAPTIC_MEM_0_DADDR  <= std_logic_vector(to_unsigned(i+128*m,SYNAPTIC_MEM_0_DADDR'length));
        
            SYNAPTIC_MEM_1_DIN(15 downto 8)     <= std_logic_vector(to_unsigned(  i,SYNAPTIC_MEM_0_DIN'length/2));
            SYNAPTIC_MEM_1_DIN(7  downto 0)     <= std_logic_vector(to_unsigned(  i,SYNAPTIC_MEM_0_DIN'length/2));
            SYNAPTIC_MEM_1_DADDR  <= std_logic_vector(to_unsigned(i+128*m,SYNAPTIC_MEM_0_DADDR'length));
        
            SYNAPTIC_MEM_2_DIN(15 downto 8)     <= std_logic_vector(to_unsigned(  i,SYNAPTIC_MEM_0_DIN'length/2));
            SYNAPTIC_MEM_2_DIN(7  downto 0)     <= std_logic_vector(to_unsigned(  i,SYNAPTIC_MEM_0_DIN'length/2));
            SYNAPTIC_MEM_2_DADDR  <= std_logic_vector(to_unsigned(i+128*m,SYNAPTIC_MEM_0_DADDR'length));            
        
            SYNAPTIC_MEM_3_DIN(15 downto 8)     <= std_logic_vector(to_unsigned(  i,SYNAPTIC_MEM_0_DIN'length/2));
            SYNAPTIC_MEM_3_DIN(7  downto 0)     <= std_logic_vector(to_unsigned(  i,SYNAPTIC_MEM_0_DIN'length/2));
            SYNAPTIC_MEM_3_DADDR  <= std_logic_vector(to_unsigned(i+128*m,SYNAPTIC_MEM_0_DADDR'length));            
            
            SYNAPTIC_MEM_0_EN   <= '1';
            SYNAPTIC_MEM_0_WREN <= '1';
        
            SYNAPTIC_MEM_1_EN   <= '1';
            SYNAPTIC_MEM_1_WREN <= '1';
                    
            SYNAPTIC_MEM_2_EN   <= '1';
            SYNAPTIC_MEM_2_WREN <= '1';
        
            SYNAPTIC_MEM_3_EN   <= '1';
            SYNAPTIC_MEM_3_WREN <= '1';
            
            wait for CLKPERIOD; 
             
        end loop;
        
    end loop;
    
            SYNAPTIC_MEM_0_EN   <= '0';
            SYNAPTIC_MEM_0_WREN <= '0';
        
            SYNAPTIC_MEM_1_EN   <= '0';
            SYNAPTIC_MEM_1_WREN <= '0';
                    
            SYNAPTIC_MEM_2_EN   <= '0';
            SYNAPTIC_MEM_2_WREN <= '0';
        
            SYNAPTIC_MEM_3_EN   <= '0';
            SYNAPTIC_MEM_3_WREN <= '0';

    
    wait for CLKPERIOD;  

    SYNAPSE_ROUTE              <= "00";
    wait for CLKPERIOD;  

    wait for 20*CLKPERIOD;
    
    -- Neuron Param Initialization

    wait for CLKPERIOD;
    
    --  DOUTA(31 downto 28)
    --
    -- "0001" --> SYNAPSE_LOW_ADDRESS
    --
    --            if SYNLOW = DOUTA(31 downto 28)
    --              SYNAPSE_LOW_ADDRESS   <= douta(15 downto 0)
    --
    -- "0010" --> SPIKE SOURCE & SPIKE DESTINATION & SYNAPSE_HIGH_ADDRESS  
    --
    --            if SSSDSYNHIGH = DOUTA(31 downto 28)
    --              SPIKE SOURCE          <= douta(17)            '0' : MAIN SPIKE BUFFER ,      '1' : AUXILLARY SPIKE BUFFER
    --              SPIKE DESTINATION     <= douta(16)            '0' : AUXILLARY SPIKE BUFFER , '1' : OUTPUT SPIKE BUFFER
    --              SYNAPSE_HIGH_ADDRESS  <= douta(15 downto 0)
    --
    -- "0011" --> REFRACTORY PERIOD & LAST SPIKE TIME                     
    --              
    --             if RFPLST = DOUTA(31 downto 28)
    --              REFACTORY PERIOD      <= douta(15 downto 8)
    --              LAST SPIKE TIME       <= douta(7  downto 0) 
    --
    -- "0100" --> PROGRAM FLOW LOW & SYNAPTIC QFACTOR  
    --
    --             if PFLOWSYNQ = DOUTA(31 downto 28)
    --              PROGRAM FLOW LOW      <= douta(25 downto 16) 
    --              SYNAPTIC QFACTOR      <= douta(15 downto  0) 
    --
    -- "0101" --> SYNAPSE_PRUN & IGNORE_ZEROS & IGNORE_SOFTLIM & NEURON_WMAX & NEURON_WMIN & PRUN_THRESHOLD
    --
    --             if ULEARNPARAMS = DOUTA(31 downto 28)
    --              SYNAPSE_PRUN          <= douta(26)     
    --              IGNORE_ZEROS          <= douta(25)      
    --              IGNORE_SOFTLIM        <= douta(24)      
    --              NEURON_WMAX           <= douta(23 downto 16)                   
    --              NEURON_WMIN           <= douta(15 downto  8)
    --              PRUN_THRESHOLD        <= douta(7  downto  0)
    --
    -- "0110" --> NPARAM_ADDR & NPARAM_DATA
    --
    --             if NPARAMADDR  = DOUTA(31 downto 28)
    --              NPARAM_ADDR <= douta(25 downto 16)
    --              NPARAM_DATA <= douta(15 downto 0)
    --
    -- "0111" --> ENDFLOW   
    --   
    --             if NPARAMDATA  = DOUTA(31 downto 28)
    --              ENDFLOW = X"0001" --> Start Inference. There will be a neuron next. Wait for NMC_NMODEL_FINISHED and load the next neuron.
    --              ENDFLOW = X"0002" --> Start Learning. Take only INFERENCE CYCLES and LAST SPIKE TIMES and feed them into Learning Engines
    --              ENDFLOW = X"0003" --> Network completed. Load the first neurons and first synapses and wait for an event.


    for k in 0 to 31 loop
 
 
        NMC_0_EN         <= '1';
        NMC_0_WREN       <= '1';
  
        NMC_1_EN         <= '1';
        NMC_1_WREN       <= '1';
            
        NMC_2_EN         <= '1';
        NMC_2_WREN       <= '1';
            
        NMC_3_EN         <= '1';
        NMC_3_WREN       <= '1';

        wait for CLKPERIOD; 

        NMC_0_NMEM_DIN(31 downto 28)  <= SYNLOW;
        NMC_0_NMEM_DIN(27 downto 16)  <= (others=>'0');
        NMC_0_NMEM_DIN(15 downto  0)  <= std_logic_vector(to_unsigned(0+128*k,16));
        NMC_0_NMEM_ADDR <= std_logic_vector(to_unsigned(0+k*8,32));
        
        NMC_1_NMEM_DIN(31 downto 28)  <= SYNLOW;
        NMC_1_NMEM_DIN(27 downto 16)  <= (others=>'0');
        NMC_1_NMEM_DIN(15 downto  0)  <= std_logic_vector(to_unsigned(0+128*k,16));
        NMC_1_NMEM_ADDR <= std_logic_vector(to_unsigned(0+k*8,32));
        
        NMC_2_NMEM_DIN(31 downto 28)  <= SYNLOW;
        NMC_2_NMEM_DIN(27 downto 16)  <= (others=>'0');
        NMC_2_NMEM_DIN(15 downto  0)  <= std_logic_vector(to_unsigned(0+128*k,16));
        NMC_2_NMEM_ADDR <= std_logic_vector(to_unsigned(0+k*8,32));
        
        NMC_3_NMEM_DIN(31 downto 28)  <= SYNLOW;
        NMC_3_NMEM_DIN(27 downto 16)  <= (others=>'0');
        NMC_3_NMEM_DIN(15 downto  0)  <= std_logic_vector(to_unsigned(0+128*k,16));
        NMC_3_NMEM_ADDR <= std_logic_vector(to_unsigned(0+k*8,32));
        
        wait for CLKPERIOD; 
        
        NMC_0_NMEM_DIN(31 downto 28)  <= SSSDSYNHIGH  ;
        NMC_0_NMEM_DIN(27 downto 18)  <= (others=>'0');
        NMC_0_NMEM_DIN(17)            <= '0'  ;
        NMC_0_NMEM_DIN(16)            <= '1'  ;
        NMC_0_NMEM_DIN(15 downto 0)   <= std_logic_vector(to_unsigned(128*k+127,16)) ;
        NMC_0_NMEM_ADDR <= std_logic_vector(to_unsigned(1+k*8,32));    
                
        NMC_1_NMEM_DIN(31 downto 28)  <= SSSDSYNHIGH  ;
        NMC_1_NMEM_DIN(27 downto 18)  <= (others=>'0');
        NMC_1_NMEM_DIN(17)            <= '0'  ;
        NMC_1_NMEM_DIN(16)            <= '1'  ;
        NMC_1_NMEM_DIN(15 downto 0)   <= std_logic_vector(to_unsigned(128*k+127,16)) ;
        NMC_1_NMEM_ADDR <= std_logic_vector(to_unsigned(1+k*8,32));
       
        NMC_2_NMEM_DIN(31 downto 28)  <= SSSDSYNHIGH  ;
        NMC_2_NMEM_DIN(27 downto 18)  <= (others=>'0');
        NMC_2_NMEM_DIN(17)            <= '0'  ;
        NMC_2_NMEM_DIN(16)            <= '1'  ;
        NMC_2_NMEM_DIN(15 downto 0)   <= std_logic_vector(to_unsigned(128*k+127,16)) ;
        NMC_2_NMEM_ADDR <= std_logic_vector(to_unsigned(1+k*8,32));
                
        NMC_3_NMEM_DIN(31 downto 28)  <= SSSDSYNHIGH  ;
        NMC_3_NMEM_DIN(27 downto 18)  <= (others=>'0');
        NMC_3_NMEM_DIN(17)            <= '0'  ;
        NMC_3_NMEM_DIN(16)            <= '1'  ;
        NMC_3_NMEM_DIN(15 downto 0)   <= std_logic_vector(to_unsigned(128*k+127,16)) ;
        NMC_3_NMEM_ADDR <= std_logic_vector(to_unsigned(1+k*8,32));
        
        wait for CLKPERIOD; 
        
        NMC_0_NMEM_DIN(31 downto 28)  <= REFPLST          ;
        NMC_0_NMEM_DIN(27 downto 16)  <= (others=>'0');
        NMC_0_NMEM_DIN(15 downto  8)  <= (others=>'0');
        NMC_0_NMEM_DIN(7 downto   0)  <= std_logic_vector(to_unsigned(32+k,8));   
        NMC_0_NMEM_ADDR <= std_logic_vector(to_unsigned(2+k*8,32));
                
        NMC_1_NMEM_DIN(31 downto 28)  <= REFPLST          ;
        NMC_1_NMEM_DIN(27 downto 16)  <= (others=>'0');
        NMC_1_NMEM_DIN(15 downto  8)  <= (others=>'0');
        NMC_1_NMEM_DIN(7 downto   0)  <= std_logic_vector(to_unsigned(32+k,8))          ;
        NMC_1_NMEM_ADDR <= std_logic_vector(to_unsigned(2+k*8,32));
                
        NMC_2_NMEM_DIN(31 downto 28)  <= REFPLST          ;
        NMC_2_NMEM_DIN(27 downto 16)  <= (others=>'0');
        NMC_2_NMEM_DIN(15 downto  8)  <= (others=>'0');
        NMC_2_NMEM_DIN(7 downto   0)  <= std_logic_vector(to_unsigned(32+k,8))          ;
        NMC_2_NMEM_ADDR <= std_logic_vector(to_unsigned(2+k*8,32));
                
        NMC_3_NMEM_DIN(31 downto 28)  <= REFPLST          ;
        NMC_3_NMEM_DIN(27 downto 16)  <= (others=>'0');
        NMC_3_NMEM_DIN(15 downto  8)  <= (others=>'0');
        NMC_3_NMEM_DIN(7 downto   0)  <= std_logic_vector(to_unsigned(32+k,8))          ;
        NMC_3_NMEM_ADDR <= std_logic_vector(to_unsigned(2+k*8,32));
        
        wait for CLKPERIOD; 
        
        NMC_0_NMEM_DIN(31 downto 28)  <= PFLOWSYNQ    ;
        NMC_0_NMEM_DIN(27 downto 26)  <= (others=>'0');
        NMC_0_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(542,10))    ;
        NMC_0_NMEM_DIN(15 downto  0)  <= X"2004"      ;
        NMC_0_NMEM_ADDR <= std_logic_vector(to_unsigned(3+k*8,32));  
                
        NMC_1_NMEM_DIN(31 downto 28)  <= PFLOWSYNQ    ;
        NMC_1_NMEM_DIN(27 downto 26)  <= (others=>'0');
        NMC_1_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(542,10))    ;
        NMC_1_NMEM_DIN(15 downto  0)  <= X"2004"      ;
        NMC_1_NMEM_ADDR <= std_logic_vector(to_unsigned(3+k*8,32));  
                
        NMC_2_NMEM_DIN(31 downto 28)  <= PFLOWSYNQ    ;
        NMC_2_NMEM_DIN(27 downto 26)  <= (others=>'0');
        NMC_2_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(542,10))    ;
        NMC_2_NMEM_DIN(15 downto  0)  <= X"2004"      ;
        NMC_2_NMEM_ADDR <= std_logic_vector(to_unsigned(3+k*8,32));  
                
        NMC_3_NMEM_DIN(31 downto 28)  <= PFLOWSYNQ    ;
        NMC_3_NMEM_DIN(27 downto 26)  <= (others=>'0');
        NMC_3_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(542,10))    ;
        NMC_3_NMEM_DIN(15 downto  0)  <= X"2004"      ;
        NMC_3_NMEM_ADDR <= std_logic_vector(to_unsigned(3+k*8,32));  
        
        wait for CLKPERIOD; 
          
        NMC_0_NMEM_DIN(31 downto 28)  <= ULEARNPARAMS ;
        NMC_0_NMEM_DIN(27)            <= '0'     ;
        NMC_0_NMEM_DIN(26)            <= '0'     ;
        NMC_0_NMEM_DIN(25)            <= '0'     ;
        NMC_0_NMEM_DIN(24)            <= '0'     ;
        NMC_0_NMEM_DIN(23 downto 16)  <= std_logic_vector(to_signed(127,8)) ;
        NMC_0_NMEM_DIN(15 downto  8)  <= std_logic_vector(to_signed(-128,8)) ;
        NMC_0_NMEM_DIN(7  downto  0)  <= std_logic_vector(to_signed(-12,8)) ;
        NMC_0_NMEM_ADDR <= std_logic_vector(to_unsigned(4+k*8,32));
                  
        NMC_1_NMEM_DIN(31 downto 28)  <= ULEARNPARAMS ;
        NMC_1_NMEM_DIN(27)            <= '0'     ;
        NMC_1_NMEM_DIN(26)            <= '0'     ;
        NMC_1_NMEM_DIN(25)            <= '0'     ;
        NMC_1_NMEM_DIN(24)            <= '0'     ;
        NMC_1_NMEM_DIN(23 downto 16)  <= std_logic_vector(to_signed(127,8)) ;
        NMC_1_NMEM_DIN(15 downto  8)  <= std_logic_vector(to_signed(-128,8)) ;
        NMC_1_NMEM_DIN(7  downto  0)  <= std_logic_vector(to_signed(-12,8)) ;
        NMC_1_NMEM_ADDR <= std_logic_vector(to_unsigned(4+k*8,32));
                  
        NMC_2_NMEM_DIN(31 downto 28)  <= ULEARNPARAMS ;
        NMC_2_NMEM_DIN(27)            <= '0'     ;
        NMC_2_NMEM_DIN(26)            <= '0'     ;
        NMC_2_NMEM_DIN(25)            <= '0'     ;
        NMC_2_NMEM_DIN(24)            <= '0'     ;
        NMC_2_NMEM_DIN(23 downto 16)  <= std_logic_vector(to_signed(127,8)) ;
        NMC_2_NMEM_DIN(15 downto  8)  <= std_logic_vector(to_signed(-128,8)) ;
        NMC_2_NMEM_DIN(7  downto  0)  <= std_logic_vector(to_signed(-12,8)) ;
        NMC_2_NMEM_ADDR <= std_logic_vector(to_unsigned(4+k*8,32));
                  
        NMC_3_NMEM_DIN(31 downto 28)  <= ULEARNPARAMS ;
        NMC_3_NMEM_DIN(27)            <= '0'     ;
        NMC_3_NMEM_DIN(26)            <= '0'     ;
        NMC_3_NMEM_DIN(15)            <= '0'     ;
        NMC_3_NMEM_DIN(24)            <= '0'     ;
        NMC_3_NMEM_DIN(23 downto 16)  <= std_logic_vector(to_signed(127,8)) ;
        NMC_3_NMEM_DIN(15 downto  8)  <= std_logic_vector(to_signed(-128,8)) ;
        NMC_3_NMEM_DIN(7  downto  0)  <= std_logic_vector(to_signed(-12,8)) ;
        NMC_3_NMEM_ADDR <= std_logic_vector(to_unsigned(4+k*8,32));
        
        wait for CLKPERIOD; 
        
        NMC_0_NMEM_DIN(31 downto 28)  <= NPADDRDATA   ;
        NMC_0_NMEM_DIN(27 downto 26)  <= (others=>'0')   ;
        NMC_0_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(768+44,10))   ;
        NMC_0_NMEM_DIN(15 downto  0)  <= X"0000"  ;     
        NMC_0_NMEM_ADDR <= std_logic_vector(to_unsigned(5+k*8,32));    
                
        NMC_1_NMEM_DIN(31 downto 28)  <= NPADDRDATA   ;
        NMC_1_NMEM_DIN(27 downto 26)  <= (others=>'0')   ;
        NMC_1_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(768+44,10))   ;
        NMC_1_NMEM_DIN(15 downto  0)  <= X"0000"    ;
        NMC_1_NMEM_ADDR <= std_logic_vector(to_unsigned(5+k*8,32));    
                
        NMC_2_NMEM_DIN(31 downto 28)  <= NPADDRDATA   ;
        NMC_2_NMEM_DIN(27 downto 26)  <= (others=>'0')   ;
        NMC_2_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(768+44,10))   ;
        NMC_2_NMEM_DIN(15 downto  0)  <= X"0000"     ;
        NMC_2_NMEM_ADDR <= std_logic_vector(to_unsigned(5+k*8,32));    
                
        NMC_3_NMEM_DIN(31 downto 28)  <= NPADDRDATA   ;
        NMC_2_NMEM_DIN(27 downto 26)  <= (others=>'0')   ;
        NMC_3_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(768+44,10))   ;
        NMC_3_NMEM_DIN(15 downto  0)  <= X"0000"    ;
        NMC_3_NMEM_ADDR <= std_logic_vector(to_unsigned(5+k*8,32));    

        wait for CLKPERIOD; 
        
        NMC_0_NMEM_DIN(31 downto 28)  <= NPADDRDATA   ;
        NMC_0_NMEM_DIN(27 downto 26)  <= (others=>'0')   ;
        NMC_0_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(768+46,10))   ;
        NMC_0_NMEM_DIN(15 downto  0)  <= X"0000" ;
        NMC_0_NMEM_ADDR <= std_logic_vector(to_unsigned(6+k*8,32));
                
        NMC_1_NMEM_DIN(31 downto 28)  <= NPADDRDATA   ;
        NMC_1_NMEM_DIN(27 downto 26)  <= (others=>'0')   ;
        NMC_1_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(768+46,10))   ;
        NMC_1_NMEM_DIN(15 downto  0)  <= X"0000";
        NMC_1_NMEM_ADDR <= std_logic_vector(to_unsigned(6+k*8,32));
                
        NMC_2_NMEM_DIN(31 downto 28)  <= NPADDRDATA   ;
        NMC_2_NMEM_DIN(27 downto 26)  <= (others=>'0')   ;
        NMC_2_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(768+46,10))   ;
        NMC_2_NMEM_DIN(15 downto  0)  <= X"0000";
        NMC_2_NMEM_ADDR <= std_logic_vector(to_unsigned(6+k*8,32));
                
        NMC_3_NMEM_DIN(31 downto 28)  <= NPADDRDATA   ;
        NMC_3_NMEM_DIN(27 downto 26)  <= (others=>'0')   ;
        NMC_3_NMEM_DIN(25 downto 16)  <= std_logic_vector(to_unsigned(768+46,10))   ;
        NMC_3_NMEM_DIN(15 downto  0)  <= X"0000";
        NMC_3_NMEM_ADDR <= std_logic_vector(to_unsigned(6+k*8,32));
    
        wait for CLKPERIOD;  
        
        NMC_0_NMEM_DIN(31 downto 28)  <= ENDFLOW      ;
        NMC_0_NMEM_DIN(27 downto 16)  <= (others=>'0')      ;
        NMC_0_NMEM_DIN(15 downto  0)  <= X"0001"      ;
        NMC_0_NMEM_ADDR <= std_logic_vector(to_unsigned(7+k*8,32));
                
        NMC_1_NMEM_DIN(31 downto 28)  <= ENDFLOW      ;
        NMC_1_NMEM_DIN(27 downto 16)  <= (others=>'0')      ;
        NMC_1_NMEM_DIN(15 downto  0)  <= X"0001"      ;
        NMC_1_NMEM_ADDR <= std_logic_vector(to_unsigned(7+k*8,32));
                
        NMC_2_NMEM_DIN(31 downto 28)  <= ENDFLOW      ;
        NMC_2_NMEM_DIN(27 downto 16)  <= (others=>'0')      ;
        NMC_2_NMEM_DIN(15 downto  0)  <= X"0001"      ;
        NMC_2_NMEM_ADDR <= std_logic_vector(to_unsigned(7+k*8,32));
                
        NMC_3_NMEM_DIN(31 downto 28)  <= ENDFLOW      ;
        NMC_3_NMEM_DIN(27 downto 16)  <= (others=>'0')      ;
        NMC_3_NMEM_DIN(15 downto  0)  <= X"0001"      ;
        NMC_3_NMEM_ADDR <= std_logic_vector(to_unsigned(7+k*8,32));
        
        wait for CLKPERIOD; 
        
    end loop;
        
        NMC_0_NMEM_ADDR  <= std_logic_vector(to_unsigned(255,32));
        NMC_0_NMEM_DIN(31 downto 28) <= ENDFLOW;
        NMC_0_NMEM_DIN(27 downto 16) <= (others=>'0');
        NMC_0_NMEM_DIN(15  downto 0) <= X"0002";

        NMC_1_NMEM_ADDR  <= std_logic_vector(to_unsigned(255,32));
        NMC_1_NMEM_DIN(31 downto 28) <= ENDFLOW;
        NMC_1_NMEM_DIN(27 downto 16) <= (others=>'0');
        NMC_1_NMEM_DIN(15  downto 0) <= X"0002";
            
        NMC_2_NMEM_ADDR  <= std_logic_vector(to_unsigned(255,32));
        NMC_2_NMEM_DIN(31 downto 28) <= ENDFLOW;
        NMC_2_NMEM_DIN(27 downto 16) <= (others=>'0');
        NMC_2_NMEM_DIN(15  downto 0) <= X"0002";
        
        NMC_3_NMEM_ADDR  <= std_logic_vector(to_unsigned(255,32));
        NMC_3_NMEM_DIN(31 downto 28) <= ENDFLOW;
        NMC_3_NMEM_DIN(27 downto 16) <= (others=>'0');
        NMC_3_NMEM_DIN(15  downto 0) <= X"0002";
        wait for CLKPERIOD;
        
        NMC_0_NMEM_ADDR  <= std_logic_vector(to_unsigned(256,32));
        NMC_0_NMEM_DIN(31 downto 28) <= ENDFLOW;
        NMC_0_NMEM_DIN(27 downto 16) <= (others=>'0');
        NMC_0_NMEM_DIN(15  downto 0) <= X"0003";

        NMC_1_NMEM_ADDR  <= std_logic_vector(to_unsigned(256,32));
        NMC_1_NMEM_DIN(31 downto 28) <= ENDFLOW;
        NMC_1_NMEM_DIN(27 downto 16) <= (others=>'0');
        NMC_1_NMEM_DIN(15  downto 0) <= X"0003";
            
        NMC_2_NMEM_ADDR  <= std_logic_vector(to_unsigned(256,32));
        NMC_2_NMEM_DIN(31 downto 28) <= ENDFLOW;
        NMC_2_NMEM_DIN(27 downto 16) <= (others=>'0');
        NMC_2_NMEM_DIN(15  downto 0) <= X"0003";
        
        NMC_3_NMEM_ADDR  <= std_logic_vector(to_unsigned(256,32));
        NMC_3_NMEM_DIN(31 downto 28) <= ENDFLOW;
        NMC_3_NMEM_DIN(27 downto 16) <= (others=>'0');
        NMC_3_NMEM_DIN(15  downto 0) <= X"0003";
        wait for CLKPERIOD;
        
        NMC_0_EN         <= '0';
        NMC_0_WREN       <= '0';
        NMC_1_EN         <= '0';
        NMC_1_WREN       <= '0';
        NMC_2_EN         <= '0';
        NMC_2_WREN       <= '0';
        NMC_3_EN         <= '0';
        NMC_3_WREN       <= '0';
        
        
     wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
  
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
    
      
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
    
      
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
    
      
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
    
      
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
      
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
    
      
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000";
    
    
      
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
    
        wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     

    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';
      
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';
    
    wait until EVENT_ACCEPT = '1';  
             
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';    
    
    wait until EVENT_ACCEPT = '1';      
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  

    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';      
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';   
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';              
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';       
    
    wait until EVENT_ACCEPT = '1'; 
     
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';     
    
    wait until EVENT_ACCEPT = '1';  
    
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '1';  
    wait for CLKPERIOD;
    SPIKEVECTOR_IN     <= (others=>'0'); 
    SPIKEVECTOR_VLD_IN <= '0';         
    
               
    wait until TIMESTEP_UPDATE = B"1111";  
                         
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "1111";
    
    wait for CLKPERIOD;

    NEW_TIMESTEP <= "0000" ;
 
   
    wait for 10 us;  
                     
   assert false report "Test: OK" severity failure;


end process;

DUT: EXPANDABLE_SPIKE_PROCESSOR 
    Generic Map(
            CROSSBAR_ROW_WIDTH => CROSSBAR_ROW_WIDTH ,
            SYNAPSE_MEM_DEPTH  => SYNAPSE_MEM_DEPTH  ,
            NEURAL_MEM_DEPTH   => NEURAL_MEM_DEPTH   
            )
    Port Map ( 
            RST                               => RST                ,
            CLK                               => CLK                ,
            NEW_TIMESTEP                      => NEW_TIMESTEP       ,
            TIMESTEP_UPDATE                   => TIMESTEP_UPDATE    ,
            SPIKEVECTOR_IN                    => SPIKEVECTOR_IN     ,
            SPIKEVECTOR_VLD_IN                => SPIKEVECTOR_VLD_IN ,
            SPIKEVECTOR_OUT                   => SPIKEVECTOR_OUT    ,
            SPIKEVECTOR_VLD_OUT               => SPIKEVECTOR_VLD_OUT,
            -- SPIKE SOURCE
            MAIN_SPIKE_BUFFER                 => MAIN_SPIKE_BUFFER        ,
            AUXILLARY_SPIKE_BUFFER            => AUXILLARY_SPIKE_BUFFER   ,
            -- EVENT ACCEPTANCE
            EVENT_ACCEPT                      => EVENT_ACCEPT   ,
            -- STREAMING INTERFACES (RAM - NOT FIFO)
            SYNAPSE_ROUTE                     => SYNAPSE_ROUTE        ,            
            -- SYNAPTIC MEMORY                   
            SYNAPTIC_MEM_0_DIN                => SYNAPTIC_MEM_0_DIN   ,            
            SYNAPTIC_MEM_0_DADDR              => SYNAPTIC_MEM_0_DADDR ,            
            SYNAPTIC_MEM_0_EN                 => SYNAPTIC_MEM_0_EN    ,            
            SYNAPTIC_MEM_0_WREN               => SYNAPTIC_MEM_0_WREN  ,            
            SYNAPTIC_MEM_0_RDEN               => SYNAPTIC_MEM_0_RDEN  ,            
            SYNAPTIC_MEM_0_DOUT               => SYNAPTIC_MEM_0_DOUT  ,            
            -- SYNAPTIC MEMORY                      
            SYNAPTIC_MEM_1_DIN                => SYNAPTIC_MEM_1_DIN   ,            
            SYNAPTIC_MEM_1_DADDR              => SYNAPTIC_MEM_1_DADDR ,            
            SYNAPTIC_MEM_1_EN                 => SYNAPTIC_MEM_1_EN    ,            
            SYNAPTIC_MEM_1_WREN               => SYNAPTIC_MEM_1_WREN  ,            
            SYNAPTIC_MEM_1_RDEN               => SYNAPTIC_MEM_1_RDEN  ,            
            SYNAPTIC_MEM_1_DOUT               => SYNAPTIC_MEM_1_DOUT  ,            
            -- SYNAPTIC MEMORY                      
            SYNAPTIC_MEM_2_DIN                => SYNAPTIC_MEM_2_DIN   ,            
            SYNAPTIC_MEM_2_DADDR              => SYNAPTIC_MEM_2_DADDR ,            
            SYNAPTIC_MEM_2_EN                 => SYNAPTIC_MEM_2_EN    ,            
            SYNAPTIC_MEM_2_WREN               => SYNAPTIC_MEM_2_WREN  ,            
            SYNAPTIC_MEM_2_RDEN               => SYNAPTIC_MEM_2_RDEN  ,            
            SYNAPTIC_MEM_2_DOUT               => SYNAPTIC_MEM_2_DOUT  ,            
            -- SYNAPTIC MEMORY                 
            SYNAPTIC_MEM_3_DIN                => SYNAPTIC_MEM_3_DIN   ,            
            SYNAPTIC_MEM_3_DADDR              => SYNAPTIC_MEM_3_DADDR ,            
            SYNAPTIC_MEM_3_EN                 => SYNAPTIC_MEM_3_EN    ,            
            SYNAPTIC_MEM_3_WREN               => SYNAPTIC_MEM_3_WREN  ,            
            SYNAPTIC_MEM_3_RDEN               => SYNAPTIC_MEM_3_RDEN  ,            
            SYNAPTIC_MEM_3_DOUT               => SYNAPTIC_MEM_3_DOUT  ,            
            -- NMC REGS
            NMC_XNEVER_BASE                   => NMC_XNEVER_BASE,
            NMC_XNEVER_HIGH                   => NMC_XNEVER_HIGH,
            -- NMC STATUS REGS
            NMC0_MATH_ERROR                   =>  NMC0_MATH_ERROR         ,
            NMC0_MEMORY_VIOLATION             =>  NMC0_MEMORY_VIOLATION   ,
            NMC1_MATH_ERROR                   =>  NMC1_MATH_ERROR         ,
            NMC1_MEMORY_VIOLATION             =>  NMC1_MEMORY_VIOLATION   ,
            NMC2_MATH_ERROR                   =>  NMC2_MATH_ERROR         ,
            NMC2_MEMORY_VIOLATION             =>  NMC2_MEMORY_VIOLATION   ,
            NMC3_MATH_ERROR                   =>  NMC3_MATH_ERROR         ,
            NMC3_MEMORY_VIOLATION             =>  NMC3_MEMORY_VIOLATION   ,            
            -- NMC PROGRAMMING INTERFACES
            NMC_PMODE_SWITCH                  => NMC_PMODE_SWITCH ,
            -- NMC 0
            NMC_NPARAM_DATA                    => NMC_NPARAM_DATA          ,
            NMC_NPARAM_ADDR                    => NMC_NPARAM_ADDR          ,
            NMC_PROG_MEM_PORTA_EN              => NMC_PROG_MEM_PORTA_EN    ,
            NMC_PROG_MEM_PORTA_WEN             => NMC_PROG_MEM_PORTA_WEN   ,
            -- NMC SPIKE OUTPUTS
            NMC_0_NMODEL_SPIKE_OUT            => NMC_0_NMODEL_SPIKE_OUT  , 
            NMC_0_NMODEL_SPIKE_VLD            => NMC_0_NMODEL_SPIKE_VLD  ,   
            NMC_1_NMODEL_SPIKE_OUT            => NMC_1_NMODEL_SPIKE_OUT  , 
            NMC_1_NMODEL_SPIKE_VLD            => NMC_1_NMODEL_SPIKE_VLD  ,  
            NMC_2_NMODEL_SPIKE_OUT            => NMC_2_NMODEL_SPIKE_OUT  , 
            NMC_2_NMODEL_SPIKE_VLD            => NMC_2_NMODEL_SPIKE_VLD  ,  
            NMC_3_NMODEL_SPIKE_OUT            => NMC_3_NMODEL_SPIKE_OUT  , 
            NMC_3_NMODEL_SPIKE_VLD            => NMC_3_NMODEL_SPIKE_VLD  ,  
            NMC_0_W_AUX_BUFFER                => NMC_0_W_AUX_BUFFER      ,
            NMC_0_W_OUT_BUFFER                => NMC_0_W_OUT_BUFFER      ,
            NMC_1_W_AUX_BUFFER                => NMC_1_W_AUX_BUFFER      ,
            NMC_1_W_OUT_BUFFER                => NMC_1_W_OUT_BUFFER      ,
            NMC_2_W_AUX_BUFFER                => NMC_2_W_AUX_BUFFER      ,
            NMC_2_W_OUT_BUFFER                => NMC_2_W_OUT_BUFFER      ,
            NMC_3_W_AUX_BUFFER                => NMC_3_W_AUX_BUFFER      ,
            NMC_3_W_OUT_BUFFER                => NMC_3_W_OUT_BUFFER      ,
            LEARN_LUT_DIN                     => LEARN_LUT_DIN           ,
            LEARN_LUT_ADDR                    => LEARN_LUT_ADDR          ,
            LEARN_LUT_EN                      => LEARN_LUT_EN            ,    
            -- NEURAL MEMORY INTERFACES
            NMC_0_NMEM_ADDR                   => NMC_0_NMEM_ADDR          ,
            NMC_0_NMEM_DIN                    => NMC_0_NMEM_DIN           ,
            NMC_0_NMEM_DOUT                   => NMC_0_NMEM_DOUT          ,
            NMC_0_EN                          => NMC_0_EN                 ,
            NMC_0_WREN                        => NMC_0_WREN               ,
            NMC_0_RST                         => NMC_0_RST                ,
            NMC_1_NMEM_ADDR                   => NMC_1_NMEM_ADDR          ,
            NMC_1_NMEM_DIN                    => NMC_1_NMEM_DIN           ,
            NMC_1_NMEM_DOUT                   => NMC_1_NMEM_DOUT          ,
            NMC_1_EN                          => NMC_1_EN                 ,
            NMC_1_WREN                        => NMC_1_WREN               ,
            NMC_1_RST                         => NMC_1_RST                ,
            NMC_2_NMEM_ADDR                   => NMC_2_NMEM_ADDR          ,
            NMC_2_NMEM_DIN                    => NMC_2_NMEM_DIN           ,
            NMC_2_NMEM_DOUT                   => NMC_2_NMEM_DOUT          ,
            NMC_2_EN                          => NMC_2_EN                 ,
            NMC_2_WREN                        => NMC_2_WREN               ,
            NMC_2_RST                         => NMC_2_RST                ,
            NMC_3_NMEM_ADDR                   => NMC_3_NMEM_ADDR          ,
            NMC_3_NMEM_DIN                    => NMC_3_NMEM_DIN           ,
            NMC_3_NMEM_DOUT                   => NMC_3_NMEM_DOUT          ,
            NMC_3_EN                          => NMC_3_EN                 ,
            NMC_3_WREN                        => NMC_3_WREN               ,
            NMC_3_RST                         => NMC_3_RST           
        );
end your_love;
