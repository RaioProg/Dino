

let catalogo = [];

async function cargarCatalogo() {
    const res = await fetch('dinos.php');
    if (!res.ok) throw new Error('Error al cargar el catálogo');
    catalogo = await res.json();
}

const PERIODOS = {
    triasico:  { n: 'Triásico',  r: '252–201 M.a.', e: '🌵' },
    jurasico:  { n: 'Jurásico',  r: '201–145 M.a.', e: '🌿' },
    cretacico: { n: 'Cretácico', r: '145–66 M.a.',  e: '🌋' },
};  