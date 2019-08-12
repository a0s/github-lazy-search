window.onload = function () {
  var generateUUID = function () {
    var d = new Date().getTime();
    if (typeof performance !== 'undefined' && typeof performance.now === 'function') {
      d += performance.now();
    }
    return 'xxxxxxxx-xxxx-xxxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      var r = (d + Math.random() * 16) % 16 | 0;
      d = Math.floor(d / 16);
      return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
    });
  };

  var show = function (str) {
    var container = document.getElementById('responses');
    container.innerHTML = str;
  };

  var ws_init = function () {
    ws = new WebSocket('ws://' + window.location.host + window.location.pathname);
    ws.onopen = function () {
      console.log('connected');
    };
    ws.onclose = function () {
      console.log('disconnected');
      setTimeout(function () {
        ws_init()
      }, 1000);
    };
    ws.onmessage = function (m) {
      var message = JSON.parse(m.data);
      const html_list = `
          <q>Query: ${message.query}</q>
          <ul>
            ${message.response.map(repo => `<p>
<a href="${repo.html_url}">${repo.full_name}</a><br>
Watchers:${repo.watchers} Stars:${repo.stargazers_count} Forks:${repo.forks}</p>`).join("\n")}
          </ul>
        `;
      show(html_list);
      console.log(message);
    }
  };

  var search_init = function () {
    var input = document.getElementById('query');
    var submit = document.getElementById('search');
    submit.onsubmit = function () {
      show('Searching...');
      var message = JSON.stringify({
        query_uuid: generateUUID(),
        query: input.value
      });
      ws.send(message);
      input.value = "";
      return false;
    };
  };

  ws_init();
  search_init();
};
