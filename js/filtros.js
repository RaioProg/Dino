const filtrosButton = document.getElementById('boton');
const panelFiltros = document.getElementById('panel-filtros');
const limpiarFiltrosButton = document.getElementById('aplicar-filtros');

filtrosButton.addEventListener('click', () => {
    if (panelFiltros.classList.contains('oculto')) {
        panelFiltros.classList.remove('oculto');
        filtrosButton.classList.add('oculto');
    }
});

limpiarFiltrosButton.addEventListener('click', () => {
    const checkboxes = panelFiltros.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach(checkbox => {
        checkbox.checked = false;
    });
    panelFiltros.classList.add('oculto');
    filtrosButton.classList.remove('oculto');
});