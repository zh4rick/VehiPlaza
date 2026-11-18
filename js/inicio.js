document.addEventListener("DOMContentLoaded", () => {
    const modelosPorMarca = {
        renault: ["Logan", "Sandero", "Duster", "Kwid", "Stepway"],
        chevrolet: ["Onix", "Tracker", "Spark", "Captiva", "Sail"],
        toyota: ["Corolla", "Hilux", "Fortuner", "Yaris", "Prado"],
        nissan: ["Versa", "March", "Kicks", "Frontier", "Sentra"],
        mazda: ["Mazda 2", "Mazda 3", "CX-30", "CX-5", "CX-50"]
    };

    const selectFiltroMarca = document.getElementById("filtro-marca");
    const selectFiltroModelo = document.getElementById("filtro-modelo");

    if (selectFiltroMarca && selectFiltroModelo) {
        selectFiltroMarca.addEventListener("change", (e) => {
            const marcaSeleccionada = e.target.value.toLowerCase();
            const modelos = modelosPorMarca[marcaSeleccionada] || [];
            selectFiltroModelo.innerHTML = '<option value="" selected>Todos los modelos</option>';

            modelos.forEach((mod) => {
                const option = document.createElement("option");
                option.value = mod;
                option.textContent = mod;
                selectFiltroModelo.appendChild(option);
            });
        });
    }

    const contenedorCarros = document.querySelector("main .row.g-3") || document.querySelector("main .row");
    const formFiltros = document.querySelector("aside form");

    const rutaImagen = (url) => {
        if (!url || url.trim() === "") return "img/carro.png";
        if (url.startsWith("http")) return url;
        return "img/" + url.split("/").pop();
    };

    const obtenerIdsFavoritos = async () => {
        const usuario = JSON.parse(localStorage.getItem("usuarioLogueadoDatos") || "null");
        if (!usuario) return new Set();
        try {
            const res = await fetch(`php/obtener_favoritos.php?usuario_id=${usuario.id}`);
            const data = await res.json();
            if (data.success) return new Set(data.favoritos.map(f => String(f.id)));
        } catch (e) {
            console.error("No se pudieron cargar los favoritos:", e);
        }
        return new Set();
    };

    const activarBotonesFavoritos = () => {
        document.querySelectorAll(".btn-favorito").forEach(btn => {
            btn.addEventListener("click", async () => {
                const usuario = JSON.parse(localStorage.getItem("usuarioLogueadoDatos") || "null");
                if (!usuario) {
                    alert("Debes iniciar sesión para guardar en favoritos.");
                    window.location.href = "inisesi.html";
                    return;
                }

                const publicacionId = btn.getAttribute("data-id");
                const yaEsFavorito = btn.classList.contains("btn-danger");
                const accion = yaEsFavorito ? "quitar" : "agregar";

                try {
                    const res = await fetch("php/favoritos.php", {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({ usuario_id: usuario.id, publicacion_id: publicacionId, accion })
                    });
                    const resData = await res.json();

                    if (resData.success) {
                        btn.classList.toggle("btn-danger", !yaEsFavorito);
                        btn.classList.toggle("btn-outline-danger", yaEsFavorito);
                        btn.title = yaEsFavorito ? "Agregar a favoritos" : "Quitar de favoritos";
                    } else {
                        alert("Error: " + resData.mensaje);
                    }
                } catch (e) {
                    console.error("Error con favoritos:", e);
                    alert("Ocurrió un error al conectar con el servidor.");
                }
            });
        });
    };

    const cargarCarros = async (filtros = {}) => {
        let url = "php/obtener_carros.php?";
        if (filtros.marca) url += `marca=${encodeURIComponent(filtros.marca)}&`;
        if (filtros.modelo) url += `modelo=${encodeURIComponent(filtros.modelo)}`;

        try {
            const [res, favoritosIds] = await Promise.all([fetch(url), obtenerIdsFavoritos()]);
            const data = await res.json();

            if (data.success && data.carros.length > 0) {
                contenedorCarros.innerHTML = data.carros.map(carro => {
                    const esFav = favoritosIds.has(String(carro.id));
                    return `
                        <div class="col-12 col-sm-6 col-lg-4 mb-4">
                            <div class="card h-100 shadow-sm">
                                <img src="${rutaImagen(carro.imagen_url)}" class="card-img-top card-img-fija" alt="${carro.marca}"
                                     onerror="this.onerror=null; this.src='img/carro.png';">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title font-weight-bold mb-1">${carro.marca} ${carro.modelo}</h5>
                                    <small class="text-muted mb-2">Año ${carro.anio} | ${carro.ciudad}</small>
                                    <span class="text-muted mb-1">${parseInt(carro.kilometraje).toLocaleString()} km | ${carro.transmision}</span>
                                    <span class="text-muted mb-2">Combustible: ${carro.combustible}</span>
                                    <p class="h5 text-success font-weight-bold mt-auto mb-3">$ ${parseFloat(carro.precio).toLocaleString()}</p>
                                    <div class="d-flex gap-2 mt-auto">
                                        <a href="detalle.html?id=${carro.id}" class="btn btn-primary btn-sm w-100">Ver Más</a>
                                        <button class="btn ${esFav ? "btn-danger" : "btn-outline-danger"} btn-sm btn-favorito ml-2"
                                                data-id="${carro.id}" title="${esFav ? "Quitar de favoritos" : "Agregar a favoritos"}">♥</button>
                                    </div>
                                </div>
                            </div>
                        </div>`;
                }).join("");

                activarBotonesFavoritos();
            } else {
                contenedorCarros.innerHTML = '<div class="col-12"><p class="alert alert-info text-center">No se encontraron vehículos con esos criterios.</p></div>';
            }
        } catch (error) {
            console.error("Error al cargar publicaciones:", error);
        }
    };

    if (formFiltros) {
        formFiltros.addEventListener("submit", (e) => {
            e.preventDefault();
            cargarCarros({
                marca: selectFiltroMarca ? selectFiltroMarca.value : "",
                modelo: selectFiltroModelo ? selectFiltroModelo.value : ""
            });
        });

        const btnBorrar = document.getElementById("btn-borrar");
        if (btnBorrar) {
            btnBorrar.addEventListener("click", () => {
                selectFiltroModelo.innerHTML = '<option value="" selected>Selecciona primero una marca</option>';
                cargarCarros({});
            });
        }
    }

    cargarCarros();
});