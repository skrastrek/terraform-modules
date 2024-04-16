const index = '/index.html';

function handler(event) {
  const request = event.request;
  // if extension not found (access not real file)
  if (request.uri.indexOf(".") === -1) {
    request.uri = index;
  }
  return request;
}
