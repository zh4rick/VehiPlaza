(() => {
    let pagina = location.pathname.split("/").pop() || "index.html";
    if (pagina === "detalle.html") pagina = "index.html";

    const leerUsuario = () => {
        try { return JSON.parse(localStorage.getItem("usuarioLogueadoDatos") || "null"); }
        catch (e) { return null; }
    };

    const limpiarSesionLocal = () => {
        localStorage.removeItem("usuarioLogueado");
        localStorage.removeItem("usuarioLogueadoDatos");
    };

    window.cerrarSesion = async () => {
        try { await fetch("php/auth.php?accion=logout", { method: "POST" }); } catch (e) {}
        limpiarSesionLocal();
        alert("Sesión cerrada correctamente.");
        window.location.href = "index.html";
    };

    const enlace = (href, texto) =>
        `<li class="nav-item"><a href="${href}" class="nav-link${pagina === href ? " active" : ""}">${texto}</a></li>`;

    const pintarMenu = (usuario) => {
        const ul = document.querySelector(".main-menu .nav");
        if (!ul) return;

        let html = enlace("index.html", "Inicio") + enlace("contacto.html", "Contacto");

        if (usuario) {
            html += enlace("publicar.html", "Publicar") + enlace("cuenta.html", "Cuenta");
            if (usuario.rol === "administrador") {
                html += enlace("admin.html", "Admin") + enlace("reportes.html", "Reportes");
            }
            html += '<li class="nav-item"><a href="#" class="nav-link text-danger" id="btn-cerrar-sesion">Cerrar sesión</a></li>';
        } else {
            html += enlace("inisesi.html", "Iniciar sesión") + enlace("registro.html", "Registrarse");
        }

        ul.innerHTML = html;

        const btn = document.getElementById("btn-cerrar-sesion");
        if (btn) btn.addEventListener("click", (e) => { e.preventDefault(); window.cerrarSesion(); });
    };

    pintarMenu(leerUsuario());

    fetch("php/auth.php?accion=sesion")
        .then((r) => r.json())
        .then((d) => {
            if (d && d.success) {
                localStorage.setItem("usuarioLogueado", d.usuario.correo);
                localStorage.setItem("usuarioLogueadoDatos", JSON.stringify(d.usuario));
                pintarMenu(d.usuario);
            } else if (d && d.sesion === false) {
                limpiarSesionLocal();
                pintarMenu(null);
            }
        })
        .catch(() => {});
})();
