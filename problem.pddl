(define (problem problema1)
 (:domain procesar-enviar-contenedores)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; Se define tren de tipo transporte
 ; Se define todas las localizaciones (puerto ciudad fabrica1 fabrica2 almacen)
 ; Se define los 8 contenedores (c1 c2 c3 c4 c5 c6 c7 c8)
 ; Se definen todos los espacios que representaran la capacidad para contenedores
 ; tanto en transporte como en localizaciones (Por ejemplo, si el tren tiene
 ; capacidad para 4 contenedores, se define espacio_1_tren espacio_2_tren 
 ; espacio_3_tren y espacio_4_tren). Si fabrica2 tiene capacidad para 1 contenedor
 ; se define unicamente espacio_1_fabrica2
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (:objects 
     tren - transporte 
     puerto ciudad fabrica1 fabrica2 almacen - localizacion
     c1 c2 c3 c4 c5 c6 c7 c8 - contenedor
     espacio_1_tren espacio_2_tren espacio_3_tren espacio_4_tren
     espacio_1_puerto espacio_2_puerto espacio_3_puerto espacio_4_puerto
     espacio_5_puerto espacio_6_puerto espacio_7_puerto espacio_8_puerto
     espacio_1_fabrica1 espacio_2_fabrica1 espacio_3_fabrica1 espacio_1_fabrica2
     espacio_1_almacen espacio_2_almacen espacio_3_almacen - espacio
 )
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; Con "(conectado x y)" se inicializa todo el circuito descrito en la practica, 
 ; formado por puerto - ciudad - fabrica2 - fabrica1 - almacen (todos conectados de ida y vuelta)
 ; Con "(en obj x) se indica la posicion inicial del tren
 ; Como el tren solo puede descargar en algunas localizaciones se especifica que
 ; localizaciones aceptarn descargas con "(acepta_descargas x)"
 ; Tambien se especifica las localizaciones que son fabricas y tienes la capacidad
 ; de procesar contenedores con "(es_fabrica x)" y las localizaciones que son almacenes 
 ; y tienen las capacidad de enviar los contenedores a su destino final "(es_almacen x)"
 ; Se definen todos los espacios donde se puede colocar un contenedor. Estos espacios estan
 ; asociados a un transporte o localizacion con "(espacio_en veh/x esp)" y define la capacidad
 ; de veh (transporte) o x (localizacion)
 ; El estado de estos espacios (si esta vacio u ocupado) se define con "(espacio_contiene esp c)"
 ; indicando si contiene un contenedor o esta vacio ("vacio" es una constante de tipo container
 ; utilizada para indicar la ausencia de contenedor)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (:init
    (conectado puerto ciudad) (conectado ciudad puerto)
    (conectado ciudad fabrica2) (conectado fabrica2 ciudad)
    (conectado fabrica2 fabrica1) (conectado fabrica1 fabrica2) 
    (conectado fabrica1 almacen) (conectado almacen fabrica1)
    (conectado almacen puerto) (conectado puerto almacen)
    (en tren puerto)
    (acepta_descargas fabrica1)   
    (acepta_descargas fabrica2)
    (acepta_descargas almacen)
    (es_fabrica fabrica1) (es_fabrica fabrica2)
    (es_almacen almacen)
    (espacio_en puerto espacio_1_puerto)
    (espacio_en puerto espacio_2_puerto)
    (espacio_en puerto espacio_3_puerto)
    (espacio_en puerto espacio_4_puerto)
    (espacio_en puerto espacio_5_puerto)
    (espacio_en puerto espacio_6_puerto)
    (espacio_en puerto espacio_7_puerto)
    (espacio_en puerto espacio_8_puerto)
    (espacio_contiene espacio_1_puerto c1)
    (espacio_contiene espacio_2_puerto c2)
    (espacio_contiene espacio_3_puerto c3)
    (espacio_contiene espacio_4_puerto c4)
    (espacio_contiene espacio_5_puerto c5)
    (espacio_contiene espacio_6_puerto c6)
    (espacio_contiene espacio_7_puerto c7)
    (espacio_contiene espacio_8_puerto c8)
    (espacio_en tren espacio_1_tren)
    (espacio_en tren espacio_2_tren)
    (espacio_en tren espacio_3_tren)
    (espacio_en tren espacio_4_tren)
    (espacio_contiene espacio_1_tren vacio)
    (espacio_contiene espacio_2_tren vacio)
    (espacio_contiene espacio_3_tren vacio)
    (espacio_contiene espacio_4_tren vacio)
    (espacio_en fabrica1 espacio_1_fabrica1)
    (espacio_en fabrica1 espacio_2_fabrica1)
    (espacio_en fabrica1 espacio_3_fabrica1)
    (espacio_contiene espacio_1_fabrica1 vacio)
    (espacio_contiene espacio_2_fabrica1 vacio)
    (espacio_contiene espacio_3_fabrica1 vacio)
    (espacio_en fabrica2 espacio_1_fabrica2)
    (espacio_contiene espacio_1_fabrica2 vacio)
    (espacio_en almacen espacio_1_almacen)
    (espacio_en almacen espacio_2_almacen)
    (espacio_en almacen espacio_3_almacen)
    (espacio_contiene espacio_1_almacen vacio)
    (espacio_contiene espacio_2_almacen vacio)
    (espacio_contiene espacio_3_almacen vacio) 
 )
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; El goal u objetivo de este problema es que todos los contenedores sean transportados
 ; hasta las fabricas para procesarse y, finalmente, llevarse a un almacen para enviarse 
 ; a su destino final
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 (:goal (and 
     (esta_enviado c1)
     (esta_enviado c2)
     (esta_enviado c3)
     (esta_enviado c4)
     (esta_enviado c5)
     (esta_enviado c6)
     (esta_enviado c7)
     (esta_enviado c8)
 ))
)