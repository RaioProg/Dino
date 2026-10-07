const CLAVE = 'dinofusion_coleccion';
const CARTAS_POR_SOBRE = 5;

// nombres de los dinosaurios que ya tiene el jugador
let coleccion = JSON.parse(localStorage.getItem(CLAVE) || '[]');

function abrirSobre(periodo) {
    // CAMBIA: DINOS por el nombre real del array de datos.js
    const pool = DINOS.filter(d => d.periodo === periodo);
    const sacadas = [];

    for (let i = 0; i < CARTAS_POR_SOBRE; i++) {
        sacadas.push(pool[Math.floor(Math.random() * pool.length)]);
    }

    sacadas.forEach(d => {
        if (!coleccion.includes(d.nombre)) coleccion.push(d.nombre);
    });
    localStorage.setItem(CLAVE, JSON.stringify(coleccion));

    mostrarReveladas(sacadas);
    pintarColeccion();
}

function mostrarReveladas(cartas) {
    document.getElementById('carta-revelada-info').innerHTML = cartas.map(htmlCarta).join('');
    
}

function pintarColeccion() {
    const tengo = DINOS.filter(d => coleccion.includes(d.nombre));
    document.querySelector('.lista-coleccion').innerHTML = tengo.map(htmlCarta).join('');
    document.querySelector('#titulo-coleccion').textContent = `Mi colección (${tengo.length})`;
}

// CAMBIA: .sobre por la clase real de cada sobre
document.querySelectorAll('.sobre').forEach(sobre => {
    sobre.addEventListener('click', () => abrirSobre(sobre.dataset.periodo));
});

pintarColeccion(); // al cargar la página

