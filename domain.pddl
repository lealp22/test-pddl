(define (domain procesar-enviar-contenedores)
    (:requirements :strips :typing :equality :negative-preconditions)
    ; 
    ; Se define cuatro tipos de elementos:
    ; - transporte
    ; - localizacion
    ; - contenedor
    ; - espacio: Representa la capacidad de tener un contenedor
    ;
    (:types
        transporte
        localizacion
        contenedor
        espacio
    )
    ; 
    ; Contante de tipo contenedor utilizada para representar que un "espacio" esta disponible
    ;
    (:constants vacio - contenedor)
    ;
    ; Predicados
    ;
    (:predicates
       (conectado ?x - localizacion ?y - localizacion) ; Quiere decir que se puede mover de ?x a ?y
       (en ?veh - transporte ?x - localizacion) ; Quiere decir que ?x esta en ?y
       (acepta_descargas ?x - localizacion) ; Indica que es posible la accion "descargar" en una localizacion
       (es_fabrica ?x - localizacion) ; Indica que ?x es una fabrica y, por tanto, puede procesar
       (es_almacen ?x - localizacion) ; Indica que ?x es un almacen y, por tanto, puede enviar un container
       (esta_procesado ?c - contenedor) ; Indica que ?c esta procesado
       (esta_enviado ?c - contenedor) ; Indica que ?c esta enviado (ha completado el circuito)
       (espacio_en ?x ?e) ; Indica que ?x tiene un ?e (espacio) para poner un container
       (espacio_contiene ?e - espacio ?c - contenedor) ; Indica que en el espacio ?e contiene el contenedor ?c 
    )
    ;
    ; Mover
    ; Parametros: 
    ;   - ?veh - Transporte
    ;   - ?x - Posicion inicial 
    ;   - ?y - Posicion final
    ; Precondiciones: 
    ;   - El vehiculo ?veh esta en ?x
    ;   - ?x e ?y conectadas
    ; Efectos: 
    ;   - El vehiculo ?veh esta en ?y (y deja de estar en ?x)
    ;
    (:action mover
        :parameters (
            ?veh - transporte
            ?x ?y - localizacion
        )
        :precondition (and 
            (en ?veh ?x) 
            (conectado ?x ?y)
        )
        :effect (and 
           (en ?veh ?y)
           (not (en ?veh ?x))
        )
    )
    ;
    ; Cargar
    ; Parametros: 
    ;   - ?cont : contenedor   
    ;   - ?veh  : transporte  
    ;   - ?esp_veh: espacio en el transporte
    ;   - ?x : localizacion
    ;   - ?esp_x: espacio en la localizacion
    ; Precondiciones: 
    ;   - ?veh en localizacion ?x
    ;   - Que ?veh tiene espacio (?esp_veh) para un contenedor
    ;   - Que ?esp_veh esta vacio
    ;   - Que ?x tiene espacio (?esp_x) para un contenedor
    ;   - Que ?esp_x contiene el contenedor ?cont
    ; Efecto:
    ;   - Es espacio ?esp_veh en el tren deja de estar vacio y contiene ?cont
    ;   - El espacio ?esp_x en localizacion ?x deja de tener ?cont y pasa a estar vacio
    ;
    (:action cargar
        :parameters (
            ?cont - contenedor
            ?veh - transporte
            ?esp_veh - espacio
            ?x - localizacion
            ?esp_x - espacio
        )
        :precondition (and 
            (en ?veh  ?x)
            (espacio_en ?veh ?esp_veh)
            (espacio_contiene ?esp_veh vacio)
            (espacio_en ?x ?esp_x)
            (espacio_contiene ?esp_x ?cont)
        )
        :effect (and 
           (not (espacio_contiene ?esp_veh vacio))
           (espacio_contiene ?esp_veh ?cont)
           (not (espacio_contiene ?esp_x ?cont))
           (espacio_contiene ?esp_x vacio)
        )
    )
    ;
    ; Descargar
    ; Parametros: 
    ;   - ?cont : contenedor   
    ;   - ?veh  : transporte  
    ;   - ?esp_veh: espacio en el transporte
    ;   - ?x : localizacion
    ;   - ?esp_x: espacio en la localizacion
    ; Precondiciones: 
    ;   - transporte ?veh en localizacion ?x
    ;   - Que ?veh tiene espacio (?esp_veh) para un contenedor
    ;   - Que ?esp_veh contiene el contenedor ?cont
    ;   - Que ?x tiene espacio (?esp_x) para un contenedor
    ;   - Que ?esp_x esta vacio
    ;   - Que ?x acepte descargas
    ; Efecto:
    ;   - Es espacio ?esp_veh en el tren deja de tener ?cont y pasa a estar vacio
    ;   - El espacio ?esp_x en localizacion ?x deja de estar vacio y contiene ?cont
    ;        
    (:action descargar
        :parameters (
            ?cont - contenedor
            ?veh - transporte
            ?esp_veh - espacio
            ?x - localizacion
            ?esp_x - espacio
        )
        :precondition (and 
            (en ?veh  ?x)
            (espacio_en ?veh ?esp_veh)
            (espacio_contiene ?esp_veh ?cont)
            (espacio_en ?x ?esp_x)
            (espacio_contiene ?esp_x vacio)
            (acepta_descargas ?x)
        )
        :effect (and 
           (not (espacio_contiene ?esp_veh ?cont))
           (espacio_contiene ?esp_veh vacio)
           (not (espacio_contiene ?esp_x vacio))
           (espacio_contiene ?esp_x ?cont)           
        )
    )
    ;    
    ; Procesar
    ; Parametros: 
    ;   - ?cont - contenedor
    ;   - ?x - localizacion
    ; Precondiciones: 
    ;   - Localizacion ?x tiene un espacio ?esp_x
    ;   - El contenedor ?cont esta en el espacio ?esp_x
    ;   - ?x es una fabrica (con capacidad para procesar)
    ; Efecto:
    ;   - contenedor ?cont pasa estar "procesado"
    ;
    (:action procesar
        :parameters (
            ?cont - contenedor
            ?x - localizacion
            ?esp_x - espacio
        )
        :precondition (and
            (espacio_en ?x ?esp_x)
            (espacio_contiene ?esp_x ?cont)
            (es_fabrica ?x)
        )
        :effect (and
            (esta_procesado ?cont)
        )
    )
    ;    
    ; Enviar
    ; Parametros: 
    ;   - ?cont - contenedor
    ;   - ?x - localizacion
    ;   - ?esp_x - espacio
    ; Precondiciones: 
    ;   - ?x es un almacen (con capacidad para enviar)
    ;   - ?cont ya esta "procesado"
    ;   - ?esp_x es un espacio de la localizacion ?x
    ;   - ?cont esta en el espacio ?esp_x
    ; Efecto:
    ;   - contenedor ?cont pasa estar "enviado" (completa el circuito)
    ;   - ?cont deja de estar en el espacio ?esp_x y este se queda "vacio"
    ;
    (:action enviar
        :parameters (
            ?cont - contenedor
            ?x - localizacion
            ?esp_x - espacio
        )
        :precondition (and
            (es_almacen ?x)
            (esta_procesado ?cont)
            (espacio_en ?x ?esp_x)
            (espacio_contiene ?esp_x ?cont)
        )
        :effect (and
            (esta_enviado ?cont)
            (not (espacio_contiene ?esp_x ?cont))
            (espacio_contiene ?esp_x vacio)
        )
    )
)