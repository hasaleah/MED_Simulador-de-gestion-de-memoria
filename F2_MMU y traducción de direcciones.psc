Proceso SimuladorMMU
	
    Definir TAM_MARCO Como Entero
    TAM_MARCO <- 4096
	
    //tamaño de páginas
    Dimension Presente[5]
    Dimension MarcoDePagina[5]
	
    Definir i Como Entero
    Definir dir Como Entero
	

    Para i <- 1 Hasta 5
        Presente[i] <- 0
        MarcoDePagina[i] <- -1
    FinPara
	
    
    Presente[1] <- 1
    MarcoDePagina[1] <- 2
	
    Presente[2] <- 1
    MarcoDePagina[2] <- 3
	
    Presente[3] <- 0 
	
    //pruebas
    Escribir "Prueba 1 (Página en memoria):"
    dir <- TraducirDireccion(1, 100, Presente, MarcoDePagina, TAM_MARCO)
    Escribir "Dirección física: ", dir
	
    Escribir ""
	
    Escribir "Prueba 2 (Fallo de página):"
    dir <- TraducirDireccion(3, 50, Presente, MarcoDePagina, TAM_MARCO)
    Escribir "Resultado: ", dir
	
FinProceso



Funcion dirFisica <- TraducirDireccion(paginaLogica, offset, Presente, MarcoDePagina, TAM_MARCO)
	
    Definir dirFisica Como Entero
    Definir marco Como Entero
	
    Si Presente[paginaLogica] = 0 Entonces
        dirFisica <- -1   //fallo de página
    Sino
        marco <- MarcoDePagina[paginaLogica]
        dirFisica <- (marco * TAM_MARCO) + offset
    FinSi

FinFuncion