
List<Map<String, dynamic>> affiliationCount(List<String> affiliations) {
  int klingons = 0;
  int federations = 0;
  int starfleets = 0;
  int romulans = 0;
  int rogues = 0;

  affiliations.forEach((word) => {
  if(word == 'klingon') {klingons += 1},
  if(word == 'federation') {federations += 1},
  if(word == 'starfleet') {starfleets += 1},
  if(word == 'romulan') {romulans += 1},
  if(word == 'rogue') {rogues += 1}
  });

 return [
    {'name' : 'klingon', 'amt' : klingons},
    {'name' : 'federation', 'amt' : federations},
    {'name' : 'starfleet', 'amt' : starfleets},
    {'name' : 'romulan', 'amt' : romulans},
    {'name' : 'rogue', 'amt' : rogues}
  ];
}