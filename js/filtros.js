const btnFiltros = document.getElementById('boton');
const panel = document.getElementById('panel-filtros');

btnFiltros.addEventListener('click', () => {
    panel.classList.remove('oculto');
    btnFiltros.classList.add('oculto');
});

document.getElementById('aplicar-filtros').addEventListener('click', () => {
    renderColeccion();
    panel.classList.add('oculto');
    btnFiltros.classList.remove('oculto');
});

document.getElementById('limpiar-filtros').addEventListener('click', () => {
    document.getElementById('filtro-nombre').value = '';
    panel.querySelectorAll('input[type="checkbox"]').forEach(c => c.checked = false);
    renderColeccion();
});