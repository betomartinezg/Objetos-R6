#~ #~  it uses the encapsulated OOP paradigm, which means that methods
#~ #~  belong to objects, not generics, and you call them like
#~ #~  object$method().


#~ #~  R6 objects are mutable, which means that they are modified in
#~ #~  place, and hence have reference semantics.

#~  install.packages("R6")

library(R6)

#~ Clases y métodos
#~ Los dos argumentos más importantes para R6Class():

#~  1) classname: no es estrictamente necesario, pero mejora los mensajes de error y permite utilizar objetos R6 con genéricos S3. Por convención, las clases R6 tienen UpperCamelCasenombres.

#~  2)  public: proporciona una lista de métodos (funciones) y campos (cualquier otra cosa) que componen la interfaz pública del objeto. Los métodos pueden acceder a los métodos y campos del objeto actual a través de self$.



Accumulator <- R6Class("Accumulator", list(              #definir la clase "R6" o lista de metodos
  sum = 0,                                               #elementos de la clase
  add = function(x = 1) {                                #metodo proporcionado dentro de la clase
    self$sum <- self$sum + x 
    invisible(self)
  })
)



Accumulator


#~ construir un nuevo objeto de la clase mediante new(). En R6, los métodos pertenecen a los objetos, por lo que se utiliza $para acceder a new():


x <- Accumulator$new() 

x


#~ #~  mediante $ se accede a los campos.

x$add(0)


#~ en esta clase, los campos y métodos son públicos, lo que significa que puede obtener o establecer el valor de cualquier campo. 

#~  "Método de encadenamiento"

#~ $add()se llama principalmente por su efecto secundario de la actualización $sum

Accumulator <- R6Class("Accumulator", list(
  sum = 0,
  add = function(x = 1) {
    self$sum <- self$sum + x 
    invisible(self)
  })
)



#~ Los métodos de efectos secundarios R6 siempre deben volver self invisiblemente. Esto devuelve el objeto "actual" y permite encadenar varias llamadas a métodos:


x                                  #el valor inicial es igual a 0


x$add(10)                          #al llamar el argumento "$" add y a�adirle 10 x toma un nuevo valor
x

x$add(10)$add(10)                  #se le a�adio al argumento 20 mas, evidensiandose que al llamar el argumento y la funcion implicita, y darle nuevos valores estos seran acumlativos

x
x$add(10)$add(10)$sum              

x

#~ #~ #~  Hay dos métodos importantes que deben definirse para la mayor�?a de las clases: $initialize()y $print()

#~  $initialize() anula el comportamiento predeterminado de $new()

Person <- R6Class("Person", list(
  name = NULL,
  age = NA,
  initialize = function(name, age = NA) {                        #para anular el comportamiento de una classe
    stopifnot(is.character(name), length(name) == 1)
    stopifnot(is.numeric(age), length(age) == 1)
    
    self$name <- name
    self$age <- age
  }
))

hadley <- Person$new("Hadley", age = "thirty-eight")
#~ > Error in .subset2(public_bind_env, "initialize")(...): is.numeric(age) is
#~ > not TRUE

hadley <- Person$new("Hadley", age = 38)


hadley

#~ #~  $print() permite anular el comportamiento de impresión predeterminado.  $print()deber�?a regresar invisible(self).

Person <- R6Class("Person", list(
  name = NULL,
  age = NA,
  initialize = function(name, age = NA) {
    self$name <- name
    self$age <- age
  },
  print = function(...) {
    cat("Person: \n")
    cat("  Name: ", self$name, "\n", sep = "")
    cat("  Age:  ", self$age, "\n", sep = "")
    invisible(self)
  }
))

hadley2 <- Person$new("Hadley")                        #se agrego "Hadley" como nuevo elemento del argumento
hadley2
hadley2$print                                           #"print" nos permite observar la estructura y el entorno del nuevo elemento en la funcion de la clase
hadley2$print()                                          #"print()" nos permite observar el elemento asignado al argumento y "Age" que hasta el momento no se le fue asignado nada

#~ Agregar métodos después de la creación
#~ En lugar de crear continuamente nuevas clases, también es posible modificar los campos y métodos de una clase existente. Esto es útil cuando explora interactivamente o cuando tiene una clase con muchas funciones que le gustar�?a dividir en pedazos. 


Accumulator <- R6Class("Accumulator")

Accumulator$set("public", "sum", 0)
Accumulator$set("public", "add", function(x = 1) {
  self$sum <- self$sum + x 
  invisible(self)
})


#~ #~  herencia

#~ Para heredar el comportamiento de una clase existente, proporcione el objeto de clase al argumento inherit 



AccumulatorChatty <- R6Class("AccumulatorChatty", 
                             inherit = Accumulator,                                          #argumento para heredad
                             public = list(
                               add = function(x = 1) {
                                 cat("Adding ", x, "\n", sep = "")
                                 super$add(x = x)
                               }
                             )
)


x2 <- AccumulatorChatty$new()

x2

x2$add(10)

x2$add(10)$add(1)$sum

x2


#~ Cada objeto R6 tiene una clase S3 que refleja su jerarqu�?a de clases R6. Esto significa que la forma más fácil de determinar la clase (y todas las clases de las que hereda) es usar class():

hadley
class(hadley)

names(hadley)

hadley2
class(hadley2)

names(hadley2)

