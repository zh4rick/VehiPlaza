document.addEventListener("DOMContentLoaded", () => {
    const $ = (id) => document.getElementById(id);
    const poner = (id, texto) => { const el = $(id); if (el) el.textContent = texto; };

    $("btn-volver").addEventListener("click", () => {
        if (document.referrer && history.length > 1) {
            history.back();
        } else {
            window.location.href = "index.html";
        }
    });

    const id = new URLSearchParams(window.location.search).get("id");
    if (!id) {
        poner("carro-descripcion", "No se indicó qué vehículo mostrar.");
        return;
    }

    const cargar = async () => {
        try {
            const res = await fetch(`php/obtener_carros.php?id=${encodeURIComponent(id)}`);
            const data = await res.json();
            const c = data.carros && data.carros[0];

            if (!c) {
                poner("nombre-carro", "Vehículo no encontrado");
                poner("carro-descripcion", "Esta publicación no existe o fue eliminada.");
                return;
            }

            const img = $("imagen_url");
            const archivo = c.imagen_url ? c.imagen_url.split("/").pop() : "";
            img.src = archivo ? "img/" + archivo : "img/carro.png";
            poner("nombre-carro", `${c.marca} ${c.modelo} ${c.anio}`);
            poner("carro-precio", "$ " + parseFloat(c.precio).toLocaleString());
            poner("carro-km", parseInt(c.kilometraje).toLocaleString() + " km");
            poner("carro-transmision", c.transmision);
            poner("carro-combustible", c.combustible);
            poner("carro-anio", c.anio);
            poner("carro-ciudad", c.ciudad);
            const desc = (c.descripcion || "").trim();
            poner("carro-descripcion", desc !== "" ? desc : "El vendedor no agregó una descripción para este vehículo.");

            if (c.equipamiento) {
                poner("carro-equipamiento", c.equipamiento);
                $("bloque-equipamiento").style.display = "block";
            }

            if (c.vendedor_telefono) {
                let tel = String(c.vendedor_telefono).replace(/\D/g, "");
                if (tel.length === 10) tel = "57" + tel;   // celular colombiano sin indicativo
                const mensaje = encodeURIComponent(`Hola, estoy interesado en el ${c.marca} ${c.modelo} ${c.anio} que publicaste.`);
                $("btn-whatsapp").href = `https://wa.me/${tel}?text=${mensaje}`;
            }
        } catch (e) {
            console.error("Error al cargar el detalle:", e);
            poner("carro-descripcion", "No se pudo cargar la información del vehículo.");
        }
    };

    cargar();
});