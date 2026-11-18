const esc = (t) => String(t ?? "").replace(/[&<>"']/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
const cop = (n) => "$ " + parseFloat(n).toLocaleString();

const cargar = async (tipo, idTbody, columnas, vacio) => {
    const tbody = document.getElementById(idTbody);
    try {
        const res = await fetch(`php/reportes.php?tipo=${tipo}`);
        const data = await res.json();

        if (!data.success) {
            tbody.innerHTML = `<tr><td colspan="${columnas}" class="text-danger">${esc(data.mensaje)}</td></tr>`;
            return;
        }
        if (data.datos.length === 0) {
            tbody.innerHTML = `<tr><td colspan="${columnas}" class="text-muted">${vacio}</td></tr>`;
            return;
        }
        return data.datos;
    } catch (e) {
        tbody.innerHTML = `<tr><td colspan="${columnas}" class="text-danger">Error al cargar el reporte.</td></tr>`;
    }
};

document.addEventListener("DOMContentLoaded", async () => {
    const marcas = await cargar("marcas", "rep-marcas", 5, "Aún no hay publicaciones.");
    if (marcas) {
        document.getElementById("rep-marcas").innerHTML = marcas.map(r => `
            <tr><td>${esc(r.marca)}</td><td>${r.total_publicaciones}</td>
                <td>${cop(r.precio_promedio)}</td><td>${cop(r.precio_minimo)}</td><td>${cop(r.precio_maximo)}</td></tr>`).join("");
    }

    const vendedores = await cargar("vendedores", "rep-vendedores", 3, "Aún no hay vendedores con publicaciones.");
    if (vendedores) {
        document.getElementById("rep-vendedores").innerHTML = vendedores.map(r => `
            <tr><td>${esc(r.nombre)}</td><td>${r.total_publicaciones}</td><td>${r.favoritos_recibidos}</td></tr>`).join("");
    }

    const populares = await cargar("populares", "rep-populares", 6, "Todavía no hay publicaciones con favoritos.");
    if (populares) {
        document.getElementById("rep-populares").innerHTML = populares.map(r => `
            <tr><td>${esc(r.marca)} ${esc(r.modelo)}</td><td>${r.anio}</td><td>${esc(r.precio_formateado)}</td>
                <td>${esc(r.ciudad)}</td><td>${r.total_favoritos}</td>
                <td><a href="detalle.html?id=${r.id}" class="btn btn-primary btn-sm">Ver</a></td></tr>`).join("");
    }
});