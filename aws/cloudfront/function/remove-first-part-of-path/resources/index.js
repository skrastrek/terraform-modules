async function handler(event) {
    const request = event.request;
    request.uri = request.uri.replace(/^\/[^/]*\//, "/");
    return request
}
