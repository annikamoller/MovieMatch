function login_click() {
    console.log("Knapp tryckt")
    const username = $("#username").val()
    console.log(username)
    const password = $("#password").val()

    login(username, password)
        .then(data => {
            location.href = "/index.html"
        }).catch(err => {
            console.log(err.response)
            alert("Failed: " + err.response.data);
        })
}

$("#login_btn").click(login_click)