username = prompt("Användarnamn:")
password = prompt("Lösenord:")

let form = new FormData()
form.append("user", username)
form.append("password", password)

axios.post("http://localhost:4567/register", form)
    .then((result) => {
         console.log(result) })
    .catch(() => { 
        alert("Användarnamnet används redan") })
