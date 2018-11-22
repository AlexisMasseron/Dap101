pragma solidity ^0.4.19;

/**
 * @title PokeFactory
 * @dev The PokeFactory is used to create Pokemons and store them. It also keeps track to 
 whom own which pokemons.
 */

contract PokeFactory {

  event NewPokemon(address indexed _from, uint id, uint pokeId);

  struct Pokemon {
    string name;
    uint pokeId;
    uint32 level;
  }

   /**
   * @param Pokemon array of struct Pokemon that will store all pokemons created
   */
   
  Pokemon[] public pokedex; 

  mapping (uint => address) public PokemonToTrainer;
  mapping (address => uint) PokemonTrainerCount;

   /**
   * @dev create a pokemon with a unique ID and set ownership + update the number of pokemon the owner owns and sends an event.
   * @param _pokeId number between 1 and 150 that represent which pokemon will be generated.
   */
  function _createPokemon(uint _pokeId) internal {
    uint id = pokedex.push(Pokemon("AnonymousPoké", _pokeId, 1)) - 1;
    PokemonToTrainer[id] = msg.sender;
    PokemonTrainerCount[msg.sender]++;
    emit NewPokemon(msg.sender, id, _pokeId);
  }

   /**
   * @dev create a random uin. There is a potential security vulnerability as I generate my random number based on timestamp that can be manipulated by miners. 
   * Improvements to be done here.
   */
  function _generateRandomId() private view returns (uint) {
    uint rand = uint256(keccak256(
      abi.encodePacked(now, msg.sender)
      )
    );   
    return rand;
  }

  /**
   * @dev create a random starter pokemon, this function is for testing and display purpose only as it breaks the gaming mechanics. Same story here as I use 'now' again. Improvements TBD
   */
   function catchUnlimitedRandomPokemon() public {
    uint _pokeId = _generateRandomId();
    _pokeId = (_pokeId % 150) + 1; 
    _createPokemon( _pokeId);
  }

  /**
   * @dev returns all pokemon the owner owns.
   * @param _owner is the owner address. We loop though the PokemonToTrainer mapping and store each pokemon the owner owns.
   */
  function getPokemonByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](PokemonTrainerCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < pokedex.length; i++) {
      if (PokemonToTrainer[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}
