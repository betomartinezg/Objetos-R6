#######################################
#####     TAREA DE  R6      ###########
#######################################

# Ejercicio 1. Cree una clase de cuenta bancaria R6 que almacene un saldo y le permita depositar y retirar dinero. Cree una subclase que arroje un error si intenta entrar en sobregiro. Cree otra subclase que le permita entrar en sobregiro, pero le cobra una tarifa.


cuentabancaria<-R6Class("cuentabancaria", list(                          ####se creo una clase de cuenta bancaria con un saldo almacenado
  suma = 650000,
  deposito =function(dep=0) {
    self$suma <- self$suma + dep
     invisible(self)},
  retiro= function(retirar){
    self$suma = self$suma - retirar
    invisible(self)
  }
  ))


x<-cuentabancaria$new()                                             #####luego a un objeto x se le asigno la clase de cuenta bancaria  permitiendonos sumarle o restarle al saldo almacenado

x$suma


x$deposito(10000)$retiro(20000)$suma                            ####se le añade 100000 a la cuenta con un total de 750000

Sobregiro<-R6Class("sobregiro",
  inherit = cuentabancaria,
   public = list(
     retiro=function(retirar=0){
       if ( self$suma - retirar<0){
         stop("su 'retiro' debe ser menor" ," que su 'suma'.", call. = FALSE)
       }
       insuficiente$retiro(retirar = retirar)
     } 
  ))
              
minuevoretiro<-Sobregiro$new()
minuevoretiro$suma

minuevoretiro$deposito(10000)$retiro(700000)


giro_cobro<-R6Class("cuentabancaria",
    inherit =  cuentabancaria,
    public = list(
      retiro = function(retirar=0){
        if(self$suma - retirar < 0){
          retirar<- retirar + 10000
        }
          super$retiro(retirar = retirar)
      }
    ))                     

costo_sobregiro<-giro_cobro$new()
costo_sobregiro$suma

costo_sobregiro$
  retiro(700000)
  
costo_sobregiro$suma


# Ejercicio 2. Cree una clase (parquedero) R6 que almacene diferentes vehiculos y le permita  diferencar motocicletas y automoviles. Cree una subclase para diferenciar el cobro por tipo de vehiculo y otra por la cantidad de tiempo. Adicione otra clase "dia" y finalemente presente los ingresos mensueales.


parqueadero <- R6Class("parqueadero", list(
  motocicleta = NA,
  automoviles = NULL,
  initialize = function(automoviles, motocicleta=NA) {
    stopifnot(is.character(automoviles), length(motocicleta) == 1)
    stopifnot(is.numeric(motocicleta), length(automoviles) == 3)
    
    self$motocicleta <- motocicleta
    self$automoviles <- automoviles
  }
))

ingreso<-parqueadero$new(c("toyota","hyundai","chevrolet"), 54)
ingreso


cobro_parqueo<-R6Class("parqueadero", 
      inherit = parqueadero,
       public =  list(                     
  motocicleta = 2000,
  automoviles = "x",
   x =  function(dep=0) {
    self$motocicleta<- self$motocicleta + 1500
    invisible(self)},
  cobro = function(cobrar){
    self$motocicleta = self$motocicleta+1500
    invisible(self)
  }
))

z<-cobro_parqueo$new()


cobro_parqueo<-R6Class("parqueadero", 
  inherit = parqueadero,
  public = list(
  motocicleta = 2000,
  automoviles = "x",
   "x" = function(dep=0) {
    self$motocicleta <- self$motocicleta + 4000
    invisible(self)}
))

z<-cobro_parqueo$new()



cobro_parqueo<-R6Class("parqueadero",
                    inherit =  parqueadero,
                    public = list(
                      cobro = function(retirar=0){
                        if(self$automoviles = ""){
                          retirar<- 10000
                        }
                        super$cobro(retirar = retirar)
                      }
                    ))                     
