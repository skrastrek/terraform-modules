async function handler(event) {
  if (event.request.method === 'OPTIONS') {
    return {
      statusCode: 204,
      statusDescription: 'No Content'
    }
  }

  return event.request
}
