----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2024 12:46:12
-- Design Name: 
-- Module Name: FSM_fantasma - Behavioral
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

entity FSM_fantasma is
    Port ( Clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           Salida_col : out STD_LOGIC_VECTOR (5 downto 0);
           Salida_filas : out STD_LOGIC_VECTOR (5 downto 0);
           Entrada_filas : in STD_LOGIC_VECTOR (5 downto 0);
           Entrada_col : in STD_LOGIC_VECTOR (5 downto 0));
end FSM_fantasma;

architecture Behavioral of FSM_fantasma is

    type Estados_Loading is (RIGHT_UP,RIGHT_DOWN,LEFT_DOWN,LEFT_UP);
    signal e_act,e_sig: Estados_Loading;
    signal col: unsigned(5 downto 0) := to_unsigned(20,6); 
    signal fila: unsigned(5 downto 0) := to_unsigned(7,6);
    
    signal pulsos : unsigned (22 downto 0);
    signal reloj_10Hz : std_logic;   
    constant fin_pulsos : natural := 2500000-1;
    
begin
    reloj: process(clk,RESET)          
    begin                              
        if reset = '1' then            
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

    P_SEQ_FSM: process (reset,clk)
    begin
        if reset = '1' then
            e_act <= RIGHT_UP;
        elsif clk'event and clk = '1' then
            if reloj_10Hz = '1' then
                e_act <= e_sig;
            end if;
        end if;  
    end process;
    
    P_COMB_FSM_tran: process (fila,col,e_act)
    begin
        case e_act is
            when RIGHT_UP =>        
            if fila = "000001" then
                e_sig <= RIGHT_DOWN;
            else
                e_sig <= RIGHT_UP;
            end if; 
            when RIGHT_DOWN =>
            if col = "011110" then
                e_sig <= LEFT_DOWN;
            else
                e_sig <= RIGHT_DOWN;
            end if;
            when LEFT_DOWN =>
            if fila = "011100" then
                e_sig <= LEFT_UP;                      
            else                                        
                e_sig <= LEFT_DOWN;                      
            end if;
            when LEFT_UP =>                          
            if col = "000001" then
                e_sig <= RIGHT_UP;                      
            else                                  
                e_sig <= LEFT_UP;                    
            end if;                               
        end case;                                        
    end process;
    
    P_COMB_FSM_out: process (clk, reset)
    begin                                            
        if reset = '1' then
            col <= to_unsigned(20,6);
            fila <=  to_unsigned(7,6);
        elsif rising_edge(Clk) then
            if reloj_10Hz = '1' then
                case e_act is                               
                    when RIGHT_UP => 
                    if en = '1' then                            
                        col <= col + 1;
                        fila <= fila - 1;
                    end if;                                                                                       
                    when RIGHT_DOWN =>
                    if en = '1' then 
                        col <= col + 1;                           
                        fila <= fila + 1;
                    end if;                                                                                             
                    when LEFT_DOWN =>
                    if en = '1' then                                                 
                        col <= col - 1;
                        fila <= fila + 1;
                    end if;                                              
                    when LEFT_UP =>
                    if en = '1' then 
                        col <= col - 1;                              
                        fila <= fila - 1;            
                    end if;                                                                                 
                end case;
            end if;
        end if;                                    
    end process;                                    
    
    Salida_col <= std_logic_vector(col);
    Salida_filas <= std_logic_vector(fila);
    
end Behavioral;
