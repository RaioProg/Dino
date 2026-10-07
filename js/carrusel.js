const carrusel = document.querySelector('.carrusel');
const diapositivas = [...carrusel.querySelectorAll('.diapositiva')];
const contenedorPuntos = carrusel.querySelector('.puntos');
const INTERVALO = 5000; // milisegundos entre diapositivas

let actual = 0;
let temporizador = null;

// Crear un punto por diapositiva
const puntos = diapositivas.map((_, i) => {
    const punto = document.createElement('button');
    punto.type = 'button';
    punto.className = 'punto';
    punto.setAttribute('aria-label', `Ir a la novedad ${i + 1}`);
    punto.addEventListener('click', () => ir(i));
    contenedorPuntos.appendChild(punto);
    return punto;
});

function ir(indice) {
    actual = (indice + diapositivas.length) % diapositivas.length;
    diapositivas.forEach((d, i) => {
        d.classList.toggle('activa', i === actual);
        d.setAttribute('aria-hidden', i !== actual);
    });
    puntos.forEach((p, i) => p.classList.toggle('activo', i === actual));
}

function iniciar() {
    // Respeta a quien tiene desactivadas las animaciones
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    detener();
    temporizador = setInterval(() => ir(actual + 1), INTERVALO);
}

function detener() {
    clearInterval(temporizador);
}

carrusel.querySelector('.anterior').addEventListener('click', () => { ir(actual - 1); iniciar(); });
carrusel.querySelector('.siguiente').addEventListener('click', () => { ir(actual + 1); iniciar(); });

// Pausar mientras el ratón o el teclado están dentro
carrusel.addEventListener('mouseenter', detener);
carrusel.addEventListener('mouseleave', iniciar);
carrusel.addEventListener('focusin', detener);
carrusel.addEventListener('focusout', iniciar);

ir(0);
iniciar();