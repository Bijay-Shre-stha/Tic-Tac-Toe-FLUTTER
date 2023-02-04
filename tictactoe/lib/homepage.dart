import 'package:flutter/material.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

//icon
    static const String Player_X="X";
    static const String Player_Y="O";

    late String currentPlayer;
    late bool gameEnd;
    late List<String> occupied;

//game state
    @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame(){
    currentPlayer = Player_X;
    gameEnd=false;
    occupied=["","","","","","","","","",];//9boxes

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            _headerText(),
            _gameContainer(),
            _reset(),
          ],
        )
        ),
    );
  }
  Widget _headerText(){
    return Column(
      children: [
        const Text("TIC TAC TOE", style:TextStyle(
          color:Colors.red,
          fontSize: 32,
          fontWeight: FontWeight.bold
          ),
          ),
          Text("$currentPlayer turn ", style: const TextStyle(
            color: Colors.blue,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),)
      ],
    );
  }
Widget _gameContainer(){
  return Container(
    color: Color.fromARGB(255, 108, 247, 112),
    height: MediaQuery.of(context).size.height/2,
    width: MediaQuery.of(context).size.width/2,
    margin: EdgeInsets.all(8),
    child: GridView.builder(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
    itemCount: 9,
    itemBuilder: (context, int index){
      return _box(index);
    }
    ),
  );

}
Widget _box(int index){
  return InkWell(
    onTap: (){
      //onclick
      if(gameEnd||occupied[index].isNotEmpty){
        //box clicked
        return;
      }


      setState(() {
        occupied[index]= currentPlayer;
        changeTurn();
        checkWinner();
        checkDraw();
      });
      
    },
    child: Container(
    color: occupied[index].isEmpty?Colors.black:occupied[index]==Player_X?Colors.red:Colors.lightBlue,
    margin: EdgeInsets.all(8),
    child:Center(
    child: Text(occupied[index],
    style: const TextStyle(fontSize: 50),
    ),
    ),
    ),
  );
}
_reset(){
  return ElevatedButton(onPressed: (){
    setState(() {
      initializeGame();
    });

  }, child: const Text("Reset"),
  );
}

changeTurn(){
  if(currentPlayer== Player_X){
    currentPlayer= Player_Y;
  }
  else{
    currentPlayer = Player_X;
  }
}
checkWinner(){
  //for win
  List<List<int>> winninglist=[
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6],
  ];
  for(var winningpos in winninglist){
    String playerPosition0=occupied[winningpos[0]];
    String playerPosition1=occupied[winningpos[1]];
    String playerPosition2=occupied[winningpos[2]];

    if(playerPosition0.isNotEmpty){
      if(playerPosition0==playerPosition1 && playerPosition0 == playerPosition2){
        //Draw
        showGameOverMessage("Player $playerPosition0 won");
        gameEnd=true;
        return;
      }
    }
  }
}
checkDraw(){
  if(gameEnd){
    return;
  }
  bool draw=true;
  for(var occupiedPlayer in occupied){
    if(occupiedPlayer.isEmpty){
      //at least one is empty 
      draw=false;
    }
  }
  if(draw){
    showGameOverMessage("Draw");
    gameEnd=true;
    }

}
showGameOverMessage(String Message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blueGrey,
      content: Text("Game Over\n $Message",
      textAlign: TextAlign.center,
      style: const TextStyle(
      fontSize: 20,
    ),),)
  );
}


}

