class Nave{
  var velocidadMaxima = 100000
  var velocidad
  var direccion
  var combustible


  method acelerar(unaCantidad) {
    velocidad = (velocidad + unaCantidad).min(velocidadMaxima)
  }

  method desacelerar(unaCantidad) {
    velocidad = (velocidad - unaCantidad).max(0)
  }

  method irHaciaElSol() {
    direccion = 10
  }

  method escaparDelSol() {
    direccion = -10
  }

  method ponerseParaleloAlSol() {
    direccion = 0
  }

  method acercarseUnPocoAlSol() {
    direccion = (direccion + 1).min(10)
  }

  method alejarseUnPocoDelSol() {
    direccion = (direccion - 1).max(-10)
  }

  method cargarCombustible(unaCantidad) {
    combustible = combustible + unaCantidad

  }
  method descargarCombustible(unaCantidad) {
    combustible = (combustible - unaCantidad).max(0)
  }

  method prepararViaje() 

  method accionAdicional(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method estaTranquila() = combustible >= 4000 && velocidad <= 12000
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  method escapar()
  method avisar()

  method estaDeRelajo() 


}


class NaveBaliza inherits Nave{
  var colorDeBaliza
  var cantidadDeCambiosDeBaliza = 0

  method colorDeBaliza() = colorDeBaliza 

  method cambiarColorDeBaliza(colorNuevo) {
    colorDeBaliza = colorNuevo
    cantidadDeCambiosDeBaliza += 1
  }


  override method prepararViaje() {
    self.accionAdicional()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }

    override method estaTranquila() = super() && colorDeBaliza != "rojo"

  
  override method escapar(){self.irHaciaElSol()} 
  override method avisar(){self.cambiarColorDeBaliza("rojo")}

  override method estaDeRelajo() = cantidadDeCambiosDeBaliza == 0
}

class NavePasajeros inherits Nave{
  const cantidadDePasajeros
  var racionesDeComida
  var racionesDeBebida
  var cantidadTotalDeComidaServida = 0

  method cargarRacionesDeComida(cantidad) {
    racionesDeComida = racionesDeComida + cantidad
    cantidadTotalDeComidaServida = cantidadTotalDeComidaServida + cantidad
  }

  method cargarRacionesDeBebida(cantidad) {
    racionesDeBebida = racionesDeBebida + cantidad
  }

  method descargarRacionesDeComida(cantidad) {
    racionesDeComida = (racionesDeComida - cantidad).max(0)
  }

  method descargarRacionesDeBebida(cantidad) {
    racionesDeBebida = (racionesDeBebida - cantidad).max(0)
  }

  override method prepararViaje() {
    self.accionAdicional()
    self.cargarRacionesDeComida(4 * cantidadDePasajeros)
    self.cargarRacionesDeBebida(6 * cantidadDePasajeros)
    self.acercarseUnPocoAlSol()
  } 

  override method escapar(){
    velocidad = velocidad * 2
  } 

  override method avisar(){
    self.descargarRacionesDeBebida(2 * cantidadDePasajeros)
    self.descargarRacionesDeComida(1 * cantidadDePasajeros)
  }

  override method estaDeRelajo() = cantidadTotalDeComidaServida < 50

}


class NaveCombate inherits Nave{

  const property mensajes = []

  var invisible
  var misilesDesplegados


  method misilesDesplegados() = misilesDesplegados 
  method estaInvisible() = invisible 
  
  method ponerseVisible() {invisible = false}
  method ponerseInvisible() {invisible = true}

  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}
 
  method emitioMensaje(mensaje) = mensajes.contains(mensaje)
  method emitirMensaje(unMensaje){mensajes.add(unMensaje)} 
  method mensajesEmitidos() = mensajes
  method primerMensajeEmitido() = if(self.emitioAlgunMensaje()) mensajes.first()
  method ultimoMensajeEmitido() = if(self.emitioAlgunMensaje()) mensajes.last()
  method esEscueta() = mensajes.all({m => m.length() <= 30})
  method emitioAlgunMensaje() = mensajes.size() > 0

  override method prepararViaje() {
    self.accionAdicional()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")

  }

  override method estaTranquila() = super() && not(misilesDesplegados)

  override method escapar() {
    1 .. 2(self.acercarseUnPocoAlSol())
  }

  override method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }



}

 class NaveHospital inherits NavePasajeros{
   var tieneQuirofanosPreparados

   method tieneQuirofanosPreparados() = tieneQuirofanosPreparados 
   method habilitarQuirofano() {tieneQuirofanosPreparados = true}
   method deshabilitarQuirofano() {tieneQuirofanosPreparados = false}
   override method estaTranquila() = super() && not(tieneQuirofanosPreparados) 
   
   override method recibirAmenaza(){
    super()
    self.habilitarQuirofano()

   }
 }

 class NaveDeCombateSigilosa inherits NaveCombate{

   override method estaTranquila() = super() && not(self.estaInvisible())
  override method escapar(){
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
 }