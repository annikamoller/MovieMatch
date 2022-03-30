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

function logout(){
    localStorage.clear();
    location.href = "./login.html"
}

function getRequest(endpoint){
    return new Promise((resolve, reject) => {
        axios.get(server + endpoint, {headers: {
            'Authorization': `${localStorage.getItem('token')}` 
          }})
          .then(data => resolve(data.data))
          .catch(err => {
              console.log(err.response.data)
              if(err.response.data.err = "Unauthorized"){
                  location.href = err.response.data.data
              }else {
                reject(err.response)
              }
            })
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

/**
 * Create Party
 *
 * @returns {Promise<Party>} Party
 */
function createParty(){
    localStorage.setItem("index", 0);
    return new Promise((resolve, reject) => {
        getRequest("/party/create").then((party)=>{
           localStorage.setItem("code", party.code);
           resolve(party)
        })
    })
}

/**
 * @typedef Party
 * @property {string} code
 * @property {Array.<string>} users - member usernames
 * @property {array} movies
 */

/**
 * Join Party
 *
 * @param {string} code - Party Code
 * @returns {Promise<Party>} Party
 */
function joinParty(code){
    localStorage.setItem("index", 0);
    return new Promise((resolve, reject) => {
        getRequest(`/party/${code}/join`).then((party)=>{
           localStorage.setItem("code", code);
           resolve(party)
        }).catch(err => reject(err))
    })
}

/**
 * Get current party
 *
 * @returns {Promise<Party>} Party
 */
function getParty(){
    return getRequest(`/party/${localStorage.getItem("code")}`)
}

/**
 * @typedef Movie
 * @property {number} id
 * @property {string} title - Movie title
 * @property {string} rating
 */

/**
 * Get movie by id
 *
 * @param {number} id - Movie id
 * @returns {Promise<Movie>} Movie
 */
function getMovie(id){
    return getRequest(`/movie/${id}`)
}

/**
 * Get next movie
 *
 * @param {number} id - Movie id
 * @returns {Promise<Movie>} Movie
 */
function nextMovie(){
    let index = localStorage.getItem("index");
    if (index == null) {
        index = -1;
    }
    index++;
    localStorage.setItem("index", index);
    return new Promise((resolve, reject) => {
        getParty().then(party => {
            resolve(getMovie(party.movies[index]))
        })
    })
}

/**
 * Like movie in current party by id
 *
 * @param {number} id - Movie id
 * @returns {Promise<string>} It's a match | no match
 */
function likeMovie(id){
    return getRequest(`/party/${localStorage.getItem("code")}/like/${id}`)
}

function activateParty(){
    return getRequest(`/party/${localStorage.getItem("code")}/activate`)
}


/**
 * clears all data saved by party to be ready for new party
 */
function startParty(){
    localStorage.removeItem("index")
    localStorage.setItem("matches", [])
}

/**
 * Sends genres to backend one by one
 *
 * @param {Array.<string>} genres - Movie genres
 */
function saveGenres(genres) {
    for(let i = 0; i < genres.length; i++) {
        getRequest(`/party/${localStorage.getItem("code")}/genres/add/${genres[i]}`)
    }
}