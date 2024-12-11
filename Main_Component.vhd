----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2024 12:20:17
-- Design Name: 
-- Module Name: Main_Component - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main_Component is
    Port ( Reloj  : in STD_LOGIC;
           Reset  : in STD_LOGIC;
           en     : in std_logic;                      
           clk_p  : out std_logic;                    
           clk_n  : out std_logic;                    
           data_p : out std_logic_vector(2 downto 0);
           data_n : out std_logic_vector(2 downto 0);
           Selector_personaje: in std_logic;
           BTN0   : in STD_LOGIC;
           BTN1   : in STD_LOGIC;
           BTN2   : in STD_LOGIC;
           BTN3   : in STD_LOGIC); 
end Main_Component;

architecture Behavioral of Main_Component is
                                        
    signal clk0_o_s       : std_logic;                        
    signal clk1_o_s       : std_logic;                                                                    
    signal fila_s         : std_logic_vector(9 downto 0);     
    signal col_s          : std_logic_vector(9 downto 0);     
    signal visible_s      : std_logic;                    
    signal vsinc_s        : std_logic;                    
    signal hsinc_s        : std_logic;                    
    signal rojo_s         : std_logic_vector(8-1 downto 0); 
    signal verde_s        : std_logic_vector(8-1 downto 0);
    signal azul_s         : std_logic_vector(8-1 downto 0); 
    signal RGB            : std_logic_vector(23 downto 0);     
    signal clk_p_s        : std_logic;                     
    signal clk_n_s        : std_logic;                     
    signal data_p_s       : std_logic_vector(2 downto 0); 
    signal data_n_s       : std_logic_vector(2 downto 0);
    signal columna_s      : std_logic_vector(5 downto 0);
    signal filass_s       : std_logic_vector(5 downto 0);
    signal address_memo_pista_s: std_logic_vector(5-1 downto 0);
    signal address_memo_s : std_logic_vector(7 downto 0);
    signal datos_memoria  : std_logic_vector(15 downto 0);
    signal Dato_memo_pista_verde_s: std_logic_vector(32-1 downto 0);
    signal Dato_memo_pista_azul_s: std_logic_vector(32-1 downto 0);
    signal Salida_col_s   : STD_LOGIC_VECTOR(5 downto 0);  
    signal Salida_filas_s : STD_LOGIC_VECTOR(5 downto 0);
    signal Direccion_PACMAN_s : STD_LOGIC_VECTOR(3 downto 0);
    signal PACMAN_en_pista_s: std_logic;
    signal Dato_memo_red_s    : std_logic_vector(15 downto 0);
    signal Dato_memo_green_s  : std_logic_vector(15 downto 0);
    signal Dato_memo_blue_s   : std_logic_vector(15 downto 0);
    signal address_memo_RGB_s : std_logic_vector(8 downto 0);                  
    component Sincro_VGA is                                   
        Port ( Clk     : in STD_LOGIC;                            
               Reset   : in STD_LOGIC;                          
               fila    : out STD_LOGIC_VECTOR (9 downto 0);      
               col     : out STD_LOGIC_VECTOR (9 downto 0);       
               visible : out STD_LOGIC;                       
               vsinc   : out STD_LOGIC;                         
               hsinc   : out STD_LOGIC);                        
    end component;                                            
                                                              
    component Conta_40ns is                                   
        port ( clk_i   : in std_logic;            
               clk0_o  : out std_logic;         
               clk1_o  : out std_logic);                       
    end component;                                            
                                                              
    component pinta_barras is                                 
        Port (                                                                                         
          visible      : in std_logic;                        
          col          : in unsigned(10-1 downto 0);          
          fila         : in unsigned(10-1 downto 0);
          col_cuadrado : in unsigned(5 downto 0);
          fila_cuadrado: in unsigned(5 downto 0);
          col_fantasma : in unsigned(5 downto 0);
          fila_fantasma: in unsigned(5 downto 0);
          Dato_memo    : in std_logic_vector(15 downto 0);
          Dato_memo_pista_verde: in std_logic_vector(32-1 downto 0);
          Dato_memo_pista_azul: in std_logic_vector(32-1 downto 0);          
          Direccion_PACMAN: in std_logic_vector(3 downto 0);
          Selector_personaje    : in std_logic;
          Dato_memo_red    : in std_logic_vector(15 downto 0);
          Dato_memo_green  : in std_logic_vector(15 downto 0);
          Dato_memo_blue   : in std_logic_vector(15 downto 0);
           
          PACMAN_en_pista   : out std_logic;                             
          rojo         : out std_logic_vector(8-1 downto 0);  
          verde        : out std_logic_vector(8-1 downto 0);  
          azul         : out std_logic_vector(8-1 downto 0);
          address_memo_RGB  : out std_logic_vector(8 downto 0);
          address_memo_pista: out std_logic_vector(5-1 downto 0);
          address_memo : out std_logic_vector(7 downto 0)   
        );                                                    
    end component;
    
    component hdmi_rgb2tmds is                                   
        port(                                                     
            -- reset and clocks                                   
            rst : in std_logic;                                   
            pixelclock : in std_logic;  -- slow pixel clock 1x    
            serialclock : in std_logic; -- fast serial clock 5    
                                                                  
            -- video signals                                      
            video_data : in std_logic_vector(23 downto 0);        
            video_active  : in std_logic;                         
            hsync : in std_logic;                                 
            vsync : in std_logic;                                 
                                                                  
            -- tmds output ports                                                                              
            clk_p : out std_logic;                              
            clk_n : out std_logic;                              
            data_p : out std_logic_vector(2 downto 0);          
            data_n : out std_logic_vector(2 downto 0)           
        );                                                      
    end component;
    
    component Transiciones_PACMAN is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               BTN0 : in STD_LOGIC;
               BTN1 : in STD_LOGIC;
               BTN2 : in STD_LOGIC;
               BTN3 : in STD_LOGIC;
               PACMAN_en_pista : in std_logic;
               BOTON: out STD_LOGIC_VECTOR (3 downto 0);
               col : out STD_LOGIC_VECTOR (5 downto 0);
               fila : out STD_LOGIC_VECTOR (5 downto 0));
    end component;
    
    component ROM1b_1f_imagenes16_16x16_bn is
        port ( clk  : in  std_logic;   -- reloj
               addr : in  std_logic_vector(8-1 downto 0);
               dout : out std_logic_vector(16-1 downto 0)); 
    end component;
    
    component ROM1b_1f_green_racetrack_1 is 
        port ( clk  : in  std_logic;   -- reloj
               addr : in  std_logic_vector(5-1 downto 0);
               dout : out std_logic_vector(32-1 downto 0)); 
    end component;
    
    component ROM1b_1f_blue_racetrack_1 is 
        port ( clk  : in  std_logic;   -- reloj
               addr : in  std_logic_vector(5-1 downto 0);
               dout : out std_logic_vector(32-1 downto 0)); 
    end component;
    
    component FSM_fantasma is                                   
        Port ( Clk : in STD_LOGIC;                              
               en : in STD_LOGIC;                               
               reset : in STD_LOGIC;                            
               Salida_col : out STD_LOGIC_VECTOR (5 downto 0);  
               Salida_filas : out STD_LOGIC_VECTOR (5 downto 0);
               Entrada_filas : in STD_LOGIC_VECTOR (5 downto 0);
               Entrada_col : in STD_LOGIC_VECTOR (5 downto 0)); 
    end component;
    
    component ROM1b_1f_red_num32_play_sprite16x16 is
        port ( clk  : in  std_logic;   -- reloj
               addr : in  std_logic_vector(9-1 downto 0);
               dout : out std_logic_vector(16-1 downto 0)); 
    end component; 
    
    component ROM1b_1f_green_num32_play_sprite16x16 is
        port ( clk  : in  std_logic;   -- reloj
               addr : in  std_logic_vector(9-1 downto 0);
               dout : out std_logic_vector(16-1 downto 0)); 
    end component;
    
    component ROM1b_1f_blue_num32_play_sprite16x16 is
        port ( clk  : in  std_logic;   -- reloj
               addr : in  std_logic_vector(9-1 downto 0);
               dout : out std_logic_vector(16-1 downto 0)); 
    end component;                                               
              
begin
    U1: Conta_40ns            
    port map(                 
        clk_i  => Reloj,           
        clk0_o => clk0_o_s,       
        clk1_o => clk1_o_s        
    );                        
    U2: Sincro_VGA            
    port map(                 
        --Entrada => clk1_o_s,    
        Clk => clk1_o_s,          
        Reset => Reset,         
        fila => fila_s,           
        col => col_s,             
        visible => visible_s,     
        vsinc => vsinc_s,         
        hsinc => hsinc_s          
    );                        
    U3: pinta_barras          
    port map(                 
        visible => visible_s,     
        col => unsigned(col_s),
        col_cuadrado => unsigned(columna_s),
        fila_cuadrado => unsigned(filass_s),
        fila => unsigned(fila_s),
        col_fantasma => unsigned(salida_col_s),   
        fila_fantasma => unsigned(salida_filas_s),      
        address_memo => address_memo_s,
        address_memo_pista => address_memo_pista_s,
        Selector_personaje => Selector_personaje,
        Direccion_PACMAN => Direccion_PACMAN_s,
        PACMAN_en_pista => PACMAN_en_pista_s,
        Dato_memo_red => Dato_memo_red_s,  
        Dato_memo_green => Dato_memo_green_s,
        Dato_memo_blue => Dato_memo_blue_s,
        address_memo_RGB => address_memo_RGB_s, 
        rojo => Rojo_s,           
        verde => Verde_s,         
        azul => Azul_s,
        Dato_memo_pista_verde => Dato_memo_pista_verde_s,
        Dato_memo_pista_azul => Dato_memo_pista_azul_s,
        Dato_memo => datos_memoria            
    );
    U4: hdmi_rgb2tmds             
    port map(                     
        rst => Reset,           
        pixelclock => clk1_o_s,   
        serialclock => clk0_o_s,  
        video_data => RGB,        
        video_active => visible_s,
        hsync => hsinc_s,         
        vsync => vsinc_s,         
        clk_p => clk_p,  
        clk_n => clk_n, 
        data_p => data_p, 
        data_n => data_n 
    );
    U5: Transiciones_PACMAN
    port map(
        clk => clk1_o_s,
        rst => reset,
        BTN0 => BTN0,
        BTN1 => BTN1,
        BTN2 => BTN2,
        BTN3 => BTN3,
        PACMAN_en_pista => PACMAN_en_pista_s,
        BOTON => Direccion_PACMAN_s,
        col => columna_s,
        fila => filass_s          
     );
     U6: ROM1b_1f_imagenes16_16x16_bn
     port map(
        clk => clk1_o_s,
        addr => address_memo_s, 
        dout => datos_memoria
     );
     U7: FSM_fantasma                    
     port map(                           
        Clk => clk1_o_s,                
        en => en,                     
        reset => reset,               
        Salida_col => salida_col_s,     
        Salida_filas => salida_filas_s, 
        Entrada_filas => salida_filas_s,
        Entrada_col => salida_col_s     
     );
     U8: ROM1b_1f_green_racetrack_1 
     port map(
        clk => clk1_o_s,
        addr => address_memo_pista_s, 
        dout => Dato_memo_pista_verde_s       
     );
     U9: ROM1b_1f_blue_racetrack_1 
     port map(
        clk => clk1_o_s,
        addr => address_memo_pista_s, 
        dout => Dato_memo_pista_azul_s       
     );
     U10: ROM1b_1f_red_num32_play_sprite16x16
     port map(
        clk => clk1_o_s,
        addr => address_memo_RGB_s, 
        dout => Dato_memo_red_s
     );
     U11: ROM1b_1f_green_num32_play_sprite16x16
     port map(
        clk => clk1_o_s,
        addr => address_memo_RGB_s, 
        dout => Dato_memo_green_s
     );  
     U12: ROM1b_1f_blue_num32_play_sprite16x16
     port map(
        clk => clk1_o_s,
        addr => address_memo_RGB_s, 
        dout => Dato_memo_blue_s
     );                                   
     RGB <= Rojo_s & Verde_s & Azul_s;      
    
end Behavioral;
