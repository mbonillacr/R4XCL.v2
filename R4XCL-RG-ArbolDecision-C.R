#+++++++++++++++++++++++++++++++++++++++++++++++++++++++    
# ARBOLES DE DECISION POR CELDA                        +
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++

AD_ArbolDeDecision.C <- function(
                                 SetDatosY, 
                                 SetDatosX,
                                 Categorica=0,
                                 Escala=0,
                                 Filtro=0,
                                 TipoOutput=0, 
                                 SetDatosPredecir=NULL
                                 )
{
  
  #-------------------------->>>
  # VALIDACIONES
  #-------------------------->>>
  
  # if (missing(SetDatosX)) {
  #   stop("Error: SetDatosX es un parámetro obligatorio.")
  # }
  # if (missing(SetDatosY)) {
  #   stop("Error: SetDatosY es un parámetro obligatorio.")
  # }
  # if (!is.data.frame(SetDatosX)) {
  #   stop("Error: SetDatosX debe ser un data frame.")
  # }
  # if (!is.data.frame(SetDatosY)) {
  #   stop("Error: SetDatosY debe ser un data frame.")
  # }
  # if (!is.numeric(Categorica) || Categorica < 0 || Categorica > 1) {
  #   stop("Error: Categorica debe ser 0 o 1.")
  # }
  # if (!is.numeric(Escala) || Escala < 0 || Escala > 1) {
  #   stop("Error: Escala debe ser 0 o 1.")
  # }
  # if (!is.numeric(TipoOutput) || TipoOutput < 0 || TipoOutput > 8) {
  #   stop("Error: TipoOutput debe ser un número entre 0 y 8.")
  # }
  # if (!is.null(SetDatosPredecir) &&!is.data.frame(SetDatosPredecir)) {
  #   stop("Error: SetDatosPredecir debe ser un data frame.")
  # }
  # 
  #-------------------------->>>
  # PREPARACION DE DATOS Y PARAMETROS
  #-------------------------->>>
  
  library(rpart)
  library(rpart.plot)
  require(svDialogs)
  
  #-------------------------->>>   
  # [1] PREPARACION DE DATOS Y PARAMETROS  
  #-------------------------->>>  
  
  FX <- R4XCL_INT_FUNCION(SetDatosX,SetDatosY)
  especificacion <- eval(parse(text=FX))
  
  Procedimientos <- R4XCL_INT_PROCEDIMIENTOS()
  
  Datos <- R4XCL_INT_DATOS(
                          SetDatosX  = SetDatosX,
                          SetDatosY  = SetDatosY, 
                          Escala     = Escala,
                          Filtro     = Filtro,
                          Categorica = Categorica
                          )
  
  #-------------------------->>> 
  # [2] PROCEDIMIENTO ANALITICO
  #-------------------------->>> 
  
  Modelo <- rpart(especificacion, data=Datos)
  Y_Pred <- predict(Modelo)
  
  #-------------------------->>> 
  # [3] PREPARACION DE RESULTADOS
  #-------------------------->>> 
  
  if (TipoOutput <= 0){
    
    OutPut <- Procedimientos$ARBOLES
    
  } else if (TipoOutput == 1){  
    
    suppressMessages(rpart.plot(Modelo))
    
    OutPut <- "Ver Gráfico"
    
  }else if(TipoOutput == 2){   
    
    OutPut <- Modelo$split  
    
  }else if(TipoOutput == 3){   
    
    OutPut <- Modelo$csplit  
    
  }else if(TipoOutput == 4){   
    
    OutPut <- Modelo$cptable
    
  }else if(TipoOutput == 5){   
    
    OutPut <- Modelo$frame   
    
  }else if(TipoOutput == 6){   
    
    OutPut <- Modelo$where    
    
  }else if(TipoOutput == 7){   
    
    a <- c("minsplit",Modelo$control$minsplit)
    b <- c("minbucket",Modelo$control$minbucket)
    c <- c("cp",Modelo$control$cp)
    d <- c("maxcompete",Modelo$control$maxcompete)
    e <- c("maxsurrogate",Modelo$control$maxsurrogate)
    f <- c("surrogatestyle",Modelo$control$surrogatestyle)
    g <- c("maxdepth",Modelo$control$maxdepth)
    h <- c("xval",Modelo$control$xval)
    
    OutPut <- rbind(a,b,c,d,e,f,g,h)
    
  }else if(TipoOutput == 8){ 
    
    if(missing(SetDatosPredecir)){
      
          OutPut <- data.frame("R4XCL_PrediccionDentroDeMuestra"= Y_Pred)
      
    }else{
      
          DT <- R4XCL_INT_DATOS(SetDatosPredecir)
          DT <- data.frame(DT)
          P  <- ncol(DT)
          N  <- nrow(DT)
          Datos <- tidyr::unnest(DT, c(1:P))
          
          A <- predict(Modelo, newdata = Datos, type = "matrix")
          OutPut <- data.frame("R4XCL_PrediccionFueraDeMuestra"= A)
          
          }  
    
  }else if(TipoOutput > 8){   
    
    OutPut <- "Revisar parámetros disponibles" 
    
  }  
  
  #-------------------------->>>
  # RESULTADO FINAL
  #-------------------------->>>

  return(OutPut)
  
}

DialogosXCL=R4XCL_INT_DIALOGOS()

attr(AD_ArbolDeDecision.C, DialogosXCL$Descripcion) = 
  list(
       Detalle          = DialogosXCL$Detalle,
       SetDatosY        = DialogosXCL$SetDatosY, 
       SetDatosX        = DialogosXCL$SetDatosX,
       Categorica       = DialogosXCL$Categorica,
       Filtro           = DialogosXCL$Filtro,
       TipoOutput       = DialogosXCL$TipoOutput,
       SetDatosPredecir = DialogosXCL$SetDatosPredecir
       )