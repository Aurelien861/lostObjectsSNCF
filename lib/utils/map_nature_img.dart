String pathForObjectNature(String nature) {
  switch (nature) {
    case 'Porte-monnaie, portefeuille':
      return 'assets/images/objects/portefeuille.png';
    case 'Sac à dos':
      return 'assets/images/objects/sac-decole.png';
    case 'Valise, sac sur roulettes':
      return 'assets/images/objects/les-valises.png';
    case 'Téléphone portable':
      return 'assets/images/objects/telephone-mobile.png';
    case 'Manteau, veste, blazer, parka, blouson, cape':
      return 'assets/images/objects/veste.png';
    case 'Sac de voyage, sac de sport, sac à bandoulière':
      return 'assets/images/objects/sac-de-sport.png';
    case 'Clés, porte-clés':
      return 'assets/images/objects/cles.png';
    case "Carte d'identité, passeport, permis de conduire":
      return 'assets/images/objects/passeport.png';
    case "Sac d'enseigne (plastique, papier, …)":
      return 'assets/images/objects/shopping-en-ligne.png';
    case "Lunettes":
      return 'assets/images/objects/des-lunettes-de-soleil.png';
    case "Sac à main":
      return 'assets/images/objects/sac-a-main.png';
    case "Téléphone portable protégé (étui, coque,…)":
      return 'assets/images/objects/telephone-mobile.png';
    case "Carte de crédit":
      return 'assets/images/objects/carte-bancaire.png';
    case "Lunettes en étui":
      return 'assets/images/objects/des-lunettes-de-soleil.png';
    case "Bonnet, chapeau":
      return 'assets/images/objects/bonnet-en-tricot.png';
    case "Foulard, écharpe":
      return 'assets/images/objects/echarpe-dhiver.png';
    default:
      return 'assets/images/objects/no_image.png';
  }
}