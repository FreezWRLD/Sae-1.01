unit objets;
interface
  const 
    //batiments
    hub: _Batiment = (
      _TypeBatiment.hub, 
      _Niveau(1), 
      _TypeRessources.resMineraiCuivre,
      _Recette(
        (
          _TypeRessources.resCableCuivre,
          10
        ),
        None,
        None,
        0
      ),
      None,
      0
    );

    mine: _Batiment = (
      _TypeBatiment.mine, 
      _Niveau(1), 
      _TypeRessources.resMineraiCuivre,
      _Recette(
        (
          _TypeRessources.resMineraiCuivre,
          10
        ),
        None,
        None,
        0
      ),
      None,
      0
    );

    constructeur: _Batiment = (
      _TypeBatiment.constructeur, 
      _Niveau(1), 
      _TypeRessources.resLingotCuivre,
      _Recette(
        (
          _TypeRessources.resMineraiCuivre,
          10
        ),
        None,
        None,
        0
      ),
      _Recette(
        (
          _TypeRessources.resLingotFer,
          10
        ),
        None,
        None,
        0
      ),
      0
    );

    centrale: _Batiment = (
      _TypeBatiment.centrale, 
      _Niveau(1), 
      _TypeRessources.resAcier,
      _Recette(
        (
          _TypeRessources.resLingotFer,
          10
        ),
        None,
        None,
        0
      ),
      _Recette(
        (
          _TypeRessources.resBeton,
          10
        ),
        None,
        None,
        0
      ),
      0
    );

implementation
end.