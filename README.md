Pasos a realizar para un correcto deployment de esta DAO:

0. Hacer deployment del contrato del token a utilizar.

1. Hacer deployment del GovernanceContract.

2. Proceso de propuesta y votacion de las propuestas.

3. Proceso de apertura y cierre de votacion.

4. Resultados.



Estructura del sistema de votacion, necesitamos:

0. OBTENER LA LISTA DE ADDRESSES QUE POSEEN EL TOKEN
    Se puede crear un mapping cada vez que alguien llama a la funcion transfer para poder salvar cada una de las cuentas que obtienen el token y luego llamar la funcion BalanceOf(account) para saber cuanto tiene.

RESPUESTA: Sencillamente se usa la interfaz del contrato IERC20 junto con el address del token creado y se hace un require .balance >0 en donde el tener tokens o no debe ser tomado en cuenta.

Y ademas si se necesita que la persona tenga un % minimo de token respecto al total de tokens se hace el llamado al method .totalsupply y se compara

1. SISTEMA DE PROPUESTAS
    Quien puede proponer? ---> Todos los que tengan un minimo % del token 
    Que informacion necesitamos del que propone? ---> wallet address
    Como, con que tipo de datos es posible hacer la propuesta?
    Apenas se publique la propuesta, se tendra un tiempo establecido donde una vez ocurrido se dara inicio a la votacion

2. SISTEMA DE VOTACION
    Apenas comienza el tiempo de votacion, se procede a activar otro timer que va a contar el tiempo hasta que termine la votacion
    Las opciones de votacion son Aprobar, Reprobar, Abstener


✔ Entender diferencias entre heredar e importar contracts e interfaces y saber cuando usar cada uno.

3. Flujo de funcionamiento:
    - Se hace deploy del contrato del token.
    - Se hace deploiy del contrato del governance.
    - Se agregan cuentas a la whitelist o personas compran tokens.
    - Se hace una propuesta que efectivamente se publique, cambia el estado de las votaciones y mas nadie puede proponer.
    - El owner del contract procede a hacer start de las votaciones luego de transcurrido cierto tiempo.
    -  Se puede votar.
    - 2 horas luego de comenzadas las votaciones se cierra la votacion.