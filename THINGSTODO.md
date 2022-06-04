* ✔ Resolver el tema de la division del supply.

* ✔ Entender como hacemos para una vez luego del deployment del contrato del token, como hacemos para transferir tokens de ese contract.

* ✔ Resolver la distribucion de tokens: Se tendria que separar la creacion del token de la creacion del contract para asi tener ya una whiteList armada antes de mintear.

    RESPUESTA: No Creamos una whitelist y sino que cada quien que quiera entrar en el governanceContract tiene que comprar tokens

* ✔ Crear la condicion para el minteo de tokens cueste una cantidad de eth.

* ✔ Crear el method para agregar personas a la whitelist.

* ✔ Incluir la libreria SafeMath para evitar problemas en los calculos matematicos dentro del GovernanceContract.

* Revolver el tema del tiempo, hacer un call a una function automaticamente luego de que haya transcurrido un cierto tiempo.

* ✔ Crear un mecanismo que tome el nombre y numero de la propuesta y entregue un struct con los resultados para asi poder dar los resultados con toda la informacion.

* Desarrollar tests para ver si funciona lo realizado hasta ahora.

* ✔ Crear la estructura para los calculos matematicos para saber si una persona puede proponer, votar, etc.

    CREO SE PUEDE MEJORAR

* Crear el mecanismo para permitir votar en base al % de tokens en el wallet.
    
    a. Tambien podria ser un mecanismo en el que los votos cambien de valor en base al % de tokens en el wallet.

    b. Revisar o entender la logica si serian % de tokens en el wallet o % de tokens stakeados en un contract.

* Aprender a obtener el length de un array sin usar dos contratos separados.

* Pregunta: Los que estan en la whiteList tienen poder de voto?