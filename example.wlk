
// ------- VAGONES ---------

class Vagon {
  var tipo // instancia de VagonConPasajeros o VagonDeCarga


  method pesoMaximo() = tipo.pesoMaximo()
  method esLiviano() = self.pesoMaximo() < 2500

  method capacidadPasajeros() = tipo.capacidadPasajeros()
}


class VagonConPasajeros {
  var largo
  var ancho

  method capacidadPasajeros() {
    if (ancho <= 2.5){
      return largo * 8
    }else{
      return largo * 10
    }
  
  }

  method pesoMaximo() {
    return self.capacidadPasajeros() * 80
  }
  //method tieneCapacidadPasajeros() = true
}


class VagonDeCarga {
  var cargaMaxima

  method pesoMaximo() { 
    return cargaMaxima + 160
  }

  // esta medio mal igual
  method capacidadPasajeros() = 0
  //method tieneCapacidadPasajeros() = false
}


// ------- LOCOMOTORAS ---------
class Locomotora{
  var peso
  var pesoMaximoDeArrastre
  var velocidadMaxima

  method arrastreUtil() {
    return pesoMaximoDeArrastre - peso
  }
}

// ------- FORMACIONES -------

class Formacion{
  var locomotoras = []
  var vagones = []

    //Agregar a uns lista
  method agregarVagon(vagon) {
    vagones.add(vagon)
  }
    
  method agregarLocomotora(locomotora) {
    locomotoras.add(locomotora)
  }

    //PUNTO 3 -> Cant vagones de una formacion (tamaño de una lista)
  method cantidadDeVagones() {
    return vagones.size()
  }
    //PUNTO 4 -> Total de pasajeros que puede transportar una formacion 
  method totalPasajeros() {
  // suma solo los que tienen capacidad de pasajeros
    return vagones.map(v -> v.capacidadPasajeros())
                  .sum(x -> x)
  }

    // cuántos vagones cumplen esLiviano
  method cantidadDeVagonesLivianos() {
    return vagones.count(unVagon -> unVagon.esLiviano())
  }

  // PUNTO 6: velocidad máxima de la formación
  method velocidadMaxima() {
    return locomotoras.min(unaLocomotora -> unaLocomotora.velocidadMaxima)
  }

  // PUNTO 7 --> es eficiente si cada locomotora arrastra >= 5 * su peso
  method esEficiente() {
    return locomotoras.forAll(unaLocomotora -> unaLocomotora.arrastreUtil() >= unaLocomotora.peso * 5)
  }

  // PUNTO 8 --> si arrastre útil total >= peso total de vagones ==> puede moverse
  method puedeMoverse() {
    return self.arrastreUtilTotal() >= self.pesoTotalDeVagones()
  }

  method arrastreUtilTotal() {
    locomotoras.sum(unaLocomotora -> unaLocomotora.arrastreUtil()) 
  }

  method pesoTotalDeVagones(){
    vagones.sum(unVagon -> unVagon.pesoMaximo())
  }

  // PUNTO 9 --> kilos de empuje que faltan
  method kilosFaltantesDeEmpuje() {
    return (self.pesoTotalDeVagones() - self.arrastreUtilTotal())
  }


 // para el punto 10 que pide una formacion con cada vagon mas pesado
  method vagonMasPesado() {
    return vagones.max(unVagon -> unVagon.pesoMaximo())
  }

  //si una formacion es compleja, tambien para punto 11 (deposito)
  method esCompleja() {
    return (locomotoras.size() + vagones.size() > 20) || (self.pesoTotal() > 10000)
  }

  // El peso total (sumando locomotoras y vagones) 
  method pesoTotal(){
    return self.pesoTotalDeVagones() + self.pesoTotalLocomotoras()
  } 

  method pesoTotalLocomotoras() {
     locomotoras.sum(unaLocomotora -> unaLocomotora.peso)
  }
  
}

// ------- DEPOSITO -------

class Deposito{
  var formaciones = [] //ya armadas
  var locomotorasSueltas = {}

    // PUNTO 10 --> conjunto formado por el vagón más pesado de cada formación
    method vagonesMasPesados() {
        return formaciones.map(unaFormacion -> unaFormacion.vagonMasPesado())
    }

  // PUNTO 11 --> necesita uno si ALGUNA de las formaciones es compleja
  method conductorExperimentado() {
    return formaciones.any(unaFormacion -> unaFormacion.esCompleja())
  }


    // PUNTO 12 --> agregar locomotora si una formacion (determinada) no puede moverse
    // solo agregar (una locomotora suelta) si su arrastre útil es  >= a los kilos de empuje que le faltan a la formación.
  method agregarLocomotoraA(unaFormacion) {
    if (not unaFormacion.puedeMoverse()) {

      var kilosFaltantes = unaFormacion.kilosFaltantesDeEmpuje()
      var locomotoraAdecuada =locomotorasSueltas.find(unaLocomotora -> unaLocomotora.arrastreUtil() >= kilosFaltantes)
      if (locomotoraAdecuada != null) {
        unaFormacion.agregarLocomotora(locomotoraAdecuada)
      }
    }
  }
}



const vagon1 = new Vagon(tipo = new VagonConPasajeros(largo = 9, ancho = 5))
const vagon2 = new Vagon(tipo = new VagonDeCarga(cargaMaxima = 10000))
const vagon3 = new Vagon(tipo = new VagonConPasajeros(largo = 8, ancho = 5))
const vagon4 = new Vagon(tipo = new VagonDeCarga(cargaMaxima = 8000))

const locomotora1 = new Locomotora(peso = 80, pesoMaximoDeArrastre = 6000, velocidadMaxima = 120)
const locomotora2 = new Locomotora(peso = 90, pesoMaximoDeArrastre = 7000, velocidadMaxima = 110)


const formacion1 = new Formacion(locomotoras = [locomotora1], vagones = [vagon1, vagon2])
const formacion2 = new Formacion(locomotoras = [locomotora2], vagones = [vagon3, vagon4])

const deposito1 = new Deposito(formaciones = [formacion1, formacion2], locomotorasSueltas = #{locomotora2})





