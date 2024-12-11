----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2024 18:00:43
-- Design Name: 
-- Module Name: Transiciones_PACMAN - Behavioral
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

entity Transiciones_PACMAN is
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
end Transiciones_PACMAN;

architecture Behavioral of Transiciones_PACMAN is

    signal pulsos : unsigned (25 downto 0);
    signal pulsos2 : unsigned (25 downto 0);
    signal reloj_10Hz : std_logic;   
    constant fin_pulsos : natural := 2500000-1;
    signal reloj_2Hz : std_logic;   
    constant fin_pulsos2 : natural := 12500000-1;
    --signal cuenta: std_logic;
    signal columnas: unsigned (5 downto 0) := to_unsigned(24,6);
    signal filas: unsigned (5 downto 0) := to_unsigned(17,6);
    
    signal direccion_pacman: STD_LOGIC_VECTOR (3 downto 0); 
begin
    
    reloj: process(clk,rst)          
    begin                              
        if rst = '1' then            
            pulsos <= (others => '0');              
        elsif rising_edge(clk) then    
            if reloj_10Hz = '1' then     
                pulsos <= (others => '0');                 
            else                       
                pulsos <= pulsos+1;
            end if;                    
        end if;                        
    end process;
    reloj_10Hz <= '1' when pulsos = fin_pulsos else '0';                        
    
    reloj_500ms: process(clk,rst)          
    begin                              
        if rst = '1' then            
            pulsos2 <= (others => '0');              
        elsif rising_edge(clk) then    
            if reloj_2Hz = '1' then     
                pulsos2 <= (others => '0');                 
            else                       
                pulsos2 <= pulsos2+1;
            end if;                    
        end if;                        
    end process;
    reloj_2Hz <= '1' when pulsos2 = fin_pulsos2 else '0';
    
    cuenta_col_fila:process(clk,rst)
    begin
        if rst = '1' then             
            columnas <= to_unsigned(24,6);
            filas <= to_unsigned(24,6);
        elsif rising_edge(clk) then
            if PACMAN_en_pista= '1' then
                if reloj_10Hz = '1' then
                    if BTN0 = '1' then--DERECHA
                        if columnas = 31 then
                            columnas <= to_unsigned(31,6);
                        else
                            columnas <= columnas + 1;
                        end if;
                    elsif BTN1 = '1' then--IZQUIERDA
                        if columnas = 0 then
                            columnas <= to_unsigned(0,6);
                        else
                            columnas <= columnas - 1;
                        end if;
                    elsif BTN2 = '1' then--ARRIBA
                        if filas = 0 then
                            filas <= to_unsigned(0,6);
                        else
                        filas <= filas - 1;
                        end if;
                    elsif BTN3 = '1' then--ABAJO
                        if filas = 29 then
                            filas <= to_unsigned(29,6);
                        else
                            filas <= filas + 1;
                        end if;
                    end if;
                end if; 
            else 
            if reloj_2Hz = '1' then
               if BTN0 = '1' then--DERECHA
                   if columnas = 31 then
                       columnas <= to_unsigned(31,6);
                   else
                       columnas <= columnas + 1;
                   end if;
               elsif BTN1 = '1' then--IZQUIERDA
                   if columnas = 0 then
                       columnas <= to_unsigned(0,6);
                   else
                       columnas <= columnas - 1;
                   end if;
               elsif BTN2 = '1' then--ARRIBA
                   if filas = 0 then
                       filas <= to_unsigned(0,6);
                   else
                   filas <= filas - 1;
                   end if;
               elsif BTN3 = '1' then--ABAJO
                   if filas = 29 then
                       filas <= to_unsigned(29,6);
                   else
                       filas <= filas + 1;
                   end if;
               end if;
            end if; 
          end if;   
        end if;    
    end process;
    direccion_pacman <= BTN3 & BTN2 & BTN1 & BTN0;
    BOTON <= direccion_pacman;
    col <= std_logic_vector(columnas);
    fila <= std_logic_vector(filas); 
      
end Behavioral;
