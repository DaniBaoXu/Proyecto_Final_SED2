--------------------------------------------------------------------------------
-- Felipe Machado Sanchez
-- Departameto de Tecnologia Electronica
-- Universidad Rey Juan Carlos
-- http://gtebim.es/~fmachado
--
-- Pinta barras para la XUPV2P

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pinta_barras is
  Port (
    -- In ports
    visible        : in std_logic;
    col            : in unsigned(10-1 downto 0);
    fila           : in unsigned(10-1 downto 0);
    col_cuadrado   : in unsigned(5 downto 0);
    fila_cuadrado  : in unsigned(5 downto 0);
    col_fantasma   : in unsigned(5 downto 0);
    fila_fantasma  : in unsigned(5 downto 0);
    Dato_memo      : in std_logic_vector(15 downto 0);
    Dato_memo_pista: in std_logic_vector(32-1 downto 0);
    -- Out ports
    rojo              : out std_logic_vector(8-1 downto 0);
    verde             : out std_logic_vector(8-1 downto 0);
    azul              : out std_logic_vector(8-1 downto 0);
    address_memo_pista: out std_logic_vector(5-1 downto 0);
    address_memo      : out std_logic_vector(7 downto 0)
  );
end pinta_barras;

architecture behavioral of pinta_barras is

  signal col_lineas     : std_logic_vector(3 downto 0);
  signal fila_lineas    : std_logic_vector(3 downto 0);
  
  signal direccion_memo : std_logic_vector(3 downto 0) := "0011";
  signal direccion_fantasma : std_logic_vector(3 downto 0) := "0100";
  
  signal pinta_personaje: std_logic;
  signal pinta_personaje_traspuesta: std_logic;
  signal pinta_pista: std_logic;
  
  signal fantasma: std_logic_vector(7 downto 0);
  signal PACMAN_IZQ: std_logic_vector(7 downto 0);
  signal PACMAN_DER: std_logic_vector(7 downto 0);
  signal PACMAN_ARRIBA: std_logic_vector(7 downto 0);
  signal PACMAN_ABAJO: std_logic_vector(7 downto 0);
  signal PISTA: std_logic_vector(4 downto 0);
  
begin
  --Guardamos los cuatro bits menos significativos de filas y columnas para pintar las cuadriculas
  col_lineas <= std_logic_vector(col(3 downto 0));
  fila_lineas <= std_logic_vector(fila(3 downto 0));
  
  --Personajes:
  --PACMAN
  PACMAN_IZQ <= direccion_memo & std_logic_vector(fila(3 downto 0));
  PACMAN_DER <= direccion_memo & not(std_logic_vector(fila(3 downto 0)));
  PACMAN_ARRIBA <= direccion_memo & std_logic_vector(col(3 downto 0));
  PACMAN_ABAJO <= direccion_memo & not(std_logic_vector(col(3 downto 0)));
  --FANTASMA 
  fantasma <= direccion_fantasma & std_logic_vector(fila(3 downto 0));
  --MUX para pintar los diferentes personajes  
  pinta_personaje <= Dato_memo(TO_INTEGER(col(3 downto 0)));
  pinta_personaje_traspuesta <= Dato_memo(TO_INTEGER(fila(3 downto 0)));
    
  --Pista
  PISTA <= std_logic_vector(fila(8 downto 4));
  address_memo_pista <= PISTA;
  --MUX para pintar la pista
  pinta_pista <= Dato_memo_pista(TO_INTEGER(col(8 downto 4)));
    
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
        elsif pinta_pista = '0' then
            rojo   <= (others=>'1');
            verde  <= (others=>'0');
            azul   <= (others=>'0');
        elsif pinta_pista = '1' then     
            rojo   <= (others=>'0');     
            verde  <= (others=>'1');     
            azul   <= (others=>'0');
        end if;
        --PINTAMOS PACMAN Y FANTASMA                           
        if col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
            if col = col - 1 then
                address_memo <= PACMAN_IZQ;
                if pinta_personaje = '0' then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');
                elsif pinta_personaje = '1' and pinta_pista = '0' then  
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif pinta_personaje = '1' and pinta_pista = '1' then  
                    rojo   <= (others=>'0');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');         
                end if;
            end if;
        elsif col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
            if col = col + 1 then
                address_memo <= PACMAN_DER;
                if pinta_personaje = '0' then
                    rojo   <= (others=>'1');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');
                elsif pinta_personaje = '1' and pinta_pista = '0' then  
                    rojo   <= (others=>'1');
                    verde  <= (others=>'0');
                    azul   <= (others=>'0');
                elsif pinta_personaje = '1' and pinta_pista = '1' then  
                    rojo   <= (others=>'0');
                    verde  <= (others=>'1');
                    azul   <= (others=>'0');         
                end if;
            end if;
        elsif col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
            if fila = fila - 1 then
               address_memo <= PACMAN_ARRIBA;
               if pinta_personaje_traspuesta = '0' then
                   rojo   <= (others=>'1');
                   verde  <= (others=>'1');
                   azul   <= (others=>'0');
               elsif pinta_personaje_traspuesta = '1' and pinta_pista = '0' then  
                   rojo   <= (others=>'1');
                   verde  <= (others=>'0');
                   azul   <= (others=>'0');
               elsif pinta_personaje_traspuesta = '1' and pinta_pista = '1' then  
                   rojo   <= (others=>'0');
                   verde  <= (others=>'1');
                   azul   <= (others=>'0');         
               end if;
           end if;
        elsif col_cuadrado = col(9 downto 4) and fila_cuadrado = fila(9 downto 4) then
            if fila = fila + 1 then
               address_memo <= PACMAN_ABAJO;
               if pinta_personaje_traspuesta = '0' then
                   rojo   <= (others=>'1');
                   verde  <= (others=>'1');
                   azul   <= (others=>'0');
               elsif pinta_personaje_traspuesta = '1' and pinta_pista = '0' then  
                   rojo   <= (others=>'1');
                   verde  <= (others=>'0');
                   azul   <= (others=>'0');
               elsif pinta_personaje_traspuesta = '1' and pinta_pista = '1' then  
                   rojo   <= (others=>'0');
                   verde  <= (others=>'1');
                   azul   <= (others=>'0');         
               end if;
           end if;
        elsif col_fantasma = col(9 downto 4) and fila_fantasma = fila(9 downto 4) then
            address_memo <= fantasma; 
            if pinta_personaje = '0' then
                rojo   <= (others=>'1');
                verde  <= (others=>'0');
                azul   <= (others=>'1');
            elsif pinta_personaje = '1' and pinta_pista = '0' then  
                rojo   <= (others=>'1');
                verde  <= (others=>'0');
                azul   <= (others=>'0');
            elsif pinta_personaje = '1' and pinta_pista = '1' then  
                rojo   <= (others=>'0');
                verde  <= (others=>'1');
                azul   <= (others=>'0');                 
            end if;
        end if;
    end if;
  end process;
    
end Behavioral;

