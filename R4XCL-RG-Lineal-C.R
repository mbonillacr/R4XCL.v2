#+++++++++++++++++++++++++++++++++++++++++++++++++++++++
# MODELO LINEAL
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++

MR_Lineal.C <- function(
    SetDatosY, 
    SetDatosX,
    Categorica=0,
    Escala=0,
    Filtro=0,
    SetDatosPredecir=NULL,
    Constante=1,
    TipoOutput=1,
    Ponderadores = NULL
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
  # if (!is.null(SetDatosPredecir) &&!is.data.frame(SetDatosPredecir)) {
  #   stop("Error: SetDatosPredecir debe ser un data frame.")
  # }
  # if (!is.numeric(Constante) || Constante < 0 || Constante > 1) {
  #   stop("Error: Constante debe ser 0 o 1.")
  # }
  # if (!is.numeric(TipoOutput) || TipoOutput < 0 || TipoOutput > 12) {
  #   stop("Error: TipoOutput debe ser un número entre 0 y 12.")
  # }
  # if (!is.null(Ponderadores) &&!is.vector(Ponderadores)) {
  #   stop("Error: Ponderadores debe ser un vector.")
  # }
  
  #-------------------------->>>
  # PREPARACION DE DATOS Y PARAMETROS
  #-------------------------->>>
  
  library(stargazer)
  #library(margins)
  
  #-------------------------->>>   
  # [1] PREPARACION DE DATOS Y PARAMETROS  
  #-------------------------->>>  
  
  FX <- R4XCL_INT_FUNCION(SetDatosX,SetDatosY)

  Procedimientos <- R4XCL_INT_PROCEDIMIENTOS()
  
  if (Constante==0){FX=paste0(FX,"-1")}
  
  DT <- R4XCL_INT_DATOS(
                        SetDatosY=SetDatosY,                   
                        SetDatosX=SetDatosX,
                        Escala=Escala,
                        Filtro=Filtro,
                        Categorica=Categorica,
                        Ponderadores = Ponderadores
                      )

  P  <- ncol(DT)
  
  especificacion <- eval(parse(text=FX))
  
  #-------------------------->>> 
  # [2] PROCEDIMIENTO ANALITICO
  #-------------------------->>> 
  
  Modelo <- lm(
              formula = especificacion, 
              data = DT,
              weights = PESOS
              )
  
  Y_Pred <- Modelo$fitted.values
  
  #-------------------------->>> 
  # [3] PREPARACION DE RESULTADOS
  #-------------------------->>> 
  
  if (TipoOutput <= 0){
    
    OutPut = Procedimientos$LINEAL
    
  } else if (TipoOutput == 1){  
    
    OutPut <- data.frame("R4XCL_ModeloEstimado"= stargazer(Modelo, type="text", ci=TRUE, ci.level=0.95,single.row=TRUE))
    
  }else if(TipoOutput == 2){
    
    OutPut <- data.frame("R4XCL_PrediccionDentroDeMuestra"= Y_Pred)
    
  }else if(TipoOutput == 3){ 
    
    if(missing(SetDatosPredecir))
      
    {OutPut <- data.frame("R4XCL_PrediccionDentroDeMuestra"= Y_Pred)
    
    }else{
      
      p        <- ncol(SetDatosPredecir)
      nombresX <- paste0(SetDatosX[1,1:p])
      
      SetDatosPredecir <- SetDatosPredecir[-1,]
      SetDatosPredecir <- matrix(as.numeric(SetDatosPredecir), nrow=nrow(SetDatosPredecir)-1, ncol=p)
      SetDatosPredecir <- data.frame(SetDatosPredecir)
      
      colnames(SetDatosPredecir)[1:p]=nombresX[1:p]
      
      A <- predict(Modelo, newdata = SetDatosPredecir)
      OutPut <- data.frame("R4XCL_PrediccionFueraDeMuestra"= A)
      
    }
    
  }else if(TipoOutput == 4){
    
    OutPut <- sapply(marginal_effects(Modelo, DT),mean)
    OutPut <- data.frame("R4XCL_EfectosMarginales"= capture.output(OutPut))
    
  }else if(TipoOutput == 5){  
    
    require(usdm)
    OutPut <- usdm::vif(DT[,-1]) 
    OutPut <- data.frame("R4XCL_InflacionDeVarianza"= OutPut)
    
  }else if(TipoOutput == 6){  
    
    OutPut <- lmtest::bptest(Modelo) 
    OutPut <- data.frame("R4XCL_Heterocedasticidad"=capture.output(OutPut))    
    
  }else if(TipoOutput == 7){    
    
    cov <- sandwich::vcovHC(Modelo, type = "HC")
    
    robust.se <- sqrt(diag(cov))
    
    OutPut <- stargazer(Modelo, Modelo, 
                     se=list(NULL, robust.se),
                     column.labels=c("OLS","OLS E.S. Robusto"), 
                     type="text",
                     align=TRUE);  
    
  }else if(TipoOutput == 8){ 
    
    A <- influence.measures(Modelo)
    OutPut <- data.frame("R4XCL_ObservacionesDeInfluencia"=A$is.inf)
    
  }else if(TipoOutput == 9){ 
    
    OutPut <- R4XCL_INT_INFO_EJECUCION(FX, DT)  
    
  }else if(TipoOutput == 10){ 
    
    ListaM <- c(Modelo)
    ListaN <- c("LINEAL")
    OutPut <- R4XCL_INT_CREARDS(ListaM,ListaN)
    
  } else if (TipoOutput == 11){  
    
    OutPut <- data.frame("R4XCL_ModeloEstimado"= capture.output(summary(Modelo)))
    
  } else if (TipoOutput == 12){  
    
    OutPut <- data.frame("R4XCL_Residuos"= resid(Modelo))    
    
  }else if(TipoOutput > 12){   
    
    OutPut <- "Revisar par?metros disponibles" 
    
  }  
  
  #-------------------------->>> 
  # [4] RESULTADO FINAL
  #-------------------------->>> 
  
  return(OutPut);  
}

DialogosXCL <- R4XCL_INT_DIALOGOS()

attr(MR_Lineal.C, DialogosXCL$Descripcion) = 
  
  list(
    Detalle.Lineal  = DialogosXCL$Detalle,
    SetDatosY       = DialogosXCL$SetDatosY,
    SetDatosX       = DialogosXCL$SetDatosX,
    Categorica      = DialogosXCL$Categorica,
    Escala          = DialogosXCL$Escala,
    Filtro          = DialogosXCL$Filtro,
    SetDatosPredecir= DialogosXCL$SetDatosPredecir,
    Constante       = DialogosXCL$Constante,
    TipoOutput      = DialogosXCL$TipoOutput.Lineal,
    Ponderadores    = DialogosXCL$Ponderadores
  )

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++    
# FIN DE PROCEDIMIENTO                                 +
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++