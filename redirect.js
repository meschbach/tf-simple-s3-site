function handler(event) {
    var request = event.request;
    var uri = request.uri;
    var len = uri.length;
    if(len <= 1){
        return request;
    }
    if(uri[len-1] === "/"){
        request.uri = uri + "index.html";
    }
    return request;
};
