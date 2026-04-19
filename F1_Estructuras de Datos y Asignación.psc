Proceso AdministradorMemoria
	
    Dimension MarcoOcupado[4]
    Dimension MarcoPagina[4]
    
    Definir i Como Entero
	
    // Inicializar RAM
    Para i <- 1 Hasta 4
        MarcoOcupado[i] <- 0
        MarcoPagina[i] <- -1
    FinPara
	
    Escribir "Estado inicial:"
    MostrarMapaBits(MarcoOcupado)
	
    // Simulación
    AsignarPagina(MarcoOcupado, MarcoPagina, 1)
    AsignarPagina(MarcoOcupado, MarcoPagina, 2)
    AsignarPagina(MarcoOcupado, MarcoPagina, 3)
	
    MostrarMapaBits(MarcoOcupado)
	
    LiberarMarco(MarcoOcupado, MarcoPagina, 2)
	
    MostrarMapaBits(MarcoOcupado)
	
FinProceso



SubProceso MostrarMapaBits(MO)
    Definir i Como Entero
    Definir linea Como Cadena
    
    linea <- "Mapa de bits (M1..M4): "
    
    Para i <- 1 Hasta 4
        linea <- linea + ConvertirATexto(MO[i]) + " "
    FinPara
    
    Escribir linea
FinSubProceso



SubProceso AsignarPagina(MO, MP, pagina)
    Definir i Como Entero
    Definir asignado Como Logico
    
    asignado <- Falso
    
    Para i <- 1 Hasta 4
        Si asignado = Falso Entonces
            Si MO[i] = 0 Entonces
                MO[i] <- 1
                MP[i] <- pagina
                Escribir "Página ", pagina, " asignada al marco ", i
                asignado <- Verdadero
            FinSi
        FinSi
    FinPara
    
    Si asignado = Falso Entonces
        Escribir "No hay marcos libres"
    FinSi
FinSubProceso



SubProceso LiberarMarco(MO, MP, marco)
    Si MO[marco] = 1 Entonces
        MO[marco] <- 0
        MP[marco] <- -1
        Escribir "Marco ", marco, " liberado"
    Sino
        Escribir "El marco ya está libre"
    FinSi
FinSubProceso