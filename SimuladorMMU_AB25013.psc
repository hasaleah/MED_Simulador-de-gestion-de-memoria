Proceso SimuladorMMU

	Dimension MarcoOcupado[4]
	Dimension MarcoPagina[4]
	Dimension Presente[5]
	Dimension MarcoDePagina[5]
	Dimension Referencias[12]
	Dimension MarcosFIFO[3]
	Dimension OcupadoFIFO[3]
	Dimension MarcosOPT[3]
	Dimension OcupadoOPT[3]

	Definir i, t, pag, libre, punteroFIFO Como Entero
	Definir fallosFIFO, fallosOPT Como Entero
	Definir k, dist, mayorDist, mejorMarco Como Entero
	Definir dir, TAM_MARCO Como Entero
	Definir encontrado, falloF, falloO Como Logico
	Definir opcion Como Entero

	TAM_MARCO <- 4096

	//inicializacion
	Para i <- 1 Hasta 4
		MarcoOcupado[i] <- 0
		MarcoPagina[i]  <- -1
	FinPara

	Para i <- 1 Hasta 5
		Presente[i]      <- 0
		MarcoDePagina[i] <- -1
	FinPara

	Presente[1]      <- 1
	MarcoDePagina[1] <- 2
	Presente[2]      <- 1
	MarcoDePagina[2] <- 3
	Presente[3]      <- 0

	Referencias[1]  <- 1
	Referencias[2]  <- 2
	Referencias[3]  <- 3
	Referencias[4]  <- 4
	Referencias[5]  <- 1
	Referencias[6]  <- 2
	Referencias[7]  <- 5
	Referencias[8]  <- 1
	Referencias[9]  <- 2
	Referencias[10] <- 3
	Referencias[11] <- 4
	Referencias[12] <- 5

	//menu
	Repetir

		Escribir ""
		Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
		Escribir "     SIMULADOR DE GESTION DE MEMORIA     "
		Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
		Escribir "  1. Fase 1 - Mapa de bits de la RAM"
		Escribir "  2. Fase 2 - Traduccion de direcciones"
		Escribir "  3. Fase 3 - Simulacion FIFO"
		Escribir "  4. Fase 3 - Simulacion OPT"
		Escribir "  5. Fase 3 - Resumen FIFO vs OPT"
		Escribir "  6. Ejecutar todo"
		Escribir "  0. Salir"
		Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
		Escribir "Ingrese una opcion: "
		Leer opcion

		Segun opcion Hacer

			1:
				Para i <- 1 Hasta 4
					MarcoOcupado[i] <- 0
					MarcoPagina[i]  <- -1
				FinPara

				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "     FASE 1: MAPA DE BITS DE LA RAM    "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir ""
				Escribir "Estado inicial:"
				MostrarMapaBits(MarcoOcupado)

				AsignarPagina(MarcoOcupado, MarcoPagina, 1)
				AsignarPagina(MarcoOcupado, MarcoPagina, 2)
				AsignarPagina(MarcoOcupado, MarcoPagina, 3)
				Escribir "Tras asignar P1, P2, P3:"
				MostrarMapaBits(MarcoOcupado)

				LiberarMarco(MarcoOcupado, MarcoPagina, 2)
				Escribir "Tras liberar marco 2:"
				MostrarMapaBits(MarcoOcupado)

			2:
				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "    FASE 2: TRADUCCION DE DIRECCIONES   "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir ""
				Escribir "Tabla de paginas cargada:"
				Escribir "  P1 -> Marco 2  (presente)"
				Escribir "  P2 -> Marco 3  (presente)"
				Escribir "  P3 -> ---      (ausente)"
				Escribir ""
				Escribir "Prueba 1 - Pagina 1 en memoria (marco 2, offset 100):"
				dir <- TraducirDireccion(1, 100, Presente, MarcoDePagina, TAM_MARCO)
				Escribir "Direccion fisica: ", dir, "  (esperado: 8292)"
				Escribir ""
				Escribir "Prueba 2 - Pagina 3 no esta en RAM (fallo de pagina):"
				dir <- TraducirDireccion(3, 50, Presente, MarcoDePagina, TAM_MARCO)
				Escribir "Resultado: ", dir, "  (esperado: -1)"

			3:
				Para i <- 1 Hasta 3
					OcupadoFIFO[i] <- 0
					MarcosFIFO[i]  <- -1
				FinPara
				fallosFIFO  <- 0
				punteroFIFO <- 1

				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "       FASE 3: SIMULACION FIFO"
				Escribir "  Cadena: [1,2,3,4,1,2,5,1,2,3,4,5]"
				Escribir "  Marcos disponibles: 3"
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir " t  | Ref | M1    M2    M3   | Fallo?"
				Escribir "----|-----|------------------|-------"

				Para t <- 1 Hasta 12
					pag    <- Referencias[t]
					falloF <- Verdadero

					Para i <- 1 Hasta 3
						Si OcupadoFIFO[i] = 1 Y MarcosFIFO[i] = pag Entonces
							falloF <- Falso
						FinSi
					FinPara

					Si falloF = Verdadero Entonces
						fallosFIFO <- fallosFIFO + 1
						libre <- -1
						Para i <- 1 Hasta 3
							Si OcupadoFIFO[i] = 0 Entonces
								libre <- i
							FinSi
						FinPara
						Si libre <> -1 Entonces
							OcupadoFIFO[libre] <- 1
							MarcosFIFO[libre]  <- pag
						Sino
							MarcosFIFO[punteroFIFO] <- pag
							punteroFIFO <- punteroFIFO + 1
							Si punteroFIFO > 3 Entonces
								punteroFIFO <- 1
							FinSi
						FinSi
					FinSi

					ImprimirFila(t, pag, MarcosFIFO, OcupadoFIFO, falloF)
				FinPara

				Escribir "----|-----|------------------|-------"
				Escribir "Total fallos FIFO: ", fallosFIFO

			4:
				Para i <- 1 Hasta 3
					OcupadoOPT[i] <- 0
					MarcosOPT[i]  <- -1
				FinPara
				fallosOPT <- 0

				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "       FASE 3 ? SIMULACION OPT           "
				Escribir "  Cadena: [1,2,3,4,1,2,5,1,2,3,4,5]     "
				Escribir "  Marcos disponibles: 3                   "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir " t  | Ref | M1    M2    M3   | Fallo?"
				Escribir "----|-----|------------------|-------"

				Para t <- 1 Hasta 12
					pag    <- Referencias[t]
					falloO <- Verdadero

					Para i <- 1 Hasta 3
						Si OcupadoOPT[i] = 1 Y MarcosOPT[i] = pag Entonces
							falloO <- Falso
						FinSi
					FinPara

					Si falloO = Verdadero Entonces
						fallosOPT <- fallosOPT + 1
						libre <- -1
						Para i <- 1 Hasta 3
							Si OcupadoOPT[i] = 0 Entonces
								libre <- i
							FinSi
						FinPara
						Si libre <> -1 Entonces
							OcupadoOPT[libre] <- 1
							MarcosOPT[libre]  <- pag
						Sino
							mayorDist  <- -1
							mejorMarco <- 1
							Para i <- 1 Hasta 3
								dist       <- 9999
								encontrado <- Falso
								Para k <- t + 1 Hasta 12
									Si encontrado = Falso Entonces
										Si Referencias[k] = MarcosOPT[i] Entonces
											dist       <- k - t
											encontrado <- Verdadero
										FinSi
									FinSi
								FinPara
								Si dist > mayorDist Entonces
									mayorDist  <- dist
									mejorMarco <- i
								FinSi
							FinPara
							MarcosOPT[mejorMarco] <- pag
						FinSi
					FinSi

					ImprimirFila(t, pag, MarcosOPT, OcupadoOPT, falloO)
				FinPara

				Escribir "----|-----|------------------|-------"
				Escribir "Total fallos OPT: ", fallosOPT

			5:
				//recalcular FIFO
				Para i <- 1 Hasta 3
					OcupadoFIFO[i] <- 0
					MarcosFIFO[i]  <- -1
				FinPara
				fallosFIFO  <- 0
				punteroFIFO <- 1
				Para t <- 1 Hasta 12
					pag    <- Referencias[t]
					falloF <- Verdadero
					Para i <- 1 Hasta 3
						Si OcupadoFIFO[i] = 1 Y MarcosFIFO[i] = pag Entonces
							falloF <- Falso
						FinSi
					FinPara
					Si falloF = Verdadero Entonces
						fallosFIFO <- fallosFIFO + 1
						libre <- -1
						Para i <- 1 Hasta 3
							Si OcupadoFIFO[i] = 0 Entonces
								libre <- i
							FinSi
						FinPara
						Si libre <> -1 Entonces
							OcupadoFIFO[libre] <- 1
							MarcosFIFO[libre]  <- pag
						Sino
							MarcosFIFO[punteroFIFO] <- pag
							punteroFIFO <- punteroFIFO + 1
							Si punteroFIFO > 3 Entonces
								punteroFIFO <- 1
							FinSi
						FinSi
					FinSi
				FinPara

				//recalcular OPT
				Para i <- 1 Hasta 3
					OcupadoOPT[i] <- 0
					MarcosOPT[i]  <- -1
				FinPara
				fallosOPT <- 0
				Para t <- 1 Hasta 12
					pag    <- Referencias[t]
					falloO <- Verdadero
					Para i <- 1 Hasta 3
						Si OcupadoOPT[i] = 1 Y MarcosOPT[i] = pag Entonces
							falloO <- Falso
						FinSi
					FinPara
					Si falloO = Verdadero Entonces
						fallosOPT <- fallosOPT + 1
						libre <- -1
						Para i <- 1 Hasta 3
							Si OcupadoOPT[i] = 0 Entonces
								libre <- i
							FinSi
						FinPara
						Si libre <> -1 Entonces
							OcupadoOPT[libre] <- 1
							MarcosOPT[libre]  <- pag
						Sino
							mayorDist  <- -1
							mejorMarco <- 1
							Para i <- 1 Hasta 3
								dist       <- 9999
								encontrado <- Falso
								Para k <- t + 1 Hasta 12
									Si encontrado = Falso Entonces
										Si Referencias[k] = MarcosOPT[i] Entonces
											dist       <- k - t
											encontrado <- Verdadero
										FinSi
									FinSi
								FinPara
								Si dist > mayorDist Entonces
									mayorDist  <- dist
									mejorMarco <- i
								FinSi
							FinPara
							MarcosOPT[mejorMarco] <- pag
						FinSi
					FinSi
				FinPara

				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "            RESUMEN FINAL                "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir " Algoritmo | Fallos de pagina"
				Escribir "-----------|----------------"
				Escribir " FIFO      | ", fallosFIFO
				Escribir " OPT       | ", fallosOPT
				Escribir "-----------|----------------"
				Escribir " Diferencia: ", fallosFIFO - fallosOPT, " fallos menos con OPT"
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir ""
				Escribir " OPT es el limite inferior teorico:"
				Escribir " ningun algoritmo puede producir menos"
				Escribir " fallos para esta cadena con 3 marcos."
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"

			6:
				Para i <- 1 Hasta 4
					MarcoOcupado[i] <- 0
					MarcoPagina[i]  <- -1
				FinPara
				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "     FASE 1: MAPA DE BITS DE LA RAM    "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "Estado inicial:"
				MostrarMapaBits(MarcoOcupado)
				AsignarPagina(MarcoOcupado, MarcoPagina, 1)
				AsignarPagina(MarcoOcupado, MarcoPagina, 2)
				AsignarPagina(MarcoOcupado, MarcoPagina, 3)
				Escribir "Tras asignar P1, P2, P3:"
				MostrarMapaBits(MarcoOcupado)
				LiberarMarco(MarcoOcupado, MarcoPagina, 2)
				Escribir "Tras liberar marco 2:"
				MostrarMapaBits(MarcoOcupado)

				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "    FASE 2: TRADUCCION DE DIRECCIONES   "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "Prueba 1 - Pagina 1 (marco 2, offset 100):"
				dir <- TraducirDireccion(1, 100, Presente, MarcoDePagina, TAM_MARCO)
				Escribir "Direccion fisica: ", dir
				Escribir "Prueba 2 - Pagina 3 (no en RAM):"
				dir <- TraducirDireccion(3, 50, Presente, MarcoDePagina, TAM_MARCO)
				Escribir "Resultado: ", dir

				Para i <- 1 Hasta 3
					OcupadoFIFO[i] <- 0
					MarcosFIFO[i]  <- -1
				FinPara
				fallosFIFO  <- 0
				punteroFIFO <- 1
				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "       FASE 3: SIMULACION FIFO          "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir " t  | Ref | M1    M2    M3   | Fallo?"
				Escribir "----|-----|------------------|-------"
				Para t <- 1 Hasta 12
					pag    <- Referencias[t]
					falloF <- Verdadero
					Para i <- 1 Hasta 3
						Si OcupadoFIFO[i] = 1 Y MarcosFIFO[i] = pag Entonces
							falloF <- Falso
						FinSi
					FinPara
					Si falloF = Verdadero Entonces
						fallosFIFO <- fallosFIFO + 1
						libre <- -1
						Para i <- 1 Hasta 3
							Si OcupadoFIFO[i] = 0 Entonces
								libre <- i
							FinSi
						FinPara
						Si libre <> -1 Entonces
							OcupadoFIFO[libre] <- 1
							MarcosFIFO[libre]  <- pag
						Sino
							MarcosFIFO[punteroFIFO] <- pag
							punteroFIFO <- punteroFIFO + 1
							Si punteroFIFO > 3 Entonces
								punteroFIFO <- 1
							FinSi
						FinSi
					FinSi
					ImprimirFila(t, pag, MarcosFIFO, OcupadoFIFO, falloF)
				FinPara
				Escribir "----|-----|------------------|-------"
				Escribir "Total fallos FIFO: ", fallosFIFO
				
				//OPT
				Para i <- 1 Hasta 3
					OcupadoOPT[i] <- 0
					MarcosOPT[i]  <- -1
				FinPara
				fallosOPT <- 0
				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "       FASE 3 ? SIMULACION OPT           "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir " t  | Ref | M1    M2    M3   | Fallo?"
				Escribir "----|-----|------------------|-------"
				Para t <- 1 Hasta 12
					pag    <- Referencias[t]
					falloO <- Verdadero
					Para i <- 1 Hasta 3
						Si OcupadoOPT[i] = 1 Y MarcosOPT[i] = pag Entonces
							falloO <- Falso
						FinSi
					FinPara
					Si falloO = Verdadero Entonces
						fallosOPT <- fallosOPT + 1
						libre <- -1
						Para i <- 1 Hasta 3
							Si OcupadoOPT[i] = 0 Entonces
								libre <- i
							FinSi
						FinPara
						Si libre <> -1 Entonces
							OcupadoOPT[libre] <- 1
							MarcosOPT[libre]  <- pag
						Sino
							mayorDist  <- -1
							mejorMarco <- 1
							Para i <- 1 Hasta 3
								dist       <- 9999
								encontrado <- Falso
								Para k <- t + 1 Hasta 12
									Si encontrado = Falso Entonces
										Si Referencias[k] = MarcosOPT[i] Entonces
											dist       <- k - t
											encontrado <- Verdadero
										FinSi
									FinSi
								FinPara
								Si dist > mayorDist Entonces
									mayorDist  <- dist
									mejorMarco <- i
								FinSi
							FinPara
							MarcosOPT[mejorMarco] <- pag
						FinSi
					FinSi
					ImprimirFila(t, pag, MarcosOPT, OcupadoOPT, falloO)
				FinPara
				Escribir "----|-----|------------------|-------"
				Escribir "Total fallos OPT: ", fallosOPT

				Escribir ""
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir "            RESUMEN FINAL                "
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
				Escribir " Fallos FIFO : ", fallosFIFO
				Escribir " Fallos OPT  : ", fallosOPT
				Escribir " Diferencia  : ", fallosFIFO - fallosOPT, " fallos menos con OPT"
				Escribir "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"

			0:
				Escribir ""
				Escribir "Saliendo del simulador. Hasta luego!"

			De Otro Modo:
				Escribir ""
				Escribir "Opcion no valida. Ingrese un numero del 0 al 6."

		FinSegun

	Hasta Que opcion = 0

FinProceso

//subprocesos y funciones

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
				MO[i]    <- 1
				MP[i]    <- pagina
				asignado <- Verdadero
				Escribir "Pagina ", pagina, " asignada al marco ", i
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
		Escribir "El marco ya esta libre"
	FinSi
FinSubProceso

Funcion dirFisica <- TraducirDireccion(paginaLogica, offset, Presente, MarcoDePagina, TAM_MARCO)
	Definir dirFisica Como Entero
	Definir marco Como Entero
	Si Presente[paginaLogica] = 0 Entonces
		dirFisica <- -1
	Sino
		marco     <- MarcoDePagina[paginaLogica]
		dirFisica <- (marco * TAM_MARCO) + offset
	FinSi
FinFuncion

SubProceso ImprimirFila(t, pag, Marcos, Ocupado, fallo)
	Definir i Como Entero
	Definir linea, celda Como Cadena
	Si t < 10 Entonces
		linea <- " " + ConvertirATexto(t) + "  | "
	Sino
		linea <- " " + ConvertirATexto(t) + " | "
	FinSi
	linea <- linea + "P" + ConvertirATexto(pag) + "  | "
	Para i <- 1 Hasta 3
		Si Ocupado[i] = 1 Entonces
			celda <- "P" + ConvertirATexto(Marcos[i])
		Sino
			celda <- " - "
		FinSi
		linea <- linea + celda + "   "
	FinPara
	Si fallo = Verdadero Entonces
		linea <- linea + "| Fallo"
	Sino
		linea <- linea + "| Hit"
	FinSi
	Escribir linea
FinSubProceso
