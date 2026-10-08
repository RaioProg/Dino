// Este archivo solo cambia entre el formulario de login y el de registro.
// Los datos se envían y se comprueban en PHP.

const btnLogin = document.getElementById("btn-login");
const btnRegistro = document.getElementById("btn-registro");
const formLogin = document.getElementById("form-login");
const formRegistro = document.getElementById("form-registro");

function mostrarLogin() {
  formLogin.classList.remove("oculto");
  formRegistro.classList.add("oculto");
  btnLogin.classList.add("activa");
  btnRegistro.classList.remove("activa");
}

function mostrarRegistro() {
  formRegistro.classList.remove("oculto");
  formLogin.classList.add("oculto");
  btnRegistro.classList.add("activa");
  btnLogin.classList.remove("activa");
}

btnLogin.addEventListener("click", mostrarLogin);
btnRegistro.addEventListener("click", mostrarRegistro);


formRegistro.addEventListener("submit", function (event) {
  const password = document.getElementById("registro-password").value;
  const passwordRepetida = document.getElementById("registro-repetir").value;
  const labelNoCoinciden = document.getElementById("label-no-coinciden");

  if (password !== passwordRepetida) {
    event.preventDefault(); // evita que se envíe
    labelNoCoinciden.classList.remove("oculto"); // muestra el error
  } else {
    labelNoCoinciden.classList.add("oculto"); // oculta el error si ya coinciden
  }
});

const params = new URLSearchParams(location.search);
if (params.get('error') === 'login') alert('Usuario o contraseña incorrectos');
if (params.get('error') === 'registro') {
  mostrarRegistro();
  alert('No se pudo crear la cuenta (el usuario ya existe o faltan datos)');
}