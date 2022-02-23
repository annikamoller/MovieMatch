function login_click() {
    console.log("Knapp tryckt")
    let username = $("#username").val()
    console.log(username)
    let password = $("#password").val()
    console.log(password)

    login(username, password).then(data => {
        location.href = "/index.html"
    }).catch(err => {
        console.log(err.response)
        alert("Failed: " + err.response.data);
    })
}

$("#login_btn").click(login_click)