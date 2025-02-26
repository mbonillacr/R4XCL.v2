#+++++++++++++++++++++++++++++++++++++++++++++++++++++++    
# Graficacion                                          +
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++

GR_Graficos.D <- function(
                          SetDatosY,
                          SetDatosX, 
                          Categorica=1
                         )
  {

  #-------------------------->>>
  # VALIDACIONES
  #-------------------------->>>
  # if (missing(SetDatosX)) {
  #   stop("Error: SetDatosX es un parámetro obligatorio.")
  # }
  # if (!is.data.frame(SetDatosX)) {
  #   stop("Error: SetDatosX debe ser un data frame.")
  # }
  # if (!missing(SetDatosY) &&!is.data.frame(SetDatosY)) {
  #   stop("Error: SetDatosY debe ser un data frame.")
  # }
  
  #-------------------------->>>
  # PREPARACION DE DATOS Y PARAMETROS
  #-------------------------->>>
  
  library(svDialogs)

  #-------------------------->>>   
  # [1] PREPARACION DE DATOS Y PARAMETROS  
  #-------------------------->>>  

  FX <- R4XCL_INT_FUNCION(
                          SetDatosX,
                          SetDatosY
                          )

  DT <- R4XCL_INT_DATOS(
                        SetDatosY=SetDatosY,                   
                        SetDatosX=SetDatosX,
                        Categorica=Categorica
                        )
  
  Procedimientos<-R4XCL_INT_PROCEDIMIENTOS()
  
  
  especificacion <- eval(parse(text=FX))
  
  #-------------------------->>> 
  # [2] PROCEDIMIENTO ANALITICO
  #-------------------------->>> 

  
  #-------------------------->>> 
  # [3] PREPARACION DE RESULTADOS
  #-------------------------->>> 
  
  A <- dlg_list(Procedimientos$GRAFICA)
  TipoOutput=A$res
  
  if (TipoOutput == Procedimientos$GRAFICA[1]){

    BERT.graphics.device(cell=T);

      cols <- rainbow(3, s = 0.5)
      
       boxplot(
               especificacion, 
               data = DT,
               col = cols
               )
        legend(
               "topleft", 
               fill = cols, 
               legend = c(1,2,3), 
               horiz = T
               )
      
      dev.off();
      
    OutPut  = "Ver Gráfico"   
    
  } else if (TipoOutput == Procedimientos$GRAFICA[2]){
    
    OutPut  = "EN PROCESO"   
    
  } else if (TipoOutput == Procedimientos$GRAFICA[3]){   
    
    OutPut  <- "EN PROCESO"   
    
  } else if (TipoOutput == Procedimientos$GRAFICA[4]){
    
    OutPut  <- "EN PROCESO"   
    
  } else if (TipoOutput == Procedimientos$GRAFICA[5]){
    
    OutPut  <- "EN PROCESO"   
    
  } else if (TipoOutput == Procedimientos$GRAFICA[6]){
    
    OutPut  <- "EN PROCESO"   
    
  } else if (TipoOutput == Procedimientos$GRAFICA[7]){    
    
    OutPut  <- "EN PROCESO"   
  
  } else if (TipoOutput == Procedimientos$GRAFICA[8]){ 
    
    OutPut  <- "EN PROCESO"   
    
  } else if (TipoOutput == Procedimientos$GRAFICA[9]){ 

    OutPut  <- "EN PROCESO"   

  } 
  #_________________________________________________________________   
  # [4] RESULTADO FINAL
  #_________________________________________________________________
  
  return(OutPut)
  
}

DialogosXCL <- R4XCL_INT_DIALOGOS()
attr(GR_Graficos.D, DialogosXCL$Descripcion) = 
  list(
        Detalle     = DialogosXCL$Detalle.KM,
        SetDatosX   = DialogosXCL$SetDatosX.NS,
        Escala      = DialogosXCL$Escala,
        Filtro      = DialogosXCL$Filtro,
        K           = DialogosXCL$K,
        Koptimo     = DialogosXCL$Koptimo,
        Semilla     = DialogosXCL$Semilla,
        TipoModelo  = DialogosXCL$TipoModelo.KM
      )