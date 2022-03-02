function validate_password(password) {
    return true
}

function register_click() {
    console.log("Knapp tryckt")
    let username = $("#username").val()
    console.log(username)
    let password = $("#password").val()
    if(validate_password(password)){
        alert("Ditt lösenord är tillräckligt starkt!")
    }
    else{
        alert("Ditt lösenord är för svagt!")
    }

    registerUser(username, password).then(data => {
        alert("Welcome " + data.username);
        location.href = "./login.html"
    }).catch(err => {
        alert("Failed: " + err);
    })
}

$("#register_btn").click(register_click)