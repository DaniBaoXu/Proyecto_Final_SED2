----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2024 16:04:53
-- Design Name: 
-- Module Name: Sincro_VGA - Behavioral
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

entity Sincro_VGA is
    Port ( --Entrada : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           fila : out STD_LOGIC_VECTOR (9 downto 0);
           col : out STD_LOGIC_VECTOR (9 downto 0);
           visible : out STD_LOGIC;
           vsinc : out STD_LOGIC;
           hsinc : out STD_LOGIC);
end Sincro_VGA;

architecture Behavioral of Sincro_VGA is

    signal cuenta_columna : unsigned (9 downto 0);
    signal ultima_columna: std_logic;                
    constant fin_columna : natural := 799;   
    
    signal cuenta_filas : unsigned (9 downto 0);
    signal ultima_filas: std_logic;             
    constant fin_filas : natural := 524;        
                 
begin

    Conta_Columnas: Process (reset, clk)                        
    begin                                                      
        if reset = '1' then                                    
            cuenta_columna <= (others => '0');                 
        elsif clk'event and clk = '1' then                     
            --if Entrada = '1' then                           
                if ultima_columna = '1' then                      
                    cuenta_columna <= (others => '0');         
                else                                           
                    cuenta_columna <= cuenta_columna+1;        
                end if;                                        
            --end if;                                            
        end if;                                                
    end process;                                               
    ultima_columna <= '1' when cuenta_columna = fin_columna else '0';
    col <= std_logic_vector(cuenta_columna);
    
    Conta_Filas: Process (reset, clk)                             
    begin                                                            
        if reset = '1' then                                          
            cuenta_filas <= (others => '0');                       
        elsif clk'event and clk = '1' then                           
            if ultima_columna  = '1' then                                    
                if ultima_filas = '1' then                         
                    cuenta_filas <= (others => '0');               
                else                                                 
                    cuenta_filas <= cuenta_filas+1;              
                end if;                                              
            end if;                                                  
        end if;                                                      
    end process;                                                     
    ultima_filas <= '1' when cuenta_filas = fin_filas else '0';
    fila <= std_logic_vector(cuenta_filas);
    
    hsinc <= '1' when cuenta_columna < 656 or cuenta_columna > 751  else '0';
    vsinc <= '1' when cuenta_filas < 489 or cuenta_filas > 491  else '0'; 
    visible <= '1' when cuenta_columna <= 639 and cuenta_filas <= 479 else '0';
                                       
end Behavioral;
