#+++++++++++++++++++++++++++++++++++++++++++++++++++++++
# INSTALAR PAQUETES
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++

R4XCL_INSTALACION <- function(directorio,TipoOutput=0 )
{
    tiempo_inicio <- Sys.time()
    Procedimientos = R4XCL_INT_PROCEDIMIENTOS()
    
    if (TipoOutput == 0){
      
      OutPut = Procedimientos$INSTALA
      return(OutPut)
      
    }else if(TipoOutput == 1){
    
      pSVDIALOGS <- c("svMisc_1.0-1.tar.gz", 
                      "svGUI_0.9-55.tar.gz", 
                      "svDialogs_0.9-50.tar.gz")
      
      OutPut <- pSVDIALOGS
    
    }else if(TipoOutput == 2){
    
      pDEVTOOLS <-c("R6_2.2.2.tar.gz",
                    "openssl_1.0.1.tar.gz",
                    "httr_1.3.1.tar.gz",
                    "digest_0.6.15.tar.gz",
                    "digest_0.6.15.tar.gz",
                    "whisker_0.3-2.tar.gz",
                    "rstudioapi_0.7.tar.gz",
                    "git2r_0.21.0.tar.gz",
                    "withr_2.1.2.tar.gz",
                    "devtools_1.13.5.tar.gz")
      
      OutPut <- pDEVTOOLS
    
    }else if(TipoOutput == 3){
    
      pWORLDMAP <- c("dotCall64_0.9-5.tar.gz",
                     "spam_2.1-4.tar.gz",
                     "fields_9.0.tar.gz",
                     "Rcpp_0.12.16.tar.gz",
                     "raster_2.6-7.tar.gz",
                     "terra_0.5-2.tar.gz",
                     "maptools_0.9-2.tar.gz",
                     "rworldmap_1.3-1.tar.gz")
      
      OutPut <- pWORLDMAP
    
    }else if(TipoOutput == 4){
    
      pSTARGAZER <- c("stargazer_5.2.1.tar.gz")
      
      OutPut <- pSTARGAZER
    
    }else if(TipoOutput == 5){
    
      pPLM <- c("Formula_1.2-3.tar.gz",
                "bdsmatrix_1.3-3.tar.gz",
                "zoo_1.8-1.tar.gz",
                "sandwich_2.4-0.tar.gz",
                "lmtest_0.9-36.tar.gz",
                "miscTools_0.6-22.tar.gz",
                "maxLik_1.3-4.tar.gz",
                "plm_1.6-6.tar.gz")
      
      OutPut <- pPLM
    
    }else if(TipoOutput == 6){
    
      pRPART <- c("rpart.plot_2.2.0.tar.gz")
      
      OutPut <- pRPART
    
    }else if(TipoOutput == 7){
    
      pRESOURCE_SELECTION=c("pbapply_1.3-4.tar.gz",
                           "data.table_1.11.2.tar.gz",
                           "prediction_0.3.2.tar.gz",
                           "margins_0.3.0.tar.gz",
                           "ResourceSelection_0.3-2.tar.gz")
      
      OutPut <- pRESOURCE_SELECTION 
    
    }else if(TipoOutput == 8){
    
      pTM <- c("VGAM_1.0-5.tar.gz",
               "xml2_1.2.0.tar.gz",
               "tm_0.7-3.tar.gz")
    
      OutPut <- pTM 
    
    }else if(TipoOutput == 9){
    
      pSNOWBALLC=c("SnowballC_0.7.1.tar.gz")
      
      OutPut <- pSNOWBALLC 
    
    }else if(TipoOutput == 10){
    
      pWORDCLUD <- c("RColorBrewer_1.1-2.tar.gz","wordcloud_2.5.tar.gz")
      
      OutPut <- pWORDCLUD 
    
    }else if(TipoOutput == 11){
    
      pPERFORMANCE_ANALYTICS=c("xts_0.10-2.tar.gz", 
                               "quadprog_1.5-5.tar.gz",
                               "PerformanceAnalytics_1.5.2.tar.gz")
      
      OutPut <- pPERFORMANCE_ANALYTICS 
    
    }else if(TipoOutput == 12){
    
      pRLANG <- c("rlang_0.2.0.tar.gz")
      
      OutPut <- pRLANG 
    
    }else if(TipoOutput == 13){
    
      pFS = c("stargazer_5.2.1.tar.gz")

      OutPut <- pFS

    }else if(TipoOutput == 14){
      
      pDUMMIES = c("dummies_1.5.6.tar.gz")
      
      OutPut <- pDUMMIES  
    
    }else if(TipoOutput == -1){
     
      OutPut <- union(
                     pSVDIALOGS,
                     pDEVTOOLS,
                     pWORLDMAP,
                     pSTARGAZER,
                     pPLM,
                     pRPART,
                     pRESOURCE_SELECTION,
                     pTM,
                     pSNOWBALLC,
                     pWORDCLUD,
                     pPERFORMANCE_ANALYTICS,
                     pRLANG,
                     pFS
                   )
    }  

    df_errores <- data.frame(Resultado = character())

    for (nombre_archivo in OutPut) {
      
      nombre_paquete <- sub("_.+", "", nombre_archivo)          # Extraer el nombre del paquete del nombre del archivo (antes del primer "_")
      ruta_paquete <- file.path(directorio, nombre_archivo)     # Construir la ruta al archivo del paquete
      
      if (!file.exists(ruta_paquete)) {
        cat("Error: No se encontró el paquete", nombre_archivo, "en el directorio especificado.\n")
        return(FALSE)  # Detener la instalación si falta un paquete
      }
      
      # Instalar el paquete
      tryCatch(
               {
                install.packages(
                  ruta_paquete, 
                  repos = NULL, 
                  type = "source",
                  verbose = FALSE,  # Suprimir mensajes detallados
                  quiet = TRUE      # Mostrar advertencias y errores
                )
                
                pMensaje=paste0("El paquete: [", nombre_paquete, "] se instaló correctamente.\n")
                nueva_fila <- data.frame(Resultado = pMensaje)
                df_errores <- rbind(df_errores, nueva_fila)
                cat(pMensaje)
                
              }, error = function(e) {
                                      cat("Error al instalar el paquete", nombre_paquete, ":", e$message, "\n")
                                      return(FALSE)}
              )
      
      # Cargar el paquete
      tryCatch({
        library(nombre_paquete)
        pMensaje=paste0("El paquete: [", nombre_paquete, "] se cargó correctamente.\n")
        nueva_fila <- data.frame(mensaje = pMensaje)
        df_errores <- rbind(df_errores, nueva_fila)
        cat(pMensaje)

      }, error = function(e) {
        #cat("Error al cargar el paquete", nombre_paquete, ":", e$message, "\n")
        #return(FALSE)  # Detener la instalación si hay un error
      })
    }

    tiempo_fin <- Sys.time()
    tiempo_transcurrido_seg <- difftime(tiempo_fin, tiempo_inicio, units = "secs")
    
    # Convierte a minutos y segundos
    minutos  <- floor(as.numeric(tiempo_transcurrido_seg) / 60)
    segundos <- round(as.numeric(tiempo_transcurrido_seg) %% 60)
    
    # Formatea el mensaje con el tiempo transcurrido
    mensaje_tiempo <- paste("Proceso completado en", minutos, "minutos y", segundos, "segundos")
    df_tiempo      <- data.frame(Resultado = c("----------",mensaje_tiempo))
    
    df_errores <- rbind(df_errores, df_tiempo)
    return(df_errores)

  }
  