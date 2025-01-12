--------------------------------------------------------------------------------
-- Felipe Machado Sanchez
-- Departameto de Tecnologia Electronica
-- Universidad Rey Juan Carlos
-- http://gtebim.es/~fmachado
--
-- Pinta barras para la XUPV2P
library xil_defaultlib;
use xil_defaultlib.racetrack_pkg.ALL;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.RACETRACK_PKG.ALL;

entity pinta_barras is
Port (-- In ports
      visible               : in std_logic;
      col                   : in unsigned(10-1 downto 0);
      fila                  : in unsigned(10-1 downto 0);
      col_cuadrado          : in unsigned(5 downto 0);
      fila_cuadrado         : in unsigned(5 downto 0);
      col_fantasma          : in unsigned(5 downto 0);
      fila_fantasma         : in unsigned(5 downto 0);
      Dato_memo             : in std_logic_vector(15 downto 0);
      Dato_memo_pista_verde : in std_logic_vector(32-1 downto 0);
      Dato_memo_pista_azul  : in std_logic_vector(32-1 downto 0);
      Direccion_PACMAN      : in std_logic_vector(3 downto 0);
      Selector_personaje    : in std_logic;
      Dato_memo_red         : in std_logic_vector(15 downto 0);
      Dato_memo_green       : in std_logic_vector(15 downto 0);
      Dato_memo_blue        : in std_logic_vector(15 downto 0);
      -- Out ports
      PACMAN_en_pista       : out std_logic;
      rojo                  : out std_logic_vector(8-1 downto 0);
      verde                 : out std_logic_vector(8-1 downto 0);
      azul                  : out std_logic_vector(8-1 downto 0);
      address_memo_RGB      : out std_logic_vector(8 downto 0);
      address_memo_pista    : out std_logic_vector(5-1 downto 0);
      address_memo          : out std_logic_vector(7 downto 0));
end pinta_barras;

architecture behavioral of pinta_barras is

  signal col_lineas     : std_logic_vector(3 downto 0);
  signal fila_lineas    : std_logic_vector(3 downto 0);
  
  signal direccion_memo     : std_logic_vector(3 downto 0) := "0011";
  signal direccion_fantasma : std_logic_vector(3 downto 0) := "0100";
  signal direccion_coche    : std_logic_vector(4 downto 0) := "11110";
  
  signal pinta_personaje            : std_logic;
  signal pinta_personaje_traspuesta : std_logic;
  signal pinta_pista_verde          : std_logic;
  signal pinta_pista_azul           : std_logic;
  signal pinta_coche_red            : std_logic;
  signal pinta_coche_green          : std_logic;
  signal pinta_coche_blue           : std_logic;
  signal pinta_coche_red_T          : std_logic;
  signal pinta_coche_green_T        : std_logic;
  signal pinta_coche_blue_T         : std_logic;
  
  signal fantasma         : std_logic_vector(7 downto 0);
  signal PACMAN_IZQ       : std_logic_vector(7 downto 0);
  signal PACMAN_DER       : std_logic;
  signal PACMAN_ARRIBA    : std_logic_vector(7 downto 0);
  signal PACMAN_ABAJO     : std_logic;
  signal COCHE            : std_logic_vector(8 downto 0);
  signal COCHE_DOWN       : std_logic_vector(8 downto 0);
  signal COCHE_LEFT       : std_logic_vector(8 downto 0);
  signal COCHE_RIGHT      : std_logic_vector(8 downto 0); 
  signal PISTA_1          : std_logic_vector(4 downto 0);
  signal pista_VB         : std_logic_vector(1 downto 0);
  signal coche_RGB        : std_logic_vector(2 downto 0);
  signal coche_RGB_T      : std_logic_vector(2 downto 0);
  
begin
  --Guardamos los cuatro bits menos significativos de filas y columnas para pintar las cuadriculas
  col_lineas <= std_logic_vector(col(3 downto 0));
  fila_lineas <= std_logic_vector(fila(3 downto 0));
  
  --Personajes:
  --PACMAN
  PACMAN_IZQ    <= direccion_memo & std_logic_vector(fila(3 downto 0));
  PACMAN_ARRIBA <= direccion_memo & std_logic_vector(col(3 downto 0));
  --MUX para pintar los diferentes personajes  
  pinta_personaje            <= Dato_memo(TO_INTEGER(col(3 downto 0)));
  PACMAN_DER                 <= Dato_memo(TO_INTEGER(not(col(3 downto 0))));
  pinta_personaje_traspuesta <= Dato_memo(TO_INTEGER(fila(3 downto 0)));
  PACMAN_ABAJO               <= Dato_memo(TO_INTEGER(not(fila(3 downto 0))));  
  --FANTASMA 
  fantasma <= direccion_fantasma & std_logic_vector(fila(3 downto 0));
  
  --COCHE
  COCHE               <= direccion_coche & std_logic_vector(fila(3 downto 0));
  COCHE_DOWN          <= direccion_coche & std_logic_vector(NOT(fila(3 downto 0)));
  COCHE_LEFT          <= direccion_coche & std_logic_vector(col(3 downto 0));
  COCHE_RIGHT         <= direccion_coche & std_logic_vector(NOT(col(3 downto 0)));
  pinta_coche_red     <= Dato_memo_red(TO_INTEGER(col(3 downto 0)));
  pinta_coche_green   <= Dato_memo_green(TO_INTEGER(col(3 downto 0)));
  pinta_coche_blue    <= Dato_memo_blue(TO_INTEGER(col(3 downto 0)));
  coche_RGB           <= pinta_coche_red & pinta_coche_green & pinta_coche_blue;
  pinta_coche_red_T   <= Dato_memo_red(TO_INTEGER(fila(3 downto 0)));
  pinta_coche_green_T <= Dato_memo_green(TO_INTEGER(fila(3 downto 0)));
  pinta_coche_blue_T  <= Dato_memo_blue(TO_INTEGER(fila(3 downto 0)));
  coche_RGB_T         <= pinta_coche_red_T & pinta_coche_green_T & pinta_coche_blue_T;
   
  --Pista
  PISTA_1            <= std_logic_vector(fila(8 downto 4));
  address_memo_pista <= PISTA_1;
  --MUX para pintar la pista
  pinta_pista_verde  <= Dato_memo_pista_verde(TO_INTEGER(col(8 downto 4)));
  pinta_pista_azul   <= Dato_memo_pista_azul(TO_INTEGER(col(8 downto 4)));
  pista_VB           <= pinta_pista_verde & pinta_pista_azul;
  
  --Posición PACMAN en pista
  PACMAN_en_pista <= pista(to_integer(fila_cuadrado))(to_integer(col_cuadrado));
  
  P_pinta: Process (visible, col, fila)
  begin
    rojo   <= (others=>'0');
    verde  <= (others=>'0');
    azul   <= (others=>'0');
    if visible = '1' then
        --Pintamos el borde de toda la pantalla en blanco
        if col = 0 OR col = 640-1 OR fila = 0 OR fila = 480-1 then
            rojo   <= (others=>'1');
            verde  <= (others=>'1');
            azul   <= (others=>'1');
        --Pintamos la parte derecha de la pantalla en negro
        elsif col > 512  then
            rojo   <= (others=>'0');
            verde  <= (others=>'0');
            azul   <= (others=>'0');  
        --Pintamos la cuadricula con lineas blancas
        elsif fila_lineas= "0000" or col_lineas = "0000" then 
            rojo   <= (others=>'1');
            verde  <= (others=>'1');
            azul   <= (others=>'1');
        --Pintamos la pista de color rojo y verde
        elsif pista_VB = "00" then
            rojo   <= (others=>'1');
            verde  <= (others=>'0');
            azul   <= (others=>'0');
        elsif pista_VB = "01" then     
            rojo   <= (others=>'0');     
            verde  <= (others=>'0');     
            azul   <= (others=>'1');
        elsif pista_VB = "10" then     
            rojo   <= (others=>'0');     
            verde  <= (others=>'1');     
            azul   <= (others=>'0');
        elsif pista_VB = "11" then     
            rojo   <= (others=>'1');     
            verde  <= (others=>'1');     
            azul   <= (others=>'1');
        end if;
        --PINTAMOS PACMAN Y FANTASMA
        if Selector_personaje = '1' then
        if direccion_PACMAN = "0000" then
            if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                address_memo_RGB <= COCHE;
                if coche_RGB = "000" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "001" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB = "010" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "011" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');
                elsif coche_RGB = "100" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');
                elsif coche_RGB = "110" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB = "101" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');    
                elsif coche_RGB = "111" and pista_VB = "00" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "111" and pista_VB = "01" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'0');     
                    azul   <= (others=>'1');
                elsif coche_RGB = "111" and pista_VB = "10" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'0');
                elsif coche_RGB = "111" and pista_VB = "11" then     
                    rojo   <= (others=>'1');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'1');              
                end if;
            end if;
        end if;
        if direccion_PACMAN = "0010" then
            if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                address_memo_RGB <= COCHE_LEFT;
                if coche_RGB_T = "000" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "001" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB_T = "010" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "011" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');
                elsif coche_RGB_T = "100" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "110" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB_T = "101" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');    
                elsif coche_RGB_T = "111" and pista_VB = "00" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "111" and pista_VB = "01" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'0');     
                    azul   <= (others=>'1');
                elsif coche_RGB_T = "111" and pista_VB = "10" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "111" and pista_VB = "11" then     
                    rojo   <= (others=>'1');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'1');              
                end if;
            end if;
        end if;
        if direccion_PACMAN = "0001" then
            if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                address_memo_RGB <= COCHE_RIGHT;
                if coche_RGB_T = "000" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "001" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB_T = "010" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "011" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');
                elsif coche_RGB_T = "100" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "110" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB_T = "101" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');    
                elsif coche_RGB_T = "111" and pista_VB = "00" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "111" and pista_VB = "01" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'0');     
                    azul   <= (others=>'1');
                elsif coche_RGB_T = "111" and pista_VB = "10" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'0');
                elsif coche_RGB_T = "111" and pista_VB = "11" then     
                    rojo   <= (others=>'1');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'1');              
                end if;
            end if;
        end if;
        if direccion_PACMAN = "0100" then
            if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                address_memo_RGB <= COCHE;
                if coche_RGB = "000" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "001" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB = "010" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "011" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');
                elsif coche_RGB = "100" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');
                elsif coche_RGB = "110" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB = "101" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');    
                elsif coche_RGB = "111" and pista_VB = "00" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "111" and pista_VB = "01" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'0');     
                    azul   <= (others=>'1');
                elsif coche_RGB = "111" and pista_VB = "10" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'0');
                elsif coche_RGB = "111" and pista_VB = "11" then     
                    rojo   <= (others=>'1');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'1');              
                end if;
            end if;
        end if;
        if direccion_PACMAN = "1000" then
            if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                address_memo_RGB <= COCHE_DOWN;
                if coche_RGB = "000" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "001" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB = "010" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "011" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');
                elsif coche_RGB = "100" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');
                elsif coche_RGB = "110" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'1');
                elsif coche_RGB = "101" then
                    rojo   <= (others=>'0');
                    verde  <= (others=>'0');
                    azul   <= (others=>'1');    
                elsif coche_RGB = "111" and pista_VB = "00" then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif coche_RGB = "111" and pista_VB = "01" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'0');     
                    azul   <= (others=>'1');
                elsif coche_RGB = "111" and pista_VB = "10" then     
                    rojo   <= (others=>'0');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'0');
                elsif coche_RGB = "111" and pista_VB = "11" then     
                    rojo   <= (others=>'1');     
                    verde  <= (others=>'1');     
                    azul   <= (others=>'1');              
                end if;
            end if;
        end if;
        else
            if direccion_PACMAN = "0000" then
                if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                    address_memo <= PACMAN_IZQ;
                    if pinta_personaje = '0' then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'1');
                        azul   <= (others=>'0');
                    elsif pinta_personaje = '1' and pista_VB = "00" then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'0');
                        azul   <= (others=>'0');
                    elsif pinta_personaje = '1' and pista_VB = "01" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'0');     
                        azul   <= (others=>'1');
                    elsif pinta_personaje = '1' and pista_VB = "10" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'0');
                    elsif pinta_personaje = '1' and pista_VB = "11" then     
                        rojo   <= (others=>'1');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'1');              
                    end if;
                end if;
            end if;
            if direccion_PACMAN = "0010" then
                if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                    address_memo <= PACMAN_IZQ;
                    if pinta_personaje = '0' then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'1');
                        azul   <= (others=>'0');
                    elsif pinta_personaje = '1' and pista_VB = "00" then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'0');
                        azul   <= (others=>'0');
                    elsif pinta_personaje = '1' and pista_VB = "01" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'0');     
                        azul   <= (others=>'1');
                    elsif pinta_personaje = '1' and pista_VB = "10" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'0');
                    elsif pinta_personaje = '1' and pista_VB = "11" then     
                        rojo   <= (others=>'1');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'1');              
                    end if;
                end if;
            end if;
            if direccion_PACMAN = "0001" then
                if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                    address_memo <= PACMAN_IZQ;
                    if PACMAN_DER = '0' then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'1');
                        azul   <= (others=>'0');
                    elsif PACMAN_DER = '1' and pista_VB = "00" then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'0');
                        azul   <= (others=>'0');
                    elsif PACMAN_DER = '1' and pista_VB = "01" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'0');     
                        azul   <= (others=>'1');
                    elsif PACMAN_DER = '1' and pista_VB = "10" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'0');
                    elsif PACMAN_DER = '1' and pista_VB = "11" then     
                        rojo   <= (others=>'1');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'1');              
                    end if;
                end if;
            end if;
            if direccion_PACMAN = "0100" then
                if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                    address_memo <= PACMAN_ARRIBA;
                    if pinta_personaje_traspuesta = '0' then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'1');
                        azul   <= (others=>'0');
                    elsif pinta_personaje_traspuesta = '1' and pista_VB = "00" then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'0');
                        azul   <= (others=>'0');
                    elsif pinta_personaje_traspuesta = '1' and pista_VB = "01" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'0');     
                        azul   <= (others=>'1');
                    elsif pinta_personaje_traspuesta = '1' and pista_VB = "10" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'0');
                    elsif pinta_personaje_traspuesta = '1' and pista_VB = "11" then     
                        rojo   <= (others=>'1');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'1');              
                    end if;
                end if;
            end if;
            if direccion_PACMAN = "1000" then
                if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
                    address_memo <= PACMAN_ARRIBA;
                    if PACMAN_ABAJO = '0' then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'1');
                        azul   <= (others=>'0');
                    elsif PACMAN_ABAJO = '1' and pista_VB = "00" then
                        rojo   <= (others=>'1');
                        verde  <= (others=>'0');
                        azul   <= (others=>'0');
                    elsif PACMAN_ABAJO = '1' and pista_VB = "01" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'0');     
                        azul   <= (others=>'1');
                    elsif PACMAN_ABAJO = '1' and pista_VB = "10" then     
                        rojo   <= (others=>'0');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'0');
                    elsif PACMAN_ABAJO = '1' and pista_VB = "11" then     
                        rojo   <= (others=>'1');     
                        verde  <= (others=>'1');     
                        azul   <= (others=>'1');              
                    end if;
                end if;
            end if;       
        end if;                              
        if col_fantasma = col(9 downto 4) and fila_fantasma = fila(9 downto 4) then
            address_memo <= fantasma; 
            if pinta_personaje = '0' then
                rojo   <= (others=>'1');
                verde  <= (others=>'0');
                azul   <= (others=>'1');
            elsif pinta_personaje = '1' and pista_VB = "00" then
                rojo   <= (others=>'1');
                verde  <= (others=>'0');
                azul   <= (others=>'0');
            elsif pinta_personaje = '1' and pista_VB = "01" then     
                rojo   <= (others=>'0');     
                verde  <= (others=>'0');     
                azul   <= (others=>'1');
            elsif pinta_personaje = '1' and pista_VB = "10" then     
                rojo   <= (others=>'0');     
                verde  <= (others=>'1');     
                azul   <= (others=>'0');
            elsif pinta_personaje = '1' and pista_VB = "11" then     
                rojo   <= (others=>'1');     
                verde  <= (others=>'1');     
                azul   <= (others=>'1');              
            end if;
        end if;
    end if;
  end process;   
end Behavioral;

