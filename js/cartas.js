const listaColeccion = document.getElementById('grid');
const contenedorScroll = document.querySelector('.scroll');
const contador = document.getElementById('contador-cartas');

const CARTAS_POR_SOBRE = 5;
let temporizadorReveladas = null;
let temporizadorLimpieza = null;
let coleccion = JSON.parse(localStorage.getItem('coleccion')) || [];

const norm = s => String(s ?? '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
const esc = s => String(s ?? '').replace(/[&<>"']/g, c => (
    { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]
));
const fmt = n => Number(n).toLocaleString('es-ES', { maximumFractionDigits: 2 });

function stat(label, v) {
    return `<div class="stat"><span>${label}</span><div class="bar"><i style="width:${v}%"></i></div><b>${v}</b></div>`;
}

function htmlCarta(d) {
    const per = norm(d.periodo);
    const p = PERIODOS[per] || { n: d.periodo, r: '', e: '🦴' };
    return `<article class="card ${esc(per)}" aria-label="${esc(d.nombre)}, ${esc(p.n)}">
      <div class="inner">
        <div class="top">
          <div><h2>${esc(d.nombre)}</h2><small>${esc(d.especie)}</small></div>
          <div class="hp">❤️ ${d.hp}</div>
        </div>
        <div class="art">
          <div class="ph" aria-hidden="true">🦖</div>
          <img src="${esc(d.imagenUrl)}" alt="${esc(d.nombre)}" loading="lazy" onerror="this.remove()">
          <div class="ribbon">${p.e} ${esc(p.n)} <i>${esc(p.r)}</i></div>
        </div>
        ${d.rol ? `<div class="role">${esc(d.rol)}</div>` : ''}
        <div class="stats">
          ${stat('⚡ Vigor', d.vigor)}${stat('⚔️ Ataque', d.ataque)}${stat('🛡️ Defensa', d.defensa)}${stat('💨 Agilidad', d.agilidad)}
        </div>
        <div class="size">
          <div><strong>${fmt(d.altura)} m</strong>Altura</div>
          <div><strong>${fmt(d.largo)} m</strong>Largo</div>
          <div><strong>${fmt(d.peso)} t</strong>Peso</div>
        </div>
        ${d.frase ? `<p class="tag">${esc(d.frase)}</p>` : ''}
      </div>
    </article>`;
}

function renderColeccion() {
    listaColeccion.innerHTML = coleccion.map(htmlCarta).join('');
    contador.textContent = coleccion.length;
}

function agregarCartas(cartas) {
    coleccion.push(...cartas);
    localStorage.setItem('coleccion', JSON.stringify(coleccion));
    renderColeccion();
    contenedorScroll.scrollTop = contenedorScroll.scrollHeight;
}

function abrirSobre(periodo) {
    const pool = catalogo.filter(c => norm(c.periodo) === norm(periodo));
    if (pool.length === 0) return;

    const mezcla = [...pool];
    for (let i = mezcla.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [mezcla[i], mezcla[j]] = [mezcla[j], mezcla[i]];
    }
    const sacadas = mezcla.slice(0, CARTAS_POR_SOBRE);
    const revelado = document.getElementById('carta-revelada-info');

    // cancelar timers anteriores y volver a mostrar el contenedor
    clearTimeout(temporizadorReveladas);
    clearTimeout(temporizadorLimpieza);
    revelado.classList.remove('oculto');

    revelado.innerHTML = sacadas.map(htmlCarta).join('');

    // a los 5 s: animación de salida; a los 0,6 s más: vaciar
    temporizadorReveladas = setTimeout(() => {
        revelado.classList.add('oculto');
        temporizadorLimpieza = setTimeout(() => {
            revelado.innerHTML = '';
            revelado.classList.remove('oculto');
        }, 600);
    }, 5000);

    agregarCartas(sacadas);
}

async function iniciar() {
    renderColeccion();

    document.querySelector('.central').addEventListener('click', e => {
        const pack = e.target.closest('.pack-wrap');
        if (!pack) return;
        console.log('Sobre:', pack.dataset.periodo, '| cartas en catálogo:', catalogo.length);
        abrirSobre(pack.dataset.periodo);
    });

    try {
        await cargarCatalogo();
    } catch (e) {
        console.error('No se pudo cargar dinos.php:', e);
    }
}

document.addEventListener('DOMContentLoaded', iniciar);

