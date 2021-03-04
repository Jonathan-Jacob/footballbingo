fetch("https://soccer.sportmonks.com/api/v2.0/livescores?api_token=CYKQiMHdrgenG9Uwe91lnRk3lMI0LOiowonRns3ryM6xygFyxmfa0p4E3jA2&include=localTeam,visitorTeam,events,lineup")
.then(response => response.json())
.then((data) => {
  console.log(data);
});