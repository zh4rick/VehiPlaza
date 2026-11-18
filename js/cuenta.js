document.addEventListener("DOMContentLoaded", () => {
    let usuario = JSON.parse(localStorage.getItem("usuarioLogueadoDatos") || "null");

    if (!usuario) {
        alert("Debes iniciar sesión para ver tu cuenta.");
        window.location.href = "inisesi.html";
        return;
    }

    const $ = (id) => document.getElementById(id);
    const contPub = $("contenedorPublicaciones");
    const contFav = $("contenedorFavoritos");

    const rutaImagen = (url) => url ? "img/" + url.split("/").pop() : "img/carro.png";
    const escapar = (t) => String(t ?? "").replace(/[&<>"']/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));

    const mostrarPanel = (cual) => {
        const pub = cual === "pub";
        $("panelPublicaciones").style.display = pub ? "block" : "none";
        $("panelFavoritos").style.display = pub ? "none" : "block";
        $("tabPublicaciones").className = "btn " + (pub ? "btn-primary" : "btn-outline-primary");
        $("tabFavoritos").className = "btn " + (pub ? "btn-outline-primary" : "btn-primary");
    };
    $("tabPublicaciones").addEventListener("click", () => mostrarPanel("pub"));
    $("tabFavoritos").addEventListener("click", () => mostrarPanel("fav"));

    $("btnCerrarSesion").addEventListener("click", () => cerrarSesion());

    const pintarPerfil = (u) => {
        $("tituloCuenta").textContent = u.nombre || "Mi Cuenta";
        $("cuentaNombre").value = u.nombre || "";
        $("cuentaTelefono").value = u.telefono || "";
        $("cuentaCorreo").value = u.correo || "";
    };

    const cargarPerfil = async () => {
        pintarPerfil(usuario); // muestra lo que ya tenemos mientras llega el resto
        try {
            const res = await fetch(`php/cuenta.php?accion=perfil&usuario_id=${usuario.id}`);
            const data = await res.json();
            if (data.success) {
                usuario = { ...usuario, ...data.usuario };
                localStorage.setItem("usuarioLogueadoDatos", JSON.stringify(usuario));
                pintarPerfil(usuario);
            }
        } catch (e) {
            console.error("No se pudo cargar el perfil:", e);
        }
    };

    $("formCuenta").addEventListener("submit", async (e) => {
        e.preventDefault();
        const msg = $("mensajeCuenta");
        msg.className = "small mb-2";
        msg.textContent = "Guardando...";

        try {
            const res = await fetch("php/cuenta.php?accion=actualizar", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    usuario_id: usuario.id,
                    nombre: $("cuentaNombre").value,
                    telefono: $("cuentaTelefono").value,
                    correo: $("cuentaCorreo").value,
                    password_nueva: $("cuentaPasswordNueva").value,
                    password_actual: $("cuentaPasswordActual").value
                })
            });
            const data = await res.json();

            if (data.success) {
                usuario = { ...usuario, ...data.usuario };
                localStorage.setItem("usuarioLogueadoDatos", JSON.stringify(usuario));
                localStorage.setItem("usuarioLogueado", usuario.correo); // lo usa publicar.js
                pintarPerfil(usuario);
                $("cuentaPasswordNueva").value = "";
                $("cuentaPasswordActual").value = "";
                msg.className = "small mb-2 text-success";
                msg.textContent = data.mensaje;
                cargarPublicaciones();
            } else {
                msg.className = "small mb-2 text-danger";
                msg.textContent = data.mensaje;
            }
        } catch (err) {
            console.error(err);
            msg.className = "small mb-2 text-danger";
            msg.textContent = "Ocurrió un error al conectar con el servidor.";
        }
    });

    const cargarPublicaciones = async () => {
        try {
            const res = await fetch(`php/cuenta.php?accion=mis_publicaciones&usuario_id=${usuario.id}`);
            const data = await res.json();

            if (!data.success) {
                contPub.innerHTML = `<p class="text-danger">${escapar(data.mensaje)}</p>`;
                return;
            }
            if (data.publicaciones.length === 0) {
                contPub.innerHTML = '<p class="text-muted">Aún no has publicado vehículos. <a href="publicar.html">Publica el primero</a>.</p>';
                return;
            }

            contPub.innerHTML = data.publicaciones.map(c => `
                <div class="col-md-6 mb-3">
                    <div class="card h-100 shadow-sm">
                        <img src="${rutaImagen(c.imagen_url)}" class="card-img-top img-fija" alt="${escapar(c.marca)}"
                             onerror="this.onerror=null; this.src='img/carro.png';">
                        <div class="card-body p-3">
                            <h6 class="card-title mb-1">${escapar(c.marca)} ${escapar(c.modelo)} ${escapar(c.anio)}</h6>
                            <p class="text-success fw-bold mb-1">$ ${parseFloat(c.precio).toLocaleString()}</p>
                            <p class="small text-muted mb-2">${parseInt(c.kilometraje).toLocaleString()} km · ${escapar(c.ciudad)}</p>
                            <a href="detalle.html?id=${c.id}" class="btn btn-primary btn-sm w-100">Ver Detalles</a>
                            <button type="button" class="btn btn-outline-danger btn-sm w-100 mt-2 btn-eliminar-pub" data-id="${c.id}">Eliminar publicación</button>
                        </div>
                    </div>
                </div>`).join("");
        } catch (err) {
            console.error(err);
            contPub.innerHTML = `<p class="text-danger">Error al cargar tus publicaciones: ${escapar(err.message)}</p>`;
        }
    };

    const mensajeVacioFav = '<p class="text-muted">No tienes vehículos guardados en tu lista de deseos.</p>';

    const cargarFavoritos = async () => {
        try {
            const res = await fetch(`php/obtener_favoritos.php?usuario_id=${usuario.id}`);
            const data = await res.json();

            if (!data.success) {
                contFav.innerHTML = `<p class="text-danger">${escapar(data.mensaje || "Error al obtener favoritos.")}</p>`;
                return;
            }
            if (data.favoritos.length === 0) {
                contFav.innerHTML = mensajeVacioFav;
                return;
            }

            contFav.innerHTML = data.favoritos.map(c => `
                <div class="col-md-6 mb-3" id="fav-${c.id}">
                    <div class="card h-100 shadow-sm">
                        <img src="${rutaImagen(c.imagen_url)}" class="card-img-top img-fija" alt="${escapar(c.marca)}"
                             onerror="this.onerror=null; this.src='img/carro.png';">
                        <div class="card-body p-3">
                            <h6 class="card-title mb-1">${escapar(c.marca)} ${escapar(c.modelo)}</h6>
                            <p class="text-success fw-bold mb-2">$ ${parseFloat(c.precio).toLocaleString()}</p>
                            <a href="detalle.html?id=${c.id}" class="btn btn-primary btn-sm w-100 mb-2">Ver Detalles</a>
                            <button type="button" class="btn btn-outline-danger btn-sm w-100 btn-quitar-fav" data-id="${c.id}">Quitar de favoritos</button>
                        </div>
                    </div>
                </div>`).join("");
        } catch (err) {
            console.error(err);
            contFav.innerHTML = `<p class="text-danger">Error al cargar la lista de deseos: ${escapar(err.message)}</p>`;
        }
    };

    contFav.addEventListener("click", async (e) => {
        const btn = e.target.closest(".btn-quitar-fav");
        if (!btn) return;
        if (!confirm("¿Quitar este vehículo de tus favoritos?")) return;

        const publicacionId = btn.dataset.id;
        btn.disabled = true;
        try {
            const res = await fetch("php/favoritos.php", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ usuario_id: usuario.id, publicacion_id: publicacionId, accion: "quitar" })
            });
            const data = await res.json();
            if (data.success) {
                const tarjeta = $("fav-" + publicacionId);
                if (tarjeta) tarjeta.remove();
                if (!contFav.children.length) contFav.innerHTML = mensajeVacioFav;
            } else {
                btn.disabled = false;
                alert("Error: " + data.mensaje);
            }
        } catch (err) {
            btn.disabled = false;
            alert("Ocurrió un error al conectar con el servidor.");
        }
    });

    contPub.addEventListener("click", async (e) => {
        const btn = e.target.closest(".btn-eliminar-pub");
        if (!btn) return;
        if (!confirm("¿Eliminar esta publicación? Esta acción no se puede deshacer.")) return;

        btn.disabled = true;
        try {
            const res = await fetch("php/cuenta.php?accion=eliminar_publicacion", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ usuario_id: usuario.id, publicacion_id: btn.dataset.id })
            });
            const data = await res.json();
            if (data.success) {
                cargarPublicaciones();
                cargarFavoritos();
            } else {
                btn.disabled = false;
                alert("Error: " + data.mensaje);
            }
        } catch (err) {
            btn.disabled = false;
            alert("Ocurrió un error al conectar con el servidor.");
        }
    });

    cargarPerfil();
    cargarPublicaciones();
    cargarFavoritos();
});