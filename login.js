function validate_password(password) {
    return false
}

function login_click() {
    console.log("Knapp tryckt")
    let username = $("#username").val()
    console.log(username)
    let password = $("#password").val()
    console.log(password)
    if(validate_password(password)){
        alert("Ditt lösenord är tillräckligt starkt!")
    }
    else{
        alert("Ditt lösenord är för svagt!")
    }
}

$("#login_btn").click(login_click)