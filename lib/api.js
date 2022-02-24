const server = "http://localhost:4567"

function registerUser(user, pass){
    let payload = {user, password: pass}

    return new Promise((resolve, reject) => {
        axios.post(server + "/register", JSON.stringify(payload)).then(data => resolve(data.data)).catch(err => reject(err.response))
    })
}

function login(user, pass){
    let payload = {user, password: pass}

    return new Promise((resolve, reject) => {
        axios.post(server + "/login", JSON.stringify(payload))
            .then(data => {
                localStorage.setItem('token', data.data.data);
                resolve();
            }).catch(err => {
                location.href = err.response.data.data
                reject();
            })
    })  
}

function getRequest(endpoint){
    return new Promise((resolve, reject) => {
        axios.get(server + endpoint, {headers: {
            'Authorization': `${localStorage.getItem('token')}` 
          }}).then(data => resolve(data.data)).catch(err => reject(err.response))
    })
}

function putRequest(endpoint){
    return new Promise((resolve, reject) => {
        axios.put(server + endpoint, "", {headers: {
            'Authorization': `${localStorage.getItem('token')}` 
          }}).then(data => resolve(data.data)).catch(err => reject(err.response))
    })
}

function getUser(){
    return getRequest("/me")
}

function createParty(){
    return new Promise((resolve, reject) => {
        getRequest("/party/create").then((party)=>{
           localStorage.setItem("code", party.code);
           resolve(party)
        })
    })
}

function joinParty(code){
    return new Promise((resolve, reject) => {
        getRequest(`/party/${code}/join`).then((party)=>{
           localStorage.setItem("code", code);
           resolve(party)
        })
    })
}

function getParty(){
    getRequest(`/party/${localStorage.getItem("code")}/join`)
}
