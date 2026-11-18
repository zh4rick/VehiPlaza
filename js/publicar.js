document.addEventListener("DOMContentLoaded", () => {
    const usuarioLogueado = localStorage.getItem("usuarioLogueado");
    const datosUsuario = JSON.parse(localStorage.getItem("usuarioLogueadoDatos") || "null");

    if (!usuarioLogueado || usuarioLogueado === "null" || usuarioLogueado === "" || !datosUsuario) {
        alert("Debes iniciar sesión para publicar un vehículo.");
        window.location.href = "inisesi.html";
        return;
    }

    const modelosPorMarca = {
        renault: ["Logan", "Sandero", "Duster", "Kwid", "Stepway"],
        chevrolet: ["Onix", "Tracker", "Spark", "Captiva", "Sail"],
        toyota: ["Corolla", "Hilux", "Fortuner", "Yaris", "Prado"],
        nissan: ["Versa", "March", "Kicks", "Frontier", "Sentra"],
        mazda: ["Mazda 2", "Mazda 3", "CX-30", "CX-5", "CX-50"]
    };

    const selectMarca = document.getElementById("marca");
    const selectModelo = document.getElementById("modelo");

    if (selectMarca && selectModelo) {
        selectMarca.addEventListener("change", (e) => {
            const marcaSeleccionada = e.target.value.toLowerCase();
            const modelos = modelosPorMarca[marcaSeleccionada] || [];

            selectModelo.innerHTML = '<option value="" selected disabled>Selecciona el modelo</option>';

            modelos.forEach((mod) => {
                const option = document.createElement("option");
                option.value = mod;
                option.textContent = mod;
                selectModelo.appendChild(option);
            });
        });
    }

    const formPublicar = document.getElementById("form-publicar");
    if (formPublicar) {
        formPublicar.addEventListener("submit", async (e) => {
            e.preventDefault();

            const btn = document.getElementById("btn-publicar");
            if (btn) btn.disabled = true;

            const formData = new FormData();
            formData.append("usuario_id", datosUsuario.id);
            formData.append("marca", document.getElementById("marca").value);
            formData.append("modelo", document.getElementById("modelo").value);
            formData.append("anio", document.getElementById("anio").value);
            formData.append("precio", document.getElementById("precio").value);
            formData.append("km", document.getElementById("km").value);
            formData.append("transmision", document.getElementById("transmision").value);
            formData.append("combustible", document.getElementById("combustible").value);
            formData.append("ciudad", document.getElementById("ciudad").value);
            formData.append("descripcion", document.getElementById("descripcion").value);

            const extras = Array.from(document.querySelectorAll('#form-publicar input[type="checkbox"]:checked'))
                .map(c => c.value);
            formData.append("equipamiento", extras.join(","));

            const inputImagen = document.getElementById("imagen");
            if (inputImagen && inputImagen.files[0]) {
                formData.append("imagen", inputImagen.files[0]);
            }

            try {
                const response = await fetch("php/procesar_publicacion.php", {
                    method: "POST",
                    body: formData
                });
                const resultado = await response.json();

                if (resultado.success) {
                    alert("¡Tu carro ha sido publicado con éxito!");
                    window.location.href = "index.html";
                } else {
                    alert("Error al publicar: " + (resultado.mensaje || "Inténtalo de nuevo."));
                    if (btn) btn.disabled = false;
                }
            } catch (error) {
                console.error("Error de conexión:", error);
                alert("Ocurrió un error al guardar la publicación.");
                if (btn) btn.disabled = false;
            }
        });
    }
});