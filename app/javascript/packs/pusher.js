var pusher = new Pusher('12e21f086ab8bbad38d2', {
  cluster: 'us2',
  forceTLS: true
});

var channel = pusher.subscribe('jeopardy');

channel.bind('update', function (data) {
});
