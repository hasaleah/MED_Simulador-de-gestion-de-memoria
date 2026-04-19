Proceso SimuladorReemplazo
	
    Dimension Referencias[12]
    Dimension Marcos[3]
    Dimension Ocupado[3]
	
    Definir i, t, pag, libre, punteroFIFO Como Entero
    Definir fallosFIFO, fallosOPT Como Entero
    Definir k, dist, mayorDist, mejorMarco Como Entero
    Definir encontrado Como Logico
	
    // =========================
    // REFERENCIAS
    // =========================
    Referencias[1] <- 1
    Referencias[2] <- 2
    Referencias[3] <- 3
    Referencias[4] <- 4
    Referencias[5] <- 1
    Referencias[6] <- 2
    Referencias[7] <- 5
    Referencias[8] <- 1
    Referencias[9] <- 2
    Referencias[10] <- 3
    Referencias[11] <- 4
    Referencias[12] <- 5
	
	
    // =========================
    // FIFO
    // =========================
    Para i <- 1 Hasta 3
        Ocupado[i] <- 0
        Marcos[i] <- -1
    FinPara
	
    fallosFIFO <- 0
    punteroFIFO <- 1
	
    Para t <- 1 Hasta 12
		
        pag <- Referencias[t]
		
        // Buscar página
        libre <- -1
        Para i <- 1 Hasta 3
            Si Ocupado[i] = 1 Y Marcos[i] = pag Entonces
                libre <- i
            FinSi
        FinPara
		
        Si libre = -1 Entonces
			
            fallosFIFO <- fallosFIFO + 1
			
            // Buscar marco libre
            libre <- -1
            Para i <- 1 Hasta 3
                Si Ocupado[i] = 0 Entonces
                    libre <- i
                FinSi
            FinPara
			
            Si libre <> -1 Entonces
                Ocupado[libre] <- 1
                Marcos[libre] <- pag
            Sino
                Marcos[punteroFIFO] <- pag
				
                punteroFIFO <- punteroFIFO + 1
                Si punteroFIFO > 3 Entonces
                    punteroFIFO <- 1
                FinSi
            FinSi
			
        FinSi
		
    FinPara
	
	
    // =========================
    // OPTIMO
    // =========================
    Para i <- 1 Hasta 3
        Ocupado[i] <- 0
        Marcos[i] <- -1
    FinPara
	
    fallosOPT <- 0
	
    Para t <- 1 Hasta 12
		
        pag <- Referencias[t]
		
        // Buscar página
        libre <- -1
        Para i <- 1 Hasta 3
            Si Ocupado[i] = 1 Y Marcos[i] = pag Entonces
                libre <- i
            FinSi
        FinPara
		
        Si libre = -1 Entonces
			
            fallosOPT <- fallosOPT + 1
			
            // Buscar libre
            libre <- -1
            Para i <- 1 Hasta 3
                Si Ocupado[i] = 0 Entonces
                    libre <- i
                FinSi
            FinPara
			
            Si libre <> -1 Entonces
                Ocupado[libre] <- 1
                Marcos[libre] <- pag
            Sino
				
                // Elegir víctima (OPT)
                mayorDist <- -1
                mejorMarco <- 1
				
                Para i <- 1 Hasta 3
					
                    dist <- 9999
                    encontrado <- Falso
					
                    Para k <- t + 1 Hasta 12
                        Si encontrado = Falso Entonces
                            Si Referencias[k] = Marcos[i] Entonces
                                dist <- k - t
                                encontrado <- Verdadero
                            FinSi
                        FinSi
                    FinPara
					
                    Si dist > mayorDist Entonces
                        mayorDist <- dist
                        mejorMarco <- i
                    FinSi
					
                FinPara
				
                Marcos[mejorMarco] <- pag
				
            FinSi
			
        FinSi
		
    FinPara
	
	
    // =========================
    // RESULTADOS
    // =========================
    Escribir "Fallos de página FIFO: ", fallosFIFO
    Escribir "Fallos de página OPT: ", fallosOPT
	
FinProceso