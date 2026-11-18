document.addEventListener("DOMContentLoaded", () => {
    const formLogin = document.getElementById("form-login");
    if (formLogin) {
        formLogin.addEventListener("submit", async (e) => {
            e.preventDefault();
            const correo = document.getElementById("correo").value;
            const password = document.getElementById("password").value;

            try {
                const response = await fetch("php/auth.php?accion=login", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ correo, password })
                });

                const data = await response.json();
                if (data.success) {
                    localStorage.setItem("usuarioLogueado", data.usuario.correo);
                    localStorage.setItem("usuarioLogueadoDatos", JSON.stringify(data.usuario));
                    window.location.href = "index.html";
                }
            } catch (err) {
                console.error("Error de red:", err);
                alert("Ocurrió un error al conectar con el servidor.");
            }
        });
    }

    const formRegistro = document.getElementById("form-registro");
    if (formRegistro) {
        formRegistro.addEventListener("submit", async (e) => {
            e.preventDefault();
            const nombre = document.getElementById("nombre").value;
            const telefono = document.getElementById("telefono") ? document.getElementById("telefono").value : "";
            const correo = document.getElementById("correo").value;
            const password = document.getElementById("password").value;

            try {
                const response = await fetch("php/auth.php?accion=registro", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ nombre, telefono, correo, password })
                });

                const data = await response.json();
                if (data.success) {
                    alert("¡Registro exitoso! Ya puedes iniciar sesión.");
                    window.location.href = "inisesi.html";
                } else {
                    alert(data.mensaje);
                }
            } catch (err) {
                console.error("Error de red:", err);
                alert("Ocurrió un error al conectar con el servidor.");
            }
        });
    }
});