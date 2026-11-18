const $ = (id) => document.getElementById(id);
const esc = (t) => String(t ?? "").replace(/[&<>"']/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));

let usuariosCache = [];
let miId = 0;

const aviso = (texto, ok) => {
    const el = $("mensaje");
    el.className = "alert " + (ok ? "alert-success" : "alert-danger");
    el.textContent = texto;
    el.style.display = "block";
    window.scrollTo({ top: 0, behavior: "smooth" });
};

const api = async (accion, cuerpo) => {
    const opciones = cuerpo
        ? { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(cuerpo) }
        : {};
    const res = await fetch(`php/admin.php?accion=${accion}`, opciones);
    return res.json();
};

const paneles = ["usuarios", "publicaciones", "auditoria"];
const mostrarPanel = (cual) => {
    paneles.forEach(p => {
        $("panel-" + p).style.display = (p === cual) ? "block" : "none";
        $("tab-" + p).className = "btn " + (p === cual ? "btn-primary" : "btn-outline-primary");
    });
    $("mensaje").style.display = "none";
    if (cual === "usuarios") cargarUsuarios();
    if (cual === "publicaciones") cargarPublicaciones();
    if (cual === "auditoria") cargarAuditoria();
};
paneles.forEach(p => $("tab-" + p).addEventListener("click", () => mostrarPanel(p)));

const limpiarFormulario = () => {
    $("form-usuario").reset();
    $("u-id").value = "";
    $("titulo-form").textContent = "Crear usuario";
    $("btn-guardar-usuario").textContent = "Crear usuario";
    $("grupo-activo").style.display = "none";
    $("grupo-password").style.display = "block";
    $("btn-cancelar").style.display = "none";
};
$("btn-cancelar").addEventListener("click", limpiarFormulario);

const cargarUsuarios = async () => {
    try {
        const data = await api("usuarios");
        if (!data.success) { $("tbody-usuarios").innerHTML = `<tr><td colspan="9" class="text-danger">${esc(data.mensaje)}</td></tr>`; return; }

        usuariosCache = data.usuarios;
        miId = data.yo;

        $("u-rol").innerHTML = data.roles.map(r => `<option value="${r.id}">${esc(r.nombre)}</option>`).join("");

        $("tbody-usuarios").innerHTML = data.usuarios.map(u => `
            <tr>
                <td>${u.id}</td><td>${esc(u.nombre)}</td><td>${esc(u.correo)}</td><td>${esc(u.telefono)}</td>
                <td><span class="badge badge-${u.rol === "administrador" ? "warning" : "secondary"}">${esc(u.rol)}</span></td>
                <td>${u.activo == 1 ? "Activo" : '<span class="text-danger">Inactivo</span>'}</td>
                <td>${u.total_publicaciones}</td><td>${u.total_favoritos}</td>
                <td class="text-nowrap">
                    <button class="btn btn-outline-primary btn-sm btn-editar" data-id="${u.id}">Editar</button>
                    <button class="btn btn-outline-danger btn-sm btn-eliminar-usuario" data-id="${u.id}">Eliminar</button>
                </td>
            </tr>`).join("");
    } catch (e) {
        $("tbody-usuarios").innerHTML = '<tr><td colspan="9" class="text-danger">Error al cargar los usuarios.</td></tr>';
    }
};

$("tbody-usuarios").addEventListener("click", async (e) => {
    const btnEditar = e.target.closest(".btn-editar");
    const btnEliminar = e.target.closest(".btn-eliminar-usuario");

    if (btnEditar) {
        const u = usuariosCache.find(x => x.id == btnEditar.dataset.id);
        if (!u) return;
        $("u-id").value = u.id;
        $("u-nombre").value = u.nombre;
        $("u-telefono").value = u.telefono;
        $("u-correo").value = u.correo;
        $("u-rol").value = u.rol_id;
        $("u-activo").value = u.activo;
        $("titulo-form").textContent = `Editar usuario #${u.id}`;
        $("btn-guardar-usuario").textContent = "Guardar cambios";
        $("grupo-activo").style.display = "block";
        $("grupo-password").style.display = "none";
        $("btn-cancelar").style.display = "inline-block";
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    if (btnEliminar) {
        const u = usuariosCache.find(x => x.id == btnEliminar.dataset.id);
        if (!u || !confirm(`¿Eliminar a ${u.nombre}? También se borrarán sus publicaciones y favoritos.`)) return;
        const data = await api("usuario_eliminar", { id: u.id });
        aviso(data.mensaje, data.success);
        if (data.success) cargarUsuarios();
    }
});

$("form-usuario").addEventListener("submit", async (e) => {
    e.preventDefault();
    const editando = $("u-id").value !== "";
    const cuerpo = {
        nombre: $("u-nombre").value,
        telefono: $("u-telefono").value,
        correo: $("u-correo").value,
        rol_id: $("u-rol").value
    };
    let data;
    if (editando) {
        cuerpo.id = $("u-id").value;
        cuerpo.activo = $("u-activo").value;
        data = await api("usuario_actualizar", cuerpo);
    } else {
        cuerpo.password = $("u-password").value;
        data = await api("usuario_crear", cuerpo);
    }
    aviso(data.mensaje, data.success);
    if (data.success) { limpiarFormulario(); cargarUsuarios(); }
});

const cargarPublicaciones = async () => {
    const tbody = $("tbody-publicaciones");
    try {
        const data = await api("publicaciones");
        if (!data.success) { tbody.innerHTML = `<tr><td colspan="9" class="text-danger">${esc(data.mensaje)}</td></tr>`; return; }
        if (!data.publicaciones.length) { tbody.innerHTML = '<tr><td colspan="9" class="text-muted">No hay publicaciones.</td></tr>'; return; }

        tbody.innerHTML = data.publicaciones.map(p => `
            <tr>
                <td>${p.id}</td><td>${esc(p.marca)} ${esc(p.modelo)}</td><td>${p.anio}</td>
                <td>$ ${parseFloat(p.precio).toLocaleString()}</td><td>${esc(p.ciudad)}</td>
                <td>${esc(p.vendedor_nombre)}</td><td>${p.total_favoritos}</td>
                <td>
                    <select class="form-control form-control-sm sel-estado" data-id="${p.id}">
                        ${["activa", "vendida", "inactiva"].map(s => `<option value="${s}" ${p.estado === s ? "selected" : ""}>${s}</option>`).join("")}
                    </select>
                </td>
                <td class="text-nowrap">
                    <a href="detalle.html?id=${p.id}" class="btn btn-outline-primary btn-sm">Ver</a>
                    <button class="btn btn-outline-danger btn-sm btn-eliminar-pub" data-id="${p.id}">Eliminar</button>
                </td>
            </tr>`).join("");
    } catch (e) {
        tbody.innerHTML = '<tr><td colspan="9" class="text-danger">Error al cargar las publicaciones.</td></tr>';
    }
};

$("tbody-publicaciones").addEventListener("change", async (e) => {
    const sel = e.target.closest(".sel-estado");
    if (!sel) return;
    const data = await api("publicacion_estado", { id: sel.dataset.id, estado: sel.value });
    aviso(data.mensaje, data.success);
    if (!data.success) cargarPublicaciones();
});

$("tbody-publicaciones").addEventListener("click", async (e) => {
    const btn = e.target.closest(".btn-eliminar-pub");
    if (!btn || !confirm("¿Eliminar esta publicación? No se puede deshacer.")) return;
    const data = await api("publicacion_eliminar", { id: btn.dataset.id });
    aviso(data.mensaje, data.success);
    if (data.success) cargarPublicaciones();
});

const cargarAuditoria = async () => {
    const tbody = $("tbody-auditoria");
    try {
        const data = await api("auditoria");
        if (!data.success) { tbody.innerHTML = `<tr><td colspan="7" class="text-danger">${esc(data.mensaje)}</td></tr>`; return; }
        if (!data.auditoria.length) { tbody.innerHTML = '<tr><td colspan="7" class="text-muted">Aún no hay movimientos.</td></tr>'; return; }
        tbody.innerHTML = data.auditoria.map(a => `
            <tr><td>${a.id}</td><td class="text-nowrap">${esc(a.fecha)}</td><td>${esc(a.tabla)}</td><td>${esc(a.accion)}</td>
                <td>${a.registro_id ?? ""}</td><td>${esc(a.detalle)}</td><td>${esc(a.usuario_bd)}</td></tr>`).join("");
    } catch (e) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-danger">Error al cargar la auditoría.</td></tr>';
    }
};

document.addEventListener("DOMContentLoaded", async () => {
    const sesion = await fetch("php/auth.php?accion=sesion").then(r => r.json()).catch(() => null);
    if (!sesion || !sesion.success || sesion.usuario.rol !== "administrador") {
        alert("Esta sección es solo para administradores.");
        window.location.href = sesion && sesion.success ? "index.html" : "inisesi.html";
        return;
    }
    $("contenido").style.display = "block";
    cargarUsuarios();
});